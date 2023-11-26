`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/15 17:23:43
// Design Name: 
// Module Name: pulse_generator_tb
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


module pulse_generator_tb(
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

    
    reg  [71:0] time_reg_ns_in;
    wire [71:0] time_reg_ns;
    wire [63:0] time_ptp_ns;
    wire [63:0] sync_time_ptp_ns;

    rtc_mini rtc(
        // .rst(rtc_rst),
        // .rst(rtc_rst || rst),
        // TODO: replace this with `!axis_resetn`
        .rst(glbl_rst),
        // .rst((~S_AXI_REG_ARESETN)),
        .clk(gtx_clk_bufg),

        // .time_ld(time_ld),
        .time_reg_ns_in(time_reg_ns_in),

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

    wire tx_signal;
    // reg [63:0] tx_period_ns = 64'd10_000_000; 
    reg [63:0] tx_period_ns = 64'd1_000;
    reg [63:0] time_offset_ptp_ns = 64'd100_000; 

    pulse_generator dut(
        .clk(gtx_clk_bufg),
        .rst(glbl_rst),
        .time_ptp_ns(sync_time_ptp_ns),
        .time_offset_ptp_ns(time_offset_ptp_ns),
        .tx_period_ns(tx_period_ns),
        .tx_signal(tx_signal)
    );
    
endmodule
