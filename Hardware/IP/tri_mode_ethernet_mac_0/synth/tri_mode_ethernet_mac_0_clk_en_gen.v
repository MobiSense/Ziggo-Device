//------------------------------------------------------------------------------
// Title      : Transmitter Clock Generator
// Project    : Tri-Mode Ethernet MAC
//------------------------------------------------------------------------------
// File       : tri_mode_ethernet_mac_0_clk_en_gen.v
// Author     : Xilinx Inc.
// -----------------------------------------------------------------------------
// (c) Copyright 2009 Xilinx, Inc. All rights reserved.
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
//   Description:  This module provides clock enables for the tx
//   logic and clocks to be used in the generation of rgmii_txc.
//   At 1G the enables are both set to 1 as they are not reuired, at 100M
//   the enables occur every 5th cycle for the phy interface and every 10th for
//   the client.  At 10M this changes to every 50th and every 100th respectively.
//   The clk_div5 outputs are used purely to generate the txc output and are
//   used as data inputs to the DDR logic.
//------------------------------------------------------------------------------

`timescale 1 ps/1 ps

module tri_mode_ethernet_mac_0_clk_en_gen
  (
      input             reset,
      input             speed_is_10_100,
      input             speed_is_100,
      input             clk,
      input             clk90,
      output   reg      client_tx_enable,
      output   reg      phy_tx_enable,
	  output   reg      phy_tx_enable_falling,
      output   reg      clk_div5,
      output   reg      clk_div5_shift
   );

   reg   [5:0]          counter;
   reg   [5:0]          wrap_point;
   reg   [5:0]          first_edge;
   reg   [5:0]          second_edge;
   reg                  div_2;
   wire                 speed_is_10_100_int;
   wire                 speed_is_100_int;
   reg                  clk_div5_int;
   reg                  clk_div5_shift_int;
   reg                  clk_div5_int1;
   reg                  clk_div5_shift_int1;
   reg                  client_tx_enable_int;
   reg                  phy_tx_enable_fall;
   reg                  phy_tx_enable_int;
   wire                 reset90;
   
// locally sync the reset - don't need a full reset sync as it is already synchronous
// just on the wrong phase
   tri_mode_ethernet_mac_0_block_sync_block reset90gen (
      .clk              (clk90),
      .data_in          (reset),
      .data_out         (reset90)
   );

// locally sync the speed controls

   tri_mode_ethernet_mac_0_block_sync_block txspeedis10100gen (
      .clk              (clk90),
      .data_in          (speed_is_10_100),
      .data_out         (speed_is_10_100_int)
   );

   tri_mode_ethernet_mac_0_block_sync_block txspeedis100gen (
      .clk              (clk90),
      .data_in          (speed_is_100),
      .data_out         (speed_is_100_int)
   );

// generate a 6 bit counter which counts to a max of 50 and then wraps
// the wrap point is dependant upon the speed setting
always @(posedge clk90)
begin
   if (reset90) begin
      counter                    <= 0;
   end
   else begin
      if (counter >= wrap_point) begin
         counter                 <= 0;
      end
      else begin
         counter                 <= counter + 1;
      end
   end
end

always @(speed_is_10_100_int or speed_is_100_int)
begin
   if (!speed_is_10_100_int) begin
      wrap_point                 = 0;
      first_edge                 = 0;
      second_edge                = 0;
   end
   else begin
      if (speed_is_100_int) begin
         wrap_point                 = 4;
         first_edge                 = 1;
         second_edge                = 2;
      end
      else begin
         wrap_point                 = 49;
         first_edge                 = 23;
         second_edge                = 24;
      end
   end
end

// look for counter to equal wrap point - this gives the high speed
// clock enable - we want to generate a second enable every other pulse
always @(posedge clk90)
begin
   if (reset90) begin
      div_2                      <= 0;
   end
   else begin
      if (speed_is_10_100_int) begin
         if (counter >= wrap_point) begin
            div_2                <= !div_2;
         end
      end
      else begin
         div_2                   <= 0;
      end
   end
end

// generate the clock enables - only if speed is not 1G
always @(posedge clk90)
begin
   if (reset90) begin
      clk_div5_int               <= 0;
      clk_div5_shift_int         <= 0;
   end
   else begin
      if (speed_is_10_100_int) begin
         if (counter >= wrap_point) begin
            clk_div5_int         <= 1;
            clk_div5_shift_int   <= 1;
         end
         else if (counter == first_edge) begin
            clk_div5_int         <= 0;
            clk_div5_shift_int   <= 1;
         end
         else if (counter == second_edge) begin
            clk_div5_int         <= 0;
            clk_div5_shift_int   <= 0;
         end
      end
      else begin
         clk_div5_int            <= 0;
         clk_div5_shift_int      <= 1;
      end
   end
end

// the pipeline delay between the MAC enable and the clock needs to be controlled
// to ensure the correct timing at the IO
always @(posedge clk90)
begin
   if (reset90) begin
      clk_div5_int1              <= 0;
      clk_div5_shift_int1        <= 0;
      clk_div5                   <= 0;
      clk_div5_shift             <= 0;
   end
   else begin
      clk_div5_int1              <= clk_div5_int;
      clk_div5_shift_int1        <= clk_div5_shift_int;
      clk_div5                   <= clk_div5_int1;
      clk_div5_shift             <= clk_div5_shift_int1;
   end
end

always @(posedge clk90)
begin
   if (reset90) begin
      client_tx_enable_int       <= 0;
      phy_tx_enable_int          <= 0;
   end
   else begin
      if (counter >= wrap_point) begin
         phy_tx_enable_int       <= 1;
      end
      else begin
         phy_tx_enable_int       <= 0;
      end
      if (counter >= first_edge) begin
         phy_tx_enable_fall      <= 1;
      end
      else begin
         phy_tx_enable_fall      <= 0;
      end
      if ((counter >= wrap_point) & !div_2) begin
         client_tx_enable_int    <= 1;
      end
      else begin
         client_tx_enable_int    <= 0;
      end
   end
end

always @(posedge clk)
begin
   if (reset) begin
      client_tx_enable           <= 0;
      phy_tx_enable              <= 0;
      phy_tx_enable_falling      <= 0;
   end
   else begin
      phy_tx_enable              <= phy_tx_enable_int;
      phy_tx_enable_falling      <= phy_tx_enable_fall;
      client_tx_enable           <= client_tx_enable_int;
   end
end


endmodule

