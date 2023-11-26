`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MobiSense Lab
// Engineer: Hao Cao, Xiaowu He.
//
// Create Date: 2021/06/15 11:09:53
// Design Name:
// Module Name: tns_tsn_device
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Top module for TSN test device.
//     1. send ethernet packet from one port to another with specificed period & 
//        packet number.
//     2. add timestamp at packet sending/receiving moment, append it to packet body
//     3. access packet content & write packet generator settings by DMA
//     4. time syncronization with TSN switch
//     ...
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//     1. send ethernet packet on time (10 packets every 10ms)
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
//                       _oo0oo_
//                      o8888888o
//                      88" . "88
//                      (| -_- |)
//                      0\  =  /0
//                    ___/`---'\___
//                  .' \\|     |// '.
//                 / \\|||  :  |||// \
//                / _||||| -:- |||||- \
//               |   | \\\  -  /// |   |
//               | \_|  ''\---/''  |_/ |
//               \  .-\__  '-'  ___/-. /
//             ___'. .'  /--.--\  `. .'___
//          ."" '<  `.___\_<|>_/___.' >' "".
//         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//         \  \ `_.   \_ __\ /__ _/   .-` /  /
//     =====`-.____`.___ \_____/___.-`___.-'=====
//                       `=---='
//
//
//     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//               佛祖保佑         永无BUG
//
//
//////////////////////////////////////////////////////////////////////////////////


