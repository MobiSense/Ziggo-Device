`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/23 19:50:19
// Design Name: 
// Module Name: axi_packet_generator_tb
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


module axi_packet_generator_tb(
    );

    reg    clk            = 1;

    reg    tresetn;
    reg    tready         = 1;

    wire[7:0]   tdata;
    wire        tvalid;
    wire        tlast;

    reg        tx_signal  = 0;

    always begin
        #4 clk = ~clk;
    end

    initial begin
        tresetn <= 1'b0;
        #40;
        tresetn <= 1'b1;
    end



    reg [47:0]     src_addr1 = 48'h010203040506;
    reg [47:0]     src_addr2 = 48'h070809101112;
    reg [47:0]     dest_addr = 48'hffffffffffff;
    reg [15:0]     pkt_update1 = 10;
    reg [15:0]     pkt_update2 = 20;
    reg [31:0]     pkt_id1   = 0;
    reg [31:0]     pkt_id2   = 0;

    reg [31:0]     vlan_hdr  = {8'h81, 8'h00, 3'd2, 1'b0, 12'd2};

    reg [127:0]      pkt_hdr_in;
    reg              enable_vlan_in;
    reg [15:0]       seq_id_in;
    reg [31:0]       pkt_id_in;
    reg [15:0]       max_sent_packet_counter_in;

    always begin
        #100000  // sequence 1
        tx_signal <= 1'b1;
        pkt_hdr_in                 <= {
            vlan_hdr[0 +: 8],
            vlan_hdr[8 +: 8],
            vlan_hdr[16 +: 8],
            vlan_hdr[24 +: 8],
            src_addr1[0 +: 8],
            src_addr1[8 +: 8],
            src_addr1[16 +: 8],
            src_addr1[24 +: 8],
            src_addr1[32 +: 8],
            src_addr1[40 +: 8],
            dest_addr[0 +: 8],
            dest_addr[8 +: 8],
            dest_addr[16 +: 8],
            dest_addr[24 +: 8],
            dest_addr[32 +: 8],
            dest_addr[40 +: 8]
        };
        enable_vlan_in             <= 1'b1;
        seq_id_in                  <= 16'd1;
        pkt_id_in                  <= pkt_id1;
        max_sent_packet_counter_in <= pkt_update1;
        #8    
        tx_signal <= 1'b0;
        pkt_id1   <= pkt_id1 + pkt_update1;
        #200000 // sequence 2
        tx_signal <= 1'b1;
        pkt_hdr_in                 <= {
            32'd0,
            src_addr2[0 +: 8],
            src_addr2[8 +: 8],
            src_addr2[16 +: 8],
            src_addr2[24 +: 8],
            src_addr2[32 +: 8],
            src_addr2[40 +: 8],
            dest_addr[0 +: 8],
            dest_addr[8 +: 8],
            dest_addr[16 +: 8],
            dest_addr[24 +: 8],
            dest_addr[32 +: 8],
            dest_addr[40 +: 8]
        };
        enable_vlan_in             <= 1'b0;
        seq_id_in                  <= 16'd2;
        pkt_id_in                  <= pkt_id2;
        max_sent_packet_counter_in <= pkt_update2;
        #8
        tx_signal <= 1'b0;
        pkt_id2   <= pkt_id2 + pkt_update2;
    end

    axi_packet_generator dut (
        .axi_tclk       (clk),
        .axi_tresetn    (tresetn),

        .tdata          (tdata),
        .tvalid         (tvalid),
        .tlast          (tlast),
        .tready         (tready),

        .tx_signal      (tx_signal),

        .pkt_hdr_in                 (pkt_hdr_in),
        .enable_vlan_in             (enable_vlan_in),
        .seq_id_in                  (seq_id_in),
        .pkt_id_in                  (pkt_id_in),
        .max_sent_packet_counter_in (max_sent_packet_counter_in)
    );

endmodule
