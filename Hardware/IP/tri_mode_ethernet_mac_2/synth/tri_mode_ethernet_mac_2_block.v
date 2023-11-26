//------------------------------------------------------------------------------
// File       : tri_mode_ethernet_mac_2_block.v
// Author     : Xilinx Inc.
// -----------------------------------------------------------------------------
// (c) Copyright 2004-2013 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// -----------------------------------------------------------------------------
// Description: This is the block level Verilog design for the Tri-Mode
//              Ethernet MAC Example Design.
//
//              This block level:
//
//              * instantiates the statistics counter decode logic for all user definable
//                counters
//
//              * instantiates the axi4-lite ipif module to convert to the core IPIC
//                interface
//
//              Please refer to the Datasheet, Getting Started Guide, and
//              the Tri-Mode Ethernet MAC User Gude for further information.
//
//
//              -----------------------------------------|
//              | BLOCK LEVEL WRAPPER                    |
//              |                                        |
//              |      --------------                    |
//              |      |  STATS     |                    |
//              |      |    DECODE  |                    |
//              |      |            |                    |
//              |      --------------                    |
//              |        |        |                      |
//              |    ---------------------               |
//              |    | ETHERNET MAC      |               |
//              |    | CORE              |               |
//              |    |                   |               |
//            --|--->| Tx            Tx  |-------------->|
//              |    | AXI           PHY |               |
//              |    | I/F           I/F |               |
//              |    |                   |               |
//              |    |                   |               |
//              |    |                   |               |
//              |    | Rx            Rx  |               |
//              |    | AXI           PHY |               |
//            <-|----| I/F           I/F |<--------------|
//              |    |                   |               |
//              |    ---------------------               |
//              |            |  |                        |
//              |       --------------------             |
//              |       |                  |             |
//            --|------>|  AXI4-Lite IPIF  |             |
//            <-|-------|                  |             |
//              |       |                  |             |
//              |       --------------------             |
//              |                                        |
//              -----------------------------------------|
//

