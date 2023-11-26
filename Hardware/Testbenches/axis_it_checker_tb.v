`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/29 16:11:19
// Design Name: 
// Module Name: axis_it_checker_tb.v
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

module axis_it_checker_tb ();

// Local parameters
// time scale is 1ps/1ps
localparam ONE_NS = 1000;
localparam time PER_clk = 40*ONE_NS; // 40 ns clock
localparam time PER_rtc_clk = 8*ONE_NS; // 8 ns clock
localparam time PER_PS = 20*ONE_NS;
localparam DATA_WIDTH = 256;

// Reg declarations
reg clk = 1;
reg rtc_clk = 1;
reg ps_clk = 1;
reg [63:0] rtc_timer = 0;
reg resetn;
reg [DATA_WIDTH-1:0] m_axis_tdata = 0;
reg [31:0]  m_axis_tkeep = 0;
reg m_axis_tvalid = 0;
reg m_axis_tlast = 0;
reg m_axis_tready = 1'b1;

wire reset = ~resetn;

wire is_it_frame;

integer i = 0;

reg [DATA_WIDTH-1:0] block[6:0];

// Clock signals
always begin
    clk = #(PER_clk/2) ~clk;
end

always begin
    rtc_clk = #(PER_rtc_clk/2) ~rtc_clk;
end

always begin
    ps_clk = #(PER_PS/2) ~ps_clk;
end

always @(posedge rtc_clk) begin
    if (reset == 1'b1) begin
        rtc_timer = 0;
    end
    else begin
        rtc_timer = rtc_timer + 1;
    end
end

rtc_mini rtc(
    .rst(reset),
    .clk(rtc_clk),

    .time_reg_ns_in(time_reg_ns_in),

    .time_reg_ns(time_reg_ns),

    .time_ptp_ns(time_ptp_ns),
    .sync_time_ptp_ns(sync_time_ptp_ns)
);

//wire                    m_axis_tvalid;
//wire                    m_axis_tready;
//wire    [255:0]         m_axis_tdata;
//wire                    m_axis_tlast;

initial begin
    block[0] = 256'h0307a8c08bf774c60e00010004060008010006088bf774c60e00ffffffffffff;
    block[1] = 256'h00000000000000000000000000000000000000000000000000000201a9feca9e;
    block[2] = 256'h0307a8c08bf774c60e00010004060008010006088bf774c60e00ffffffffffff;
    block[3] = 256'h10000000c45ac5f6030000000000f78802400081493625090401ffffffffffff;
    block[4] = 256'h000000000201a9feca9e;
    block[5] = 256'hfffffffff201a9feca9e;
    block[6] = 256'h10000000c45ac5f6030000000000ab6602400081493625090401ffffffffffff;

    resetn = 1'b0;
    #(PER_clk * 16);
    resetn = 1'b1;
    
    /*--------------------------------it packet, 2 blocks----------------------------------------*/
    @(posedge clk);
    m_axis_tdata = block[0];
    m_axis_tready = 1'b1;
    m_axis_tvalid = 1'b1;
    m_axis_tlast = 1'b0;
    // m_axis_tkeep = 8'hffffffff;
    @(posedge clk);

    m_axis_tvalid = 1'b0;
    repeat(32) @(posedge clk);

    m_axis_tdata = block[1];
    m_axis_tready = 1'b1;
    m_axis_tvalid = 1'b1;
    m_axis_tlast = 1'b1;
    // m_axis_tkeep = 8'h0000003ff;
    @(posedge clk);

    m_axis_tready = 1'b0;
    m_axis_tvalid = 1'b0;
    m_axis_tlast = 1'b0;
    /*-------------------------------------------------------------------------------------------*/

    repeat(16) @(posedge clk);

    /*--------------------------------it packet, 1 block ----------------------------------------*/
    @(posedge clk);
    m_axis_tdata = block[2];
    m_axis_tready = 1'b1;
    m_axis_tvalid = 1'b1;
    m_axis_tlast = 1'b1;
    @(posedge clk);

    m_axis_tready = 1'b0;
    m_axis_tvalid = 1'b0;
    m_axis_tlast = 1'b0;
    /*-------------------------------------------------------------------------------------------*/

    repeat(16) @(posedge clk);

    /*--------------------------------critical packet, 3 blocks----------------------------------------*/
    @(posedge clk);
    m_axis_tdata = block[3];
    m_axis_tready = 1'b1;
    m_axis_tvalid = 1'b1;
    m_axis_tlast = 1'b0;
    @(posedge clk);

    m_axis_tvalid = 1'b0;
    repeat(32) @(posedge clk);

    m_axis_tdata = block[4];
    m_axis_tready = 1'b1;
    m_axis_tvalid = 1'b1;
    m_axis_tlast = 1'b0;
    @(posedge clk);

    m_axis_tvalid = 1'b0;
    repeat(32) @(posedge clk);

    m_axis_tdata = block[5];
    m_axis_tready = 1'b1;
    m_axis_tvalid = 1'b1;
    m_axis_tlast = 1'b1;
    @(posedge clk);

    m_axis_tready = 1'b0;
    m_axis_tvalid = 1'b0;
    m_axis_tlast = 1'b0;
    /*-------------------------------------------------------------------------------------------*/

    repeat(16) @(posedge clk);

    /*--------------------------------critical packet, 1 block ----------------------------------------*/
    @(posedge clk);
    m_axis_tdata = block[6];
    m_axis_tready = 1'b1;
    m_axis_tvalid = 1'b1;
    m_axis_tlast = 1'b1;

    @(posedge clk);
    m_axis_tready = 1'b0;
    m_axis_tvalid = 1'b0;
    m_axis_tlast = 1'b0;
    /*-------------------------------------------------------------------------------------------*/

    repeat(16) @(posedge clk);

    /*--------------------------------it packet, 2 blocks----------------------------------------*/
    @(posedge clk);
    m_axis_tdata = block[0];
    m_axis_tready = 1'b1;
    m_axis_tvalid = 1'b1;
    m_axis_tlast = 1'b0;
    // m_axis_tkeep = 8'hffffffff;
    @(posedge clk);

    m_axis_tvalid = 1'b0;
    repeat(32) @(posedge clk);

    m_axis_tdata = block[1];
    m_axis_tready = 1'b1;
    m_axis_tvalid = 1'b1;
    m_axis_tlast = 1'b1;
    // m_axis_tkeep = 8'h0000003ff;
    @(posedge clk);

    m_axis_tready = 1'b0;
    m_axis_tvalid = 1'b0;
    m_axis_tlast = 1'b0;
    /*-------------------------------------------------------------------------------------------*/
end

axis_it_checker axis_it_checker_tb(
    .rstn                   (resetn),                 // input rst
    .axis_aclk              (clk),                    // input axis_aclk
    .axis_tvalid            (m_axis_tvalid),          // input axis_tvalid
    .axis_tready            (m_axis_tready),          // input axis_tready
    .axis_tdata             (m_axis_tdata),           // input axis_tdata
    .axis_tlast             (m_axis_tlast),           // input axis_tlast
    .is_it_frame            (is_it_frame)             // output is_it_frame
);

endmodule