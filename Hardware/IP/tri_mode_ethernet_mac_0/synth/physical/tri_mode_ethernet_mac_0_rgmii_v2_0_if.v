//------------------------------------------------------------------------------
// File       : tri_mode_ethernet_mac_0_rgmii_v2_0_if.v
// Author     : Xilinx Inc.
// -----------------------------------------------------------------------------
// (c) Copyright 2004-2009 Xilinx, Inc. All rights reserved.
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
// Description:  This module creates a version 2.0 Reduced Gigabit Media
//               Independent Interface (RGMII v2.0) by instantiating
//               Input/Output buffers and Input/Output double data rate
//               (DDR) flip-flops as required.
//
//               This interface is used to connect the Ethernet MAC to
//               an external Ethernet PHY.
//               This module routes the rgmii_rxc from the phy chip
//               (via a bufg) onto the rx_clk line.
//               A BUFIO/BUFR combination is used for the input clock to allow
//               the use of IODELAYs on the DATA.

//------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

//------------------------------------------------------------------------------
// The module declaration for the PHY IF design.
//------------------------------------------------------------------------------
module tri_mode_ethernet_mac_0_rgmii_v2_0_if (
    // Synchronous resets
    input            tx_reset90,
    input            tx_reset,
    input            rx_reset,

    // The following ports are the MDIO physical interface: these will be
    // pins on the FPGA
    inout            mdio,
    output           mdc,

    // The following ports are the internal connections from IOB logic to
    // the TEMAC core for the MDIO
    output           mdio_i,
    input            mdio_o,
    input            mdio_t,
    input            mdc_i,

    // Current operating speed is 10/100
    input            speedis10100,

    // The following ports are the RGMII physical interface: these will be at
    // pins on the FPGA
    output     [3:0] rgmii_txd,
    output           rgmii_tx_ctl,
    output           rgmii_txc,
    input      [3:0] rgmii_rxd,
    input            rgmii_rx_ctl,
    input            rgmii_rxc,

    // The following signals are in the RGMII in-band status signals
    output reg       link_status,
    output reg [1:0] clock_speed,
    output reg       duplex_status,

    // The following ports are the internal GMII connections from IOB logic
    // to the TEMAC core
    input            phy_tx_enable,
    input            phy_tx_enable_falling,
    input      [7:0] txd_from_mac,
    input            tx_en_from_mac,
    input            tx_er_from_mac,
    input            tx_clk,
    input            tx_clk90,
    input            clk_div5,
    input            clk_div5_shift,
    output     [7:0] rxd_to_mac,
    output           rx_dv_to_mac,
    output           rx_er_to_mac,

    // Receiver clock for the MAC and Client Logic
    output           rx_clk
  );



  //----------------------------------------------------------------------------
  // internal signals
  //----------------------------------------------------------------------------

  wire   [3:0] rgmii_txd_obuf;
  wire         rgmii_tx_ctl_obuf;
  wire         rgmii_txc_obuf;
  wire   [3:0] rgmii_rxd_ibuf;
  wire         rgmii_rx_ctl_ibuf;
  wire         rgmii_rxc_ibuf;

  reg    [3:0] gmii_txd_falling;             // gmii_txd signal registered on the falling edge of tx_clk.
  wire         rgmii_tx_ctl_int;             // Internal RGMII transmit control signal.
  wire         rgmii_rx_ctl_delay;
  wire   [3:0] rgmii_rxd_delay;
  wire         rgmii_rx_clk_bufio;
  wire         rgmii_rx_ctl_reg;             // Internal RGMII receiver control signal.
  reg          control_enable;
  reg          tx_en_to_ddr;

  wire         gmii_rx_dv_reg;               // gmii_rx_dv registered in IOBs.
  wire         gmii_rx_er_reg;               // gmii_rx_er registered in IOBs.
  wire   [7:0] gmii_rxd_reg;                 // gmii_rxd registered in IOBs.

  wire         inband_ce;                    // RGMII inband status registers clock enable
  wire         rx_clk_int;
  reg          phy_tx_enable_reg;


  //----------------------------------------------------------------------------
  // Input/Output Buffers
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // MDIO
  //----------------------------------------------------------------------------

  IOBUF mdio_iobuf (
     .I              (mdio_o),
     .IO             (mdio),
     .O              (mdio_i),
     .T              (mdio_t)
  );

   // Route through the MDC clock
  OBUF mdc_obuf_i (
     .I              (mdc_i),
     .O              (mdc)
  );


  //----------------------------------------------------------------------------
  // RGMII
  //----------------------------------------------------------------------------

  OBUF rgmii_txc_obuf_i (
     .I              (rgmii_txc_obuf),
     .O              (rgmii_txc)
  );

  OBUF rgmii_tx_ctl_obuf_i (
     .I              (rgmii_tx_ctl_obuf),
     .O              (rgmii_tx_ctl)
  );

  genvar loopa;
  generate for (loopa=0; loopa<4; loopa=loopa+1)
    begin : obuf_data
      OBUF rgmii_txd_obuf_i (
         .I              (rgmii_txd_obuf[loopa]),
         .O              (rgmii_txd[loopa])
      );
    end
  endgenerate

  IBUF rgmii_rxc_ibuf_i (
     .I              (rgmii_rxc),
     .O              (rgmii_rxc_ibuf)
  );

  IBUF rgmii_rx_ctl_ibuf_i (
     .I              (rgmii_rx_ctl),
     .O              (rgmii_rx_ctl_ibuf)
  );

  genvar loopi;
  generate for (loopi=0; loopi<4; loopi=loopi+1)
    begin : ibuf_data
      IBUF rgmii_rxd_ibuf_i (
         .I              (rgmii_rxd[loopi]),
         .O              (rgmii_rxd_ibuf[loopi])
      );
    end
  endgenerate


  //----------------------------------------------------------------------------
  // Route internal signals to output ports :
  //----------------------------------------------------------------------------

  assign rxd_to_mac      = gmii_rxd_reg;
  assign rx_dv_to_mac    = gmii_rx_dv_reg;
  assign rx_er_to_mac    = gmii_rx_er_reg;


  //----------------------------------------------------------------------------
  // RGMII Transmitter Clock Management :
  //----------------------------------------------------------------------------
   // Instantiate the Output DDR primitive
   ODDR #(
      .DDR_CLK_EDGE  ("SAME_EDGE")
   ) rgmii_txc_ddr (
      .Q             (rgmii_txc_obuf),
      .C             (tx_clk90),
      .CE            (1'b1),
      .D1            (clk_div5_shift),
      .D2            (clk_div5),
      .R             (tx_reset90),
      .S             (1'b0)
   );



   //---------------------------------------------------------------------------
   // RGMII Transmitter Logic :
   // drive TX signals through IOBs onto RGMII interface
   //---------------------------------------------------------------------------

   // Encode rgmii ctl signal
   assign rgmii_tx_ctl_int = tx_en_from_mac ^ tx_er_from_mac;


   // Instantiate Double Data Rate Output components.

   always @ (speedis10100, txd_from_mac)
   begin
      if (speedis10100 == 1'b0)
         gmii_txd_falling     <= txd_from_mac[7:4];
      else
         gmii_txd_falling     <= txd_from_mac[3:0];
   end


   genvar i;
   generate for (i=0; i<4; i=i+1)
     begin : txdata_out_bus

       ODDR #(
          .DDR_CLK_EDGE  ("SAME_EDGE")
       )
       rgmii_txd_out (
          .Q             (rgmii_txd_obuf[i]),
          .C             (tx_clk),
          .CE            (1'b1),
          .D1            (txd_from_mac[i]),
          .D2            (gmii_txd_falling[i]),
          .R             (tx_reset),
          .S             (1'b0)
       );

     end
   endgenerate


   // when the speed switches to 10/100 tx_clk is running much faster than
   // txc and therefore the ddr needs to be controlled to prevent updates
   // occuring at tx_clk rate
   always @(posedge tx_clk)
   begin
      if (tx_reset)
         control_enable <= 1'b1;
      else begin
         if (speedis10100)
            control_enable <= phy_tx_enable || phy_tx_enable_falling;
         else
            control_enable <= 1'b1;
      end
   end

   // when the clk_div5 is sourced from the 90 phase shifted clock we need to use
   // a different signal to gate the en_to_ddr to ease timing
   always @(posedge tx_clk)
   begin
      if (tx_reset)
         phy_tx_enable_reg <= 1'b1;
      else begin
         if (speedis10100)
            phy_tx_enable_reg <= phy_tx_enable;
         else
            phy_tx_enable_reg <= 1'b1;
      end
   end

   // The control signal above will ensure the ddr updates only once per phase of
   // txc BUT it will always be active for 2 clock edges - therefore logic is required
   // to ensure an error will send tx_ctl low for a full phase of the clock
   always @(speedis10100 or tx_en_from_mac or tx_er_from_mac or phy_tx_enable_reg)
   begin
      if (speedis10100)
         tx_en_to_ddr = tx_en_from_mac & (!tx_er_from_mac || phy_tx_enable_reg);
      else
         tx_en_to_ddr = tx_en_from_mac;
   end

   ODDR #(
      .DDR_CLK_EDGE  ("SAME_EDGE")
   )
   ctl_output (
      .Q             (rgmii_tx_ctl_obuf),
      .C             (tx_clk),
      .CE            (control_enable),
      .D1            (tx_en_to_ddr),
      .D2            (rgmii_tx_ctl_int),
      .R             (tx_reset),
      .S             (1'b0)
   );

   //---------------------------------------------------------------------------
   // RGMII Receiver Clock Logic
   //---------------------------------------------------------------------------

   // Route rgmii_rxc through a BUFIO/BUFR and onto regional clock routing
   BUFIO bufio_rgmii_rx_clk (
      .I             (rgmii_rxc_ibuf),
      .O             (rgmii_rx_clk_bufio)
   );

   // Route rx_clk through a BUFR onto regional clock routing
   BUFR bufr_rgmii_rx_clk (
      .I             (rgmii_rxc_ibuf),
      .CE            (1'b1),
      .CLR           (1'b0),
      .O             (rx_clk_int)
   );


   // Assign the internal clock signal to the output port
   assign rx_clk = rx_clk_int;


   //---------------------------------------------------------------------------
   // RGMII Receiver Logic : receive signals through IOBs from RGMII interface
   //---------------------------------------------------------------------------


   // Drive input RGMII Rx signals from PADS through IODELAYS.

   // Please modify the IODELAY_VALUE according to your design.
   // For more information on IDELAYCTRL and IODELAY, please refer to
   // the User Guide.

   IDELAYE2 #(
      .IDELAY_TYPE   ("FIXED")
   )
   delay_rgmii_rx_ctl (
      .IDATAIN       (rgmii_rx_ctl_ibuf),
      .DATAOUT       (rgmii_rx_ctl_delay),
      .DATAIN        (1'b0),
      .C             (1'b0),
      .CE            (1'b0),
      .INC           (1'b0),
      .CINVCTRL      (1'b0),
      .CNTVALUEIN    (5'h0),
      .CNTVALUEOUT   (),
      .LD            (1'b0),
      .LDPIPEEN      (1'b0),
      .REGRST        (1'b0)
      );

   genvar j;
   generate for (j=0; j<4; j=j+1)
     begin : rxdata_bus

       IDELAYE2 #(
          .IDELAY_TYPE   ("FIXED")
       )
       delay_rgmii_rxd (
          .IDATAIN       (rgmii_rxd_ibuf[j]),
          .DATAOUT       (rgmii_rxd_delay[j]),
          .DATAIN        (1'b0),
          .C             (1'b0),
          .CE            (1'b0),
          .INC           (1'b0),
          .CINVCTRL      (1'b0),
          .CNTVALUEIN    (5'h0),
          .CNTVALUEOUT   (),
          .LD            (1'b0),
          .LDPIPEEN      (1'b0),
          .REGRST        (1'b0)
       );
     end
   endgenerate

   // Instantiate Double Data Rate Input flip-flops.
   // DDR_CLK_EDGE attribute specifies output data alignment from IDDR component

   genvar k;
   generate for (k=0; k<4; k=k+1)
     begin : rxdata_in_bus

       IDDR #(
          .DDR_CLK_EDGE  ("SAME_EDGE_PIPELINED")
       )
       rgmii_rx_data_in (
          .Q1            (gmii_rxd_reg[k]),
          .Q2            (gmii_rxd_reg[k+4]),
          .C             (rgmii_rx_clk_bufio),
          .CE            (1'b1),
          .D             (rgmii_rxd_delay[k]),
          .R             (1'b0),
          .S             (1'b0)
       );
     end
   endgenerate

   IDDR #(
      .DDR_CLK_EDGE  ("SAME_EDGE_PIPELINED")
   )
   rgmii_rx_ctl_in (
      .Q1            (gmii_rx_dv_reg),
      .Q2            (rgmii_rx_ctl_reg),
      .C             (rgmii_rx_clk_bufio),
      .CE            (1'b1),
      .D             (rgmii_rx_ctl_delay),
      .R             (1'b0),
      .S             (1'b0)
   );


   // Decode gmii_rx_er signal
   assign gmii_rx_er_reg = gmii_rx_dv_reg ^ rgmii_rx_ctl_reg;


  //----------------------------------------------------------------------------
  // RGMII Inband Status Registers
  // extract the inband status from received rgmii data
  //----------------------------------------------------------------------------

   // Enable inband status registers during Interframe Gap
   assign inband_ce = !(gmii_rx_dv_reg || gmii_rx_er_reg);

   always @ (posedge rx_clk_int)
   begin
      if (rx_reset) begin
         link_status          <= 1'b0;
         clock_speed[1:0]     <= 2'b0;
         duplex_status        <= 1'b0;
      end
      else if (inband_ce) begin
         link_status          <= gmii_rxd_reg[0];
         clock_speed[1:0]     <= gmii_rxd_reg[2:1];
         duplex_status        <= gmii_rxd_reg[3];
      end
   end



endmodule

