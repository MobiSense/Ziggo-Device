//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
//Date        : Mon Dec  5 11:26:51 2022
//Host        : Horace-TNS-win10 running 64-bit major release  (build 9200)
//Command     : generate_target zynq_ps_i_wrapper.bd
//Design      : zynq_ps_i_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module zynq_ps_i_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    GMII_ETHERNET_1_0_col,
    GMII_ETHERNET_1_0_crs,
    GMII_ETHERNET_1_0_rx_clk,
    GMII_ETHERNET_1_0_rx_dv,
    GMII_ETHERNET_1_0_rx_er,
    GMII_ETHERNET_1_0_rxd,
    GMII_ETHERNET_1_0_tx_clk,
    GMII_ETHERNET_1_0_tx_en,
    GMII_ETHERNET_1_0_tx_er,
    GMII_ETHERNET_1_0_txd,
    M_AXIS_CLK,
    M_AXIS_MM2S_0_tdata,
    M_AXIS_MM2S_0_tkeep,
    M_AXIS_MM2S_0_tlast,
    M_AXIS_MM2S_0_tready,
    M_AXIS_MM2S_0_tvalid,
    S_AXIS_CLK,
    S_AXIS_S2MM_0_tdata,
    S_AXIS_S2MM_0_tkeep,
    S_AXIS_S2MM_0_tlast,
    S_AXIS_S2MM_0_tready,
    S_AXIS_S2MM_0_tvalid,
    axis_pl2ps_resetn,
    axis_ps2pl_resetn,
    enable_vlan_out_0,
    external_pl_reset,
    max_sent_packet_counter_out_0,
    pkt_hdr_out_0,
    pkt_id_out_0,
    rtc_clk_0,
    rtc_time_ns_0,
    s_axi_time_sync_araddr,
    s_axi_time_sync_aresetn,
    s_axi_time_sync_arprot,
    s_axi_time_sync_arready,
    s_axi_time_sync_arvalid,
    s_axi_time_sync_awaddr,
    s_axi_time_sync_awprot,
    s_axi_time_sync_awready,
    s_axi_time_sync_awvalid,
    s_axi_time_sync_bready,
    s_axi_time_sync_bresp,
    s_axi_time_sync_bvalid,
    s_axi_time_sync_clk,
    s_axi_time_sync_rdata,
    s_axi_time_sync_rready,
    s_axi_time_sync_rresp,
    s_axi_time_sync_rvalid,
    s_axi_time_sync_wdata,
    s_axi_time_sync_wready,
    s_axi_time_sync_wstrb,
    s_axi_time_sync_wvalid,
    seq_id_out_0,
    tx_signal_0);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input GMII_ETHERNET_1_0_col;
  input GMII_ETHERNET_1_0_crs;
  input GMII_ETHERNET_1_0_rx_clk;
  input GMII_ETHERNET_1_0_rx_dv;
  input GMII_ETHERNET_1_0_rx_er;
  input [7:0]GMII_ETHERNET_1_0_rxd;
  input GMII_ETHERNET_1_0_tx_clk;
  output [0:0]GMII_ETHERNET_1_0_tx_en;
  output [0:0]GMII_ETHERNET_1_0_tx_er;
  output [7:0]GMII_ETHERNET_1_0_txd;
  output M_AXIS_CLK;
  output [7:0]M_AXIS_MM2S_0_tdata;
  output [0:0]M_AXIS_MM2S_0_tkeep;
  output M_AXIS_MM2S_0_tlast;
  input M_AXIS_MM2S_0_tready;
  output M_AXIS_MM2S_0_tvalid;
  output S_AXIS_CLK;
  input [7:0]S_AXIS_S2MM_0_tdata;
  input [0:0]S_AXIS_S2MM_0_tkeep;
  input S_AXIS_S2MM_0_tlast;
  output S_AXIS_S2MM_0_tready;
  input S_AXIS_S2MM_0_tvalid;
  output axis_pl2ps_resetn;
  output axis_ps2pl_resetn;
  output enable_vlan_out_0;
  output [0:0]external_pl_reset;
  output [15:0]max_sent_packet_counter_out_0;
  output [127:0]pkt_hdr_out_0;
  output [31:0]pkt_id_out_0;
  input rtc_clk_0;
  input [63:0]rtc_time_ns_0;
  output [31:0]s_axi_time_sync_araddr;
  output [0:0]s_axi_time_sync_aresetn;
  output [2:0]s_axi_time_sync_arprot;
  input [0:0]s_axi_time_sync_arready;
  output [0:0]s_axi_time_sync_arvalid;
  output [31:0]s_axi_time_sync_awaddr;
  output [2:0]s_axi_time_sync_awprot;
  input [0:0]s_axi_time_sync_awready;
  output [0:0]s_axi_time_sync_awvalid;
  output [0:0]s_axi_time_sync_bready;
  input [1:0]s_axi_time_sync_bresp;
  input [0:0]s_axi_time_sync_bvalid;
  output s_axi_time_sync_clk;
  input [31:0]s_axi_time_sync_rdata;
  output [0:0]s_axi_time_sync_rready;
  input [1:0]s_axi_time_sync_rresp;
  input [0:0]s_axi_time_sync_rvalid;
  output [31:0]s_axi_time_sync_wdata;
  input [0:0]s_axi_time_sync_wready;
  output [3:0]s_axi_time_sync_wstrb;
  output [0:0]s_axi_time_sync_wvalid;
  output [15:0]seq_id_out_0;
  output tx_signal_0;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire GMII_ETHERNET_1_0_col;
  wire GMII_ETHERNET_1_0_crs;
  wire GMII_ETHERNET_1_0_rx_clk;
  wire GMII_ETHERNET_1_0_rx_dv;
  wire GMII_ETHERNET_1_0_rx_er;
  wire [7:0]GMII_ETHERNET_1_0_rxd;
  wire GMII_ETHERNET_1_0_tx_clk;
  wire [0:0]GMII_ETHERNET_1_0_tx_en;
  wire [0:0]GMII_ETHERNET_1_0_tx_er;
  wire [7:0]GMII_ETHERNET_1_0_txd;
  wire M_AXIS_CLK;
  wire [7:0]M_AXIS_MM2S_0_tdata;
  wire [0:0]M_AXIS_MM2S_0_tkeep;
  wire M_AXIS_MM2S_0_tlast;
  wire M_AXIS_MM2S_0_tready;
  wire M_AXIS_MM2S_0_tvalid;
  wire S_AXIS_CLK;
  wire [7:0]S_AXIS_S2MM_0_tdata;
  wire [0:0]S_AXIS_S2MM_0_tkeep;
  wire S_AXIS_S2MM_0_tlast;
  wire S_AXIS_S2MM_0_tready;
  wire S_AXIS_S2MM_0_tvalid;
  wire axis_pl2ps_resetn;
  wire axis_ps2pl_resetn;
  wire enable_vlan_out_0;
  wire [0:0]external_pl_reset;
  wire [15:0]max_sent_packet_counter_out_0;
  wire [127:0]pkt_hdr_out_0;
  wire [31:0]pkt_id_out_0;
  wire rtc_clk_0;
  wire [63:0]rtc_time_ns_0;
  wire [31:0]s_axi_time_sync_araddr;
  wire [0:0]s_axi_time_sync_aresetn;
  wire [2:0]s_axi_time_sync_arprot;
  wire [0:0]s_axi_time_sync_arready;
  wire [0:0]s_axi_time_sync_arvalid;
  wire [31:0]s_axi_time_sync_awaddr;
  wire [2:0]s_axi_time_sync_awprot;
  wire [0:0]s_axi_time_sync_awready;
  wire [0:0]s_axi_time_sync_awvalid;
  wire [0:0]s_axi_time_sync_bready;
  wire [1:0]s_axi_time_sync_bresp;
  wire [0:0]s_axi_time_sync_bvalid;
  wire s_axi_time_sync_clk;
  wire [31:0]s_axi_time_sync_rdata;
  wire [0:0]s_axi_time_sync_rready;
  wire [1:0]s_axi_time_sync_rresp;
  wire [0:0]s_axi_time_sync_rvalid;
  wire [31:0]s_axi_time_sync_wdata;
  wire [0:0]s_axi_time_sync_wready;
  wire [3:0]s_axi_time_sync_wstrb;
  wire [0:0]s_axi_time_sync_wvalid;
  wire [15:0]seq_id_out_0;
  wire tx_signal_0;

  zynq_ps_i zynq_ps_i_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .GMII_ETHERNET_1_0_col(GMII_ETHERNET_1_0_col),
        .GMII_ETHERNET_1_0_crs(GMII_ETHERNET_1_0_crs),
        .GMII_ETHERNET_1_0_rx_clk(GMII_ETHERNET_1_0_rx_clk),
        .GMII_ETHERNET_1_0_rx_dv(GMII_ETHERNET_1_0_rx_dv),
        .GMII_ETHERNET_1_0_rx_er(GMII_ETHERNET_1_0_rx_er),
        .GMII_ETHERNET_1_0_rxd(GMII_ETHERNET_1_0_rxd),
        .GMII_ETHERNET_1_0_tx_clk(GMII_ETHERNET_1_0_tx_clk),
        .GMII_ETHERNET_1_0_tx_en(GMII_ETHERNET_1_0_tx_en),
        .GMII_ETHERNET_1_0_tx_er(GMII_ETHERNET_1_0_tx_er),
        .GMII_ETHERNET_1_0_txd(GMII_ETHERNET_1_0_txd),
        .M_AXIS_CLK(M_AXIS_CLK),
        .M_AXIS_MM2S_0_tdata(M_AXIS_MM2S_0_tdata),
        .M_AXIS_MM2S_0_tkeep(M_AXIS_MM2S_0_tkeep),
        .M_AXIS_MM2S_0_tlast(M_AXIS_MM2S_0_tlast),
        .M_AXIS_MM2S_0_tready(M_AXIS_MM2S_0_tready),
        .M_AXIS_MM2S_0_tvalid(M_AXIS_MM2S_0_tvalid),
        .S_AXIS_CLK(S_AXIS_CLK),
        .S_AXIS_S2MM_0_tdata(S_AXIS_S2MM_0_tdata),
        .S_AXIS_S2MM_0_tkeep(S_AXIS_S2MM_0_tkeep),
        .S_AXIS_S2MM_0_tlast(S_AXIS_S2MM_0_tlast),
        .S_AXIS_S2MM_0_tready(S_AXIS_S2MM_0_tready),
        .S_AXIS_S2MM_0_tvalid(S_AXIS_S2MM_0_tvalid),
        .axis_pl2ps_resetn(axis_pl2ps_resetn),
        .axis_ps2pl_resetn(axis_ps2pl_resetn),
        .enable_vlan_out_0(enable_vlan_out_0),
        .external_pl_reset(external_pl_reset),
        .max_sent_packet_counter_out_0(max_sent_packet_counter_out_0),
        .pkt_hdr_out_0(pkt_hdr_out_0),
        .pkt_id_out_0(pkt_id_out_0),
        .rtc_clk_0(rtc_clk_0),
        .rtc_time_ns_0(rtc_time_ns_0),
        .s_axi_time_sync_araddr(s_axi_time_sync_araddr),
        .s_axi_time_sync_aresetn(s_axi_time_sync_aresetn),
        .s_axi_time_sync_arprot(s_axi_time_sync_arprot),
        .s_axi_time_sync_arready(s_axi_time_sync_arready),
        .s_axi_time_sync_arvalid(s_axi_time_sync_arvalid),
        .s_axi_time_sync_awaddr(s_axi_time_sync_awaddr),
        .s_axi_time_sync_awprot(s_axi_time_sync_awprot),
        .s_axi_time_sync_awready(s_axi_time_sync_awready),
        .s_axi_time_sync_awvalid(s_axi_time_sync_awvalid),
        .s_axi_time_sync_bready(s_axi_time_sync_bready),
        .s_axi_time_sync_bresp(s_axi_time_sync_bresp),
        .s_axi_time_sync_bvalid(s_axi_time_sync_bvalid),
        .s_axi_time_sync_clk(s_axi_time_sync_clk),
        .s_axi_time_sync_rdata(s_axi_time_sync_rdata),
        .s_axi_time_sync_rready(s_axi_time_sync_rready),
        .s_axi_time_sync_rresp(s_axi_time_sync_rresp),
        .s_axi_time_sync_rvalid(s_axi_time_sync_rvalid),
        .s_axi_time_sync_wdata(s_axi_time_sync_wdata),
        .s_axi_time_sync_wready(s_axi_time_sync_wready),
        .s_axi_time_sync_wstrb(s_axi_time_sync_wstrb),
        .s_axi_time_sync_wvalid(s_axi_time_sync_wvalid),
        .seq_id_out_0(seq_id_out_0),
        .tx_signal_0(tx_signal_0));
endmodule
