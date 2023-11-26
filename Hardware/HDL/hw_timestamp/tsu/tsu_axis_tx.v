/*
 * tsu.v
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

module tsu_axis_tx (
    input       rst,

    input       mac_axis_aclk,
    input       mac_axis_tvalid,
    input       mac_axis_tready,
    input [7:0] mac_axis_tdata,
    input       mac_axis_tlast,
    
    input        rtc_timer_clk,
    input [63:0] rtc_timer_in,  // timeStamp 1ns_64bit

    // replace ethernet body with timestamp
    output       mac_axis_out_tvalid,
    output       mac_axis_out_tready,
    output [7:0] mac_axis_out_tdata,
    output       mac_axis_out_tlast 
);

localparam IDLE = 1'b0;
localparam TRANSFER = 1'b1;

reg axis_state;
reg nxt_axis_state;

always @(posedge rst or posedge mac_axis_aclk) begin
    if (rst == 1'b1) begin
        axis_state <= IDLE;
    end
    else begin
        axis_state <= nxt_axis_state;
    end
end

always @(mac_axis_tvalid, mac_axis_tready, mac_axis_tlast, axis_state) begin
    nxt_axis_state = axis_state;
    case (axis_state)
        IDLE: begin
            if (mac_axis_tvalid == 1'b1 && mac_axis_tready == 1'b1) begin
                nxt_axis_state = TRANSFER;
            end
            else begin
                nxt_axis_state = IDLE;
            end
        end
        TRANSFER: begin
            if (mac_axis_tvalid == 1'b1 && mac_axis_tready == 1'b1 && mac_axis_tlast == 1'b1) begin
                nxt_axis_state = IDLE;
            end
            else begin
                nxt_axis_state = TRANSFER;
            end
        end
    endcase
end

wire ts_req = (axis_state == IDLE) && (mac_axis_tvalid == 1'b1 && mac_axis_tready == 1'b1);
// reg  ts_req_d1, ts_req_d2, ts_req_d3;

// always @(posedge rst or posedge rtc_timer_clk) begin
//   if (rst) begin
//     ts_req_d1 <= 1'b0;
//     ts_req_d2 <= 1'b0;
//     ts_req_d3 <= 1'b0;
//   end
//   else begin
//     ts_req_d1 <= ts_req;
//     ts_req_d2 <= ts_req_d1;
//     ts_req_d3 <= ts_req_d2;
//   end
// end

// reg [63:0] rtc_time_stamp;

// always @(posedge rst or posedge rtc_timer_clk) begin
//   if (rst)
//     rtc_time_stamp <= 64'd0;
//   else 
//     if (ts_req_d2 & !ts_req_d3)
//       rtc_time_stamp <= rtc_timer_in;
// end

// reg ts_ack, ts_ack_clr;

// always @(posedge rst or posedge ts_ack_clr or posedge rtc_timer_clk) begin
//   if (rst)
//     ts_ack <= 1'b0;
//   else if (ts_ack_clr)
//     ts_ack <= 1'b0;
//   else
//     if (ts_req_d2 & !ts_req_d3)
//       ts_ack <= 1'b1;
// end

// reg ts_ack_d1, ts_ack_d2, ts_ack_d3;
// always @(posedge rst or posedge mac_axis_aclk) begin
//   if (rst) begin
//     ts_ack_d1 <= 1'b0;
//     ts_ack_d2 <= 1'b0;
//     ts_ack_d3 <= 1'b0;
//   end
//   else begin
//     ts_ack_d1 <= ts_ack;
//     ts_ack_d2 <= ts_ack_d1;
//     ts_ack_d3 <= ts_ack_d2;
//   end
// end

reg [63:0] tsu_time_stamp;

always @(posedge rst or posedge mac_axis_aclk) begin
  if (rst) begin
    tsu_time_stamp <= 64'd0;
    // ts_ack_clr      <= 1'b0;
  end
  else begin
    if (ts_req) begin
      tsu_time_stamp <= rtc_timer_in;
      // ts_ack_clr      <= 1'b1;
    end
    else begin
      tsu_time_stamp <= tsu_time_stamp;
      // ts_ack_clr      <= 1'b0;
    end
  end
end

// byte counter
reg [ 5:0] int_bcnt;

always @(posedge rst or posedge mac_axis_aclk) begin
    if (rst) begin
        int_bcnt <= 6'd0;
    end
    else begin
      if (mac_axis_tvalid && mac_axis_tready) begin
        if (int_bcnt >= 63)
          // permit overflow
          int_bcnt <= 63;
        else
          // byte sent, increase counter by 1
          int_bcnt <= int_bcnt + 1;

        if (mac_axis_tlast == 1'b1)
          // if the last byte is sent, reset the counter
          int_bcnt <= 0;
      end
      else
        int_bcnt <= int_bcnt;
    end
end

// wire is_ptp_frame;

// axis_ptp_checker ptp_checker_inst (
//     .rst              (rst),
//     .axis_aclk        (mac_axis_aclk),
//     .axis_tvalid      (mac_axis_tvalid),
//     .axis_tready      (mac_axis_tready),
//     .axis_tdata       (mac_axis_tdata),
//     .axis_tlast       (mac_axis_tlast),
//     .is_ptp_frame     (is_ptp_frame)
// );

wire is_critical_frame;

axis_ethertype_checker ethertype_checker_inst (
    .rst              (rst),
    .axis_aclk        (mac_axis_aclk),
    .axis_tvalid      (mac_axis_tvalid),
    .axis_tready      (mac_axis_tready),
    .axis_tdata       (mac_axis_tdata),
    .axis_tlast       (mac_axis_tlast),
    .is_critical_frame     (is_critical_frame)
);

// replace ethernet body with timestamp
assign mac_axis_out_tvalid = mac_axis_tvalid;
assign mac_axis_out_tready = mac_axis_tready;
// replace axis_data [20, 27](bytes) to tsu_time_stamp
assign mac_axis_out_tdata = ((int_bcnt >= 20 && int_bcnt <= 27) && is_critical_frame) ? tsu_time_stamp[(27-int_bcnt)*8 +: 8] : mac_axis_tdata;
assign mac_axis_out_tlast = mac_axis_tlast;

endmodule