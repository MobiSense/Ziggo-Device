`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Horace He.
// 
// Create Date: 2021/11/21 15:32:40
// Design Name: tsn_device
// Module Name: axis_ptp_checker
// Project Name: tsn_device
// Target Devices: 
// Tool Versions: 
// Description: 
// Input a ethernet packet with 8bit axis signal, output if it belongs to ptp or not.
// The output signal will be valid after first 12bytes (MAC address) of current packet.
// 
// For any PTP related ethernet pacekt, it has following features:
//      * dst_MAC = \x01\x80\xc2\x00\x00\x0e
//      * ethter_type = \x88\xf7
// Here we only check its MAC address.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axis_ptp_checker(
    input       rst,
    input       axis_aclk,

    input       axis_tvalid,
    input       axis_tready,
    input [7:0] axis_tdata,
    input       axis_tlast,

    output reg  is_ptp_frame
);

reg [47:0]       MAC_addresses;

// (* mark_debug = "true" *)wire is_ptp_frame_debug;
// assign is_ptp_frame_debug = is_ptp_frame;

// (* mark_debug = "true" *)wire       axis_tvalid_debug;
// (* mark_debug = "true" *)wire       axis_tready_debug;
// (* mark_debug = "true" *)wire [7:0] axis_tdata_debug;
// (* mark_debug = "true" *)wire       axis_tlast_debug;

// assign axis_tvalid_debug   = axis_tvalid;
// assign axis_tready_debug   = axis_tready;
// assign axis_tdata_debug    = axis_tdata;
// assign axis_tlast_debug    = axis_tlast;

reg [11:0]      byte_count;

reg [2:0]       state, next_state;

always @(posedge axis_aclk) begin
    if (rst) begin
        is_ptp_frame <= 0;
    end
    else if (byte_count >= 6 && MAC_addresses == 48'h0180c200000e) begin
        is_ptp_frame <= 1;
    end
    else if (byte_count < 6) begin
        is_ptp_frame <= 0;
    end
end

always @(posedge axis_aclk) begin
    if (rst) begin
        byte_count <= 0;
    end
    else if (axis_tlast) begin
        byte_count <= 0;
    end
    else if (axis_tvalid && axis_tready) begin
        byte_count <= byte_count + 1;
    end
end

integer i;
always @(posedge axis_aclk) begin
    if (rst) begin
        MAC_addresses <= 0;
    end
    else if (axis_tlast) begin // end of packet
        MAC_addresses <= 0;
    end
    else if (axis_tvalid && axis_tready && byte_count < 6) begin
        MAC_addresses[(5-byte_count)*8 +: 8] <= axis_tdata;
    end
end



endmodule
