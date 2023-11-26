`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Horace He.
// 
// Create Date: 2022/04/26 17:00:00
// Design Name: tsn_device
// Module Name: axis_ethertype_checker
// Project Name: tsn_device
// Target Devices: 
// Tool Versions: 
// Description: 
// Input a ethernet packet with 8bit axis signal, output if it belongs to critical frame or not.
// The output signal will be valid after first 18 bytes (Ethernet header w/ VLAN) of current packet.
//
// For critical frame, the ethertype filed is 0x66ab
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axis_ethertype_checker(
    input       rst,
    input       axis_aclk,

    input       axis_tvalid,
    input       axis_tready,
    input [7:0] axis_tdata,
    input       axis_tlast,

    output reg  is_critical_frame
);

reg [15:0]      ether_type;

reg [11:0]      byte_count;

reg [2:0]       state, next_state;

always @(posedge axis_aclk) begin
    if (rst) begin
        is_critical_frame <= 0;
    end
    else if (byte_count == 18) begin
        is_critical_frame <= (ether_type == 32'h66ab);
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
        ether_type <= 0;
    end
    else if (axis_tlast) begin // end of packet
        ether_type <= 0;
    end
    else if (axis_tvalid && axis_tready) begin
        if (byte_count == 16) begin
            ether_type[15:8] <= axis_tdata;
        end
        else if (byte_count == 17) begin
            ether_type[7:0] <= axis_tdata;
        end
    end
end



endmodule
