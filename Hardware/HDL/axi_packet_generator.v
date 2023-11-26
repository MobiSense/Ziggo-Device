//------------------------------------------------------------------------------
// File       : axi_packet_generator.v
// Author     : Xiaowu He
// Comments   : adapted from Xilinx example design of tri_mode_ethernet_mac.
// -----------------------------------------------------------------------------
// Description:  Generate N packets immediately after the posedge of tx_signal
//       based on input ethernet header data and sequence id, start packet id.
// 
// * This module should be stateless witnin each transmission burst (tx_active).
// * All input signal should be syncronized to axi_tclk
// 
// Packet Structure: 
//    typedef struct
//    {
//    #ifndef ETHER_ADDR_LEN
//    #define ETHER_ADDR_LEN 6
//    #endif
//      u8  ether_dhost[ETHER_ADDR_LEN]; /* destination ethernet address */
//      u8  ether_shost[ETHER_ADDR_LEN]; /* source ethernet address */
//      u16 TPID;                        /* 0x8100 */
//      u16 vlan_header;                 /* vlan header: PCP(3 bits), CFI (1 bits), VID (12 bits) */
//      u16 ether_type;                  /* 0x66ab */
//      u8  unused[2];
//      u64 tx_timestamp;                /* timestamp when packet is sent before PHY */
//      u64 rx_timestamp;                /* timestamp when packet is received after PHY */
//      u16 seq_id;                      /* sequence id for this data stream traffic */
//      u32 pkt_id;                      /* packet id for this packet in the seq_id data stream */
//    } __attribute__ ((packed)) ethernet_packet;
//
// Thus, the total packet header signal needs to be 128 bit (16 byte) width, 
//      including dhost to ether_len.
// Accordingly, the packet_gen_controller should expose 8 + (16+4+4+1)*n, where n
//      refers to number of sequences allowed in one cycle.
//    
//    typedef struct
//    {
//    #ifndef ETHER_ADDR_LEN
//    #define ETHER_ADDR_LEN 6
//    #endif
//      u8  ether_dhost[ETHER_ADDR_LEN]; /* destination ethernet address */
//      u8  ether_shost[ETHER_ADDR_LEN]; /* source ethernet address */
//      u16 ether_type;                  /* 0x66ab */
//      u8  unused[2];
//      u64 tx_timestamp;                /* timestamp when packet is sent before PHY */
//      u64 rx_timestamp;                /* timestamp when packet is received after PHY */
//      u16 seq_id;                      /* sequence id for this data stream traffic */
//      u32 pkt_id;                      /* packet id for this packet in the seq_id data stream */
//    } __attribute__ ((packed)) ethernet_packet;
//    
// If vlan is not enabled, the header signal is only valid for pkt_hdr[0:11], 
//     i.e., first 96 bit (12 byte).
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Original File  : tri_mode_ethernet_mac_0_axi_pat_gen.v
// Author         : Xilinx Inc.
// -----------------------------------------------------------------------------
// (c) Copyright 2010 Xilinx, Inc. All rights reserved.
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
// Description:  This is a very simple pattern generator which will generate packets 
// with the supplied dest_addr and src_addr and incrementing data.  The packet size 
// increments between the min and max size (which can be set to the same value if a 
// specific size is required
//
// the pattteren generator is only throttled by the FIFO hitting full which in turn
// is throttled by the transmit rate of the MAC (10M/100M or 1G).  Since the example
// design system does not use active flow control it is possible for the FIFO's to 
// overflow on RX.  To avoid this a basic rate controller is implemented which will
// throttle the patteren generatoor output to just below the selected speed.
//
//------------------------------------------------------------------------------

