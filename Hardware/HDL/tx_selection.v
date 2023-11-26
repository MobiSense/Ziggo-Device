`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Xiaowu He.
// 
// Create Date: 2021/11/13 17:07:27
// Design Name: 
// Module Name: tx_selection
// Project Name: tsn device
// Target Devices: 
// Tool Versions: 
// Description: Selection between device generated time-critical packets and DMA
//          passed PTP packets.
//
//     if (tx_active) then send pkt_gen_data; else send ps2pl data.
//     make above decision after a packet is transmitted successfully (tlast).
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tx_selection
#(
    parameter AXIS_DATA_WIDTH = 8
)
(
    // Selection related signals
    //----------------------------------------------------------------------
    // if gaurd band enable, this sends a pulse 1500 cycle before tx_signal
    // if no gaurd band, this is tx_signal
    input                                      pkt_gen_ready, 
    // send pulse after sent_packet_counter == max_sent_packet_counter
    input                                      pkt_gen_finish, 

    // AXI-S related signals
    //----------------------------------------------------------------------
    input                                      axis_aclk,
    input                                      axis_resetn,

    input [AXIS_DATA_WIDTH - 1:0]              tx_axis_pkt_gen_tdata,
    input                                      tx_axis_pkt_gen_tvalid,
    input                                      tx_axis_pkt_gen_tlast,
    output                                     tx_axis_pkt_gen_tready,

    input [AXIS_DATA_WIDTH - 1:0]              tx_axis_ps2pl_tdata,
    input                                      tx_axis_ps2pl_tvalid,
    input                                      tx_axis_ps2pl_tlast,
    output                                     tx_axis_ps2pl_tready,

    // // From PS, Ethernet
    // input [AXIS_DATA_WIDTH - 1:0]              tx_axis_pseth_tdata,
    // input                                      tx_axis_pseth_tvalid,
    // input                                      tx_axis_pseth_tlast,
    // output                                     tx_axis_pseth_tready,

    output [AXIS_DATA_WIDTH - 1:0]             tx_axis_tdata,
    output                                     tx_axis_tvalid,
    input                                      tx_axis_tready,
    output                                     tx_axis_tlast
);

// TODO: 状态机： transmitting v.s. idle
(* mark_debug = "true" *)reg [1:0]   state, next_state;

(* mark_debug = "true" *)reg         queue, next_queue;

(* mark_debug = "true" *)reg         pkt_gen_active;

wire        axis_reset;
assign      axis_reset = !axis_resetn;

always @(posedge axis_aclk) begin
    if (axis_reset) begin
        pkt_gen_active <= 0;
    end
    else if (pkt_gen_ready) begin
        pkt_gen_active <= 1;
    end else if (pkt_gen_finish) begin
        pkt_gen_active <= 0;
    end
end

localparam  IDLE            = 2'b00,
            WAITING         = 2'b01,
            TRANSMITTING    = 2'b10;

localparam  QUEUE_PKT_GEN   = 1'b0,
            QUEUE_PS2PL     = 1'b1;

(* mark_debug = "true" *)wire [AXIS_DATA_WIDTH - 1:0]    tx_axis_tdata_w[0:1];
(* mark_debug = "true" *)wire                            tx_axis_tvalid_w[0:1];
(* mark_debug = "true" *)wire                            tx_axis_tlast_w[0:1];
(* mark_debug = "true" *)wire                            tx_axis_tready_w[0:1];

(* mark_debug = "true" *)assign      tx_axis_tdata_w[QUEUE_PKT_GEN]      = tx_axis_pkt_gen_tdata;
(* mark_debug = "true" *)assign      tx_axis_tvalid_w[QUEUE_PKT_GEN]     = tx_axis_pkt_gen_tvalid;
(* mark_debug = "true" *)assign      tx_axis_tlast_w[QUEUE_PKT_GEN]      = tx_axis_pkt_gen_tlast;

(* mark_debug = "true" *)assign      tx_axis_tdata_w[QUEUE_PS2PL]        = tx_axis_ps2pl_tdata;
(* mark_debug = "true" *)assign      tx_axis_tvalid_w[QUEUE_PS2PL]       = tx_axis_ps2pl_tvalid;
(* mark_debug = "true" *)assign      tx_axis_tlast_w[QUEUE_PS2PL]        = tx_axis_ps2pl_tlast;

(* mark_debug = "true" *)assign      tx_axis_pkt_gen_tready  = tx_axis_tready_w[QUEUE_PKT_GEN];
(* mark_debug = "true" *)assign      tx_axis_ps2pl_tready    = tx_axis_tready_w[QUEUE_PS2PL];

// Check whether pkt_gen is active after a packet transmission finishes
always @(*) begin
    next_state = state;
    next_queue = queue;
    case (state)
        IDLE        : begin
            next_queue = pkt_gen_active ? QUEUE_PKT_GEN : QUEUE_PS2PL;
            next_state = WAITING;
        end 
        WAITING     : begin
            if (tx_axis_tvalid && tx_axis_tready) begin
                next_state = tx_axis_tlast ? IDLE : TRANSMITTING;
            end
            // else if (pkt_gen_ready || pkt_gen_finish ) begin
            //     next_state = IDLE;
            // end
            else if ((pkt_gen_active && queue == QUEUE_PS2PL) || 
                    (!pkt_gen_active && queue == QUEUE_PKT_GEN)) begin
                next_state = IDLE;
            end
        end
        TRANSMITTING: begin
            if (tx_axis_tvalid && tx_axis_tready && tx_axis_tlast) begin
                next_state = IDLE;
            end
        end 
        default     : begin
            next_state = state;
            next_queue = queue;
        end
    endcase
end

always @(posedge axis_aclk) begin
    if (axis_reset) begin
        state <= IDLE;
        queue <= QUEUE_PKT_GEN;
    end
    else begin
        state <= next_state;
        queue <= next_queue;
    end
end

// If current state is IDLE, set ready to 0

assign tx_axis_tdata   = (state == IDLE) ? {AXIS_DATA_WIDTH{1'b0}}  : tx_axis_tdata_w[queue];
assign tx_axis_tvalid  = (state == IDLE) ? 1'b0                     : tx_axis_tvalid_w[queue];
assign tx_axis_tlast   = (state == IDLE) ? 1'b0                     : tx_axis_tlast_w[queue];

generate
    genvar i;
    for (i = 0; i < 2; i = i + 1) begin
        assign tx_axis_tready_w[i] = (state == IDLE) ? 1'b0 : (queue == i) ? tx_axis_tready : 0;
    end
endgenerate


endmodule
