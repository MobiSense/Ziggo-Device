`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zeyu Wang.
// 
// Create Date: 2022/4/6 13:03
// Design Name: 
// Module Name: datapath
// Project Name: tsn device
// Target Devices: 
// Tool Versions: 
// Description: 
//      check whether the packet is IT frame?
//              judged by the ethernet type in the 13~14 byte of packet header
//              if the ethernet type is not 0x66ab(critical frame) or 0x88f7(ptp frame), then it is IT frame.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module axis_it_checker (
    input               rstn,
    input               axis_aclk,

    input               axis_tvalid,
    input               axis_tready,    // why is input？A: axis_it_checker is a monitor to monitor signals
    input   [255:0]     axis_tdata,
    input               axis_tlast,

    output  reg         is_it_frame
);

(* mark_debug = "true" *) reg [1:0]   state, next_state;
wire [15:0]  ethertype1, ethertype2;
assign ethertype1 = {axis_tdata[13*8-1:12*8], axis_tdata[14*8-1:13*8]};
assign ethertype2 = {axis_tdata[17*8-1:16*8], axis_tdata[18*8-1:17*8]};
wire rst = ~rstn;

localparam  IDLE            = 2'b00,
            RECEIVING       = 2'b01,
            LASTBLOCK       = 2'b10;

always @(state or axis_tvalid or axis_tready or axis_tlast)
begin
    next_state = state;
    case (state)
        IDLE        :
        begin
            if (axis_tvalid && axis_tready)
            begin
                next_state = axis_tlast ? LASTBLOCK : RECEIVING;
            end
        end
        RECEIVING   :
        begin
            if (axis_tvalid && axis_tready && axis_tlast)
            begin
                next_state = LASTBLOCK;
            end
        end
        LASTBLOCK   :
        begin
            if (axis_tvalid && axis_tready)
            begin
                next_state = axis_tlast ? LASTBLOCK : RECEIVING;
            end
            else
            begin
                next_state = IDLE;
            end
        end
        default     :
        begin
            next_state = state;
        end
    endcase
end

always @(posedge axis_aclk)
begin
    if (rst)
    begin
        is_it_frame <= 1'b1;
    end
    else
    begin
        if (state != RECEIVING && next_state != IDLE)
        begin
            if (ethertype1 == 32'h8100)
            begin
                is_it_frame <= (ethertype2 != 32'h66ab && ethertype2 != 32'h88f7) ? 1'b1 : 1'b0;
            end
            else
            begin
                is_it_frame <= (ethertype1 != 32'h66ab && ethertype1 != 32'h88f7) ? 1'b1 : 1'b0;
            end
        end
    end
end

always @(posedge axis_aclk)
begin
    if (rst)
    begin
        state <= IDLE;
    end
    else
    begin
        state <= next_state;
    end
end

endmodule
