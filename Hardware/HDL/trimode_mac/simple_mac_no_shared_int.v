`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/30 17:07:54
// Design Name: 
// Module Name: simple_mac_no_shared_int
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      It's a copy from tns_tsn_switch/simple_mac_no_shared_int.v
//      It's a simple version of tri mode ethernet mac for gmii signal
//      
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module simple_mac_no_shared_int (
    input         gtx_clk,
    input         gtx_clk90,

    // asynchronous reset
    input         glbl_rstn,
    input         rx_axi_rstn,
    input         tx_axi_rstn,

    // Receiver Statistics Interface
    //---------------------------------------
    output        rx_mac_aclk,
    output        rx_reset,
    output [27:0] rx_statistics_vector,
    output        rx_statistics_valid,

    // Receiver (AXI-S) Interface
    //----------------------------------------
    input         rx_fifo_clock,
    input         rx_fifo_resetn_in,

    (* mark_debug = "true" *) output [7:0]  rx_axis_fifo_tdata,
    (* mark_debug = "true" *) output        rx_axis_fifo_tvalid,
    (* mark_debug = "true" *) input         rx_axis_fifo_tready,
    (* mark_debug = "true" *) output        rx_axis_fifo_tlast,

    // Transmitter Statistics Interface
    //------------------------------------------
    output        tx_mac_aclk,
    output        tx_reset,
    input  [7:0]  tx_ifg_delay,
    output [31:0] tx_statistics_vector,
    output        tx_statistics_valid,


    // Transmitter (AXI-S) Interface
    //-------------------------------------------
    input         tx_fifo_clock,
    input         tx_fifo_resetn_in,

    (* mark_debug = "true" *) input  [7:0]  tx_axis_fifo_legacy_tdata,
    (* mark_debug = "true" *) input         tx_axis_fifo_legacy_tvalid,
    (* mark_debug = "true" *) output        tx_axis_fifo_legacy_tready,
    (* mark_debug = "true" *) input         tx_axis_fifo_legacy_tlast,

    // MAC Control Interface
    //------------------------
    input         pause_req,
    input  [15:0] pause_val,

    (* mark_debug = "true" *) output [7:0]  gmii_txd,
    (* mark_debug = "true" *) output        gmii_tx_en,
    (* mark_debug = "true" *) output        gmii_tx_er,
    (* mark_debug = "true" *) input  [7:0]  gmii_rxd,
    (* mark_debug = "true" *) input         gmii_rx_dv,
    (* mark_debug = "true" *) input         gmii_rx_er,

    // AXI-Lite Interface
    input         s_axi_aclk,
    input         s_axi_resetn,

    input  [11:0] s_axi_awaddr,
    input         s_axi_awvalid,
    output        s_axi_awready,

    input  [31:0] s_axi_wdata,
    input         s_axi_wvalid,
    output        s_axi_wready,

    output [1:0]  s_axi_bresp,
    output        s_axi_bvalid,
    input         s_axi_bready,

    input  [11:0] s_axi_araddr,
    input         s_axi_arvalid,
    output        s_axi_arready,

    output [31:0] s_axi_rdata,
    output [1:0]  s_axi_rresp,
    output        s_axi_rvalid,
    input         s_axi_rready,

    output        mac_tx_axis_tvalid_out,
    output        mac_tx_axis_tready_out,
    output [7:0]  mac_tx_axis_tdata_out,
    output        mac_tx_axis_tlast_out,
     
    output        mac_rx_axis_tvalid_out,
    output        mac_rx_axis_tready_out,
    output [7:0]  mac_rx_axis_tdata_out,
    output        mac_rx_axis_tlast_out
);


    //----------------------------------------------------------------------------
    // Internal signals used in this fifo block level wrapper.
    //----------------------------------------------------------------------------

    wire       rx_mac_aclk_int;    // MAC Rx clock
    wire       tx_mac_aclk_int;    // MAC Tx clock
    wire       rx_reset_int;       // MAC Rx reset
    wire       tx_reset_int;       // MAC Tx reset

    // MAC receiver client I/F
    wire [7:0] rx_axis_mac_tdata;
    wire       rx_axis_mac_tvalid;
    wire       rx_axis_mac_tlast;
    wire       rx_axis_mac_tuser;

    // MAC transmitter client I/F
    wire [7:0] tx_axis_mac_tdata;
    wire       tx_axis_mac_tvalid;
    wire       tx_axis_mac_tready;
    wire       tx_axis_mac_tlast;
    wire       tx_axis_mac_tuser;

    // MAC transmitter legacy and bv traffic channel (into qbv time aware shaper).
    wire [7:0] tx_axis_mac_legacy_tdata;
    wire       tx_axis_mac_legacy_tvalid;
    wire       tx_axis_mac_legacy_tready;
    wire       tx_axis_mac_legacy_tlast;

    //----------------------------------------------------------------------------
    // Connect the output clock signals
    //----------------------------------------------------------------------------

    assign rx_mac_aclk          = rx_mac_aclk_int;
    assign tx_mac_aclk          = tx_mac_aclk_int;
    assign rx_reset             = rx_reset_int;
    assign tx_reset             = tx_reset_int;

    assign mac_rx_axis_tvalid_out = rx_axis_mac_tvalid;
    assign mac_rx_axis_tready_out = 1'b1;
    assign mac_rx_axis_tdata_out = rx_axis_mac_tdata;
    assign mac_rx_axis_tlast_out = rx_axis_mac_tlast;

    assign mac_tx_axis_tvalid_out = tx_axis_mac_legacy_tvalid;
    assign mac_tx_axis_tready_out = tx_axis_mac_legacy_tready;
    assign mac_tx_axis_tdata_out = tx_axis_mac_legacy_tdata;
    assign mac_tx_axis_tlast_out = tx_axis_mac_legacy_tlast;

    reg tx_fifo_resetn;
    reg rx_fifo_resetn;

    always @(posedge tx_fifo_clock) begin
       tx_fifo_resetn <= tx_fifo_resetn_in;
    end

    always @(posedge rx_fifo_clock) begin
       rx_fifo_resetn <= rx_fifo_resetn_in;
    end

  //----------------------------------------------------------------------------
  // Instantiate the Tri-Mode Ethernet MAC core
   //----------------------------------------------------------------------------
   tri_mode_ethernet_mac_2 tri_mode_ethernet_mac_i (
      .s_axi_aclk(s_axi_aclk),                      // input wire s_axi_aclk
      .s_axi_resetn(s_axi_resetn),                  // input wire s_axi_resetn
      .gtx_clk(gtx_clk),                            // input wire gtx_clk
      .glbl_rstn(glbl_rstn),                        // input wire glbl_rstn
      .rx_axi_rstn(rx_axi_rstn),                    // input wire rx_axi_rstn
      .tx_axi_rstn(tx_axi_rstn),                    // input wire tx_axi_rstn
      .rx_statistics_vector(rx_statistics_vector),  // output wire [27 : 0] rx_statistics_vector
      .rx_statistics_valid(rx_statistics_valid),    // output wire rx_statistics_valid
      .rx_mac_aclk(rx_mac_aclk_int),                    // output wire rx_mac_aclk
      .rx_reset(rx_reset_int),                          // output wire rx_reset
      .rx_axis_mac_tdata(rx_axis_mac_tdata),        // output wire [7 : 0] rx_axis_mac_tdata
      .rx_axis_mac_tvalid(rx_axis_mac_tvalid),      // output wire rx_axis_mac_tvalid
      .rx_axis_mac_tlast(rx_axis_mac_tlast),        // output wire rx_axis_mac_tlast
      .rx_axis_mac_tuser(rx_axis_mac_tuser),        // output wire rx_axis_mac_tuser
      .tx_ifg_delay(tx_ifg_delay),                  // input wire [7 : 0] tx_ifg_delay
      .tx_statistics_vector(tx_statistics_vector),  // output wire [31 : 0] tx_statistics_vector
      .tx_statistics_valid(tx_statistics_valid),    // output wire tx_statistics_valid
      .tx_mac_aclk(tx_mac_aclk_int),                    // output wire tx_mac_aclk
      .tx_reset(tx_reset_int),                          // output wire tx_reset
      .tx_axis_mac_tdata(tx_axis_mac_legacy_tdata),        // input wire [7 : 0] tx_axis_mac_tdata
      .tx_axis_mac_tvalid(tx_axis_mac_legacy_tvalid),      // input wire tx_axis_mac_tvalid
      .tx_axis_mac_tlast(tx_axis_mac_legacy_tlast),        // input wire tx_axis_mac_tlast
      .tx_axis_mac_tuser(1'b0),        // input wire [0 : 0] tx_axis_mac_tuser
      .tx_axis_mac_tready(tx_axis_mac_legacy_tready),      // output wire tx_axis_mac_tready
      .pause_req(pause_req),                        // input wire pause_req
      .pause_val(pause_val),                        // input wire [15 : 0] pause_val
      .speedis100(),                      // output wire speedis100
      .speedis10100(),                  // output wire speedis10100
      .gmii_txd(gmii_txd),                          // output wire [7 : 0] gmii_txd
      .gmii_tx_en(gmii_tx_en),                      // output wire gmii_tx_en
      .gmii_tx_er(gmii_tx_er),                      // output wire gmii_tx_er
      .gmii_rxd(gmii_rxd),                          // input wire [7 : 0] gmii_rxd
      .gmii_rx_dv(gmii_rx_dv),                      // input wire gmii_rx_dv
      .gmii_rx_er(gmii_rx_er),                      // input wire gmii_rx_er
      .s_axi_awaddr(s_axi_awaddr),                  // input wire [11 : 0] s_axi_awaddr
      .s_axi_awvalid(s_axi_awvalid),                // input wire s_axi_awvalid
      .s_axi_awready(s_axi_awready),                // output wire s_axi_awready
      .s_axi_wdata(s_axi_wdata),                    // input wire [31 : 0] s_axi_wdata
      .s_axi_wvalid(s_axi_wvalid),                  // input wire s_axi_wvalid
      .s_axi_wready(s_axi_wready),                  // output wire s_axi_wready
      .s_axi_bresp(s_axi_bresp),                    // output wire [1 : 0] s_axi_bresp
      .s_axi_bvalid(s_axi_bvalid),                  // output wire s_axi_bvalid
      .s_axi_bready(s_axi_bready),                  // input wire s_axi_bready
      .s_axi_araddr(s_axi_araddr),                  // input wire [11 : 0] s_axi_araddr
      .s_axi_arvalid(s_axi_arvalid),                // input wire s_axi_arvalid
      .s_axi_arready(s_axi_arready),                // output wire s_axi_arready
      .s_axi_rdata(s_axi_rdata),                    // output wire [31 : 0] s_axi_rdata
      .s_axi_rresp(s_axi_rresp),                    // output wire [1 : 0] s_axi_rresp
      .s_axi_rvalid(s_axi_rvalid),                  // output wire s_axi_rvalid
      .s_axi_rready(s_axi_rready),                  // input wire s_axi_rready
      .mac_irq()                            // output wire mac_irq
   );

   //----------------------------------------------------------------------------
   // Instantiate the user side FIFO
   //----------------------------------------------------------------------------

   // locally reset sync the mac generated resets - the resets are already fully sync
   // so adding a reset sync shouldn't change that
   tri_mode_ethernet_mac_0_reset_sync rx_mac_reset_gen (
      .clk                  (rx_mac_aclk_int),
      .enable               (1'b1),
      .reset_in             (rx_reset_int),
      .reset_out            (rx_mac_reset)
   );

   tri_mode_ethernet_mac_0_reset_sync tx_mac_reset_gen (
      .clk                  (tx_mac_aclk_int),
      .enable               (1'b1),
      .reset_in             (tx_reset_int),
      .reset_out            (tx_mac_reset)
   );

   // create inverted mac resets as the FIFO expects AXI compliant resets
   assign tx_mac_resetn = !tx_mac_reset;
   assign rx_mac_resetn = !rx_mac_reset;

   tri_mode_ethernet_mac_0_tx_client_fifo #
   (
      .FULL_DUPLEX_ONLY (1)
   )
   tx_fifo_legacy
   (
      .tx_fifo_aclk        (tx_fifo_clock),
      .tx_fifo_resetn      (tx_fifo_resetn),
      .tx_axis_fifo_tdata  (tx_axis_fifo_legacy_tdata),
      .tx_axis_fifo_tvalid (tx_axis_fifo_legacy_tvalid),
      .tx_axis_fifo_tlast  (tx_axis_fifo_legacy_tlast),
      .tx_axis_fifo_tready (tx_axis_fifo_legacy_tready),

      .tx_mac_aclk         (tx_mac_aclk),
      .tx_mac_resetn       (tx_mac_resetn),
      .tx_axis_mac_tdata   (tx_axis_mac_legacy_tdata),
      .tx_axis_mac_tvalid  (tx_axis_mac_legacy_tvalid),
      .tx_axis_mac_tlast   (tx_axis_mac_legacy_tlast),
      .tx_axis_mac_tready  (tx_axis_mac_legacy_tready),
      .tx_axis_mac_tuser   (),

      .fifo_overflow       (),
      .fifo_status         (),

      .tx_collision        (1'b0),
      .tx_retransmit       (1'b0)
   );
   
   tri_mode_ethernet_mac_0_rx_client_fifo rx_fifo
   (
      .rx_fifo_aclk        (rx_fifo_clock),
      .rx_fifo_resetn      (rx_fifo_resetn),
      .rx_axis_fifo_tdata  (rx_axis_fifo_tdata),
      .rx_axis_fifo_tvalid (rx_axis_fifo_tvalid),
      .rx_axis_fifo_tlast  (rx_axis_fifo_tlast),
      .rx_axis_fifo_tready (rx_axis_fifo_tready),

      .rx_mac_aclk         (rx_mac_aclk),
      .rx_mac_resetn       (rx_mac_resetn),
      .rx_axis_mac_tdata   (rx_axis_mac_tdata),
      .rx_axis_mac_tvalid  (rx_axis_mac_tvalid),
      .rx_axis_mac_tlast   (rx_axis_mac_tlast),
      .rx_axis_mac_tuser   (rx_axis_mac_tuser),

      .fifo_status         (),
      .fifo_overflow       ()
   );

endmodule

