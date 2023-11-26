`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/15 16:44:53
// Design Name: 
// Module Name: pulse_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pulse_generator (
        input clk,
        input rst,
        // current time
        input [63:0] time_ptp_ns,
        // tx period
        input [63:0] tx_period_ns,
        // start time
        input [63:0] time_offset_ptp_ns,
        output tx_signal
    );

    reg [63:0] counter;
    wire [60:0] goal;

    assign goal = tx_period_ns[63:3]; // 125MHz clk <--> 8 ns/cycle

    assign allow_tx = time_ptp_ns >= time_offset_ptp_ns;
    reg timeout;
    assign tx_signal = allow_tx && timeout;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            timeout <= 0;
        end
        else begin 
            counter <= counter + 1;
            if (counter >= goal - 1) begin
                counter <= 0;
                timeout <= 1;
            end
            else begin
                timeout <= 0;
            end
        end
    end

endmodule