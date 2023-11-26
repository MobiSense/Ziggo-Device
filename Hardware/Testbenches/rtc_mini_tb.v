`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/15 16:05:44
// Design Name: 
// Module Name: rtc_tb
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


module rtc_tb(

    );
    reg clk;
    reg glbl_rst = 0;
    wire gtx_clk_bufg = clk;

    initial begin 
        clk <= 0;
        forever #4 clk <= ~clk;
    end

    initial 
    begin
        glbl_rst <= 1'b1;
        #40;
        glbl_rst <= 1'b0;
    end

    
    // reg  [71:0] time_reg_ns_in;
    wire [71:0] time_reg_ns;
    wire [63:0] time_ptp_ns;
    wire [63:0] sync_time_ptp_ns;

    rtc_mini dut(
        // .rst(rtc_rst),
        // .rst(rtc_rst || rst),
        // TODO: replace this with `!axis_resetn`
        .rst(glbl_rst),
        // .rst((~S_AXI_REG_ARESETN)),
        .clk(gtx_clk_bufg),

        // .time_ld(time_ld),
        // .time_reg_ns_in(time_reg_ns_in),

        // .period_ld(period_ld),
        // .period_in(period_in),

        // .adj_ld(adj_ld),
        // .adj_ld_data(adj_ld_data),
        // .adj_ld_done(adj_ld_done),
        // .period_adj(period_adj),

        // .offset_ld(offset_ld),
        // .offset_ptp_ns_in(offset_ptp_ns_in),

        .time_reg_ns(time_reg_ns),

        .time_ptp_ns(time_ptp_ns),
        .sync_time_ptp_ns(sync_time_ptp_ns)
    );
    
endmodule
