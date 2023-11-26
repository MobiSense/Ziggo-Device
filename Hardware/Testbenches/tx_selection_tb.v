`timescale 1ns / 1ps

module transmission_selection_tb();
    
// Local parameters
localparam ONE_NS = 1;
localparam time PER_125M_clk = 8*ONE_NS; // 8 ns clock

localparam AXIS_DATA_WIDTH = 8;

// Reg declarations
reg clk = 1;
reg reset = 1;
reg [31:0] sync_time_ptp_ns;

// Clock signals
always begin
    clk = #(PER_125M_clk/2) ~clk;
end

always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
        sync_time_ptp_ns = 32'd999_999_000;
    end
    else begin
        sync_time_ptp_ns = (sync_time_ptp_ns + 8) % 1_000_000_000;
    end
end

wire [AXIS_DATA_WIDTH-1:0] m_axis_tdata[0:7];
wire [(AXIS_DATA_WIDTH/8)-1:0] m_axis_tkeep[0:7];
wire [7:0] m_axis_tvalid;
wire [7:0] m_axis_tready;
wire [7:0] m_axis_tlast;

wire [AXIS_DATA_WIDTH-1:0] s_axis_tdata;
wire [(AXIS_DATA_WIDTH/8)-1:0] s_axis_tkeep;
wire s_axis_tvalid;
reg s_axis_tready = 1'b1;
wire s_axis_tlast;

wire resetn;
assign resetn = ~reset;

generate
    genvar i;
    for (i = 0; i < 2; i = i + 1) begin
        packet_generator packet_generator_i (
            .axi_tclk(clk),
            .axi_tresetn(resetn),
            .enable_pat_gen(1),
            .speed(2'b00),
            .tdata(m_axis_tdata[i]),
            .tvalid(m_axis_tvalid[i]),
            .tready(m_axis_tready[i]),
            .tlast(m_axis_tlast[i])
        );
    end
endgenerate



reg tx_signal;
reg tx_pkt_gen_finish;

always begin
    tx_signal = 1;
    #8;
    tx_signal = 0;
    #100000;
    tx_pkt_gen_finish = 1;
    #8;
    tx_pkt_gen_finish = 0;
    #100000;
end

tx_selection tx_selection_inst (
    // Selection related signals
    //----------------------------------------------------------------------
    .pkt_gen_ready              (tx_signal), 
    .pkt_gen_finish             (tx_pkt_gen_finish), 

    // AXI-S related signals
    //----------------------------------------------------------------------
    .axis_aclk                  (clk),
    .axis_resetn                (resetn),

    .tx_axis_pkt_gen_tdata      (m_axis_tdata[0]),
    .tx_axis_pkt_gen_tvalid     (m_axis_tvalid[0]),
    .tx_axis_pkt_gen_tlast      (m_axis_tlast[0]),
    .tx_axis_pkt_gen_tready     (m_axis_tready[0]),

    .tx_axis_ps2pl_tdata        (m_axis_tdata[1]),
    .tx_axis_ps2pl_tvalid       (m_axis_tvalid[1]),
    .tx_axis_ps2pl_tlast        (m_axis_tlast[1]),
    .tx_axis_ps2pl_tready       (m_axis_tready[1]),

    .tx_axis_tdata              (s_axis_tdata),
    .tx_axis_tvalid             (s_axis_tvalid),
    .tx_axis_tready             (s_axis_tready),
    .tx_axis_tlast              (s_axis_tlast)
);




initial begin
    reset = 1;
    #(PER_125M_clk*16);
    reset = 0;
    #(PER_125M_clk*16);
end
endmodule
