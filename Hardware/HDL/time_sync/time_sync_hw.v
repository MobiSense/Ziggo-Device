`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/04 19:20:49
// Design Name: 
// Module Name: time_sync_hw
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


module time_sync_hw
    #(
        parameter integer C_S_AXI_REG_ADDR_WIDTH             = 32,
        parameter integer C_S_AXI_REG_DATA_WIDTH             = 32,
        parameter integer C_EXTERNAL_INTR_OUT_WIDTH          = 1
    )
    (
        input wire rst_,
        // Register Slave System Signals
        input wire                                 S_AXI_REG_ACLK,
        input wire                                 S_AXI_REG_ARESETN,
    
        // Register Slave Interface Write Address Ports
        input  wire [C_S_AXI_REG_ADDR_WIDTH-1:0]   S_AXI_REG_AWADDR,
        input  wire [3-1:0]                        S_AXI_REG_AWPROT,
        input  wire                                S_AXI_REG_AWVALID,
        output wire                                S_AXI_REG_AWREADY,

        // Register Slave Interface Write Data Ports
        input  wire [C_S_AXI_REG_DATA_WIDTH-1:0]   S_AXI_REG_WDATA,
        input  wire [C_S_AXI_REG_DATA_WIDTH/8-1:0] S_AXI_REG_WSTRB,
        input  wire                                S_AXI_REG_WVALID,
        output wire                                S_AXI_REG_WREADY,

        // Register Slave Interface Write Response Ports
        output wire [2-1:0]                        S_AXI_REG_BRESP,
        output reg                                 S_AXI_REG_BVALID,
        input  wire                                S_AXI_REG_BREADY,

        // Register Slave Interface Read Address Ports
        input  wire [C_S_AXI_REG_ADDR_WIDTH-1:0]   S_AXI_REG_ARADDR,
        input  wire [3-1:0]                        S_AXI_REG_ARPROT,
        input  wire                                S_AXI_REG_ARVALID,
        output wire                                S_AXI_REG_ARREADY,

        // Register Slave Interface Read Data Ports
        output wire [C_S_AXI_REG_DATA_WIDTH-1:0]   S_AXI_REG_RDATA,
        output wire [2-1:0]                        S_AXI_REG_RRESP,
        output reg                                 S_AXI_REG_RVALID,
        input  wire                                S_AXI_REG_RREADY,

        // Interrupt Output Ports
        output wire                                INTR_OUT,

        // RTC and TSU Ports
        input  wire        rtc_clk,
        output wire [63:0] time_ptp_ns_mini, // 63:0 ns, rtc_mini style
        output wire [63:0] sync_time_ptp_ns_mini, // 63:0 ns, rtc_mini style
        output wire [31:0] time_ptp_ns,
        output wire [47:0] time_ptp_sec,
        output wire [31:0] sync_time_ptp_ns,
        output wire [47:0] sync_time_ptp_sec,
        output wire        rtc_time_one_pps,

        // MAC AXIS
        input [3:0] mac_tx_axis_aclk,
        input [3:0] mac_tx_axis_tvalid,
        input [3:0] mac_tx_axis_tready,
        input [31:0] mac_tx_axis_tdata_flat,
        input [3:0] mac_tx_axis_tlast,

        input [3:0] mac_rx_axis_aclk,
        input [3:0] mac_rx_axis_tvalid,
        input [3:0] mac_rx_axis_tready,
        input [31:0] mac_rx_axis_tdata_flat,
        input [3:0] mac_rx_axis_tlast,

        input         gcl_clk_in,
        input [575:0] gcl_data_flat_in,
        output[  3:0] gcl_ld,
        output[  3:0] gcl_id,
        output[  8:0] gcl_ld_data
    );

    wire rtc_rst;

    wire time_ld;
    wire [37:0] time_reg_ns_in;
    wire [47:0] time_reg_sec_in;

    wire period_ld;
    wire [39:0] period_in;

    wire adj_ld;
    wire [31:0] adj_ld_data;
    wire adj_ld_done;
    wire [39:0] period_adj;

    wire offset_ld;
    wire [31:0] offset_ptp_ns_in;
    wire [47:0] offset_ptp_sec_in;

    wire [37:0] time_reg_ns;
    wire [47:0] time_reg_sec;

    wire time_one_pps;

    wire [3:0] rx_q_rst;
    wire [3:0] rx_q_clk;
    wire [3:0] rx_q_rd_en;
    wire [  7:0] rx_q_ptp_msgid_mask [0:3];
    wire [  7:0] rx_q_stat [0:3];
    wire [127:0] rx_q_data [0:3];

    wire [3:0] tx_q_rst;
    wire [3:0] tx_q_clk;
    wire [3:0] tx_q_rd_en;
    wire [  7:0] tx_q_ptp_msgid_mask [0:3];
    wire [  7:0] tx_q_stat [0:3];
    wire [127:0] tx_q_data [0:3];

    wire        up_wr;
    wire        up_rd;
    wire [11:0] up_addr;
    wire [31:0] up_data_wr;
    wire [31:0] up_data_rd;

    reg rst;

    always @(posedge rtc_clk) begin
        rst <= rst_;
    end

    assign S_AXI_REG_AWREADY = 1'b1;
    assign S_AXI_REG_WREADY  = 1'b1;
    assign S_AXI_REG_BRESP   = 2'b00;
    always @(negedge S_AXI_REG_ARESETN or posedge S_AXI_REG_ACLK) begin
        if (!S_AXI_REG_ARESETN) S_AXI_REG_BVALID <= 1'b0;
        else                    S_AXI_REG_BVALID <= S_AXI_REG_WVALID;
    end
    assign S_AXI_REG_ARREADY = 1'b1;
    assign S_AXI_REG_RDATA   = up_data_rd;
    assign S_AXI_REG_RRESP   = 2'b00;
    always @(negedge S_AXI_REG_ARESETN or posedge S_AXI_REG_ACLK) begin
        if (!S_AXI_REG_ARESETN) S_AXI_REG_RVALID <= 1'b0;
        else                    S_AXI_REG_RVALID <= S_AXI_REG_ARVALID;
    end

    // Interrupt interface
    assign INTR_OUT = 1'b0;

    // Local Bus interface
    // We only get the lower 8 bits of S_AXI_REG_AWADDR
    assign up_wr      = S_AXI_REG_WVALID;
    assign up_rd      = S_AXI_REG_ARVALID;
    assign up_addr    = S_AXI_REG_AWVALID? S_AXI_REG_AWADDR[11:0] : S_AXI_REG_ARADDR[11:0];
    assign up_data_wr = S_AXI_REG_WDATA;

    wire [ 9: 0] word_addr_in;
    wire [ 11: 0] byte_addr_in;
    assign word_addr_in = up_addr[11: 2];
    assign byte_addr_in = {word_addr_in, 2'b00};

    // rgmii data bus
    wire [3:0] rgmii_txd [0:3];
    wire [3:0] rgmii_rxd [0:3];
   
    // axis data bus
    wire [7:0] mac_tx_axis_tdata [0:3];
    wire [7:0] mac_rx_axis_tdata [0:3];
    
    assign {mac_tx_axis_tdata[3], mac_tx_axis_tdata[2], mac_tx_axis_tdata[1], mac_tx_axis_tdata[0]} = mac_tx_axis_tdata_flat;
    assign {mac_rx_axis_tdata[3], mac_rx_axis_tdata[2], mac_rx_axis_tdata[1], mac_rx_axis_tdata[0]} = mac_rx_axis_tdata_flat;
    

    wire [31:0] tx_q_stat_flat;
    wire [31:0] rx_q_stat_flat;
    wire [511:0] tx_q_data_flat;
    wire [511:0] rx_q_data_flat;

    assign tx_q_stat_flat = {tx_q_stat[3], tx_q_stat[2], tx_q_stat[1], tx_q_stat[0]};
    assign rx_q_stat_flat = {rx_q_stat[3], rx_q_stat[2], rx_q_stat[1], rx_q_stat[0]};
    assign tx_q_data_flat = {tx_q_data[3], tx_q_data[2], tx_q_data[1], tx_q_data[0]};
    assign rx_q_data_flat = {rx_q_data[3], rx_q_data[2], rx_q_data[1], rx_q_data[0]};

    wire [31:0] rx_q_ptp_msgid_mask_flat;
    wire [31:0] tx_q_ptp_msgid_mask_flat;

    assign {rx_q_ptp_msgid_mask[3], rx_q_ptp_msgid_mask[2], rx_q_ptp_msgid_mask[1], rx_q_ptp_msgid_mask[0]} = rx_q_ptp_msgid_mask_flat;
    assign {tx_q_ptp_msgid_mask[3], tx_q_ptp_msgid_mask[2], tx_q_ptp_msgid_mask[1], tx_q_ptp_msgid_mask[0]} = tx_q_ptp_msgid_mask_flat ;

    wire [79:0] rtc_time_ptp_val = {time_ptp_sec[47:0], time_ptp_ns[31:0]};
    
    
    wire [575:0] gcl_data_flat;
    assign gcl_data_flat = gcl_data_flat_in;

    rgs u_rgs (
        .rst(!S_AXI_REG_ARESETN), 
        .clk(S_AXI_REG_ACLK),

        .wr_in(up_wr),
        .rd_in(up_rd),
        .addr_in(byte_addr_in),
        .data_in(up_data_wr),
        .data_out(up_data_rd),

        .rtc_clk_in(rtc_clk),
        .rtc_rst_out(rtc_rst),
        .time_ld_out(time_ld),
        .time_reg_ns_out(time_reg_ns_in),
        .time_reg_sec_out(time_reg_sec_in),
        .period_ld_out(period_ld),
        .period_out(period_in),
        .adj_ld_out(adj_ld),
        .adj_ld_data_out(adj_ld_data),
        .period_adj_out(period_adj),
        .adj_ld_done_in(adj_ld_done),
        .offset_ld_out(offset_ld),
        .offset_ptp_ns_out(offset_ptp_ns_in),
        .offset_ptp_sec_out(offset_ptp_sec_in),
        .time_reg_ns_in(time_reg_ns),
        .time_reg_sec_in(time_reg_sec),
        .sync_time_ns_in(sync_time_ptp_ns),
        .sync_time_sec_in(sync_time_ptp_sec),

        .rx_q_rst_out(rx_q_rst),
        .rx_q_rd_clk_out(rx_q_clk),
        .rx_q_rd_en_out(rx_q_rd_en),
        .rx_q_ptp_msgid_mask_out_flat(rx_q_ptp_msgid_mask_flat),
        .rx_q_stat_in_flat(rx_q_stat_flat),
        .rx_q_data_in_flat(rx_q_data_flat),
        .tx_q_rst_out(tx_q_rst),
        .tx_q_rd_clk_out(tx_q_clk),
        .tx_q_rd_en_out(tx_q_rd_en),
        .tx_q_ptp_msgid_mask_out_flat(tx_q_ptp_msgid_mask_flat),
        .tx_q_stat_in_flat(tx_q_stat_flat),
        .tx_q_data_in_flat(tx_q_data_flat),
        .gcl_clk_in(gcl_clk_in),
        .gcl_data_in_flat(gcl_data_flat),
        .gcl_ld_out(gcl_ld),
        .gcl_id_out(gcl_id),
        .gcl_data_out(gcl_ld_data)
    );

    rtc rtc_i (
        // .rst(rtc_rst),
        .rst(rtc_rst || rst),
        // .rst((~S_AXI_REG_ARESETN)),
        .clk(rtc_clk),

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
        .time_reg_ns_mini(),

        .time_one_pps(time_one_pps),

        .time_ptp_ns_mini(time_ptp_ns_mini), // 63:0 ns, rtc_mini style
        .sync_time_ptp_ns_mini(sync_time_ptp_ns_mini), // 63:0 ns, rtc_mini style
        .time_ptp_ns(time_ptp_ns),
        .time_ptp_sec(time_ptp_sec),
        .sync_time_ptp_ns(sync_time_ptp_ns),
        .sync_time_ptp_sec(sync_time_ptp_sec)
    );

    // Timestamp PTP event messages
    genvar i;
    generate 
        for (i = 0; i < 4; i = i + 1)
        begin
            tsu_axis tsu_axis_tx_i (
                .rst(rst),
                .mac_axis_aclk(mac_tx_axis_aclk[i]),
                .mac_axis_tvalid(mac_tx_axis_tvalid[i]),
                .mac_axis_tready(mac_tx_axis_tready[i]),
                .mac_axis_tdata(mac_tx_axis_tdata[i]),
                .mac_axis_tlast(mac_tx_axis_tlast[i]),

                .ptp_msgid_mask(tx_q_ptp_msgid_mask[i]), // Sync Pdelay Pdelay_resp 8'b0000_1101
                // .ptp_msgid_mask(8'b0000_1101), // Sync Pdelay Pdelay_resp 8'b0000_1101
                .rtc_timer_clk(rtc_clk),
                .rtc_timer_in(rtc_time_ptp_val),
                .q_rst(tx_q_rst[i]),
                // .q_rst(!S_AXI_REG_ARESETN),
                .q_rd_clk(tx_q_clk[i]),
                .q_rd_en(tx_q_rd_en[i]),
                // .q_rd_en(1'b1),
                .q_rd_stat(tx_q_stat[i]),
                .q_rd_data(tx_q_data[i])
            );

            tsu_axis tsu_axis_rx_i (
                .rst(rst),
                .mac_axis_aclk(mac_rx_axis_aclk[i]),
                .mac_axis_tvalid(mac_rx_axis_tvalid[i]),
                .mac_axis_tready(mac_rx_axis_tready[i]),
                .mac_axis_tdata(mac_rx_axis_tdata[i]),
                .mac_axis_tlast(mac_rx_axis_tlast[i]),

                .ptp_msgid_mask(rx_q_ptp_msgid_mask[i]), // Sync Pdelay Pdelay_resp
                // .ptp_msgid_mask(8'b0000_1101), // Sync Pdelay Pdelay_resp 8'b0000_1101
                .rtc_timer_clk(rtc_clk),
                .rtc_timer_in(rtc_time_ptp_val),
                .q_rst(rx_q_rst[i]),
                // .q_rst(!S_AXI_REG_ARESETN),
                .q_rd_clk(rx_q_clk[i]),
                .q_rd_en(rx_q_rd_en[i]),
                // .q_rd_en(1'b1),
                .q_rd_stat(rx_q_stat[i]),
                .q_rd_data(rx_q_data[i])
            );
            
        end
    endgenerate
    
    
endmodule