`timescale 1 ps/1 ps


//------------------------------------------------------------------------------
// The entity declaration for the block level example design.
//------------------------------------------------------------------------------

module tri_mode_ethernet_mac_2_block 
  
(
      input                gtx_clk,
      
      
      // asynchronous reset
      input                glbl_rstn,
      input                rx_axi_rstn,
      input                tx_axi_rstn,

      // Receiver Interface
      //--------------------------
      output      [27:0]   rx_statistics_vector,
      output               rx_statistics_valid,

      output               rx_mac_aclk,
      output               rx_reset,
      output      [7:0]    rx_axis_mac_tdata,
      output               rx_axis_mac_tvalid,
      output               rx_axis_mac_tlast,
      output               rx_axis_mac_tuser,


      // Transmitter Interface
      //-----------------------------
      input       [7:0]    tx_ifg_delay,
      output      [31:0]   tx_statistics_vector,
      output               tx_statistics_valid,

      output               tx_mac_aclk,
      output               tx_reset,
      input       [7:0]    tx_axis_mac_tdata,
      input                tx_axis_mac_tvalid,
      input                tx_axis_mac_tlast,
      input                tx_axis_mac_tuser,
      output               tx_axis_mac_tready,

      // MAC Control Interface
      //----------------------
      input                pause_req,
      input       [15:0]   pause_val,

      // Speed Interface
      //-----------------------
      output               speedis100,
      output               speedis10100,
      // GMII Interface
      //---------------
      output      [7:0]    gmii_txd,
      output               gmii_tx_en,
      output               gmii_tx_er,
      input       [7:0]    gmii_rxd,
      input                gmii_rx_dv,
      input                gmii_rx_er,

      // MDIO Interface
      //---------------

      // AXI-Lite Interface
      //---------------
      input                s_axi_aclk,
      input                s_axi_resetn,

      input       [11:0]   s_axi_awaddr,
      input                s_axi_awvalid,
      output               s_axi_awready,

      input       [31:0]   s_axi_wdata,
      input                s_axi_wvalid,
      output               s_axi_wready,

      output      [1:0]    s_axi_bresp,
      output               s_axi_bvalid,
      input                s_axi_bready,

      input       [11:0]   s_axi_araddr,
      input                s_axi_arvalid,
      output               s_axi_arready,

      output      [31:0]   s_axi_rdata,
      output      [1:0]    s_axi_rresp,
      output               s_axi_rvalid,
      input                s_axi_rready,

      output               mac_irq

      );


   //---------------------------------------------------------------------------
   // internal signals used in this block level wrapper.
   //---------------------------------------------------------------------------

   wire           gmii_tx_en_int;            // Internal gmii_tx_en signal.
   wire           gmii_tx_er_int;            // Internal gmii_tx_er signal.
   wire  [7:0]    gmii_txd_int;              // Internal gmii_txd signal.
   wire           gmii_rx_dv_int;            // gmii_rx_dv registered in IOBs.
   wire           gmii_rx_er_int;            // gmii_rx_er registered in IOBs.
   wire  [7:0]    gmii_rxd_int;              // gmii_rxd registered in IOBs.
   wire           rx_mac_aclk_int;           // Internal receive gmii/mii clock signal.
   wire           tx_mac_aclk_int;           // Internal transmit gmii/mii clock signal.
   wire           speedis100_int;            // Asserted when speed is 100Mb/s.
   wire           speedis10100_int;          // Asserted when speed is 10Mb/s or 100Mb/s.
   wire           tx_reset_int;             // Synchronous reset in the MAC and gmii Tx domain
   wire           rx_reset_int;             // Synchronous reset in the MAC and gmii Rx domain
   wire  [31:0]   rx_statistics_vector_int;
   wire           rx_statistics_valid_int;
   wire  [39:0]   tx_statistics_vector_int;
   wire           tx_statistics_valid_int;
   wire  [4:33]   increment_vector;
   wire           bus2ip_clk;
   wire           bus2ip_reset;
   wire  [11:0]   bus2ip_addr;
   wire           bus2ip_cs;
   wire           bus2ip_rdce;
   wire           bus2ip_wrce;
   wire  [31:0]   bus2ip_data;
   wire  [31:0]   ip2bus_data;
   wire           ip2bus_wrack;
   wire           ip2bus_rdack;
   wire           ip2bus_error;
   wire [127:0]   tx_axis_mac_tuser_int;



   //---------------------------------------------------------------------------
   // Assign internal to external connections
   //---------------------------------------------------------------------------

   // assign the internal reset signals to output ports
   assign rx_reset = rx_reset_int;
   assign tx_reset = tx_reset_int;

   // Assign the internal clock signals to output ports.
   assign rx_mac_aclk = rx_mac_aclk_int;
   assign tx_mac_aclk = tx_mac_aclk_int;

   // Other signal assignments
   assign speedis100 = speedis100_int;
   assign speedis10100 = speedis10100_int;
   assign tx_axis_mac_tuser_int[127:1] = 127'b0;
   assign tx_axis_mac_tuser_int[0]     = tx_axis_mac_tuser;


   assign rx_mac_aclk_int = gtx_clk;
 
   assign tx_mac_aclk_int = gtx_clk;

   //---------------------------------------------------------------------------
   // Instantiate the axi_ipif block
   //---------------------------------------------------------------------------
   tri_mode_ethernet_mac_2_axi4_lite_ipif_wrapper axi4_lite_ipif (
      // System signals
      .s_axi_aclk          (s_axi_aclk),
      .s_axi_aresetn       (s_axi_resetn),
      .s_axi_awaddr        (s_axi_awaddr),
      .s_axi_awvalid       (s_axi_awvalid),
      .s_axi_awready       (s_axi_awready),
      .s_axi_wdata         (s_axi_wdata),
      .s_axi_wvalid        (s_axi_wvalid),
      .s_axi_wready        (s_axi_wready),
      .s_axi_bresp         (s_axi_bresp),
      .s_axi_bvalid        (s_axi_bvalid),
      .s_axi_bready        (s_axi_bready),
      .s_axi_araddr        (s_axi_araddr),
      .s_axi_arvalid       (s_axi_arvalid),
      .s_axi_arready       (s_axi_arready),
      .s_axi_rdata         (s_axi_rdata),
      .s_axi_rresp         (s_axi_rresp),
      .s_axi_rvalid        (s_axi_rvalid),
      .s_axi_rready        (s_axi_rready),
      // controls to the ipif
      .bus2ip_clk          (bus2ip_clk),
      .bus2ip_reset        (bus2ip_reset),
      .bus2ip_addr         (bus2ip_addr),
      .bus2ip_cs           (bus2ip_cs),
      .bus2ip_rdce         (bus2ip_rdce),
      .bus2ip_wrce         (bus2ip_wrce),
      .bus2ip_data         (bus2ip_data),
      .ip2bus_data         (ip2bus_data),
      .ip2bus_wrack        (ip2bus_wrack),
      .ip2bus_rdack        (ip2bus_rdack),
      .ip2bus_error        (ip2bus_error)
   );


   //---------------------------------------------------------------------------
   // Instantiate the vector decode block to define the statistic counters
   //---------------------------------------------------------------------------

   tri_mode_ethernet_mac_2_vector_decode vector_decode_inst (
      // Transmitter Statistic Vector inputs from ethernet MAC
      .tx_clk                    (tx_mac_aclk_int),
      .tx_reset                  (tx_reset_int),
      .tx_statistics_vector      (tx_statistics_vector_int[31:0]),
      .tx_statistics_valid       (tx_statistics_valid_int),

      // Receiver Statistic Vector inputs from ethernet MAC
      .rx_clk                    (rx_mac_aclk_int),
      .rx_reset                  (rx_reset_int),
      .rx_statistics_vector      (rx_statistics_vector_int[27:0]),
      .rx_statistics_valid       (rx_statistics_valid_int),

      // Increment update signals for Statistic Counters 4 upwards
      .increment_vector          (increment_vector)
   );

   assign rx_statistics_vector = rx_statistics_vector_int[27:0];
   assign rx_statistics_valid  = rx_statistics_valid_int;
   assign tx_statistics_vector = tx_statistics_vector_int[31:0];
   assign tx_statistics_valid  = tx_statistics_valid_int;

   //---------------------------------------------------------------------------
   // Assign the signals of the internal GMII
   //---------------------------------------------------------------------------
   assign gmii_tx_en           = gmii_tx_en_int;
   assign gmii_tx_er           = gmii_tx_er_int;
   assign gmii_txd             = gmii_txd_int;
   assign gmii_rx_dv_int       = gmii_rx_dv;
   assign gmii_rx_er_int       = gmii_rx_er;
   assign gmii_rxd_int         = gmii_rxd;

   //---------------------------------------------------------------------------
   // Instantiate the TEMAC encrypted HDL
   // DO NOT MODIFY this instantiation
   //---------------------------------------------------------------------------
   tri_mode_ethernet_mac_v9_0_16 #(
      .C_S_AXI_ADDR_WIDTH        (12),
      .C_PHYSICAL_INTERFACE      ("INTERNAL"),
      .C_INTERNAL_MODE_TYPE      ("BASEX"),
      .C_HALF_DUPLEX             (0),
      .C_HAS_HOST                (1),
      .C_ADD_FILTER              (0),
      .C_AT_ENTRIES              (0),
      .C_FAMILY                  ("zynq"),
      .C_HAS_2G5                 (0),
      .C_MAC_SPEED               ("SPEED_1000_MBPS"),
      .C_HAS_STATS               (1),
      .C_NUM_STATS               (34),
      .C_CNTR_RST                (1),
      .C_STATS_WIDTH             (64),
      .C_AVB                     (0),
      .C_RX_VEC_WIDTH            (79),
      .C_TX_VEC_WIDTH            (79),
      .C_1588                    (0),
      .C_TX_INBAND_CF_ENABLE     (0),
      .C_RX_INBAND_TS_ENABLE     (0),
      .C_PFC                     (0),
      .C_HAS_MDIO                (0),
      .C_DEVICE_FAMILY_US        (0)
    ) tri_mode_ethernet_mac_2_core (

      // Reset signals
      .glbl_rstn                 (glbl_rstn),
      .rx_axi_rstn               (rx_axi_rstn),
      .tx_axi_rstn               (tx_axi_rstn),

      // 1588 Timer input (unused)
      .systemtimer_s_field       (48'd0),
      .systemtimer_ns_field      (32'd0),
      .correction_timer          (64'b0),

      // Receiver Interface.
      .rx_axi_clk                (rx_mac_aclk_int),
      .rx_reset_out              (rx_reset_int),
      .rx_axis_mac_tdata         (rx_axis_mac_tdata),
      .rx_axis_mac_tvalid        (rx_axis_mac_tvalid),
      .rx_axis_mac_tlast         (rx_axis_mac_tlast),
      .rx_axis_mac_tuser         (rx_axis_mac_tuser),

      // rx sideband signals
      .rx_statistics_vector      (rx_statistics_vector_int),
      .rx_statistics_valid       (rx_statistics_valid_int),
      .rx_enable                 (1'b1),
      .rx_axis_filter_tuser      (),

      // 1588 Rx timestamping (unused)
      .rx_ts_axis_tvalid         (),
      .rx_ts_axis_tdata          (),
      .rxphy_s_field             (48'd0),
      .rxphy_ns_field            (32'd0),
      .rxphy_correction_timer    (64'b0),

      // Transmitter Interface
      .tx_axi_clk                (tx_mac_aclk_int),
      .tx_reset_out              (tx_reset_int),
      .tx_axis_mac_tdata         (tx_axis_mac_tdata),
      .tx_axis_mac_tvalid        (tx_axis_mac_tvalid),
      .tx_axis_mac_tlast         (tx_axis_mac_tlast),
      .tx_axis_mac_tuser         (tx_axis_mac_tuser_int),
      .tx_axis_mac_tready        (tx_axis_mac_tready),

      // tx sideband signals
      .tx_collision              (),
      .tx_retransmit             (),
      .tx_enable                 (1'b1),
      .tx_ifg_delay              (tx_ifg_delay),
      .tx_statistics_vector      (tx_statistics_vector_int),
      .tx_statistics_valid       (tx_statistics_valid_int),
      .tx_ts_axis_tvalid         (),
      .tx_ts_axis_tdata          (),

      // AVB AV interface (unused)
       .tx_axis_av_tdata          (8'd0),
      .tx_axis_av_tvalid         (1'b0),
      .tx_axis_av_tlast          (1'b0),
      .tx_axis_av_tuser          (1'b0),
      .tx_axis_av_tready         (),
      .rx_axis_av_tdata          (),
      .rx_axis_av_tvalid         (),
      .rx_axis_av_tlast          (),
      .rx_axis_av_tuser          (),
      .rtc_clk                   (1'b0),
      .rtc_nanosec_field         (),
      .rtc_sec_field             (),
      .clk8k                     (),
      .rtc_nanosec_field_1722    (),
      .interrupt_ptp_timer       (),
      .interrupt_ptp_rx          (),
      .interrupt_ptp_tx          (),

      // Statistics Interface
      .stats_ref_clk             (gtx_clk),
      .increment_vector          (increment_vector),

      // Flow Control Interface
      .pause_req                 (pause_req),
      .pause_val                 (pause_val),
      .tx_pfc_p0_tvalid          (1'b0),
      .tx_pfc_p1_tvalid          (1'b0),
      .tx_pfc_p2_tvalid          (1'b0),
      .tx_pfc_p3_tvalid          (1'b0),
      .tx_pfc_p4_tvalid          (1'b0),
      .tx_pfc_p5_tvalid          (1'b0),
      .tx_pfc_p6_tvalid          (1'b0),
      .tx_pfc_p7_tvalid          (1'b0),
      .rx_pfc_p0_tvalid          (),
      .rx_pfc_p1_tvalid          (),
      .rx_pfc_p2_tvalid          (),
      .rx_pfc_p3_tvalid          (),
      .rx_pfc_p4_tvalid          (),
      .rx_pfc_p5_tvalid          (),
      .rx_pfc_p6_tvalid          (),
      .rx_pfc_p7_tvalid          (),
      .rx_pfc_p0_tready          (1'b0),
      .rx_pfc_p1_tready          (1'b0),
      .rx_pfc_p2_tready          (1'b0),
      .rx_pfc_p3_tready          (1'b0),
      .rx_pfc_p4_tready          (1'b0),
      .rx_pfc_p5_tready          (1'b0),
      .rx_pfc_p6_tready          (1'b0),
      .rx_pfc_p7_tready          (1'b0),

      // Speed Interface
      .speed_is_100              (speedis100_int),
      .speed_is_10_100           (speedis10100_int),

      // GMII/MII Interface
      .gmii_tx_clken             (1'b1),
      .gmii_txd                  (gmii_txd_int),
      .gmii_tx_en                (gmii_tx_en_int),
      .gmii_tx_er                (gmii_tx_er_int),
      .gmii_crs                  (1'b0),
      .gmii_col                  (1'b0),
      .gmii_rxd                  (gmii_rxd_int),
      .gmii_rx_dv                (gmii_rx_dv_int),
      .gmii_rx_er                (gmii_rx_er_int),

      // MDIO Interface (unused)
      .mdc_out                   (),
      .mdio_in                   (1'b0),
      .mdio_out                  (),
      .mdio_tri                  (),

      // IPIC Interface
      .bus2ip_clk                (bus2ip_clk),
      .bus2ip_reset              (bus2ip_reset),
      .bus2ip_addr               (bus2ip_addr),
      .bus2ip_cs                 (bus2ip_cs),
      .bus2ip_rdce               (bus2ip_rdce),
      .bus2ip_wrce               (bus2ip_wrce),
      .bus2ip_data               (bus2ip_data),
      .ip2bus_data               (ip2bus_data),
      .ip2bus_wrack              (ip2bus_wrack),
      .ip2bus_rdack              (ip2bus_rdack),
      .ip2bus_error              (ip2bus_error),
      .mac_irq                   (mac_irq),

      // Configuration Vectors (unused)
      .rx_mac_config_vector      (80'd0),
      .tx_mac_config_vector      (80'd0)
    );


endmodule