module tns_tsn_device #(
        // C_DATA_WIDTH should be big enough to hold the Ethernet header.
        parameter C_DATA_WIDTH = 256,
        parameter C_TUSER_WIDTH = 128,
        parameter NUM_PORTS = 4
    )
    (
        // asynchronous reset
        input           glbl_rstn,
        // inpu clock signal
        input           sys_clk,

        // output          gtx_clk_bufg_out,

        // RGMII Interface
        //----------------
        output [15:0]   rgmii_txd_flat,
        output [3:0]    rgmii_tx_ctl,
        output [3:0]    rgmii_txc,
        input  [15:0]   rgmii_rxd_flat,
        input  [3:0]    rgmii_rx_ctl,
        input  [3:0]    rgmii_rxc,
        
        output [3:0]    phy_resetn,
        inout  [3:0]    mdio,
        output [3:0]    mdc 
    );

    //----------------------------------------------------------------------------
    // internal signals used in this top level wrapper.
    //----------------------------------------------------------------------------

    wire                 gtx_clk_bufg_out;

    // example design clocks
    wire                 gtx_clk_bufg;
    wire                 refclk_bufg;
    wire                 s_axi_aclk;
    wire [NUM_PORTS:0]   rx_mac_aclk;
    wire [NUM_PORTS:0]   tx_mac_aclk;
    wire                 gtx_clk_out;
    wire                 gtx_clk90_out;

    // resets (and reset generation)
    wire                 glbl_rst = !glbl_rstn; 
   
    wire                 gtx_resetn;
   
    wire [NUM_PORTS:0]   rx_reset;
    wire [NUM_PORTS:0]   tx_reset;
   
    wire                 s_axi_resetn;
    wire                 phy_resetn_int;

    assign phy_resetn[0] = phy_resetn_int;
    assign phy_resetn[1] = phy_resetn_int;
    assign phy_resetn[2] = phy_resetn_int;
    assign phy_resetn[3] = phy_resetn_int;

    wire                 dcm_locked;
    wire                 glbl_rst_intn;
   
    // set up tri-mode ethernet mac speed (10M, 100M, 1000M, etc.)
    // 1000M
    reg [1:0]            mac_speed = 2'b10;
    // 100M
    // reg [1:0]            mac_speed = 2'b01; // TODO: 10-1000M, 01-100M, 00-10M

    // Enable packet generation from hardware inside.
    wire [0:3]           enable_pat_gen;
   
    // USER side RX AXI-S interface
    wire                 rx_fifo_clock;
    wire                 rx_fifo_resetn;
   
    // 0~NUM_PORTS-1 for PHY ports, NUM_PORTS for PS_ETH
    wire  [7:0]          rx_axis_fifo_tdata [0:NUM_PORTS];
    wire                 rx_axis_fifo_tvalid [0:NUM_PORTS];
    wire                 rx_axis_fifo_tlast [0:NUM_PORTS];
    wire                 rx_axis_fifo_tready [0:NUM_PORTS];

    wire [C_DATA_WIDTH - 1: 0] rx_axis_fifo_tdata_w [0:3];
    wire                       rx_axis_fifo_tvalid_w [0:3];
    wire                       rx_axis_fifo_tlast_w [0:3];
    wire                       rx_axis_fifo_tready_w [0:3];
    wire [C_DATA_WIDTH/8-1: 0] rx_axis_fifo_tkeep_w [0:3];
   

    // USER side TX AXI-S interface
    wire                 tx_fifo_clock;
    wire                 tx_fifo_resetn;
   
    (* mark_debug = "true" *)wire  [7:0]          tx_axis_fifo_legacy_tdata [0:NUM_PORTS];
    (* mark_debug = "true" *)wire                 tx_axis_fifo_legacy_tvalid [0:NUM_PORTS];
    (* mark_debug = "true" *)wire                 tx_axis_fifo_legacy_tlast [0:NUM_PORTS];
    (* mark_debug = "true" *)wire                 tx_axis_fifo_legacy_tready [0:NUM_PORTS];

    wire [C_DATA_WIDTH-1:0]   tx_axis_fifo_legacy_tdata_w [0:3];
    wire                      tx_axis_fifo_legacy_tvalid_w [0:3];
    wire                      tx_axis_fifo_legacy_tlast_w [0:3];
    wire                      tx_axis_fifo_legacy_tready_w [0:3];
    wire [C_DATA_WIDTH/8-1:0] tx_axis_fifo_legacy_tkeep_w [0:3];
   
    // RX Statistics serialisation signals
    wire  [NUM_PORTS:0]  rx_statistics_valid;
    reg   [3:0]          rx_statistics_valid_reg;
    wire  [27:0]         rx_statistics_vector [0:NUM_PORTS];
    reg   [27:0]         rx_stats [0:3];
    reg   [29:0]         rx_stats_shift [0:3];
    reg   [3:0]          rx_stats_toggle = 4'b0;
    wire  [3:0]          rx_stats_toggle_sync;
    reg   [3:0]          rx_stats_toggle_sync_reg = 4'b0;

    // TX Statistics serialisation signals
    wire  [NUM_PORTS:0]  tx_statistics_valid;
    reg   [3:0]          tx_statistics_valid_reg;
    wire  [31:0]         tx_statistics_vector [0:NUM_PORTS];
    reg   [31:0]         tx_stats [0:3];
    reg   [33:0]         tx_stats_shift [0:3];
    reg   [3:0]          tx_stats_toggle = 4'b0;
    wire  [3:0]          tx_stats_toggle_sync;
    reg   [3:0]          tx_stats_toggle_sync_reg = 4'b0;
    wire  [3:0]          inband_link_status;
    wire  [1:0]          inband_clock_speed [0:3];
    wire  [3:0]          inband_duplex_status;

    // Pause interface DESerialisation
    reg   [18:0]         pause_shift [0:3];
    reg   [NUM_PORTS:0]  pause_req;
    reg   [15:0]         pause_val [0:NUM_PORTS];

    wire  [79:0]         rx_configuration_vector [0:3];
    wire  [79:0]         tx_configuration_vector [0:3];
   
    wire  [3:0]          tx_statistics_s;
    wire  [3:0]          rx_statistics_s;

    wire  [3:0]          int_frame_error;
    wire  [3:0]          int_activity_flash;

    // set board defaults - only updated when reprogrammed
    reg                  gen_tx_data = 0;

    // signal tie offs
    wire  [7:0]          tx_ifg_delay = 0;    // not used in this example
   
    // rgmii data bus
    wire [3:0] rgmii_txd [0:3];
    wire [3:0] rgmii_rxd [0:3];
   
    assign {rgmii_rxd[3], rgmii_rxd[2], rgmii_rxd[1], rgmii_rxd[0]} = rgmii_rxd_flat;
    assign rgmii_txd_flat = {rgmii_txd[3], rgmii_txd[2], rgmii_txd[1], rgmii_txd[0]};

    wire [3:0] rgmii_rxd_out [0:3];
    wire [15:0] rgmii_rxd_out_flat;
    wire [3:0] rgmii_rx_ctl_out;
    wire [3:0] rgmii_rxc_out;
    
    // mac axis signal
    wire [3:0] mac_tx_axis_tvalid_out;
    wire [3:0] mac_tx_axis_tready_out;
    wire [7:0] mac_tx_axis_tdata_out [0:3];
    wire [31:0] mac_tx_axis_tdata_flat;
    wire [3:0] mac_tx_axis_tlast_out;

    wire [3:0] mac_rx_axis_tvalid_out;
    wire [3:0] mac_rx_axis_tready_out;
    wire [7:0] mac_rx_axis_tdata_out [0:3];
    wire [31:0] mac_rx_axis_tdata_flat;
    wire [3:0] mac_rx_axis_tlast_out;

    assign mac_tx_axis_tdata_flat = {mac_tx_axis_tdata_out[3], mac_tx_axis_tdata_out[2], mac_tx_axis_tdata_out[1], mac_tx_axis_tdata_out[0]};
    assign mac_rx_axis_tdata_flat = {mac_rx_axis_tdata_out[3], mac_rx_axis_tdata_out[2], mac_rx_axis_tdata_out[1], mac_rx_axis_tdata_out[0]};

    // ps eth mac gmii signal
    (* mark_debug = "true" *) wire [7:0] ps_eth_gmii_txd;
    (* mark_debug = "true" *) wire ps_eth_gmii_tx_en;
    (* mark_debug = "true" *) wire ps_eth_gmii_tx_er;
    (* mark_debug = "true" *) wire ps_eth_gmii_tx_clk;
    (* mark_debug = "true" *) wire [7:0] ps_eth_gmii_rxd;
    (* mark_debug = "true" *) wire ps_eth_gmii_rx_dv;
    (* mark_debug = "true" *) wire ps_eth_gmii_rx_er;
    (* mark_debug = "true" *) wire ps_eth_gmii_rx_clk;

    // 0~NUM_PORTS-1 for PHY ports, NUM_PORTS for PS_ETH
    wire [11:0]   s_axi_awaddr [0:NUM_PORTS];
    wire          s_axi_awvalid [0:NUM_PORTS];
    wire          s_axi_awready [0:NUM_PORTS];
    wire [31:0]   s_axi_wdata [0:NUM_PORTS];
    wire          s_axi_wvalid [0:NUM_PORTS];
    wire          s_axi_wready [0:NUM_PORTS];
    wire [1:0]    s_axi_bresp [0:NUM_PORTS];
    wire          s_axi_bvalid [0:NUM_PORTS];
    wire          s_axi_bready [0:NUM_PORTS];
    wire [11:0]   s_axi_araddr [0:NUM_PORTS];
    wire          s_axi_arvalid [0:NUM_PORTS];
    wire          s_axi_arready [0:NUM_PORTS];
    wire [31:0]   s_axi_rdata [0:NUM_PORTS];
    wire [1:0]    s_axi_rresp [0:NUM_PORTS];
    wire          s_axi_rvalid [0:NUM_PORTS];
    wire          s_axi_rready [0:NUM_PORTS];

    // PS clock
    (* mark_debug = "true" *) wire [7:0]    axis_dma_o_tdata_ps;
    (* mark_debug = "true" *) wire          axis_dma_o_tlast_ps;
    (* mark_debug = "true" *) wire          axis_dma_o_tready_ps;
    (* mark_debug = "true" *) wire          axis_dma_o_tvalid_ps;

    // PS clock signal
    wire m_axis_ps_clk;
    wire s_axis_ps_clk;

    // PS resetn signl;
    wire axis_ps2pl_resetn;
    wire axis_pl2ps_resetn;

    // Clock signal.
    clk_wiz_0 clk_wiz_0_i(
        .sys_clk(sys_clk),
        .reset(glbl_rst),
        .locked(dcm_locked),
        .clk125(gtx_clk_bufg),
        .clk200(refclk_bufg),
        .clk50(s_axi_aclk)
    );
    // Pass the GTX clock to the Test Bench
    assign gtx_clk_bufg_out = gtx_clk_bufg;

    reg  [71:0] time_reg_ns_in = 72'd0;
    wire [71:0] time_reg_ns;
    wire [63:0] time_ptp_ns;
    (* mark_debug = "true" *)wire [63:0] sync_time_ptp_ns;
    (* mark_debug = "true" *)wire [31:0] sync_time_ptp_ns_legacy;
    (* mark_debug = "true" *)wire [47:0] sync_time_ptp_sec_legacy;

    wire         s_axi_time_sync_clk;
    wire         s_axi_time_sync_aresetn;

    wire         [31:0]s_axi_time_sync_araddr;
    wire         [2:0]s_axi_time_sync_arprot;
    wire         [0:0]s_axi_time_sync_arready;
    wire         [0:0]s_axi_time_sync_arvalid;
    wire         [31:0]s_axi_time_sync_awaddr;
    wire         [2:0]s_axi_time_sync_awprot;
    wire         [0:0]s_axi_time_sync_awready;
    wire         [0:0]s_axi_time_sync_awvalid;
    wire         [0:0]s_axi_time_sync_bready;
    wire         [1:0]s_axi_time_sync_bresp;
    wire         [0:0]s_axi_time_sync_bvalid;
    wire         [31:0]s_axi_time_sync_rdata;
    wire         [0:0]s_axi_time_sync_rready;
    wire         [1:0]s_axi_time_sync_rresp;
    wire         [0:0]s_axi_time_sync_rvalid;
    wire         [31:0]s_axi_time_sync_wdata;
    wire         [0:0]s_axi_time_sync_wready;
    wire         [3:0]s_axi_time_sync_wstrb;
    wire         [0:0]s_axi_time_sync_wvalid;

    // RX Statistics IT signals & other signals
    (* mark_debug = "true" *) wire    [7:0]       rx_axis_it_fifo_tdata;
    (* mark_debug = "true" *) wire                rx_axis_it_fifo_tvalid;
    (* mark_debug = "true" *) wire                rx_axis_it_fifo_tready;
    (* mark_debug = "true" *) wire                rx_axis_it_fifo_tlast;
    (* mark_debug = "true" *) wire    [7:0]       rx_axis_others_fifo_tdata;
    (* mark_debug = "true" *) wire                rx_axis_others_fifo_tvalid;
    (* mark_debug = "true" *) wire                rx_axis_others_fifo_tready;
    (* mark_debug = "true" *) wire                rx_axis_others_fifo_tlast;

    // rtc_mini rtc_i (
    //     // .rst(rtc_rst),
    //     // .rst(rtc_rst || rst),
    //     .rst(glbl_rst),
    //     // .rst((~S_AXI_REG_ARESETN)),
    //     .clk(gtx_clk_bufg),

    //     // .time_ld(time_ld),
    //     .time_reg_ns_in(time_reg_ns_in),

    //     // .period_ld(period_ld),
    //     // .period_in(period_in),

    //     // .adj_ld(adj_ld),
    //     // .adj_ld_data(adj_ld_data),
    //     // .adj_ld_done(adj_ld_done),
    //     // .period_adj(period_adj),

    //     // .offset_ld(offset_ld),
    //     // .offset_ptp_ns_in(offset_ptp_ns_in),

    //     .time_reg_ns(time_reg_ns),

    //     .time_ptp_ns(time_ptp_ns),
    //     .sync_time_ptp_ns(sync_time_ptp_ns)
    // );

    wire rx_axis_resetn = rx_fifo_resetn;
    wire tx_axis_resetn = tx_fifo_resetn;
    wire axis_resetn = rx_axis_resetn & tx_axis_resetn;
    wire external_pl_reset;

    time_sync_hw time_sync_hw_i(
        .rst_(!axis_resetn),
        .S_AXI_REG_ACLK(s_axi_time_sync_clk),
        // .S_AXI_REG_ACLK(s_axi_aclk),
        .S_AXI_REG_ARESETN(s_axi_time_sync_aresetn),
        // .S_AXI_REG_ARESETN(s_axi_resetn),

        .S_AXI_REG_AWADDR(s_axi_time_sync_awaddr),
        .S_AXI_REG_AWPROT(s_axi_time_sync_awprot),
        .S_AXI_REG_AWVALID(s_axi_time_sync_awvalid),
        .S_AXI_REG_AWREADY(s_axi_time_sync_awready),

        .S_AXI_REG_WDATA(s_axi_time_sync_wdata),
        .S_AXI_REG_WSTRB(s_axi_time_sync_wstrb),
        .S_AXI_REG_WVALID(s_axi_time_sync_wvalid),
        .S_AXI_REG_WREADY(s_axi_time_sync_wready),
              
        .S_AXI_REG_BRESP(s_axi_time_sync_bresp),
        .S_AXI_REG_BVALID(s_axi_time_sync_bvalid),
        .S_AXI_REG_BREADY(s_axi_time_sync_bready),
              
        .S_AXI_REG_ARADDR(s_axi_time_sync_araddr),
        .S_AXI_REG_ARPROT(s_axi_time_sync_arprot),
        .S_AXI_REG_ARVALID(s_axi_time_sync_arvalid),
        .S_AXI_REG_ARREADY(s_axi_time_sync_arready),
              
        .S_AXI_REG_RDATA(s_axi_time_sync_rdata),
        .S_AXI_REG_RRESP(s_axi_time_sync_rresp),
        .S_AXI_REG_RVALID(s_axi_time_sync_rvalid),
        .S_AXI_REG_RREADY(s_axi_time_sync_rready),

        .INTR_OUT(),
        
        .rtc_clk(gtx_clk_bufg),
        .time_ptp_ns(),
        .time_ptp_sec(),
        .time_ptp_ns_mini(time_ptp_ns),
        .sync_time_ptp_ns(sync_time_ptp_ns_legacy),
        .sync_time_ptp_sec(sync_time_ptp_sec_legacy),
        .sync_time_ptp_ns_mini(sync_time_ptp_ns),
        .rtc_time_one_pps(),

        .mac_tx_axis_aclk(tx_mac_aclk),
        .mac_tx_axis_tvalid(mac_tx_axis_tvalid_out),
        .mac_tx_axis_tready(mac_tx_axis_tready_out),
        .mac_tx_axis_tdata_flat(mac_tx_axis_tdata_flat),
        .mac_tx_axis_tlast(mac_tx_axis_tlast_out),

        .mac_rx_axis_aclk(rx_mac_aclk),
        .mac_rx_axis_tvalid(mac_rx_axis_tvalid_out),
        .mac_rx_axis_tready(mac_rx_axis_tready_out),
        .mac_rx_axis_tdata_flat(mac_rx_axis_tdata_flat),
        .mac_rx_axis_tlast(mac_rx_axis_tlast_out)

    );
    //----------------------------------------------------------------------------
    // Generate the user side clocks for the axi fifos
    //----------------------------------------------------------------------------
    
    assign tx_fifo_clock = gtx_clk_bufg;
    assign rx_fifo_clock = gtx_clk_bufg;

    //----------------------------------------------------------------------------
    // Generate resets required for the fifo side signals etc
    //----------------------------------------------------------------------------

    tri_mode_ethernet_mac_0_example_design_resets example_resets
    (
        // clocks
        .s_axi_aclk       (s_axi_aclk),
        .gtx_clk          (gtx_clk_bufg),
    
        // asynchronous resets
        .glbl_rst         (glbl_rst || external_pl_reset),
        .reset_error      (1'b0),
        .rx_reset         (|rx_reset),
        .tx_reset         (|tx_reset),
    
        .dcm_locked       (dcm_locked),
    
        // synchronous reset outputs
    
        .glbl_rst_intn    (glbl_rst_intn),
    
        .gtx_resetn       (gtx_resetn),
    
        .s_axi_resetn     (s_axi_resetn),
        .phy_resetn       (phy_resetn_int), // This is based on glbl_rst
        .chk_resetn       ()
    );

    // generate the user side resets for the axi fifos
   
    assign tx_fifo_resetn = gtx_resetn;
    assign rx_fifo_resetn = gtx_resetn;
   

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1)
        begin
            tri_mode_ethernet_mac_0_axi_lite_sm axi_lite_controller (
                .s_axi_aclk                   (s_axi_aclk),
                .s_axi_resetn                 (s_axi_resetn),
            
                .mac_speed                    (mac_speed),
                .update_speed                 (1'b0),   // may need glitch protection on this..
                .serial_command               (1'b0),
                .serial_response              (),
                      
                .phy_loopback                 (1'b0),
            
                .s_axi_awaddr                 (s_axi_awaddr[i]),
                .s_axi_awvalid                (s_axi_awvalid[i]),
                .s_axi_awready                (s_axi_awready[i]),
            
                .s_axi_wdata                  (s_axi_wdata[i]),
                .s_axi_wvalid                 (s_axi_wvalid[i]),
                .s_axi_wready                 (s_axi_wready[i]),
            
                .s_axi_bresp                  (s_axi_bresp[i]),
                .s_axi_bvalid                 (s_axi_bvalid[i]),
                .s_axi_bready                 (s_axi_bready[i]),
            
                .s_axi_araddr                 (s_axi_araddr[i]),
                .s_axi_arvalid                (s_axi_arvalid[i]),
                .s_axi_arready                (s_axi_arready[i]),
            
                .s_axi_rdata                  (s_axi_rdata[i]),
                .s_axi_rresp                  (s_axi_rresp[i]),
                .s_axi_rvalid                 (s_axi_rvalid[i]),
                .s_axi_rready                 (s_axi_rready[i]),
                .enable_pat_gen               (enable_pat_gen[i])
            );
        end
    endgenerate

    tri_mode_ethernet_mac_2_axi_lite_sm axi_lite_controler_ps_eth (
        .s_axi_aclk                   (s_axi_aclk),
        .s_axi_resetn                 (s_axi_resetn),
    
        .mac_speed                    (mac_speed),
        .update_speed                 (1'b0),   // may need glitch protection on this..
        .serial_command               (1'b0),
        .serial_response              (),
                
        .phy_loopback                 (1'b0),
    
        .s_axi_awaddr                 (s_axi_awaddr[NUM_PORTS]),
        .s_axi_awvalid                (s_axi_awvalid[NUM_PORTS]),
        .s_axi_awready                (s_axi_awready[NUM_PORTS]),

        .s_axi_wdata                  (s_axi_wdata[NUM_PORTS]),
        .s_axi_wvalid                 (s_axi_wvalid[NUM_PORTS]),
        .s_axi_wready                 (s_axi_wready[NUM_PORTS]),

        .s_axi_bresp                  (s_axi_bresp[NUM_PORTS]),
        .s_axi_bvalid                 (s_axi_bvalid[NUM_PORTS]),
        .s_axi_bready                 (s_axi_bready[NUM_PORTS]),

        .s_axi_araddr                 (s_axi_araddr[NUM_PORTS]),
        .s_axi_arvalid                (s_axi_arvalid[NUM_PORTS]),
        .s_axi_arready                (s_axi_arready[NUM_PORTS]),

        .s_axi_rdata                  (s_axi_rdata[NUM_PORTS]),
        .s_axi_rresp                  (s_axi_rresp[NUM_PORTS]),
        .s_axi_rvalid                 (s_axi_rvalid[NUM_PORTS]),
        .s_axi_rready                 (s_axi_rready[NUM_PORTS])
    );

    // //----------------------------------------------------------------------------
    // // Generate tx_signal periodically according to start time(time_offset_ptp_ns) and period(tx_period_ns)
    // //----------------------------------------------------------------------------
    // wire tx_signal;
    // reg [63:0] tx_period_ns = 64'h1_010_000; // Sample 256 frames for measuring average latency
    // // reg [63:0] tx_period_ns = 64'd1_000;
    // reg [63:0] time_offset_ptp_ns = 64'd100_000; 

    // pulse_generator generator (
    //     .clk(gtx_clk_bufg),
    //     .rst(glbl_rst),
    //     .time_ptp_ns(sync_time_ptp_ns),
    //     .time_offset_ptp_ns(time_offset_ptp_ns),
    //     .tx_period_ns(tx_period_ns),
    //     .tx_signal(tx_signal)
    // );

    //----------------------------------------------------------------------------
    // Instantiate the TRIMAC core fifo block wrapper
    //----------------------------------------------------------------------------
    simple_mac simple_mac_0 (
        .gtx_clk                      (gtx_clk_bufg),
        // Output clocks for share
        .gtx_clk_out                  (gtx_clk_out),
        .gtx_clk90_out                (gtx_clk90_out),
        
        // asynchronous reset
        .glbl_rstn                    (glbl_rst_intn),
        .rx_axi_rstn                  (1'b1),
        .tx_axi_rstn                  (1'b1),

        // Reference clock for IDELAYCTRL's
        .refclk                       (refclk_bufg),

        // RTC timer
        .rtc_timer_in                 (sync_time_ptp_ns),

        // Receiver Statistics Interface
        //---------------------------------------
        .rx_mac_aclk                  (rx_mac_aclk[0]),
        .rx_reset                     (rx_reset[0]),
        .rx_statistics_vector         (rx_statistics_vector[0]),
        .rx_statistics_valid          (rx_statistics_valid[0]),

        // Receiver (AXI-S) Interface
        //----------------------------------------
        .rx_fifo_clock                (rx_fifo_clock),
        .rx_fifo_resetn               (rx_fifo_resetn),
        .rx_axis_fifo_tdata           (rx_axis_fifo_tdata[0]),
        .rx_axis_fifo_tvalid          (rx_axis_fifo_tvalid[0]),
        .rx_axis_fifo_tready          (rx_axis_fifo_tready[0]),
        .rx_axis_fifo_tlast           (rx_axis_fifo_tlast[0]),
        
        // Transmitter Statistics Interface
        //------------------------------------------
        .tx_mac_aclk                  (tx_mac_aclk[0]),
        .tx_reset                     (tx_reset[0]),
        .tx_ifg_delay                 (tx_ifg_delay),
        .tx_statistics_vector         (tx_statistics_vector[0]),
        .tx_statistics_valid          (tx_statistics_valid[0]),

        // Transmitter (AXI-S) Interface
        //-------------------------------------------
        .tx_fifo_clock                (tx_fifo_clock),
        .tx_fifo_resetn               (tx_fifo_resetn),
        .tx_axis_fifo_legacy_tdata           (tx_axis_fifo_legacy_tdata[0]),
        .tx_axis_fifo_legacy_tvalid          (tx_axis_fifo_legacy_tvalid[0]),
        .tx_axis_fifo_legacy_tready          (tx_axis_fifo_legacy_tready[0]),
        .tx_axis_fifo_legacy_tlast           (tx_axis_fifo_legacy_tlast[0]),
        
        // MAC Control Interface
        //------------------------
        .pause_req                    (pause_req[0]),
        .pause_val                    (pause_val[0]),

        // RGMII Interface
        //------------------
        .rgmii_txd                    (rgmii_txd[0]),
        .rgmii_tx_ctl                 (rgmii_tx_ctl[0]),
        .rgmii_txc                    (rgmii_txc[0]),
        .rgmii_rxd                    (rgmii_rxd[0]),
        .rgmii_rx_ctl                 (rgmii_rx_ctl[0]),
        .rgmii_rxc                    (rgmii_rxc[0]),

        // .rgmii_rxd_out               (rgmii_rxd_out[0]),
        // .rgmii_rx_ctl_out            (rgmii_rx_ctl_out[0]),
        // .rgmii_rxc_out               (rgmii_rxc_out[0]),
        // RGMII Inband Status Registers
        //--------------------------------
        .inband_link_status           (inband_link_status[0]),
        .inband_clock_speed           (inband_clock_speed[0]),
        .inband_duplex_status         (inband_duplex_status[0]),
        // .rx_configuration_vector      (rx_configuration_vector[0]),
        // .tx_configuration_vector      (tx_configuration_vector[0])
      
        .mdio                         (mdio[0]),
        .mdc                          (mdc[0]),

        // AXI-Lite Interface
        //---------------
        .s_axi_aclk                   (s_axi_aclk),
        .s_axi_resetn                 (s_axi_resetn),

        .s_axi_awaddr                 (s_axi_awaddr[0]),
        .s_axi_awvalid                (s_axi_awvalid[0]),
        .s_axi_awready                (s_axi_awready[0]),

        .s_axi_wdata                  (s_axi_wdata[0]),
        .s_axi_wvalid                 (s_axi_wvalid[0]),
        .s_axi_wready                 (s_axi_wready[0]),

        .s_axi_bresp                  (s_axi_bresp[0]),
        .s_axi_bvalid                 (s_axi_bvalid[0]),
        .s_axi_bready                 (s_axi_bready[0]),

        .s_axi_araddr                 (s_axi_araddr[0]),
        .s_axi_arvalid                (s_axi_arvalid[0]),
        .s_axi_arready                (s_axi_arready[0]),

        .s_axi_rdata                  (s_axi_rdata[0]),
        .s_axi_rresp                  (s_axi_rresp[0]),
        .s_axi_rvalid                 (s_axi_rvalid[0]),
        .s_axi_rready                 (s_axi_rready[0]),

        .mac_tx_axis_tvalid_out       (mac_tx_axis_tvalid_out[0]),
        .mac_tx_axis_tready_out       (mac_tx_axis_tready_out[0]),
        .mac_tx_axis_tdata_out        (mac_tx_axis_tdata_out[0]),
        .mac_tx_axis_tlast_out        (mac_tx_axis_tlast_out[0]),

        .mac_rx_axis_tvalid_out       (mac_rx_axis_tvalid_out[0]),
        .mac_rx_axis_tready_out       (mac_rx_axis_tready_out[0]),
        .mac_rx_axis_tdata_out        (mac_rx_axis_tdata_out[0]),
        .mac_rx_axis_tlast_out        (mac_rx_axis_tlast_out[0])
    );
    genvar j;
    generate
        for (j = 1; j < NUM_PORTS; j = j + 1)
        begin
            simple_mac_no_shared simple_mac_no_shared_i (
                .gtx_clk                      (gtx_clk_out),
                .gtx_clk90                    (gtx_clk90_out),
                
                
                // asynchronous reset
                .glbl_rstn                    (glbl_rst_intn),
                .rx_axi_rstn                  (1'b1),
                .tx_axi_rstn                  (1'b1),
            
                // RTC timer
                .rtc_timer_in                 (sync_time_ptp_ns),

                // Receiver Statistics Interface
                //---------------------------------------
                .rx_mac_aclk                  (rx_mac_aclk[j]),
                .rx_reset                     (rx_reset[j]),
                .rx_statistics_vector         (rx_statistics_vector[j]),
                .rx_statistics_valid          (rx_statistics_valid[j]),
            
                // Receiver (AXI-S) Interface
                //----------------------------------------
                .rx_fifo_clock                (rx_fifo_clock),
                .rx_fifo_resetn               (rx_fifo_resetn),
                .rx_axis_fifo_tdata           (rx_axis_fifo_tdata[j]),
                .rx_axis_fifo_tvalid          (rx_axis_fifo_tvalid[j]),
                .rx_axis_fifo_tready          (rx_axis_fifo_tready[j]),
                .rx_axis_fifo_tlast           (rx_axis_fifo_tlast[j]),
                
                // Transmitter Statistics Interface
                //------------------------------------------
                .tx_mac_aclk                  (tx_mac_aclk[j]),
                .tx_reset                     (tx_reset[j]),
                .tx_ifg_delay                 (tx_ifg_delay),
                .tx_statistics_vector         (tx_statistics_vector[j]),
                .tx_statistics_valid          (tx_statistics_valid[j]),
            
                // Transmitter (AXI-S) Interface
                //-------------------------------------------
                .tx_fifo_clock                (tx_fifo_clock),
                .tx_fifo_resetn               (tx_fifo_resetn),
                .tx_axis_fifo_legacy_tdata           (tx_axis_fifo_legacy_tdata[j]),
                .tx_axis_fifo_legacy_tvalid          (tx_axis_fifo_legacy_tvalid[j]),
                .tx_axis_fifo_legacy_tready          (tx_axis_fifo_legacy_tready[j]),
                .tx_axis_fifo_legacy_tlast           (tx_axis_fifo_legacy_tlast[j]),
                
                // MAC Control Interface
                //------------------------
                .pause_req                    (pause_req[j]),
                .pause_val                    (pause_val[j]),
            
                // RGMII Interface
                //------------------
                .rgmii_txd                    (rgmii_txd[j]),
                .rgmii_tx_ctl                 (rgmii_tx_ctl[j]),
                .rgmii_txc                    (rgmii_txc[j]),
                .rgmii_rxd                    (rgmii_rxd[j]),
                .rgmii_rx_ctl                 (rgmii_rx_ctl[j]),
                .rgmii_rxc                    (rgmii_rxc[j]),

                // RGMII Inband Status Registers
                //--------------------------------
                .inband_link_status           (inband_link_status[j]),
                .inband_clock_speed           (inband_clock_speed[j]),
                .inband_duplex_status         (inband_duplex_status[j]),
                
                .mdio                         (mdio[j]),
                .mdc                          (mdc[j]),
                
                // AXI-Lite Interface
                //---------------
                .s_axi_aclk                   (s_axi_aclk),
                .s_axi_resetn                 (s_axi_resetn),
        
                .s_axi_awaddr                 (s_axi_awaddr[j]),
                .s_axi_awvalid                (s_axi_awvalid[j]),
                .s_axi_awready                (s_axi_awready[j]),
        
                .s_axi_wdata                  (s_axi_wdata[j]),
                .s_axi_wvalid                 (s_axi_wvalid[j]),
                .s_axi_wready                 (s_axi_wready[j]),
        
                .s_axi_bresp                  (s_axi_bresp[j]),
                .s_axi_bvalid                 (s_axi_bvalid[j]),
                .s_axi_bready                 (s_axi_bready[j]),
        
                .s_axi_araddr                 (s_axi_araddr[j]),
                .s_axi_arvalid                (s_axi_arvalid[j]),
                .s_axi_arready                (s_axi_arready[j]),
        
                .s_axi_rdata                  (s_axi_rdata[j]),
                .s_axi_rresp                  (s_axi_rresp[j]),
                .s_axi_rvalid                 (s_axi_rvalid[j]),
                .s_axi_rready                 (s_axi_rready[j]),
                
                .mac_tx_axis_tvalid_out       (mac_tx_axis_tvalid_out[j]),
                .mac_tx_axis_tready_out       (mac_tx_axis_tready_out[j]),
                .mac_tx_axis_tdata_out        (mac_tx_axis_tdata_out[j]),
                .mac_tx_axis_tlast_out        (mac_tx_axis_tlast_out[j]),

                .mac_rx_axis_tvalid_out       (mac_rx_axis_tvalid_out[j]),
                .mac_rx_axis_tready_out       (mac_rx_axis_tready_out[j]),
                .mac_rx_axis_tdata_out        (mac_rx_axis_tdata_out[j]),
                .mac_rx_axis_tlast_out        (mac_rx_axis_tlast_out[j])
            );
        end
    endgenerate

    simple_mac_no_shared_int simple_mac_no_shared_int_i (
        .gtx_clk                      (gtx_clk_out),
        .gtx_clk90                    (gtx_clk90_out),
        
        
        // asynchronous reset
        .glbl_rstn                    (glbl_rst_intn),
        .rx_axi_rstn                  (1'b1),
        .tx_axi_rstn                  (1'b1),
    
        // Receiver Statistics Interface
        //---------------------------------------
        .rx_mac_aclk                  (rx_mac_aclk[NUM_PORTS]),
        .rx_reset                     (rx_reset[NUM_PORTS]),
        .rx_statistics_vector         (rx_statistics_vector[NUM_PORTS]),
        .rx_statistics_valid          (rx_statistics_valid[NUM_PORTS]),
    
        // Receiver (AXI-S) Interface
        //----------------------------------------
        .rx_fifo_clock                (rx_fifo_clock),
        .rx_fifo_resetn_in            (rx_fifo_resetn),
        .rx_axis_fifo_tdata           (rx_axis_fifo_tdata[NUM_PORTS]),
        .rx_axis_fifo_tvalid          (rx_axis_fifo_tvalid[NUM_PORTS]),
        .rx_axis_fifo_tready          (rx_axis_fifo_tready[NUM_PORTS]),
        .rx_axis_fifo_tlast           (rx_axis_fifo_tlast[NUM_PORTS]),
        
        // Transmitter Statistics Interface
        //------------------------------------------
        .tx_mac_aclk                  (tx_mac_aclk[NUM_PORTS]),
        .tx_reset                     (tx_reset[NUM_PORTS]),
        .tx_ifg_delay                 (tx_ifg_delay),
        .tx_statistics_vector         (tx_statistics_vector[NUM_PORTS]),
        .tx_statistics_valid          (tx_statistics_valid[NUM_PORTS]),
    
        // Transmitter (AXI-S) Interface
        //-------------------------------------------
        .tx_fifo_clock                (tx_fifo_clock),
        .tx_fifo_resetn_in            (tx_fifo_resetn),
        .tx_axis_fifo_legacy_tdata    (tx_axis_fifo_legacy_tdata[NUM_PORTS]),
        .tx_axis_fifo_legacy_tvalid   (tx_axis_fifo_legacy_tvalid[NUM_PORTS]),
        .tx_axis_fifo_legacy_tready   (tx_axis_fifo_legacy_tready[NUM_PORTS]),
        .tx_axis_fifo_legacy_tlast    (tx_axis_fifo_legacy_tlast[NUM_PORTS]),
        
        // MAC Control Interface
        //------------------------
        .pause_req                    (pause_req[NUM_PORTS]),
        .pause_val                    (pause_val[NUM_PORTS]),

        .gmii_txd                     (ps_eth_gmii_txd),
        .gmii_tx_en                   (ps_eth_gmii_tx_en),
        .gmii_tx_er                   (ps_eth_gmii_tx_er),
        .gmii_rxd                     (ps_eth_gmii_rxd),
        .gmii_rx_dv                   (ps_eth_gmii_rx_dv),
        .gmii_rx_er                   (ps_eth_gmii_rx_er),
        
        // AXI-Lite Interface
        //---------------
        .s_axi_aclk                   (s_axi_aclk),
        .s_axi_resetn                 (s_axi_resetn),

        .s_axi_awaddr                 (s_axi_awaddr[NUM_PORTS]),
        .s_axi_awvalid                (s_axi_awvalid[NUM_PORTS]),
        .s_axi_awready                (s_axi_awready[NUM_PORTS]),

        .s_axi_wdata                  (s_axi_wdata[NUM_PORTS]),
        .s_axi_wvalid                 (s_axi_wvalid[NUM_PORTS]),
        .s_axi_wready                 (s_axi_wready[NUM_PORTS]),

        .s_axi_bresp                  (s_axi_bresp[NUM_PORTS]),
        .s_axi_bvalid                 (s_axi_bvalid[NUM_PORTS]),
        .s_axi_bready                 (s_axi_bready[NUM_PORTS]),

        .s_axi_araddr                 (s_axi_araddr[NUM_PORTS]),
        .s_axi_arvalid                (s_axi_arvalid[NUM_PORTS]),
        .s_axi_arready                (s_axi_arready[NUM_PORTS]),

        .s_axi_rdata                  (s_axi_rdata[NUM_PORTS]),
        .s_axi_rresp                  (s_axi_rresp[NUM_PORTS]),
        .s_axi_rvalid                 (s_axi_rvalid[NUM_PORTS]),
        .s_axi_rready                 (s_axi_rready[NUM_PORTS]),
        
        .mac_tx_axis_tvalid_out       (),
        .mac_tx_axis_tready_out       (),
        .mac_tx_axis_tdata_out        (),
        .mac_tx_axis_tlast_out        (),

        .mac_rx_axis_tvalid_out       (),
        .mac_rx_axis_tready_out       (),
        .mac_rx_axis_tdata_out        (),
        .mac_rx_axis_tlast_out        ()
    );

    //------------------------------------------------------------------------------------------------------------
    // forward different frames
    //      IT frames       ->      gmii PS eth (ether type 0x66ab)
    //      ptp frames      ->      DMA (ehter type 0x88f7)
    //      critical frames ->      DMA (add timestamp)
    (* mark_debug = "true" *) wire    [255:0] rx_axis_fifo_tdata_256;
    (* mark_debug = "true" *) wire            rx_axis_fifo_tvalid_256;
    (* mark_debug = "true" *) wire            rx_axis_fifo_tready_256;
    (* mark_debug = "true" *) wire            rx_axis_fifo_tlast_256;
    (* mark_debug = "true" *) wire    [31:0]  rx_axis_fifo_tkeep_256;

    wire             is_it_frame;

    (* mark_debug = "true" *) wire    [7:0]   rx_axis_fifo_tdata_8;
    (* mark_debug = "true" *) wire            rx_axis_fifo_tvalid_8;
    (* mark_debug = "true" *) wire            rx_axis_fifo_tready_8;
    (* mark_debug = "true" *) wire            rx_axis_fifo_tlast_8;
    // wire            rx_axis_fifo_tkeep_8;

    // upsize data width for instant ethertype check
    axis_dwidth_converter_8_256 axis_dwidth_converter_8_256_ins (
        .aclk                   (rx_fifo_clock),                   // input aclk
        .aresetn                (rx_fifo_resetn),                   // input aresetn
        .s_axis_tvalid          (rx_axis_fifo_tvalid[0]),           // input s_axis_tvalid
        .s_axis_tready          (rx_axis_fifo_tready[0]),           // output s_axis_tready
        .s_axis_tdata           (rx_axis_fifo_tdata[0]),            // input s_axis_tdata
        .s_axis_tlast           (rx_axis_fifo_tlast[0]),            // input s_axis_tlast
        .m_axis_tvalid          (rx_axis_fifo_tvalid_256),          // output m_axis_tvalid
        .m_axis_tready          (rx_axis_fifo_tready_256),          // input m_axis_tready
        .m_axis_tdata           (rx_axis_fifo_tdata_256),           // output m_axis_tdata
        .m_axis_tlast           (rx_axis_fifo_tlast_256),           // output m_axis_tlast
        .m_axis_tkeep           (rx_axis_fifo_tkeep_256)            // output m_axis_tkeep
    );

    // ethertype check
    axis_it_checker axis_it_checker_ins (
        .rstn                   (rx_fifo_resetn),                   // input rst
        .axis_aclk              (rx_fifo_clock),                    // input axis_aclk
        .axis_tvalid            (rx_axis_fifo_tvalid_256),          // input axis_tvalid
        .axis_tready            (rx_axis_fifo_tready_256),          // input axis_tready
        .axis_tdata             (rx_axis_fifo_tdata_256),           // input axis_tdata
        .axis_tlast             (rx_axis_fifo_tlast_256),           // input axis_tlast
        .is_it_frame            (is_it_frame)                       // ioutut is_it_frame
    );

    // downsize data width
    axis_dwidth_converter_256_8 axis_dwidth_converter_256_8_ins (
        .aclk                   (rx_fifo_clock),                   // input aclk
        .aresetn                (rx_fifo_resetn),                      // input aresetn
        .s_axis_tvalid          (rx_axis_fifo_tvalid_256),          // input s_axis_tvalid
        .s_axis_tready          (rx_axis_fifo_tready_256),          // output s_axis_tready
        .s_axis_tdata           (rx_axis_fifo_tdata_256),           // input s_axis_tdata
        .s_axis_tkeep           (rx_axis_fifo_tkeep_256),           // input s_axis_tkeep
        .s_axis_tlast           (rx_axis_fifo_tlast_256),           // input s_axis_tlast
        .m_axis_tvalid          (rx_axis_fifo_tvalid_8),            // output m_axis_tvalid
        .m_axis_tready          (rx_axis_fifo_tready_8),            // input m_axis_tready
        .m_axis_tdata           (rx_axis_fifo_tdata_8),             // output m_axis_tdata
        .m_axis_tkeep           (),                                 // output m_axis_tkeep
        .m_axis_tlast           (rx_axis_fifo_tlast_8)              // output m_axis_tlast
    );


    // separate IT frames and others, including ptp frames and critical frames
    axis_switch_1_2 axis_switch_1_2_inst (
        .aclk                   (rx_fifo_clock),                                               // input aclk
        .aresetn                (rx_fifo_resetn),                                                  // input aresetn
        .s_axis_tvalid          (rx_axis_fifo_tvalid_8),                                        // input s_axis_tvalid
        .s_axis_tready          (rx_axis_fifo_tready_8),                                        // output s_axis_tready
        .s_axis_tdata           (rx_axis_fifo_tdata_8),                                         // input s_axis_tdata
        .s_axis_tlast           (rx_axis_fifo_tlast_8),                                         // input s_axis_tlast
        .s_axis_tdest           (is_it_frame),                                                  // input s_axis_tdest
        .m_axis_tvalid          ({rx_axis_it_fifo_tvalid, rx_axis_others_fifo_tvalid}),         // output m_axis_tvalid
        .m_axis_tready          ({rx_axis_it_fifo_tready, rx_axis_others_fifo_tready}),         // input m_axis_tready
        .m_axis_tdata           ({rx_axis_it_fifo_tdata, rx_axis_others_fifo_tdata}),           // output m_axis_tdata
        .m_axis_tlast           ({rx_axis_it_fifo_tlast, rx_axis_others_fifo_tlast}),           // output m_axis_tlast
        .m_axis_tdest           (),                                                             // output m_axis_tdest
        .s_decode_err           ()                                                              // output s_decode_err
    );
    assign tx_axis_fifo_legacy_tvalid[NUM_PORTS] = rx_axis_it_fifo_tvalid;
    assign rx_axis_it_fifo_tready = tx_axis_fifo_legacy_tready[NUM_PORTS];
    assign tx_axis_fifo_legacy_tdata[NUM_PORTS]  = rx_axis_it_fifo_tdata;
    assign tx_axis_fifo_legacy_tlast[NUM_PORTS]  = rx_axis_it_fifo_tlast;
    //------------------------------------------------------------------------------------------------------------

    //----------------------------------------------------------------------------
    // Instantiate the on-time AXI packet generator
    // These signals should be provided by axi_pkt_controller in block design
    //----------------------------------------------------------------------------
    (* mark_debug = "true" *) wire          tx_signal;
    (* mark_debug = "true" *) wire [127:0]  pkt_hdr;
    (* mark_debug = "true" *) wire          enable_vlan;
    (* mark_debug = "true" *) wire [15:0]   seq_id;
    (* mark_debug = "true" *) wire [31:0]   pkt_id;
    (* mark_debug = "true" *) wire [15:0]   max_sent_packet_counter;

    wire  [7:0]          tx_axis_pkt_gen_tdata;
    wire                 tx_axis_pkt_gen_tvalid;
    wire                 tx_axis_pkt_gen_tlast;
    wire                 tx_axis_pkt_gen_tready;
    (* mark_debug = "true" *)wire                 tx_pkt_gen_finish;
    
    axi_packet_generator #(
        .PKT_SIZE(1500)
    ) pat_gen_inst(
        /* This clk must be synced to tx_signal & tx_axis's clk */
        .axi_tclk                  (tx_fifo_clock),
        .axi_tresetn               (tx_fifo_resetn),

        .tdata                     (tx_axis_pkt_gen_tdata),
        .tvalid                    (tx_axis_pkt_gen_tvalid),
        .tlast                     (tx_axis_pkt_gen_tlast),
        .tready                    (tx_axis_pkt_gen_tready),

        // Input pulse to issue on-time packet sending
        .tx_signal                  (tx_signal),
        .pkt_hdr_in                 (pkt_hdr),
        .enable_vlan_in             (enable_vlan),
        .seq_id_in                  (seq_id),
        .pkt_id_in                  (pkt_id),
        .max_sent_packet_counter_in (max_sent_packet_counter),

        .pkt_gen_finish             (tx_pkt_gen_finish)
    );

    axis_clock_converter_0 pl2ps_axis_clock_converter (
        .s_axis_aresetn(rx_fifo_resetn),                // input wire s_axis_aresetn
        .m_axis_aresetn(axis_pl2ps_resetn),             // input wire m_axis_aresetn
        .s_axis_aclk(rx_fifo_clock),                    // input wire s_axis_aclk
        .s_axis_tvalid(rx_axis_others_fifo_tvalid),     // input wire s_axis_tvalid
        .s_axis_tready(rx_axis_others_fifo_tready),     // output wire s_axis_tready
        .s_axis_tdata(rx_axis_others_fifo_tdata),       // input wire [7 : 0] s_axis_tdata
        .s_axis_tlast(rx_axis_others_fifo_tlast),       // input wire s_axis_tlast
        .m_axis_aclk(s_axis_ps_clk),                    // input wire m_axis_aclk
        .m_axis_tvalid(axis_dma_o_tvalid_ps),           // output wire m_axis_tvalid
        .m_axis_tready(axis_dma_o_tready_ps),           // input wire m_axis_tready
        .m_axis_tdata(axis_dma_o_tdata_ps),             // output wire [7 : 0] m_axis_tdata
        .m_axis_tlast(axis_dma_o_tlast_ps)              // output wire m_axis_tlast
    );

    // TODO: ps2pl clk converter
    wire  [7:0]          axis_dma_i_tdata_ps;
    wire                 axis_dma_i_tvalid_ps;
    wire                 axis_dma_i_tlast_ps;
    wire                 axis_dma_i_tready_ps;

    (* mark_debug = "true" *) wire  [7:0]          tx_axis_ps2pl_tdata;
    (* mark_debug = "true" *) wire                 tx_axis_ps2pl_tvalid;
    (* mark_debug = "true" *) wire                 tx_axis_ps2pl_tlast;
    (* mark_debug = "true" *) wire                 tx_axis_ps2pl_tready;

    axis_clock_converter_0 ps2pl_axis_clock_converter (
        .s_axis_aresetn (axis_ps2pl_resetn),          // input wire s_axis_aresetn
        .m_axis_aresetn (tx_fifo_resetn),             // input wire m_axis_aresetn
        .s_axis_aclk    (m_axis_ps_clk),              // input wire s_axis_aclk
        .s_axis_tvalid  (axis_dma_i_tvalid_ps),       // input wire s_axis_tvalid
        .s_axis_tready  (axis_dma_i_tready_ps),       // output wire s_axis_tready
        .s_axis_tdata   (axis_dma_i_tdata_ps),        // input wire [7 : 0] s_axis_tdata
        .s_axis_tlast   (axis_dma_i_tlast_ps),        // input wire s_axis_tlast
        .m_axis_aclk    (tx_fifo_clock),              // input wire m_axis_aclk
        .m_axis_tdata   (tx_axis_ps2pl_tdata),        // output wire [7 : 0] m_axis_tdata
        .m_axis_tvalid  (tx_axis_ps2pl_tvalid),       // output wire m_axis_tvalid
        .m_axis_tlast   (tx_axis_ps2pl_tlast),        // output wire m_axis_tlast
        .m_axis_tready  (tx_axis_ps2pl_tready)        // input wire m_axis_tready
    );

    (* mark_debug = "true" *) wire    [7:0]       tx_axis_pseth_ps2pl_tdata;
    (* mark_debug = "true" *) wire                tx_axis_pseth_ps2pl_tvalid;
    (* mark_debug = "true" *) wire                tx_axis_pseth_ps2pl_tlast;
    (* mark_debug = "true" *) wire                tx_axis_pseth_ps2pl_tready;
    axis_clock_converter_0 pseth_ps2pl_axis_clock_convertor (
        .s_axis_aresetn (rx_fifo_resetn),                       // input wire s_axis_aresetn
        .m_axis_aresetn (tx_fifo_resetn),                       // input wire m_axis_aresetn
        .s_axis_aclk    (rx_mac_aclk[NUM_PORTS]),               // input wire s_axis_aclk
        .s_axis_tvalid  (rx_axis_fifo_tvalid[NUM_PORTS]),       // input wire s_axis_tvalid
        .s_axis_tready  (rx_axis_fifo_tready[NUM_PORTS]),       // output wire s_axis_tready
        .s_axis_tdata   (rx_axis_fifo_tdata[NUM_PORTS]),        // input wire [7 : 0] s_axis_tdata
        .s_axis_tlast   (rx_axis_fifo_tlast[NUM_PORTS]),        // input wire s_axis_tlast
        .m_axis_aclk    (tx_fifo_clock),                        // input wire m_axis_aclk
        .m_axis_tdata   (tx_axis_pseth_ps2pl_tdata),            // output wire [7 : 0] m_axis_tdata
        .m_axis_tvalid  (tx_axis_pseth_ps2pl_tvalid),           // output wire m_axis_tvalid
        .m_axis_tlast   (tx_axis_pseth_ps2pl_tlast),            // output wire m_axis_tlast
        .m_axis_tready  (tx_axis_pseth_ps2pl_tready)            // input wire m_axis_tready
    );

    (* mark_debug = "true" *) wire    [7:0]   tx_axis_combined_tdata;
    (* mark_debug = "true" *) wire            tx_axis_combined_tvalid;
    (* mark_debug = "true" *) wire            tx_axis_combined_tlast;
    (* mark_debug = "true" *) wire            tx_axis_combined_tready;
    axis_switch_2_1 axis_switch_2_1_inst (
        .aclk           (tx_fifo_clock),                                        // input wire aclk
        .aresetn        (tx_fifo_resetn),                                       // input wire aresetn
        .s_axis_tvalid  ({tx_axis_ps2pl_tvalid, tx_axis_pseth_ps2pl_tvalid}),   // input s_axis_tvalid
        .s_axis_tready  ({tx_axis_ps2pl_tready, tx_axis_pseth_ps2pl_tready}),   // input s_axis_tready
        .s_axis_tdata   ({tx_axis_ps2pl_tdata,  tx_axis_pseth_ps2pl_tdata}),    // input s_axis_tdata
        .s_axis_tlast   ({tx_axis_ps2pl_tlast,  tx_axis_pseth_ps2pl_tlast}),    // input s_axis_tlast
        .m_axis_tvalid  (tx_axis_combined_tvalid),                              // output m_axis_tvalid
        .m_axis_tready  (tx_axis_combined_tready),                              // output m_axis_tready
        .m_axis_tdata   (tx_axis_combined_tdata),                               // output m_axis_tdata
        .m_axis_tlast   (tx_axis_combined_tlast),                               // output m_axis_tlast
        .s_req_suppress (2'b00),                                                // input s_req_suppress
        .s_decode_err   ()                                                      // output s_decode_err
    );

    //----------------------------------------------------------------------------
    // Allow PTP messages to be transmitted on the IDLE moment in pkt_gen
    // pkt_gen output should be transmitted without delay, PTP message can be queued
    // Gaurd band are set to xx to avoid collision.
    //----------------------------------------------------------------------------
    // TODO: dma tx v.s. axi packet_gen selector
    tx_selection tx_selection_inst (
        // Selection related signals
        //----------------------------------------------------------------------
        .pkt_gen_ready              (tx_signal), 
        .pkt_gen_finish             (tx_pkt_gen_finish), 

        // AXI-S related signals
        //----------------------------------------------------------------------
        .axis_aclk                  (tx_fifo_clock),
        .axis_resetn                (tx_fifo_resetn),

        .tx_axis_pkt_gen_tdata      (tx_axis_pkt_gen_tdata),
        .tx_axis_pkt_gen_tvalid     (tx_axis_pkt_gen_tvalid),
        .tx_axis_pkt_gen_tlast      (tx_axis_pkt_gen_tlast),
        .tx_axis_pkt_gen_tready     (tx_axis_pkt_gen_tready),

        .tx_axis_ps2pl_tdata        (tx_axis_combined_tdata),
        .tx_axis_ps2pl_tvalid       (tx_axis_combined_tvalid),
        .tx_axis_ps2pl_tlast        (tx_axis_combined_tlast),
        .tx_axis_ps2pl_tready       (tx_axis_combined_tready),

        // .tx_axis_pseth_tdata        (tx_axis_pseth_ps2pl_tdata),
        // .tx_axis_pseth_tvalid       (tx_axis_pseth_ps2pl_tvalid),
        // .tx_axis_pseth_tlast        (tx_axis_pseth_ps2pl_tlast),
        // .tx_axis_pseth_tready       (tx_axis_pseth_ps2pl_tready),

        .tx_axis_tdata              (tx_axis_fifo_legacy_tdata[0]),
        .tx_axis_tvalid             (tx_axis_fifo_legacy_tvalid[0]),
        .tx_axis_tready             (tx_axis_fifo_legacy_tready[0]),
        .tx_axis_tlast              (tx_axis_fifo_legacy_tlast[0])
    );


    zynq_ps_i_wrapper zynq_ps_i
    (
        .DDR_addr                           (),
        .DDR_ba                             (),
        .DDR_cas_n                          (),
        .DDR_ck_n                           (),
        .DDR_ck_p                           (),
        .DDR_cke                            (),
        .DDR_cs_n                           (),
        .DDR_dm                             (),
        .DDR_dq                             (),
        .DDR_dqs_n                          (),
        .DDR_dqs_p                          (),
        .DDR_odt                            (),
        .DDR_ras_n                          (),
        .DDR_reset_n                        (),
        .DDR_we_n                           (),
        .FIXED_IO_ddr_vrn                   (),
        .FIXED_IO_ddr_vrp                   (),
        .FIXED_IO_mio                       (),
        .FIXED_IO_ps_clk                    (),
        .FIXED_IO_ps_porb                   (),
        .FIXED_IO_ps_srstb                  (),
        .GMII_ETHERNET_1_0_col              (1'b0),
        .GMII_ETHERNET_1_0_crs              (1'b0),
        .GMII_ETHERNET_1_0_rx_clk           (gtx_clk_out),
        .GMII_ETHERNET_1_0_rx_dv            (ps_eth_gmii_tx_en),
        .GMII_ETHERNET_1_0_rx_er            (ps_eth_gmii_tx_er),
        .GMII_ETHERNET_1_0_rxd              (ps_eth_gmii_txd),
        .GMII_ETHERNET_1_0_tx_clk           (gtx_clk_out),
        .GMII_ETHERNET_1_0_tx_en            (ps_eth_gmii_rx_dv),
        .GMII_ETHERNET_1_0_tx_er            (ps_eth_gmii_rx_er),
        .GMII_ETHERNET_1_0_txd              (ps_eth_gmii_rxd),
        .M_AXIS_CLK                         (m_axis_ps_clk),
        .M_AXIS_MM2S_0_tdata                (axis_dma_i_tdata_ps),
        .M_AXIS_MM2S_0_tkeep                (1'b1),
        .M_AXIS_MM2S_0_tlast                (axis_dma_i_tlast_ps),
        .M_AXIS_MM2S_0_tready               (axis_dma_i_tready_ps),
        .M_AXIS_MM2S_0_tvalid               (axis_dma_i_tvalid_ps),
        .S_AXIS_CLK                         (s_axis_ps_clk),
        .S_AXIS_S2MM_0_tdata                (axis_dma_o_tdata_ps),
        .S_AXIS_S2MM_0_tkeep                (1'b1),
        .S_AXIS_S2MM_0_tlast                (axis_dma_o_tlast_ps),
        .S_AXIS_S2MM_0_tready               (axis_dma_o_tready_ps),
        .S_AXIS_S2MM_0_tvalid               (axis_dma_o_tvalid_ps),
        .s_axi_time_sync_clk                (s_axi_time_sync_clk),
        .s_axi_time_sync_aresetn            (s_axi_time_sync_aresetn),
        .s_axi_time_sync_araddr             (s_axi_time_sync_araddr ),
        .s_axi_time_sync_arprot             (s_axi_time_sync_arprot ),
        .s_axi_time_sync_arready            (s_axi_time_sync_arready),
        .s_axi_time_sync_arvalid            (s_axi_time_sync_arvalid),
        .s_axi_time_sync_awaddr             (s_axi_time_sync_awaddr ),
        .s_axi_time_sync_awprot             (s_axi_time_sync_awprot ),
        .s_axi_time_sync_awready            (s_axi_time_sync_awready),
        .s_axi_time_sync_awvalid            (s_axi_time_sync_awvalid),
        .s_axi_time_sync_bready             (s_axi_time_sync_bready ),
        .s_axi_time_sync_bresp              (s_axi_time_sync_bresp  ),
        .s_axi_time_sync_bvalid             (s_axi_time_sync_bvalid ),
        .s_axi_time_sync_rdata              (s_axi_time_sync_rdata  ),
        .s_axi_time_sync_rready             (s_axi_time_sync_rready ),
        .s_axi_time_sync_rresp              (s_axi_time_sync_rresp  ),
        .s_axi_time_sync_rvalid             (s_axi_time_sync_rvalid ),
        .s_axi_time_sync_wdata              (s_axi_time_sync_wdata  ),
        .s_axi_time_sync_wready             (s_axi_time_sync_wready ),
        .s_axi_time_sync_wstrb              (s_axi_time_sync_wstrb  ),
        .s_axi_time_sync_wvalid             (s_axi_time_sync_wvalid ),
        // .S_AXIS_S2MM_0_tdata (8'b10101010),
        // .S_AXIS_S2MM_0_tkeep (1'b1),
        // .S_AXIS_S2MM_0_tlast (1'b1),
        // .S_AXIS_S2MM_0_tready(axis_dma_o_tready_ps),
        // .S_AXIS_S2MM_0_tvalid(1'b1),
        .axis_pl2ps_resetn                  (axis_pl2ps_resetn),
        .axis_ps2pl_resetn                  (axis_ps2pl_resetn),
        .rtc_clk_0                          (gtx_clk_bufg),
        .rtc_time_ns_0                      (sync_time_ptp_ns),
        .pkt_hdr_out_0                      (pkt_hdr),
        .enable_vlan_out_0                  (enable_vlan),
        .seq_id_out_0                       (seq_id),
        .pkt_id_out_0                       (pkt_id),
        .max_sent_packet_counter_out_0      (max_sent_packet_counter),
        .tx_signal_0                        (tx_signal),
        .external_pl_reset                  (external_pl_reset)
        );
endmodule
