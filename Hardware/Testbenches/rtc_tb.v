`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/13 14:55:49
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
    reg rst;

    initial 
    begin
        clk <= 1'b0;
        forever #4 clk <= !clk;
    end

    initial 
    begin
        rst <= 1'b1;
        #40;
        rst <= 1'b0;
    end

    reg time_ld = 1'b0;
    reg [37:0] time_reg_ns_in = 38'd0; 
    reg [47:0] time_reg_sec_in = 48'd0;

    reg period_ld = 1'b0;
    reg [39:0] period_in = 40'd0;

    reg adj_ld = 1'b0;
    reg [31:0] adj_ld_data = 32'd0;
    wire adj_ld_done;
    reg [39:0] period_adj = 40'd0;

    reg offset_ld = 1'b0;
    reg [31:0] offset_ptp_ns_in = 32'd0;
    reg [47:0] offset_ptp_sec_in = 48'd0;

    wire [37:0] time_reg_ns;
    wire [47:0] time_reg_sec;
    wire time_one_pps;

    wire [31:0] time_ptp_ns;
    wire [47:0] time_ptp_sec;

    wire [31:0] sync_time_ptp_ns;
    wire [47:0] sync_time_ptp_sec;

    wire [63:0] time_ptp_ns_mini;
    wire [63:0] sync_time_ptp_ns_mini;

    initial begin
        #1000;
        @(posedge clk);
        offset_ld <= 1'b1;
        offset_ptp_ns_in <= 32'hf000000;
        offset_ptp_sec_in <= 48'd0;
        @(posedge clk);
        offset_ld <= 1'b0;

        #1000;
        @(posedge clk);
        offset_ld <= 1'b1;
        offset_ptp_ns_in <= 32'd8;
        offset_ptp_sec_in <= 48'h8000_0000_0000;
        @(posedge clk);
        offset_ld <= 1'b0;

        #1000;
        @(posedge clk);
        offset_ld <= 1'b1;
        offset_ptp_ns_in <= 32'd999999999;
        offset_ptp_sec_in <= 48'd0;
        @(posedge clk);
        offset_ld <= 1'b0;

        #1000;
        @(posedge clk);
        time_ld = 1'b1;
        time_reg_ns_in = 38'd0;
        time_reg_sec_in = 48'hffff;
        @(posedge clk);
        time_ld = 1'b0;

        #100;
        @(posedge clk);
        offset_ld <= 1'b1;
        offset_ptp_ns_in <= 32'd999999999;
        offset_ptp_sec_in <= 48'h8000_0000_0000;
        @(posedge clk);
        offset_ld <= 1'b0;

        #1000;
        @(posedge clk);
        offset_ld <= 1'b1;
        offset_ptp_ns_in <= 32'd999999999;
        offset_ptp_sec_in <= 48'hff00_0000;
        @(posedge clk);
        offset_ld <= 1'b0;

        #1000;
        @(posedge clk);
        offset_ld <= 1'b1;
        offset_ptp_ns_in <= 32'd999999999;
        offset_ptp_sec_in <= 48'h8000_0000_00ff;
        @(posedge clk);
        offset_ld <= 1'b0;
    end

   

    rtc rtc_i (
        .rst(rst),
        // .rst(rtc_rst || (~S_AXI_REG_ARESETN)),
        .clk(clk),

        .time_ld(time_ld),
        .time_reg_ns_in(time_reg_ns_in),
        .time_reg_sec_in(time_reg_sec_in),

        .period_ld(period_ld),
        .period_in(period_in),

        .adj_ld(adj_ld),
        .adj_ld_data(adj_ld_data),
        .adj_ld_done(adj_ld_done),
        .period_adj(period_adj),

        .offset_ld(offset_ld),
        .offset_ptp_ns_in(offset_ptp_ns_in),
        .offset_ptp_sec_in(offset_ptp_sec_in),

        .time_reg_ns(time_reg_ns),
        .time_reg_sec(time_reg_sec),

        .time_one_pps(time_one_pps),

        .time_ptp_ns(time_ptp_ns),
        .time_ptp_sec(time_ptp_sec),
        .time_ptp_ns_mini(time_ptp_ns_mini),

        .sync_time_ptp_ns(sync_time_ptp_ns),
        .sync_time_ptp_sec(sync_time_ptp_sec),
        .sync_time_ptp_ns_mini(sync_time_ptp_ns_mini)
    );
endmodule