`timescale 1 ps/1 ps

module axi_packet_generator #(
   parameter               PKT_SIZE       = 16'd64
)(
   /* This clk must be synced to tx_signal & tx_axis's clk */
   input                   axi_tclk,
   input                   axi_tresetn,

   /* AXI stream data connecting to tri-mode ethernet IP */
   output reg  [7:0]       tdata,
   output                  tvalid,
   output reg              tlast,
   input                   tready,

   /* Input pulse to issue on-time packet sending */
   input                   tx_signal,

   /* Input signal related to packet content
   *  These signals are loaded juts at tx_signal puleses.
   */
   input       [127:0]      pkt_hdr_in,
   input                    enable_vlan_in,
   input       [15:0]       seq_id_in,
   input       [31:0]       pkt_id_in,
   input       [15:0]       max_sent_packet_counter_in,

   /* A pulse indetace one transmission burst ends */
   output                   pkt_gen_finish
);

localparam     IDLE        = 3'b000,
               HEADER      = 3'b001,
               SIZE        = 3'b010,
               DATA        = 3'b011,
               OVERHEAD    = 3'b100;

reg         [11:0]         increase_byte_count;
reg         [11:0]         byte_count;
reg         [3:0]          header_count;
// reg         [3:0]          seq_count;
reg         [4:0]          overhead_count;
reg         [11:0]         pkt_size;
reg         [2:0]          next_gen_state;
reg                        byte_count_eq_1 = 0;
reg         [2:0]          gen_state;
wire        [7:0]          lut_data;
reg                        tvalid_int;
reg         [16:0]         seq_id;
reg         [31:0]         pkt_id; // increment 1 after every transmit
reg         [127:0]        pkt_hdr;


// sent packet counter, should be in [0, max_packet_counter)
reg         [15:0]         max_sent_packet_counter;
reg         [15:0]         sent_packet_counter;

// like enable_pat_gen, but used to capture tx_signal and enable N packet generation
reg                        tx_active;

// rate control signals
reg         [7:0]          basic_rc_counter;
reg                        add_credit;
reg         [12:0]         credit_count;

reg                       axi_treset;

// assign axi_treset = !axi_tresetn;

always @(posedge axi_tclk) begin
   axi_treset <= !axi_tresetn;
end

// work out the adjustment required to get the right packet size.               
reg         [31:0]     PKT_ADJUST;

// generate the require header count compare (count start from 0)
reg         [31:0]     HEADER_LENGTH;

// generate pkt_gen_finish pulse whtn tx_active goes low
reg                    tx_active_s1;
assign                 pkt_gen_finish = tx_active_s1 && !tx_active;

always @(posedge axi_tclk) begin
   tx_active_s1 <= tx_active;
end

// update sent packet counter
always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      sent_packet_counter <= 0;
   end
   else if (sent_packet_counter == max_sent_packet_counter && tx_active) begin
      sent_packet_counter <= 0;
   end 
   else if (gen_state == DATA & next_gen_state != DATA) begin // finish a packet
      // enable counter
      sent_packet_counter <= sent_packet_counter + 1;
   end
end

// update packet id
reg tx_signal_s1;

always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      pkt_id <= 0;
   end
   else if (gen_state == DATA & next_gen_state != DATA) begin // finish a packet
      // enable counter
      pkt_id <= pkt_id + 1;
   end
   else if (!tx_signal_s1 && tx_signal) begin
      pkt_id                     <= pkt_id_in;
   end
end

// capture tx_signal in tx_active state; update sent packet counter
// the tx_signal should be synced to the main clk
always @(posedge axi_tclk) begin
   tx_signal_s1 <= tx_signal;
end

always @(posedge axi_tclk) 
begin
   if (axi_treset) begin
      tx_active               <= 0;
      pkt_hdr                 <= 0;
      seq_id                  <= 0;
      max_sent_packet_counter <= 0;
      PKT_ADJUST              <= 18;
      HEADER_LENGTH           <= 11;
   end
   else if (!tx_signal_s1 && tx_signal) begin
      tx_active                  <= 1;
      pkt_hdr                    <= pkt_hdr_in;
      seq_id                     <= seq_id_in;
      max_sent_packet_counter    <= max_sent_packet_counter_in;
      PKT_ADJUST                 <= (enable_vlan_in) ? 22 : 18;
      HEADER_LENGTH              <= (enable_vlan_in) ? 15 : 11;
   end
   else if (sent_packet_counter == max_sent_packet_counter) begin
      tx_active                  <= 0;
   end
end

// need a packet counter - max size limited to 11 bits
always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      byte_count <= 0;
      increase_byte_count <= 0;
   end
   else if (gen_state == DATA & |byte_count & tready) begin
      byte_count <= byte_count -1;
      increase_byte_count <= increase_byte_count + 1;
   end     
   else if (gen_state == HEADER) begin
      byte_count <= pkt_size;
      increase_byte_count <= 0;
   end
end

always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      byte_count_eq_1 <= 0;
   end
   else if (gen_state == DATA && byte_count == 12'h2 && tready) begin
      byte_count_eq_1 <= 1;
   end     
   else if (gen_state != DATA || (byte_count_eq_1 && tready)) begin
      byte_count_eq_1 <= 0;
   end
end

// // need a sequence id counter
// always @(posedge axi_tclk)
// begin
//    if (axi_treset) begin
//       seq_count <= 0;
//    end
//    else if (gen_state == SEQ & !(&seq_count) & (tready | !tvalid_int)) begin
//       seq_count <= seq_count + 1;
//    end     
//    else if (gen_state == DATA & tready) begin
//       seq_count <= 0;
//    end
// end

// need a smaller count to manage the header insertion
always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      header_count <= 0;
   end
   else if (gen_state == HEADER & !(&header_count) & (tready | !tvalid_int)) begin
      header_count <= header_count + 1;
   end
   else if (gen_state == SIZE & tready) begin
      header_count <= 0;
   end
end

// need a count to manage the frame overhead (assume 24 bytes)
always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      overhead_count <= 0;
   end
   else if (gen_state == OVERHEAD & |overhead_count & tready) begin
      overhead_count <= overhead_count - 1;
   end
   else if (gen_state == IDLE) begin
      overhead_count <= 24;
   end
end

// need a smaller count to manage the header insertion
// adjust parameter values by 18 to allow for header and crc
// so the pkt_size can be issued directly in the size field
always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      pkt_size <= PKT_SIZE - PKT_ADJUST;
   end
   else if (gen_state == DATA & next_gen_state != DATA) begin
      pkt_size <= PKT_SIZE - PKT_ADJUST;
   end
end

// // store the parametised values in a lut (64 deep)
// // this should mean the values could be adjusted in fpga_editor etc..
/* This LUT is insightful for us to index packet header contents. */
// genvar i;  
// generate
//   for (i=0; i<=7; i=i+1) begin : lut_loop
//     LUT6 #(
//        .INIT      ({48'd0,
//                     VLAN_HEADER[i],
//                     VLAN_HEADER[i+8],
//                     VLAN_HEADER[i+16],
//                     VLAN_HEADER[i+24],
//                     SRC_ADDR[i],
//                     SRC_ADDR[i+8],
//                     SRC_ADDR[i+16],
//                     SRC_ADDR[i+24],
//                     SRC_ADDR[i+32],
//                     SRC_ADDR[i+40],
//                     DEST_ADDR[i],
//                     DEST_ADDR[i+8],
//                     DEST_ADDR[i+16],
//                     DEST_ADDR[i+24],
//                     DEST_ADDR[i+32],
//                     DEST_ADDR[i+40]
//                    })   // Specify LUT Contents
//     ) LUT6_inst (
//        .O         (lut_data[i]), 
//        .I0        (header_count[0]),
//        .I1        (header_count[1]),
//        .I2        (header_count[2]),
//        .I3        (header_count[3]),
//        .I4        (1'b0),
//        .I5        (1'b0) 
//     );
//    end
// endgenerate


// simple state machine to control the data
// on the transition from IDLE we reset the counters and increment the packet size
always @(gen_state or tx_active or header_count or tready or byte_count or tvalid_int or
         overhead_count or byte_count_eq_1)
begin
   next_gen_state = gen_state;
   case (gen_state)
      IDLE : begin
         if (tx_active & !tvalid_int)
            next_gen_state = HEADER;
      end
      HEADER : begin
         if (header_count == HEADER_LENGTH & tready)
            next_gen_state = SIZE;
      end
      SIZE : begin
         // when we enter SIZE header count is initially all 1's 
         // it is cleared when we enter SIZE which gives us the required two cycles in this state
         if (header_count == 0 & tready)
            next_gen_state = DATA;
      end
      // SEQ  : begin
      //    if (seq_count == SEQ_LENGTH & tready)
      //       next_gen_state = DATA;
      // end
      DATA : begin
         // when an AVB AV channel we want to keep valid asserted to indicate a continuous feed of data
         //   the AVB module is then enitirely resposible for the bandwidth
         if (byte_count_eq_1 & tready) begin
            next_gen_state = OVERHEAD;
         end
      end
      OVERHEAD : begin
         if (overhead_count == 1 & tready) begin 
            next_gen_state = IDLE;
         end
      end
      default : begin
         next_gen_state = IDLE;
      end
   endcase
end

always @(posedge axi_tclk)
begin
   if (axi_treset) begin
      gen_state <= IDLE;
   end
   else begin
   gen_state <= next_gen_state;
   end
end


// now generate the TVALID output
always @(posedge axi_tclk)
begin
   if (axi_treset)
      tvalid_int <= 0;
   else if (gen_state != IDLE & gen_state != OVERHEAD)
      tvalid_int <= 1;
   else if (tready)
      tvalid_int <= 0;
end

// now generate the TDATA output

always @(posedge axi_tclk)
begin
   if (gen_state == HEADER & (tready | !tvalid_int))
      tdata <= pkt_hdr[header_count*8 +: 8];
   else if (gen_state == SIZE & tready) begin
      if (header_count[3])
         tdata <= 8'h66;
      else
         tdata <= 8'hab;
   end
   else if (tready) begin
      if (increase_byte_count >= 18 && increase_byte_count <= 19)
         tdata <= seq_id[(19 - increase_byte_count)*8 +: 8]; // uint16 seq_id
      else if (increase_byte_count >= 20 && increase_byte_count <= 23)
         tdata <= pkt_id[(23 - increase_byte_count)*8 +: 8]; // uint32 pkt_id
      else
         tdata <= byte_count[7:0];
   end
end


// now generate the TLAST output
always @(posedge axi_tclk)
begin
   if (axi_treset)
      tlast <= 0;
   else if (byte_count_eq_1 & tready)
      tlast <= 1;
   else if (tready)
      tlast <= 0;
end

assign tvalid = tvalid_int;


endmodule
