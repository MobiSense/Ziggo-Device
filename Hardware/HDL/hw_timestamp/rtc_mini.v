/*
 * rtc.v
 * 
 * Copyright (c) 2012, BABY&HW. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301  USA
 */

`timescale 1ns/1ns

module rtc_mini (
  input rst, clk,
  // 1. direct time adjustment: ToD set up
  input        time_ld,
  input [71:0] time_reg_ns_in,   // 71:8 ns, 7:0 ns_fraction
  // input [47:0] time_reg_sec_in,  // 47:0 sec
  // 2. frequency adjustment: frequency set up for drift compensation
  input        period_ld,
  input [39:0] period_in,        // 39:32 ns, 31:0 ns_fraction
  // 3. precise time adjustment: small time difference adjustment with a time mark
  input        adj_ld,
  input [31:0] adj_ld_data,
  output reg   adj_ld_done,
  input [39:0] period_adj,  // 39:32 ns, 31:0 ns_fraction
  // 4. load offset (compared to synchronized time.)
  input        offset_ld,
  input [63:0] offset_ptp_ns_in,
  // input [47:0] offset_ptp_sec_in,

  // time output: for internal with ns fraction
  output [71:0] time_reg_ns,  // 71:8 ns, 7:0 ns_fraction
  // output [47:0] time_reg_sec, // 47:0 sec

  // time output: for external with one pps accuracy 
  // output reg    time_one_pps,

  // time output: for external with ptp standard
  output [63:0] time_ptp_ns,  // 63:0 ns
  // timeoutput: sync ptp time
  output [63:0] sync_time_ptp_ns  // 63:0 ns
);

parameter initial_period_fix = 40'h8_0000_0000; // inital period 8ns

reg  [39:0] period_fix;  // 39:32 ns, 31:0 ns_fraction
reg  [31:0] adj_cnt;
reg  [39:0] time_adj;    // 39:32 ns, 31:0 ns_fraction
reg  [63:0] offset_ptp_ns_reg;

// frequency and small time difference adjustment registers
always @(posedge rst or posedge clk) begin
  if (rst) begin
    // period_fix  <= period_fix;  //40'd0;
    period_fix  <= initial_period_fix;  //40'd0;
    adj_cnt     <= 32'hffffffff;
    // time_adj    <= time_adj;    //40'd0;
    time_adj    <= 40'd0;    //40'd0;
    adj_ld_done <= 1'b0;
    offset_ptp_ns_reg <= 64'd0;
  end
  else begin
    if (period_ld)  // load period adjustment
      period_fix <= period_in;
    else
      period_fix <= period_fix;
    
    if (offset_ld) begin
        offset_ptp_ns_reg <= offset_ptp_ns_in;
    end
    else begin
        offset_ptp_ns_reg <= offset_ptp_ns_reg;
    end

    if (adj_ld)  // load precise time adjustment time mark
      adj_cnt  <= adj_ld_data;
    else if (adj_cnt==32'hffffffff)
      adj_cnt  <= adj_cnt;  // no cycling
    else
      adj_cnt  <= adj_cnt - 1;  // counting down

    if (adj_cnt==0)  // change period temparorily
      time_adj <= period_fix + period_adj;
    else
      time_adj <= period_fix + 0;

    if (adj_cnt==32'hffffffff)
      adj_ld_done <= 1'b1;
    else
      adj_ld_done <= 1'b0;
  end
end

reg  [39:0] time_adj_08n_32f;      //             39:32 ns, 31:0 ns_fraction
reg  [39:0] time_adj_16b_00n_24f;  // 39:24 sign,           23:0 ns_fraction
wire [71:0] time_adj_56b_08n_08f;  // 71:16 sign, 15: 8 ns,  7:0 ns_fraction
// delta-sigma circuit to keep the lower 24bit of time_adj
always @(posedge rst or posedge clk) begin
  if (rst) begin
    time_adj_08n_32f     <= 40'd0;
    time_adj_16b_00n_24f <= 40'd0;
  end
  else begin
    time_adj_08n_32f     <= time_adj[39: 0] + time_adj_16b_00n_24f;  // add the delta
    time_adj_16b_00n_24f <= {16'h0000, time_adj_08n_32f[23: 0]}; // save the delta
  end
end

assign time_adj_56b_08n_08f = time_adj_08n_32f[39]? {56'hff_ffff_ffff_ffff, time_adj_08n_32f[39:24]}: {56'h0, time_adj_08n_32f[39:24]};  // preserve the sign

reg  [71:0] time_acc_64n_08f_pre;  // 71:8 ns , 7:0 ns_fraction
// time accumulator pre adder (48bit_s + 30bit_ns + 8bit_ns_fraction)
always @(posedge rst or posedge clk) begin
  if (rst) begin
    time_acc_64n_08f_pre <= 72'd0;
  end
  else begin
    if (time_ld) begin  // direct write
      time_acc_64n_08f_pre <= time_reg_ns_in + time_adj_56b_08n_08f;
    end
    else begin
      // accumulate one period
      time_acc_64n_08f_pre <= time_acc_64n_08f_pre + time_adj_56b_08n_08f;
    end
  end
end

reg  [71:0] time_acc_64n_08f;          // 71:8 ns , 7:0 ns_fraction
// time accumulator (48bit_s + 30bit_ns + 8bit_ns_fraction)
always @(posedge rst or posedge clk) begin
  if (rst) begin
    time_acc_64n_08f <= 72'd0;
  end
  else begin
    if (time_ld) begin  // direct write
      time_acc_64n_08f <= time_reg_ns_in;
    end
    else begin
      time_acc_64n_08f <= time_acc_64n_08f_pre;
    end
  end
end

// time output (48bit_s + 30bit_ns + 8bit_ns_fraction)
assign time_reg_ns  = time_acc_64n_08f;
// time output (48bit_s + 32bit_ns)
assign time_ptp_ns  = time_acc_64n_08f[71:8];  // 60bit is enough to represent 1,000,000,000,000,000,000ns

// time output synchronized ptp time
// The first bit of offset_ptp_sec is used to indicate the sign of offset +/-
// wire [63:0] sync_ts_sum_ns = time_ptp_ns + offset_ptp_ns_reg;
// wire add_sec_carry = sync_ts_sum_ns >= 32'd1000000000 ? 1: 0;
// wire sub_sec_borrow = time_ptp_ns < offset_ptp_ns_reg ? 1: 0;
// wire [31:0] ns_no_borrow = time_ptp_ns - offset_ptp_ns_reg;
// wire [31:0] ns_borrow = 32'd1000000000 + time_ptp_ns - offset_ptp_ns_reg;
assign sync_time_ptp_ns = time_ptp_ns + offset_ptp_ns_reg;


// always @(time_ptp_ns, time_ptp_sec, offset_ptp_ns_reg, offset_ptp_sec_in) begin
//     if (offset_ptp_sec_in[47]) begin // minus
//         if (sub_sec_borrow) begin
            
//         end
//     end
//     else begin // add
        
//     end
// end

endmodule
