// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Tue Apr 26 22:46:50 2022
// Host        : DESKTOP-5H7SBV0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/repositories/tsn_device/IP/axis_dwidth_converter_8_256/axis_dwidth_converter_8_256_sim_netlist.v
// Design      : axis_dwidth_converter_8_256
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "axis_dwidth_converter_8_256,axis_dwidth_converter_v1_1_20_axis_dwidth_converter,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "axis_dwidth_converter_v1_1_20_axis_dwidth_converter,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module axis_dwidth_converter_8_256
   (aclk,
    aresetn,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tdata,
    s_axis_tlast,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tdata,
    m_axis_tkeep,
    m_axis_tlast);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLKIF CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLKIF, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RSTIF RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RSTIF, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TVALID" *) input s_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TREADY" *) output s_axis_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TDATA" *) input [7:0]s_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS TLAST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0" *) input s_axis_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TVALID" *) output m_axis_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TREADY" *) input m_axis_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TDATA" *) output [255:0]m_axis_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TKEEP" *) output [31:0]m_axis_tkeep;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TLAST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS, TDATA_NUM_BYTES 32, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0" *) output m_axis_tlast;

  wire aclk;
  wire aresetn;
  wire [255:0]m_axis_tdata;
  wire [31:0]m_axis_tkeep;
  wire m_axis_tlast;
  wire m_axis_tready;
  wire m_axis_tvalid;
  wire [7:0]s_axis_tdata;
  wire s_axis_tlast;
  wire s_axis_tready;
  wire s_axis_tvalid;
  wire [0:0]NLW_inst_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_inst_m_axis_tid_UNCONNECTED;
  wire [31:0]NLW_inst_m_axis_tstrb_UNCONNECTED;
  wire [0:0]NLW_inst_m_axis_tuser_UNCONNECTED;

  (* C_AXIS_SIGNAL_SET = "32'b00000000000000000000000000010011" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_M_AXIS_TDATA_WIDTH = "256" *) 
  (* C_M_AXIS_TUSER_WIDTH = "1" *) 
  (* C_S_AXIS_TDATA_WIDTH = "8" *) 
  (* C_S_AXIS_TUSER_WIDTH = "1" *) 
  (* DowngradeIPIdentifiedWarnings = "yes" *) 
  (* G_INDX_SS_TDATA = "1" *) 
  (* G_INDX_SS_TDEST = "6" *) 
  (* G_INDX_SS_TID = "5" *) 
  (* G_INDX_SS_TKEEP = "3" *) 
  (* G_INDX_SS_TLAST = "4" *) 
  (* G_INDX_SS_TREADY = "0" *) 
  (* G_INDX_SS_TSTRB = "2" *) 
  (* G_INDX_SS_TUSER = "7" *) 
  (* G_MASK_SS_TDATA = "2" *) 
  (* G_MASK_SS_TDEST = "64" *) 
  (* G_MASK_SS_TID = "32" *) 
  (* G_MASK_SS_TKEEP = "8" *) 
  (* G_MASK_SS_TLAST = "16" *) 
  (* G_MASK_SS_TREADY = "1" *) 
  (* G_MASK_SS_TSTRB = "4" *) 
  (* G_MASK_SS_TUSER = "128" *) 
  (* G_TASK_SEVERITY_ERR = "2" *) 
  (* G_TASK_SEVERITY_INFO = "0" *) 
  (* G_TASK_SEVERITY_WARNING = "1" *) 
  (* P_AXIS_SIGNAL_SET = "32'b00000000000000000000000000011011" *) 
  (* P_D1_REG_CONFIG = "0" *) 
  (* P_D1_TUSER_WIDTH = "1" *) 
  (* P_D2_TDATA_WIDTH = "256" *) 
  (* P_D2_TUSER_WIDTH = "32" *) 
  (* P_D3_REG_CONFIG = "0" *) 
  (* P_D3_TUSER_WIDTH = "32" *) 
  (* P_M_RATIO = "1" *) 
  (* P_SS_TKEEP_REQUIRED = "8" *) 
  (* P_S_RATIO = "32" *) 
  axis_dwidth_converter_8_256_axis_dwidth_converter_v1_1_20_axis_dwidth_converter inst
       (.aclk(aclk),
        .aclken(1'b1),
        .aresetn(aresetn),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tdest(NLW_inst_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_inst_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(m_axis_tkeep),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tready(m_axis_tready),
        .m_axis_tstrb(NLW_inst_m_axis_tstrb_UNCONNECTED[31:0]),
        .m_axis_tuser(NLW_inst_m_axis_tuser_UNCONNECTED[0]),
        .m_axis_tvalid(m_axis_tvalid),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b1),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tready(s_axis_tready),
        .s_axis_tstrb(1'b1),
        .s_axis_tuser(1'b0),
        .s_axis_tvalid(s_axis_tvalid));
endmodule

(* C_AXIS_SIGNAL_SET = "32'b00000000000000000000000000010011" *) (* C_AXIS_TDEST_WIDTH = "1" *) (* C_AXIS_TID_WIDTH = "1" *) 
(* C_FAMILY = "zynq" *) (* C_M_AXIS_TDATA_WIDTH = "256" *) (* C_M_AXIS_TUSER_WIDTH = "1" *) 
(* C_S_AXIS_TDATA_WIDTH = "8" *) (* C_S_AXIS_TUSER_WIDTH = "1" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* G_INDX_SS_TDATA = "1" *) (* G_INDX_SS_TDEST = "6" *) (* G_INDX_SS_TID = "5" *) 
(* G_INDX_SS_TKEEP = "3" *) (* G_INDX_SS_TLAST = "4" *) (* G_INDX_SS_TREADY = "0" *) 
(* G_INDX_SS_TSTRB = "2" *) (* G_INDX_SS_TUSER = "7" *) (* G_MASK_SS_TDATA = "2" *) 
(* G_MASK_SS_TDEST = "64" *) (* G_MASK_SS_TID = "32" *) (* G_MASK_SS_TKEEP = "8" *) 
(* G_MASK_SS_TLAST = "16" *) (* G_MASK_SS_TREADY = "1" *) (* G_MASK_SS_TSTRB = "4" *) 
(* G_MASK_SS_TUSER = "128" *) (* G_TASK_SEVERITY_ERR = "2" *) (* G_TASK_SEVERITY_INFO = "0" *) 
(* G_TASK_SEVERITY_WARNING = "1" *) (* ORIG_REF_NAME = "axis_dwidth_converter_v1_1_20_axis_dwidth_converter" *) (* P_AXIS_SIGNAL_SET = "32'b00000000000000000000000000011011" *) 
(* P_D1_REG_CONFIG = "0" *) (* P_D1_TUSER_WIDTH = "1" *) (* P_D2_TDATA_WIDTH = "256" *) 
(* P_D2_TUSER_WIDTH = "32" *) (* P_D3_REG_CONFIG = "0" *) (* P_D3_TUSER_WIDTH = "32" *) 
(* P_M_RATIO = "1" *) (* P_SS_TKEEP_REQUIRED = "8" *) (* P_S_RATIO = "32" *) 
module axis_dwidth_converter_8_256_axis_dwidth_converter_v1_1_20_axis_dwidth_converter
   (aclk,
    aresetn,
    aclken,
    s_axis_tvalid,
    s_axis_tready,
    s_axis_tdata,
    s_axis_tstrb,
    s_axis_tkeep,
    s_axis_tlast,
    s_axis_tid,
    s_axis_tdest,
    s_axis_tuser,
    m_axis_tvalid,
    m_axis_tready,
    m_axis_tdata,
    m_axis_tstrb,
    m_axis_tkeep,
    m_axis_tlast,
    m_axis_tid,
    m_axis_tdest,
    m_axis_tuser);
  input aclk;
  input aresetn;
  input aclken;
  input s_axis_tvalid;
  output s_axis_tready;
  input [7:0]s_axis_tdata;
  input [0:0]s_axis_tstrb;
  input [0:0]s_axis_tkeep;
  input s_axis_tlast;
  input [0:0]s_axis_tid;
  input [0:0]s_axis_tdest;
  input [0:0]s_axis_tuser;
  output m_axis_tvalid;
  input m_axis_tready;
  output [255:0]m_axis_tdata;
  output [31:0]m_axis_tstrb;
  output [31:0]m_axis_tkeep;
  output m_axis_tlast;
  output [0:0]m_axis_tid;
  output [0:0]m_axis_tdest;
  output [0:0]m_axis_tuser;

  wire \<const0> ;
  wire \<const1> ;
  wire aclk;
  wire aclken;
  wire areset_r;
  wire areset_r_i_1_n_0;
  wire aresetn;
  wire [255:0]m_axis_tdata;
  wire [31:1]\^m_axis_tkeep ;
  wire m_axis_tlast;
  wire m_axis_tready;
  wire m_axis_tvalid;
  wire [7:0]s_axis_tdata;
  wire s_axis_tlast;
  wire s_axis_tready;
  wire s_axis_tvalid;

  assign m_axis_tdest[0] = \<const0> ;
  assign m_axis_tid[0] = \<const0> ;
  assign m_axis_tkeep[31:1] = \^m_axis_tkeep [31:1];
  assign m_axis_tkeep[0] = \<const1> ;
  assign m_axis_tstrb[31] = \<const0> ;
  assign m_axis_tstrb[30] = \<const0> ;
  assign m_axis_tstrb[29] = \<const0> ;
  assign m_axis_tstrb[28] = \<const0> ;
  assign m_axis_tstrb[27] = \<const0> ;
  assign m_axis_tstrb[26] = \<const0> ;
  assign m_axis_tstrb[25] = \<const0> ;
  assign m_axis_tstrb[24] = \<const0> ;
  assign m_axis_tstrb[23] = \<const0> ;
  assign m_axis_tstrb[22] = \<const0> ;
  assign m_axis_tstrb[21] = \<const0> ;
  assign m_axis_tstrb[20] = \<const0> ;
  assign m_axis_tstrb[19] = \<const0> ;
  assign m_axis_tstrb[18] = \<const0> ;
  assign m_axis_tstrb[17] = \<const0> ;
  assign m_axis_tstrb[16] = \<const0> ;
  assign m_axis_tstrb[15] = \<const0> ;
  assign m_axis_tstrb[14] = \<const0> ;
  assign m_axis_tstrb[13] = \<const0> ;
  assign m_axis_tstrb[12] = \<const0> ;
  assign m_axis_tstrb[11] = \<const0> ;
  assign m_axis_tstrb[10] = \<const0> ;
  assign m_axis_tstrb[9] = \<const0> ;
  assign m_axis_tstrb[8] = \<const0> ;
  assign m_axis_tstrb[7] = \<const0> ;
  assign m_axis_tstrb[6] = \<const0> ;
  assign m_axis_tstrb[5] = \<const0> ;
  assign m_axis_tstrb[4] = \<const0> ;
  assign m_axis_tstrb[3] = \<const0> ;
  assign m_axis_tstrb[2] = \<const0> ;
  assign m_axis_tstrb[1] = \<const0> ;
  assign m_axis_tstrb[0] = \<const0> ;
  assign m_axis_tuser[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT1 #(
    .INIT(2'h1)) 
    areset_r_i_1
       (.I0(aresetn),
        .O(areset_r_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    areset_r_reg
       (.C(aclk),
        .CE(1'b1),
        .D(areset_r_i_1_n_0),
        .Q(areset_r),
        .R(1'b0));
  axis_dwidth_converter_8_256_axis_dwidth_converter_v1_1_20_axisc_upsizer \gen_upsizer_conversion.axisc_upsizer_0 
       (.aclk(aclk),
        .aclken(aclken),
        .areset_r(areset_r),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tkeep(\^m_axis_tkeep ),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tready(m_axis_tready),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tvalid(s_axis_tvalid),
        .\state_reg[0]_0 (s_axis_tready),
        .\state_reg[1]_0 (m_axis_tvalid));
endmodule

(* ORIG_REF_NAME = "axis_dwidth_converter_v1_1_20_axisc_upsizer" *) 
module axis_dwidth_converter_8_256_axis_dwidth_converter_v1_1_20_axisc_upsizer
   (m_axis_tkeep,
    m_axis_tlast,
    \state_reg[0]_0 ,
    \state_reg[1]_0 ,
    m_axis_tdata,
    aclk,
    s_axis_tlast,
    aclken,
    areset_r,
    s_axis_tdata,
    s_axis_tvalid,
    m_axis_tready);
  output [30:0]m_axis_tkeep;
  output m_axis_tlast;
  output \state_reg[0]_0 ;
  output \state_reg[1]_0 ;
  output [255:0]m_axis_tdata;
  input aclk;
  input s_axis_tlast;
  input aclken;
  input areset_r;
  input [7:0]s_axis_tdata;
  input s_axis_tvalid;
  input m_axis_tready;

  wire acc_data;
  wire \acc_data[255]_i_1_n_0 ;
  wire \acc_keep[31]_i_1_n_0 ;
  wire \acc_keep[31]_i_2_n_0 ;
  wire acc_last_i_1_n_0;
  wire acc_last_i_2_n_0;
  wire acc_strb11_out;
  wire acc_strb13_out;
  wire acc_strb15_out;
  wire acc_strb17_out;
  wire acc_strb19_out;
  wire acc_strb21_out;
  wire acc_strb23_out;
  wire acc_strb25_out;
  wire acc_strb27_out;
  wire acc_strb29_out;
  wire acc_strb5_out;
  wire acc_strb7_out;
  wire acc_strb9_out;
  wire aclk;
  wire aclken;
  wire areset_r;
  wire \gen_data_accumulator[10].acc_data[87]_i_1_n_0 ;
  wire \gen_data_accumulator[10].acc_keep[10]_i_1_n_0 ;
  wire \gen_data_accumulator[11].acc_data[95]_i_1_n_0 ;
  wire \gen_data_accumulator[11].acc_keep[11]_i_1_n_0 ;
  wire \gen_data_accumulator[12].acc_data[103]_i_1_n_0 ;
  wire \gen_data_accumulator[12].acc_keep[12]_i_1_n_0 ;
  wire \gen_data_accumulator[13].acc_data[111]_i_1_n_0 ;
  wire \gen_data_accumulator[13].acc_keep[13]_i_1_n_0 ;
  wire \gen_data_accumulator[14].acc_data[119]_i_1_n_0 ;
  wire \gen_data_accumulator[14].acc_keep[14]_i_1_n_0 ;
  wire \gen_data_accumulator[15].acc_data[127]_i_1_n_0 ;
  wire \gen_data_accumulator[15].acc_keep[15]_i_1_n_0 ;
  wire \gen_data_accumulator[16].acc_data[135]_i_1_n_0 ;
  wire \gen_data_accumulator[16].acc_keep[16]_i_1_n_0 ;
  wire \gen_data_accumulator[17].acc_data[143]_i_1_n_0 ;
  wire \gen_data_accumulator[17].acc_keep[17]_i_1_n_0 ;
  wire \gen_data_accumulator[18].acc_keep[18]_i_1_n_0 ;
  wire \gen_data_accumulator[19].acc_keep[19]_i_1_n_0 ;
  wire \gen_data_accumulator[1].acc_data[15]_i_1_n_0 ;
  wire \gen_data_accumulator[1].acc_keep[1]_i_1_n_0 ;
  wire \gen_data_accumulator[20].acc_keep[20]_i_1_n_0 ;
  wire \gen_data_accumulator[21].acc_keep[21]_i_1_n_0 ;
  wire \gen_data_accumulator[22].acc_keep[22]_i_1_n_0 ;
  wire \gen_data_accumulator[23].acc_keep[23]_i_1_n_0 ;
  wire \gen_data_accumulator[24].acc_keep[24]_i_1_n_0 ;
  wire \gen_data_accumulator[25].acc_keep[25]_i_1_n_0 ;
  wire \gen_data_accumulator[26].acc_keep[26]_i_1_n_0 ;
  wire \gen_data_accumulator[27].acc_keep[27]_i_1_n_0 ;
  wire \gen_data_accumulator[28].acc_keep[28]_i_1_n_0 ;
  wire \gen_data_accumulator[29].acc_keep[29]_i_1_n_0 ;
  wire \gen_data_accumulator[2].acc_data[23]_i_1_n_0 ;
  wire \gen_data_accumulator[2].acc_keep[2]_i_1_n_0 ;
  wire \gen_data_accumulator[30].acc_keep[30]_i_1_n_0 ;
  wire \gen_data_accumulator[3].acc_data[31]_i_1_n_0 ;
  wire \gen_data_accumulator[3].acc_keep[3]_i_1_n_0 ;
  wire \gen_data_accumulator[4].acc_data[39]_i_1_n_0 ;
  wire \gen_data_accumulator[4].acc_keep[4]_i_1_n_0 ;
  wire \gen_data_accumulator[5].acc_data[47]_i_1_n_0 ;
  wire \gen_data_accumulator[5].acc_keep[5]_i_1_n_0 ;
  wire \gen_data_accumulator[6].acc_data[55]_i_1_n_0 ;
  wire \gen_data_accumulator[6].acc_keep[6]_i_1_n_0 ;
  wire \gen_data_accumulator[7].acc_data[63]_i_1_n_0 ;
  wire \gen_data_accumulator[7].acc_keep[7]_i_1_n_0 ;
  wire \gen_data_accumulator[8].acc_data[71]_i_1_n_0 ;
  wire \gen_data_accumulator[8].acc_keep[8]_i_1_n_0 ;
  wire \gen_data_accumulator[9].acc_data[79]_i_1_n_0 ;
  wire \gen_data_accumulator[9].acc_keep[9]_i_1_n_0 ;
  wire [255:0]m_axis_tdata;
  wire [30:0]m_axis_tkeep;
  wire m_axis_tlast;
  wire m_axis_tready;
  wire [31:31]p_0_in;
  wire p_1_in2_in;
  wire [7:0]r0_data;
  wire r0_last;
  wire r0_last_i_1_n_0;
  wire r0_reg_sel;
  wire \r0_reg_sel[0]_i_1_n_0 ;
  wire \r0_reg_sel_reg_n_0_[0] ;
  wire \r0_reg_sel_reg_n_0_[10] ;
  wire \r0_reg_sel_reg_n_0_[11] ;
  wire \r0_reg_sel_reg_n_0_[12] ;
  wire \r0_reg_sel_reg_n_0_[13] ;
  wire \r0_reg_sel_reg_n_0_[14] ;
  wire \r0_reg_sel_reg_n_0_[15] ;
  wire \r0_reg_sel_reg_n_0_[16] ;
  wire \r0_reg_sel_reg_n_0_[17] ;
  wire \r0_reg_sel_reg_n_0_[18] ;
  wire \r0_reg_sel_reg_n_0_[19] ;
  wire \r0_reg_sel_reg_n_0_[1] ;
  wire \r0_reg_sel_reg_n_0_[20] ;
  wire \r0_reg_sel_reg_n_0_[21] ;
  wire \r0_reg_sel_reg_n_0_[22] ;
  wire \r0_reg_sel_reg_n_0_[23] ;
  wire \r0_reg_sel_reg_n_0_[24] ;
  wire \r0_reg_sel_reg_n_0_[25] ;
  wire \r0_reg_sel_reg_n_0_[26] ;
  wire \r0_reg_sel_reg_n_0_[27] ;
  wire \r0_reg_sel_reg_n_0_[28] ;
  wire \r0_reg_sel_reg_n_0_[29] ;
  wire \r0_reg_sel_reg_n_0_[2] ;
  wire \r0_reg_sel_reg_n_0_[30] ;
  wire \r0_reg_sel_reg_n_0_[3] ;
  wire \r0_reg_sel_reg_n_0_[4] ;
  wire \r0_reg_sel_reg_n_0_[5] ;
  wire \r0_reg_sel_reg_n_0_[6] ;
  wire \r0_reg_sel_reg_n_0_[7] ;
  wire \r0_reg_sel_reg_n_0_[8] ;
  wire \r0_reg_sel_reg_n_0_[9] ;
  wire r0_strb;
  wire [7:0]s_axis_tdata;
  wire s_axis_tlast;
  wire s_axis_tvalid;
  wire [0:0]state;
  wire \state[0]_i_1_n_0 ;
  wire \state[1]_i_1_n_0 ;
  wire \state[1]_i_2_n_0 ;
  wire \state[1]_i_3_n_0 ;
  wire \state[2]_i_1_n_0 ;
  wire \state[2]_i_2_n_0 ;
  wire \state[2]_i_3_n_0 ;
  wire \state_reg[0]_0 ;
  wire \state_reg[1]_0 ;
  wire \state_reg_n_0_[2] ;

  LUT3 #(
    .INIT(8'h40)) 
    \acc_data[255]_i_1 
       (.I0(\state_reg[1]_0 ),
        .I1(\state_reg[0]_0 ),
        .I2(aclken),
        .O(\acc_data[255]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h00800000)) 
    \acc_data[7]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[0] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_data));
  FDRE \acc_data_reg[0] 
       (.C(aclk),
        .CE(acc_data),
        .D(r0_data[0]),
        .Q(m_axis_tdata[0]),
        .R(1'b0));
  FDRE \acc_data_reg[1] 
       (.C(aclk),
        .CE(acc_data),
        .D(r0_data[1]),
        .Q(m_axis_tdata[1]),
        .R(1'b0));
  FDRE \acc_data_reg[248] 
       (.C(aclk),
        .CE(\acc_data[255]_i_1_n_0 ),
        .D(s_axis_tdata[0]),
        .Q(m_axis_tdata[248]),
        .R(1'b0));
  FDRE \acc_data_reg[249] 
       (.C(aclk),
        .CE(\acc_data[255]_i_1_n_0 ),
        .D(s_axis_tdata[1]),
        .Q(m_axis_tdata[249]),
        .R(1'b0));
  FDRE \acc_data_reg[250] 
       (.C(aclk),
        .CE(\acc_data[255]_i_1_n_0 ),
        .D(s_axis_tdata[2]),
        .Q(m_axis_tdata[250]),
        .R(1'b0));
  FDRE \acc_data_reg[251] 
       (.C(aclk),
        .CE(\acc_data[255]_i_1_n_0 ),
        .D(s_axis_tdata[3]),
        .Q(m_axis_tdata[251]),
        .R(1'b0));
  FDRE \acc_data_reg[252] 
       (.C(aclk),
        .CE(\acc_data[255]_i_1_n_0 ),
        .D(s_axis_tdata[4]),
        .Q(m_axis_tdata[252]),
        .R(1'b0));
  FDRE \acc_data_reg[253] 
       (.C(aclk),
        .CE(\acc_data[255]_i_1_n_0 ),
        .D(s_axis_tdata[5]),
        .Q(m_axis_tdata[253]),
        .R(1'b0));
  FDRE \acc_data_reg[254] 
       (.C(aclk),
        .CE(\acc_data[255]_i_1_n_0 ),
        .D(s_axis_tdata[6]),
        .Q(m_axis_tdata[254]),
        .R(1'b0));
  FDRE \acc_data_reg[255] 
       (.C(aclk),
        .CE(\acc_data[255]_i_1_n_0 ),
        .D(s_axis_tdata[7]),
        .Q(m_axis_tdata[255]),
        .R(1'b0));
  FDRE \acc_data_reg[2] 
       (.C(aclk),
        .CE(acc_data),
        .D(r0_data[2]),
        .Q(m_axis_tdata[2]),
        .R(1'b0));
  FDRE \acc_data_reg[3] 
       (.C(aclk),
        .CE(acc_data),
        .D(r0_data[3]),
        .Q(m_axis_tdata[3]),
        .R(1'b0));
  FDRE \acc_data_reg[4] 
       (.C(aclk),
        .CE(acc_data),
        .D(r0_data[4]),
        .Q(m_axis_tdata[4]),
        .R(1'b0));
  FDRE \acc_data_reg[5] 
       (.C(aclk),
        .CE(acc_data),
        .D(r0_data[5]),
        .Q(m_axis_tdata[5]),
        .R(1'b0));
  FDRE \acc_data_reg[6] 
       (.C(aclk),
        .CE(acc_data),
        .D(r0_data[6]),
        .Q(m_axis_tdata[6]),
        .R(1'b0));
  FDRE \acc_data_reg[7] 
       (.C(aclk),
        .CE(acc_data),
        .D(r0_data[7]),
        .Q(m_axis_tdata[7]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hBBBBBBBB8888B888)) 
    \acc_keep[31]_i_1 
       (.I0(\acc_keep[31]_i_2_n_0 ),
        .I1(\state_reg_n_0_[2] ),
        .I2(aclken),
        .I3(\state_reg[0]_0 ),
        .I4(\state_reg[1]_0 ),
        .I5(m_axis_tkeep[30]),
        .O(\acc_keep[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF011F0F0F0F0F0F0)) 
    \acc_keep[31]_i_2 
       (.I0(r0_last),
        .I1(\r0_reg_sel_reg_n_0_[0] ),
        .I2(m_axis_tkeep[30]),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg[0]_0 ),
        .I5(aclken),
        .O(\acc_keep[31]_i_2_n_0 ));
  FDRE \acc_keep_reg[31] 
       (.C(aclk),
        .CE(1'b1),
        .D(\acc_keep[31]_i_1_n_0 ),
        .Q(m_axis_tkeep[30]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    acc_last_i_1
       (.I0(aclken),
        .I1(\state_reg[1]_0 ),
        .I2(\state_reg[0]_0 ),
        .I3(r0_last),
        .I4(\state_reg_n_0_[2] ),
        .I5(acc_last_i_2_n_0),
        .O(acc_last_i_1_n_0));
  LUT5 #(
    .INIT(32'hBFAF80A0)) 
    acc_last_i_2
       (.I0(s_axis_tlast),
        .I1(\state_reg_n_0_[2] ),
        .I2(aclken),
        .I3(\state_reg[1]_0 ),
        .I4(m_axis_tlast),
        .O(acc_last_i_2_n_0));
  FDRE acc_last_reg
       (.C(aclk),
        .CE(1'b1),
        .D(acc_last_i_1_n_0),
        .Q(m_axis_tlast),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[10].acc_data[87]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[10] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[10].acc_data[87]_i_1_n_0 ));
  FDRE \gen_data_accumulator[10].acc_data_reg[80] 
       (.C(aclk),
        .CE(\gen_data_accumulator[10].acc_data[87]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[80]),
        .R(1'b0));
  FDRE \gen_data_accumulator[10].acc_data_reg[81] 
       (.C(aclk),
        .CE(\gen_data_accumulator[10].acc_data[87]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[81]),
        .R(1'b0));
  FDRE \gen_data_accumulator[10].acc_data_reg[82] 
       (.C(aclk),
        .CE(\gen_data_accumulator[10].acc_data[87]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[82]),
        .R(1'b0));
  FDRE \gen_data_accumulator[10].acc_data_reg[83] 
       (.C(aclk),
        .CE(\gen_data_accumulator[10].acc_data[87]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[83]),
        .R(1'b0));
  FDRE \gen_data_accumulator[10].acc_data_reg[84] 
       (.C(aclk),
        .CE(\gen_data_accumulator[10].acc_data[87]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[84]),
        .R(1'b0));
  FDRE \gen_data_accumulator[10].acc_data_reg[85] 
       (.C(aclk),
        .CE(\gen_data_accumulator[10].acc_data[87]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[85]),
        .R(1'b0));
  FDRE \gen_data_accumulator[10].acc_data_reg[86] 
       (.C(aclk),
        .CE(\gen_data_accumulator[10].acc_data[87]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[86]),
        .R(1'b0));
  FDRE \gen_data_accumulator[10].acc_data_reg[87] 
       (.C(aclk),
        .CE(\gen_data_accumulator[10].acc_data[87]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[87]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[10].acc_keep[10]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[10] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[9]),
        .O(\gen_data_accumulator[10].acc_keep[10]_i_1_n_0 ));
  FDRE \gen_data_accumulator[10].acc_keep_reg[10] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[10].acc_keep[10]_i_1_n_0 ),
        .Q(m_axis_tkeep[9]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[11].acc_data[95]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[11] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[11].acc_data[95]_i_1_n_0 ));
  FDRE \gen_data_accumulator[11].acc_data_reg[88] 
       (.C(aclk),
        .CE(\gen_data_accumulator[11].acc_data[95]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[88]),
        .R(1'b0));
  FDRE \gen_data_accumulator[11].acc_data_reg[89] 
       (.C(aclk),
        .CE(\gen_data_accumulator[11].acc_data[95]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[89]),
        .R(1'b0));
  FDRE \gen_data_accumulator[11].acc_data_reg[90] 
       (.C(aclk),
        .CE(\gen_data_accumulator[11].acc_data[95]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[90]),
        .R(1'b0));
  FDRE \gen_data_accumulator[11].acc_data_reg[91] 
       (.C(aclk),
        .CE(\gen_data_accumulator[11].acc_data[95]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[91]),
        .R(1'b0));
  FDRE \gen_data_accumulator[11].acc_data_reg[92] 
       (.C(aclk),
        .CE(\gen_data_accumulator[11].acc_data[95]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[92]),
        .R(1'b0));
  FDRE \gen_data_accumulator[11].acc_data_reg[93] 
       (.C(aclk),
        .CE(\gen_data_accumulator[11].acc_data[95]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[93]),
        .R(1'b0));
  FDRE \gen_data_accumulator[11].acc_data_reg[94] 
       (.C(aclk),
        .CE(\gen_data_accumulator[11].acc_data[95]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[94]),
        .R(1'b0));
  FDRE \gen_data_accumulator[11].acc_data_reg[95] 
       (.C(aclk),
        .CE(\gen_data_accumulator[11].acc_data[95]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[95]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[11].acc_keep[11]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[11] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[10]),
        .O(\gen_data_accumulator[11].acc_keep[11]_i_1_n_0 ));
  FDRE \gen_data_accumulator[11].acc_keep_reg[11] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[11].acc_keep[11]_i_1_n_0 ),
        .Q(m_axis_tkeep[10]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[12].acc_data[103]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[12] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[12].acc_data[103]_i_1_n_0 ));
  FDRE \gen_data_accumulator[12].acc_data_reg[100] 
       (.C(aclk),
        .CE(\gen_data_accumulator[12].acc_data[103]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[100]),
        .R(1'b0));
  FDRE \gen_data_accumulator[12].acc_data_reg[101] 
       (.C(aclk),
        .CE(\gen_data_accumulator[12].acc_data[103]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[101]),
        .R(1'b0));
  FDRE \gen_data_accumulator[12].acc_data_reg[102] 
       (.C(aclk),
        .CE(\gen_data_accumulator[12].acc_data[103]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[102]),
        .R(1'b0));
  FDRE \gen_data_accumulator[12].acc_data_reg[103] 
       (.C(aclk),
        .CE(\gen_data_accumulator[12].acc_data[103]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[103]),
        .R(1'b0));
  FDRE \gen_data_accumulator[12].acc_data_reg[96] 
       (.C(aclk),
        .CE(\gen_data_accumulator[12].acc_data[103]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[96]),
        .R(1'b0));
  FDRE \gen_data_accumulator[12].acc_data_reg[97] 
       (.C(aclk),
        .CE(\gen_data_accumulator[12].acc_data[103]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[97]),
        .R(1'b0));
  FDRE \gen_data_accumulator[12].acc_data_reg[98] 
       (.C(aclk),
        .CE(\gen_data_accumulator[12].acc_data[103]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[98]),
        .R(1'b0));
  FDRE \gen_data_accumulator[12].acc_data_reg[99] 
       (.C(aclk),
        .CE(\gen_data_accumulator[12].acc_data[103]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[99]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[12].acc_keep[12]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[12] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[11]),
        .O(\gen_data_accumulator[12].acc_keep[12]_i_1_n_0 ));
  FDRE \gen_data_accumulator[12].acc_keep_reg[12] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[12].acc_keep[12]_i_1_n_0 ),
        .Q(m_axis_tkeep[11]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[13].acc_data[111]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[13] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[13].acc_data[111]_i_1_n_0 ));
  FDRE \gen_data_accumulator[13].acc_data_reg[104] 
       (.C(aclk),
        .CE(\gen_data_accumulator[13].acc_data[111]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[104]),
        .R(1'b0));
  FDRE \gen_data_accumulator[13].acc_data_reg[105] 
       (.C(aclk),
        .CE(\gen_data_accumulator[13].acc_data[111]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[105]),
        .R(1'b0));
  FDRE \gen_data_accumulator[13].acc_data_reg[106] 
       (.C(aclk),
        .CE(\gen_data_accumulator[13].acc_data[111]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[106]),
        .R(1'b0));
  FDRE \gen_data_accumulator[13].acc_data_reg[107] 
       (.C(aclk),
        .CE(\gen_data_accumulator[13].acc_data[111]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[107]),
        .R(1'b0));
  FDRE \gen_data_accumulator[13].acc_data_reg[108] 
       (.C(aclk),
        .CE(\gen_data_accumulator[13].acc_data[111]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[108]),
        .R(1'b0));
  FDRE \gen_data_accumulator[13].acc_data_reg[109] 
       (.C(aclk),
        .CE(\gen_data_accumulator[13].acc_data[111]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[109]),
        .R(1'b0));
  FDRE \gen_data_accumulator[13].acc_data_reg[110] 
       (.C(aclk),
        .CE(\gen_data_accumulator[13].acc_data[111]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[110]),
        .R(1'b0));
  FDRE \gen_data_accumulator[13].acc_data_reg[111] 
       (.C(aclk),
        .CE(\gen_data_accumulator[13].acc_data[111]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[111]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[13].acc_keep[13]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[13] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[12]),
        .O(\gen_data_accumulator[13].acc_keep[13]_i_1_n_0 ));
  FDRE \gen_data_accumulator[13].acc_keep_reg[13] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[13].acc_keep[13]_i_1_n_0 ),
        .Q(m_axis_tkeep[12]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[14].acc_data[119]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[14] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[14].acc_data[119]_i_1_n_0 ));
  FDRE \gen_data_accumulator[14].acc_data_reg[112] 
       (.C(aclk),
        .CE(\gen_data_accumulator[14].acc_data[119]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[112]),
        .R(1'b0));
  FDRE \gen_data_accumulator[14].acc_data_reg[113] 
       (.C(aclk),
        .CE(\gen_data_accumulator[14].acc_data[119]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[113]),
        .R(1'b0));
  FDRE \gen_data_accumulator[14].acc_data_reg[114] 
       (.C(aclk),
        .CE(\gen_data_accumulator[14].acc_data[119]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[114]),
        .R(1'b0));
  FDRE \gen_data_accumulator[14].acc_data_reg[115] 
       (.C(aclk),
        .CE(\gen_data_accumulator[14].acc_data[119]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[115]),
        .R(1'b0));
  FDRE \gen_data_accumulator[14].acc_data_reg[116] 
       (.C(aclk),
        .CE(\gen_data_accumulator[14].acc_data[119]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[116]),
        .R(1'b0));
  FDRE \gen_data_accumulator[14].acc_data_reg[117] 
       (.C(aclk),
        .CE(\gen_data_accumulator[14].acc_data[119]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[117]),
        .R(1'b0));
  FDRE \gen_data_accumulator[14].acc_data_reg[118] 
       (.C(aclk),
        .CE(\gen_data_accumulator[14].acc_data[119]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[118]),
        .R(1'b0));
  FDRE \gen_data_accumulator[14].acc_data_reg[119] 
       (.C(aclk),
        .CE(\gen_data_accumulator[14].acc_data[119]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[119]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[14].acc_keep[14]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[14] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[13]),
        .O(\gen_data_accumulator[14].acc_keep[14]_i_1_n_0 ));
  FDRE \gen_data_accumulator[14].acc_keep_reg[14] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[14].acc_keep[14]_i_1_n_0 ),
        .Q(m_axis_tkeep[13]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[15].acc_data[127]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[15] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[15].acc_data[127]_i_1_n_0 ));
  FDRE \gen_data_accumulator[15].acc_data_reg[120] 
       (.C(aclk),
        .CE(\gen_data_accumulator[15].acc_data[127]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[120]),
        .R(1'b0));
  FDRE \gen_data_accumulator[15].acc_data_reg[121] 
       (.C(aclk),
        .CE(\gen_data_accumulator[15].acc_data[127]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[121]),
        .R(1'b0));
  FDRE \gen_data_accumulator[15].acc_data_reg[122] 
       (.C(aclk),
        .CE(\gen_data_accumulator[15].acc_data[127]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[122]),
        .R(1'b0));
  FDRE \gen_data_accumulator[15].acc_data_reg[123] 
       (.C(aclk),
        .CE(\gen_data_accumulator[15].acc_data[127]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[123]),
        .R(1'b0));
  FDRE \gen_data_accumulator[15].acc_data_reg[124] 
       (.C(aclk),
        .CE(\gen_data_accumulator[15].acc_data[127]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[124]),
        .R(1'b0));
  FDRE \gen_data_accumulator[15].acc_data_reg[125] 
       (.C(aclk),
        .CE(\gen_data_accumulator[15].acc_data[127]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[125]),
        .R(1'b0));
  FDRE \gen_data_accumulator[15].acc_data_reg[126] 
       (.C(aclk),
        .CE(\gen_data_accumulator[15].acc_data[127]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[126]),
        .R(1'b0));
  FDRE \gen_data_accumulator[15].acc_data_reg[127] 
       (.C(aclk),
        .CE(\gen_data_accumulator[15].acc_data[127]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[127]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[15].acc_keep[15]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[15] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[14]),
        .O(\gen_data_accumulator[15].acc_keep[15]_i_1_n_0 ));
  FDRE \gen_data_accumulator[15].acc_keep_reg[15] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[15].acc_keep[15]_i_1_n_0 ),
        .Q(m_axis_tkeep[14]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[16].acc_data[135]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[16] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[16].acc_data[135]_i_1_n_0 ));
  FDRE \gen_data_accumulator[16].acc_data_reg[128] 
       (.C(aclk),
        .CE(\gen_data_accumulator[16].acc_data[135]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[128]),
        .R(1'b0));
  FDRE \gen_data_accumulator[16].acc_data_reg[129] 
       (.C(aclk),
        .CE(\gen_data_accumulator[16].acc_data[135]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[129]),
        .R(1'b0));
  FDRE \gen_data_accumulator[16].acc_data_reg[130] 
       (.C(aclk),
        .CE(\gen_data_accumulator[16].acc_data[135]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[130]),
        .R(1'b0));
  FDRE \gen_data_accumulator[16].acc_data_reg[131] 
       (.C(aclk),
        .CE(\gen_data_accumulator[16].acc_data[135]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[131]),
        .R(1'b0));
  FDRE \gen_data_accumulator[16].acc_data_reg[132] 
       (.C(aclk),
        .CE(\gen_data_accumulator[16].acc_data[135]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[132]),
        .R(1'b0));
  FDRE \gen_data_accumulator[16].acc_data_reg[133] 
       (.C(aclk),
        .CE(\gen_data_accumulator[16].acc_data[135]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[133]),
        .R(1'b0));
  FDRE \gen_data_accumulator[16].acc_data_reg[134] 
       (.C(aclk),
        .CE(\gen_data_accumulator[16].acc_data[135]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[134]),
        .R(1'b0));
  FDRE \gen_data_accumulator[16].acc_data_reg[135] 
       (.C(aclk),
        .CE(\gen_data_accumulator[16].acc_data[135]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[135]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[16].acc_keep[16]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[16] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[15]),
        .O(\gen_data_accumulator[16].acc_keep[16]_i_1_n_0 ));
  FDRE \gen_data_accumulator[16].acc_keep_reg[16] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[16].acc_keep[16]_i_1_n_0 ),
        .Q(m_axis_tkeep[15]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[17].acc_data[143]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[17] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[17].acc_data[143]_i_1_n_0 ));
  FDRE \gen_data_accumulator[17].acc_data_reg[136] 
       (.C(aclk),
        .CE(\gen_data_accumulator[17].acc_data[143]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[136]),
        .R(1'b0));
  FDRE \gen_data_accumulator[17].acc_data_reg[137] 
       (.C(aclk),
        .CE(\gen_data_accumulator[17].acc_data[143]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[137]),
        .R(1'b0));
  FDRE \gen_data_accumulator[17].acc_data_reg[138] 
       (.C(aclk),
        .CE(\gen_data_accumulator[17].acc_data[143]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[138]),
        .R(1'b0));
  FDRE \gen_data_accumulator[17].acc_data_reg[139] 
       (.C(aclk),
        .CE(\gen_data_accumulator[17].acc_data[143]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[139]),
        .R(1'b0));
  FDRE \gen_data_accumulator[17].acc_data_reg[140] 
       (.C(aclk),
        .CE(\gen_data_accumulator[17].acc_data[143]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[140]),
        .R(1'b0));
  FDRE \gen_data_accumulator[17].acc_data_reg[141] 
       (.C(aclk),
        .CE(\gen_data_accumulator[17].acc_data[143]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[141]),
        .R(1'b0));
  FDRE \gen_data_accumulator[17].acc_data_reg[142] 
       (.C(aclk),
        .CE(\gen_data_accumulator[17].acc_data[143]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[142]),
        .R(1'b0));
  FDRE \gen_data_accumulator[17].acc_data_reg[143] 
       (.C(aclk),
        .CE(\gen_data_accumulator[17].acc_data[143]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[143]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[17].acc_keep[17]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[17] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[16]),
        .O(\gen_data_accumulator[17].acc_keep[17]_i_1_n_0 ));
  FDRE \gen_data_accumulator[17].acc_keep_reg[17] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[17].acc_keep[17]_i_1_n_0 ),
        .Q(m_axis_tkeep[16]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[18].acc_data[151]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[18] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb29_out));
  FDRE \gen_data_accumulator[18].acc_data_reg[144] 
       (.C(aclk),
        .CE(acc_strb29_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[144]),
        .R(1'b0));
  FDRE \gen_data_accumulator[18].acc_data_reg[145] 
       (.C(aclk),
        .CE(acc_strb29_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[145]),
        .R(1'b0));
  FDRE \gen_data_accumulator[18].acc_data_reg[146] 
       (.C(aclk),
        .CE(acc_strb29_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[146]),
        .R(1'b0));
  FDRE \gen_data_accumulator[18].acc_data_reg[147] 
       (.C(aclk),
        .CE(acc_strb29_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[147]),
        .R(1'b0));
  FDRE \gen_data_accumulator[18].acc_data_reg[148] 
       (.C(aclk),
        .CE(acc_strb29_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[148]),
        .R(1'b0));
  FDRE \gen_data_accumulator[18].acc_data_reg[149] 
       (.C(aclk),
        .CE(acc_strb29_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[149]),
        .R(1'b0));
  FDRE \gen_data_accumulator[18].acc_data_reg[150] 
       (.C(aclk),
        .CE(acc_strb29_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[150]),
        .R(1'b0));
  FDRE \gen_data_accumulator[18].acc_data_reg[151] 
       (.C(aclk),
        .CE(acc_strb29_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[151]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[18].acc_keep[18]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[18] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[17]),
        .O(\gen_data_accumulator[18].acc_keep[18]_i_1_n_0 ));
  FDRE \gen_data_accumulator[18].acc_keep_reg[18] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[18].acc_keep[18]_i_1_n_0 ),
        .Q(m_axis_tkeep[17]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[19].acc_data[159]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[19] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb27_out));
  FDRE \gen_data_accumulator[19].acc_data_reg[152] 
       (.C(aclk),
        .CE(acc_strb27_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[152]),
        .R(1'b0));
  FDRE \gen_data_accumulator[19].acc_data_reg[153] 
       (.C(aclk),
        .CE(acc_strb27_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[153]),
        .R(1'b0));
  FDRE \gen_data_accumulator[19].acc_data_reg[154] 
       (.C(aclk),
        .CE(acc_strb27_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[154]),
        .R(1'b0));
  FDRE \gen_data_accumulator[19].acc_data_reg[155] 
       (.C(aclk),
        .CE(acc_strb27_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[155]),
        .R(1'b0));
  FDRE \gen_data_accumulator[19].acc_data_reg[156] 
       (.C(aclk),
        .CE(acc_strb27_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[156]),
        .R(1'b0));
  FDRE \gen_data_accumulator[19].acc_data_reg[157] 
       (.C(aclk),
        .CE(acc_strb27_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[157]),
        .R(1'b0));
  FDRE \gen_data_accumulator[19].acc_data_reg[158] 
       (.C(aclk),
        .CE(acc_strb27_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[158]),
        .R(1'b0));
  FDRE \gen_data_accumulator[19].acc_data_reg[159] 
       (.C(aclk),
        .CE(acc_strb27_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[159]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[19].acc_keep[19]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[19] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[18]),
        .O(\gen_data_accumulator[19].acc_keep[19]_i_1_n_0 ));
  FDRE \gen_data_accumulator[19].acc_keep_reg[19] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[19].acc_keep[19]_i_1_n_0 ),
        .Q(m_axis_tkeep[18]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[1].acc_data[15]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[1] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[1].acc_data[15]_i_1_n_0 ));
  FDRE \gen_data_accumulator[1].acc_data_reg[10] 
       (.C(aclk),
        .CE(\gen_data_accumulator[1].acc_data[15]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[10]),
        .R(1'b0));
  FDRE \gen_data_accumulator[1].acc_data_reg[11] 
       (.C(aclk),
        .CE(\gen_data_accumulator[1].acc_data[15]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[11]),
        .R(1'b0));
  FDRE \gen_data_accumulator[1].acc_data_reg[12] 
       (.C(aclk),
        .CE(\gen_data_accumulator[1].acc_data[15]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[12]),
        .R(1'b0));
  FDRE \gen_data_accumulator[1].acc_data_reg[13] 
       (.C(aclk),
        .CE(\gen_data_accumulator[1].acc_data[15]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[13]),
        .R(1'b0));
  FDRE \gen_data_accumulator[1].acc_data_reg[14] 
       (.C(aclk),
        .CE(\gen_data_accumulator[1].acc_data[15]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[14]),
        .R(1'b0));
  FDRE \gen_data_accumulator[1].acc_data_reg[15] 
       (.C(aclk),
        .CE(\gen_data_accumulator[1].acc_data[15]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[15]),
        .R(1'b0));
  FDRE \gen_data_accumulator[1].acc_data_reg[8] 
       (.C(aclk),
        .CE(\gen_data_accumulator[1].acc_data[15]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[8]),
        .R(1'b0));
  FDRE \gen_data_accumulator[1].acc_data_reg[9] 
       (.C(aclk),
        .CE(\gen_data_accumulator[1].acc_data[15]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[9]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[1].acc_keep[1]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[1] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[0]),
        .O(\gen_data_accumulator[1].acc_keep[1]_i_1_n_0 ));
  FDRE \gen_data_accumulator[1].acc_keep_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[1].acc_keep[1]_i_1_n_0 ),
        .Q(m_axis_tkeep[0]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[20].acc_data[167]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[20] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb25_out));
  FDRE \gen_data_accumulator[20].acc_data_reg[160] 
       (.C(aclk),
        .CE(acc_strb25_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[160]),
        .R(1'b0));
  FDRE \gen_data_accumulator[20].acc_data_reg[161] 
       (.C(aclk),
        .CE(acc_strb25_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[161]),
        .R(1'b0));
  FDRE \gen_data_accumulator[20].acc_data_reg[162] 
       (.C(aclk),
        .CE(acc_strb25_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[162]),
        .R(1'b0));
  FDRE \gen_data_accumulator[20].acc_data_reg[163] 
       (.C(aclk),
        .CE(acc_strb25_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[163]),
        .R(1'b0));
  FDRE \gen_data_accumulator[20].acc_data_reg[164] 
       (.C(aclk),
        .CE(acc_strb25_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[164]),
        .R(1'b0));
  FDRE \gen_data_accumulator[20].acc_data_reg[165] 
       (.C(aclk),
        .CE(acc_strb25_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[165]),
        .R(1'b0));
  FDRE \gen_data_accumulator[20].acc_data_reg[166] 
       (.C(aclk),
        .CE(acc_strb25_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[166]),
        .R(1'b0));
  FDRE \gen_data_accumulator[20].acc_data_reg[167] 
       (.C(aclk),
        .CE(acc_strb25_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[167]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[20].acc_keep[20]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[20] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[19]),
        .O(\gen_data_accumulator[20].acc_keep[20]_i_1_n_0 ));
  FDRE \gen_data_accumulator[20].acc_keep_reg[20] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[20].acc_keep[20]_i_1_n_0 ),
        .Q(m_axis_tkeep[19]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[21].acc_data[175]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[21] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb23_out));
  FDRE \gen_data_accumulator[21].acc_data_reg[168] 
       (.C(aclk),
        .CE(acc_strb23_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[168]),
        .R(1'b0));
  FDRE \gen_data_accumulator[21].acc_data_reg[169] 
       (.C(aclk),
        .CE(acc_strb23_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[169]),
        .R(1'b0));
  FDRE \gen_data_accumulator[21].acc_data_reg[170] 
       (.C(aclk),
        .CE(acc_strb23_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[170]),
        .R(1'b0));
  FDRE \gen_data_accumulator[21].acc_data_reg[171] 
       (.C(aclk),
        .CE(acc_strb23_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[171]),
        .R(1'b0));
  FDRE \gen_data_accumulator[21].acc_data_reg[172] 
       (.C(aclk),
        .CE(acc_strb23_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[172]),
        .R(1'b0));
  FDRE \gen_data_accumulator[21].acc_data_reg[173] 
       (.C(aclk),
        .CE(acc_strb23_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[173]),
        .R(1'b0));
  FDRE \gen_data_accumulator[21].acc_data_reg[174] 
       (.C(aclk),
        .CE(acc_strb23_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[174]),
        .R(1'b0));
  FDRE \gen_data_accumulator[21].acc_data_reg[175] 
       (.C(aclk),
        .CE(acc_strb23_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[175]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[21].acc_keep[21]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[21] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[20]),
        .O(\gen_data_accumulator[21].acc_keep[21]_i_1_n_0 ));
  FDRE \gen_data_accumulator[21].acc_keep_reg[21] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[21].acc_keep[21]_i_1_n_0 ),
        .Q(m_axis_tkeep[20]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[22].acc_data[183]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[22] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb21_out));
  FDRE \gen_data_accumulator[22].acc_data_reg[176] 
       (.C(aclk),
        .CE(acc_strb21_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[176]),
        .R(1'b0));
  FDRE \gen_data_accumulator[22].acc_data_reg[177] 
       (.C(aclk),
        .CE(acc_strb21_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[177]),
        .R(1'b0));
  FDRE \gen_data_accumulator[22].acc_data_reg[178] 
       (.C(aclk),
        .CE(acc_strb21_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[178]),
        .R(1'b0));
  FDRE \gen_data_accumulator[22].acc_data_reg[179] 
       (.C(aclk),
        .CE(acc_strb21_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[179]),
        .R(1'b0));
  FDRE \gen_data_accumulator[22].acc_data_reg[180] 
       (.C(aclk),
        .CE(acc_strb21_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[180]),
        .R(1'b0));
  FDRE \gen_data_accumulator[22].acc_data_reg[181] 
       (.C(aclk),
        .CE(acc_strb21_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[181]),
        .R(1'b0));
  FDRE \gen_data_accumulator[22].acc_data_reg[182] 
       (.C(aclk),
        .CE(acc_strb21_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[182]),
        .R(1'b0));
  FDRE \gen_data_accumulator[22].acc_data_reg[183] 
       (.C(aclk),
        .CE(acc_strb21_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[183]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[22].acc_keep[22]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[22] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[21]),
        .O(\gen_data_accumulator[22].acc_keep[22]_i_1_n_0 ));
  FDRE \gen_data_accumulator[22].acc_keep_reg[22] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[22].acc_keep[22]_i_1_n_0 ),
        .Q(m_axis_tkeep[21]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[23].acc_data[191]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[23] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb19_out));
  FDRE \gen_data_accumulator[23].acc_data_reg[184] 
       (.C(aclk),
        .CE(acc_strb19_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[184]),
        .R(1'b0));
  FDRE \gen_data_accumulator[23].acc_data_reg[185] 
       (.C(aclk),
        .CE(acc_strb19_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[185]),
        .R(1'b0));
  FDRE \gen_data_accumulator[23].acc_data_reg[186] 
       (.C(aclk),
        .CE(acc_strb19_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[186]),
        .R(1'b0));
  FDRE \gen_data_accumulator[23].acc_data_reg[187] 
       (.C(aclk),
        .CE(acc_strb19_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[187]),
        .R(1'b0));
  FDRE \gen_data_accumulator[23].acc_data_reg[188] 
       (.C(aclk),
        .CE(acc_strb19_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[188]),
        .R(1'b0));
  FDRE \gen_data_accumulator[23].acc_data_reg[189] 
       (.C(aclk),
        .CE(acc_strb19_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[189]),
        .R(1'b0));
  FDRE \gen_data_accumulator[23].acc_data_reg[190] 
       (.C(aclk),
        .CE(acc_strb19_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[190]),
        .R(1'b0));
  FDRE \gen_data_accumulator[23].acc_data_reg[191] 
       (.C(aclk),
        .CE(acc_strb19_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[191]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[23].acc_keep[23]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[23] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[22]),
        .O(\gen_data_accumulator[23].acc_keep[23]_i_1_n_0 ));
  FDRE \gen_data_accumulator[23].acc_keep_reg[23] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[23].acc_keep[23]_i_1_n_0 ),
        .Q(m_axis_tkeep[22]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[24].acc_data[199]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[24] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb17_out));
  FDRE \gen_data_accumulator[24].acc_data_reg[192] 
       (.C(aclk),
        .CE(acc_strb17_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[192]),
        .R(1'b0));
  FDRE \gen_data_accumulator[24].acc_data_reg[193] 
       (.C(aclk),
        .CE(acc_strb17_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[193]),
        .R(1'b0));
  FDRE \gen_data_accumulator[24].acc_data_reg[194] 
       (.C(aclk),
        .CE(acc_strb17_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[194]),
        .R(1'b0));
  FDRE \gen_data_accumulator[24].acc_data_reg[195] 
       (.C(aclk),
        .CE(acc_strb17_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[195]),
        .R(1'b0));
  FDRE \gen_data_accumulator[24].acc_data_reg[196] 
       (.C(aclk),
        .CE(acc_strb17_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[196]),
        .R(1'b0));
  FDRE \gen_data_accumulator[24].acc_data_reg[197] 
       (.C(aclk),
        .CE(acc_strb17_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[197]),
        .R(1'b0));
  FDRE \gen_data_accumulator[24].acc_data_reg[198] 
       (.C(aclk),
        .CE(acc_strb17_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[198]),
        .R(1'b0));
  FDRE \gen_data_accumulator[24].acc_data_reg[199] 
       (.C(aclk),
        .CE(acc_strb17_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[199]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[24].acc_keep[24]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[24] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[23]),
        .O(\gen_data_accumulator[24].acc_keep[24]_i_1_n_0 ));
  FDRE \gen_data_accumulator[24].acc_keep_reg[24] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[24].acc_keep[24]_i_1_n_0 ),
        .Q(m_axis_tkeep[23]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[25].acc_data[207]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[25] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb15_out));
  FDRE \gen_data_accumulator[25].acc_data_reg[200] 
       (.C(aclk),
        .CE(acc_strb15_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[200]),
        .R(1'b0));
  FDRE \gen_data_accumulator[25].acc_data_reg[201] 
       (.C(aclk),
        .CE(acc_strb15_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[201]),
        .R(1'b0));
  FDRE \gen_data_accumulator[25].acc_data_reg[202] 
       (.C(aclk),
        .CE(acc_strb15_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[202]),
        .R(1'b0));
  FDRE \gen_data_accumulator[25].acc_data_reg[203] 
       (.C(aclk),
        .CE(acc_strb15_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[203]),
        .R(1'b0));
  FDRE \gen_data_accumulator[25].acc_data_reg[204] 
       (.C(aclk),
        .CE(acc_strb15_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[204]),
        .R(1'b0));
  FDRE \gen_data_accumulator[25].acc_data_reg[205] 
       (.C(aclk),
        .CE(acc_strb15_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[205]),
        .R(1'b0));
  FDRE \gen_data_accumulator[25].acc_data_reg[206] 
       (.C(aclk),
        .CE(acc_strb15_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[206]),
        .R(1'b0));
  FDRE \gen_data_accumulator[25].acc_data_reg[207] 
       (.C(aclk),
        .CE(acc_strb15_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[207]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[25].acc_keep[25]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[25] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[24]),
        .O(\gen_data_accumulator[25].acc_keep[25]_i_1_n_0 ));
  FDRE \gen_data_accumulator[25].acc_keep_reg[25] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[25].acc_keep[25]_i_1_n_0 ),
        .Q(m_axis_tkeep[24]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[26].acc_data[215]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[26] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb13_out));
  FDRE \gen_data_accumulator[26].acc_data_reg[208] 
       (.C(aclk),
        .CE(acc_strb13_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[208]),
        .R(1'b0));
  FDRE \gen_data_accumulator[26].acc_data_reg[209] 
       (.C(aclk),
        .CE(acc_strb13_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[209]),
        .R(1'b0));
  FDRE \gen_data_accumulator[26].acc_data_reg[210] 
       (.C(aclk),
        .CE(acc_strb13_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[210]),
        .R(1'b0));
  FDRE \gen_data_accumulator[26].acc_data_reg[211] 
       (.C(aclk),
        .CE(acc_strb13_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[211]),
        .R(1'b0));
  FDRE \gen_data_accumulator[26].acc_data_reg[212] 
       (.C(aclk),
        .CE(acc_strb13_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[212]),
        .R(1'b0));
  FDRE \gen_data_accumulator[26].acc_data_reg[213] 
       (.C(aclk),
        .CE(acc_strb13_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[213]),
        .R(1'b0));
  FDRE \gen_data_accumulator[26].acc_data_reg[214] 
       (.C(aclk),
        .CE(acc_strb13_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[214]),
        .R(1'b0));
  FDRE \gen_data_accumulator[26].acc_data_reg[215] 
       (.C(aclk),
        .CE(acc_strb13_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[215]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[26].acc_keep[26]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[26] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[25]),
        .O(\gen_data_accumulator[26].acc_keep[26]_i_1_n_0 ));
  FDRE \gen_data_accumulator[26].acc_keep_reg[26] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[26].acc_keep[26]_i_1_n_0 ),
        .Q(m_axis_tkeep[25]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[27].acc_data[223]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[27] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb11_out));
  FDRE \gen_data_accumulator[27].acc_data_reg[216] 
       (.C(aclk),
        .CE(acc_strb11_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[216]),
        .R(1'b0));
  FDRE \gen_data_accumulator[27].acc_data_reg[217] 
       (.C(aclk),
        .CE(acc_strb11_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[217]),
        .R(1'b0));
  FDRE \gen_data_accumulator[27].acc_data_reg[218] 
       (.C(aclk),
        .CE(acc_strb11_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[218]),
        .R(1'b0));
  FDRE \gen_data_accumulator[27].acc_data_reg[219] 
       (.C(aclk),
        .CE(acc_strb11_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[219]),
        .R(1'b0));
  FDRE \gen_data_accumulator[27].acc_data_reg[220] 
       (.C(aclk),
        .CE(acc_strb11_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[220]),
        .R(1'b0));
  FDRE \gen_data_accumulator[27].acc_data_reg[221] 
       (.C(aclk),
        .CE(acc_strb11_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[221]),
        .R(1'b0));
  FDRE \gen_data_accumulator[27].acc_data_reg[222] 
       (.C(aclk),
        .CE(acc_strb11_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[222]),
        .R(1'b0));
  FDRE \gen_data_accumulator[27].acc_data_reg[223] 
       (.C(aclk),
        .CE(acc_strb11_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[223]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[27].acc_keep[27]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[27] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[26]),
        .O(\gen_data_accumulator[27].acc_keep[27]_i_1_n_0 ));
  FDRE \gen_data_accumulator[27].acc_keep_reg[27] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[27].acc_keep[27]_i_1_n_0 ),
        .Q(m_axis_tkeep[26]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[28].acc_data[231]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[28] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb9_out));
  FDRE \gen_data_accumulator[28].acc_data_reg[224] 
       (.C(aclk),
        .CE(acc_strb9_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[224]),
        .R(1'b0));
  FDRE \gen_data_accumulator[28].acc_data_reg[225] 
       (.C(aclk),
        .CE(acc_strb9_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[225]),
        .R(1'b0));
  FDRE \gen_data_accumulator[28].acc_data_reg[226] 
       (.C(aclk),
        .CE(acc_strb9_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[226]),
        .R(1'b0));
  FDRE \gen_data_accumulator[28].acc_data_reg[227] 
       (.C(aclk),
        .CE(acc_strb9_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[227]),
        .R(1'b0));
  FDRE \gen_data_accumulator[28].acc_data_reg[228] 
       (.C(aclk),
        .CE(acc_strb9_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[228]),
        .R(1'b0));
  FDRE \gen_data_accumulator[28].acc_data_reg[229] 
       (.C(aclk),
        .CE(acc_strb9_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[229]),
        .R(1'b0));
  FDRE \gen_data_accumulator[28].acc_data_reg[230] 
       (.C(aclk),
        .CE(acc_strb9_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[230]),
        .R(1'b0));
  FDRE \gen_data_accumulator[28].acc_data_reg[231] 
       (.C(aclk),
        .CE(acc_strb9_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[231]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[28].acc_keep[28]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[28] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[27]),
        .O(\gen_data_accumulator[28].acc_keep[28]_i_1_n_0 ));
  FDRE \gen_data_accumulator[28].acc_keep_reg[28] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[28].acc_keep[28]_i_1_n_0 ),
        .Q(m_axis_tkeep[27]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[29].acc_data[239]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[29] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb7_out));
  FDRE \gen_data_accumulator[29].acc_data_reg[232] 
       (.C(aclk),
        .CE(acc_strb7_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[232]),
        .R(1'b0));
  FDRE \gen_data_accumulator[29].acc_data_reg[233] 
       (.C(aclk),
        .CE(acc_strb7_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[233]),
        .R(1'b0));
  FDRE \gen_data_accumulator[29].acc_data_reg[234] 
       (.C(aclk),
        .CE(acc_strb7_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[234]),
        .R(1'b0));
  FDRE \gen_data_accumulator[29].acc_data_reg[235] 
       (.C(aclk),
        .CE(acc_strb7_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[235]),
        .R(1'b0));
  FDRE \gen_data_accumulator[29].acc_data_reg[236] 
       (.C(aclk),
        .CE(acc_strb7_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[236]),
        .R(1'b0));
  FDRE \gen_data_accumulator[29].acc_data_reg[237] 
       (.C(aclk),
        .CE(acc_strb7_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[237]),
        .R(1'b0));
  FDRE \gen_data_accumulator[29].acc_data_reg[238] 
       (.C(aclk),
        .CE(acc_strb7_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[238]),
        .R(1'b0));
  FDRE \gen_data_accumulator[29].acc_data_reg[239] 
       (.C(aclk),
        .CE(acc_strb7_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[239]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[29].acc_keep[29]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[29] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[28]),
        .O(\gen_data_accumulator[29].acc_keep[29]_i_1_n_0 ));
  FDRE \gen_data_accumulator[29].acc_keep_reg[29] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[29].acc_keep[29]_i_1_n_0 ),
        .Q(m_axis_tkeep[28]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[2].acc_data[23]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[2] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[2].acc_data[23]_i_1_n_0 ));
  FDRE \gen_data_accumulator[2].acc_data_reg[16] 
       (.C(aclk),
        .CE(\gen_data_accumulator[2].acc_data[23]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[16]),
        .R(1'b0));
  FDRE \gen_data_accumulator[2].acc_data_reg[17] 
       (.C(aclk),
        .CE(\gen_data_accumulator[2].acc_data[23]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[17]),
        .R(1'b0));
  FDRE \gen_data_accumulator[2].acc_data_reg[18] 
       (.C(aclk),
        .CE(\gen_data_accumulator[2].acc_data[23]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[18]),
        .R(1'b0));
  FDRE \gen_data_accumulator[2].acc_data_reg[19] 
       (.C(aclk),
        .CE(\gen_data_accumulator[2].acc_data[23]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[19]),
        .R(1'b0));
  FDRE \gen_data_accumulator[2].acc_data_reg[20] 
       (.C(aclk),
        .CE(\gen_data_accumulator[2].acc_data[23]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[20]),
        .R(1'b0));
  FDRE \gen_data_accumulator[2].acc_data_reg[21] 
       (.C(aclk),
        .CE(\gen_data_accumulator[2].acc_data[23]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[21]),
        .R(1'b0));
  FDRE \gen_data_accumulator[2].acc_data_reg[22] 
       (.C(aclk),
        .CE(\gen_data_accumulator[2].acc_data[23]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[22]),
        .R(1'b0));
  FDRE \gen_data_accumulator[2].acc_data_reg[23] 
       (.C(aclk),
        .CE(\gen_data_accumulator[2].acc_data[23]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[23]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[2].acc_keep[2]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[2] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[1]),
        .O(\gen_data_accumulator[2].acc_keep[2]_i_1_n_0 ));
  FDRE \gen_data_accumulator[2].acc_keep_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[2].acc_keep[2]_i_1_n_0 ),
        .Q(m_axis_tkeep[1]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[30].acc_data[247]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[30] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(acc_strb5_out));
  FDRE \gen_data_accumulator[30].acc_data_reg[240] 
       (.C(aclk),
        .CE(acc_strb5_out),
        .D(r0_data[0]),
        .Q(m_axis_tdata[240]),
        .R(1'b0));
  FDRE \gen_data_accumulator[30].acc_data_reg[241] 
       (.C(aclk),
        .CE(acc_strb5_out),
        .D(r0_data[1]),
        .Q(m_axis_tdata[241]),
        .R(1'b0));
  FDRE \gen_data_accumulator[30].acc_data_reg[242] 
       (.C(aclk),
        .CE(acc_strb5_out),
        .D(r0_data[2]),
        .Q(m_axis_tdata[242]),
        .R(1'b0));
  FDRE \gen_data_accumulator[30].acc_data_reg[243] 
       (.C(aclk),
        .CE(acc_strb5_out),
        .D(r0_data[3]),
        .Q(m_axis_tdata[243]),
        .R(1'b0));
  FDRE \gen_data_accumulator[30].acc_data_reg[244] 
       (.C(aclk),
        .CE(acc_strb5_out),
        .D(r0_data[4]),
        .Q(m_axis_tdata[244]),
        .R(1'b0));
  FDRE \gen_data_accumulator[30].acc_data_reg[245] 
       (.C(aclk),
        .CE(acc_strb5_out),
        .D(r0_data[5]),
        .Q(m_axis_tdata[245]),
        .R(1'b0));
  FDRE \gen_data_accumulator[30].acc_data_reg[246] 
       (.C(aclk),
        .CE(acc_strb5_out),
        .D(r0_data[6]),
        .Q(m_axis_tdata[246]),
        .R(1'b0));
  FDRE \gen_data_accumulator[30].acc_data_reg[247] 
       (.C(aclk),
        .CE(acc_strb5_out),
        .D(r0_data[7]),
        .Q(m_axis_tdata[247]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[30].acc_keep[30]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[30] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[29]),
        .O(\gen_data_accumulator[30].acc_keep[30]_i_1_n_0 ));
  FDRE \gen_data_accumulator[30].acc_keep_reg[30] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[30].acc_keep[30]_i_1_n_0 ),
        .Q(m_axis_tkeep[29]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[3].acc_data[31]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[3] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[3].acc_data[31]_i_1_n_0 ));
  FDRE \gen_data_accumulator[3].acc_data_reg[24] 
       (.C(aclk),
        .CE(\gen_data_accumulator[3].acc_data[31]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[24]),
        .R(1'b0));
  FDRE \gen_data_accumulator[3].acc_data_reg[25] 
       (.C(aclk),
        .CE(\gen_data_accumulator[3].acc_data[31]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[25]),
        .R(1'b0));
  FDRE \gen_data_accumulator[3].acc_data_reg[26] 
       (.C(aclk),
        .CE(\gen_data_accumulator[3].acc_data[31]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[26]),
        .R(1'b0));
  FDRE \gen_data_accumulator[3].acc_data_reg[27] 
       (.C(aclk),
        .CE(\gen_data_accumulator[3].acc_data[31]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[27]),
        .R(1'b0));
  FDRE \gen_data_accumulator[3].acc_data_reg[28] 
       (.C(aclk),
        .CE(\gen_data_accumulator[3].acc_data[31]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[28]),
        .R(1'b0));
  FDRE \gen_data_accumulator[3].acc_data_reg[29] 
       (.C(aclk),
        .CE(\gen_data_accumulator[3].acc_data[31]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[29]),
        .R(1'b0));
  FDRE \gen_data_accumulator[3].acc_data_reg[30] 
       (.C(aclk),
        .CE(\gen_data_accumulator[3].acc_data[31]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[30]),
        .R(1'b0));
  FDRE \gen_data_accumulator[3].acc_data_reg[31] 
       (.C(aclk),
        .CE(\gen_data_accumulator[3].acc_data[31]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[31]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[3].acc_keep[3]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[3] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[2]),
        .O(\gen_data_accumulator[3].acc_keep[3]_i_1_n_0 ));
  FDRE \gen_data_accumulator[3].acc_keep_reg[3] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[3].acc_keep[3]_i_1_n_0 ),
        .Q(m_axis_tkeep[2]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[4].acc_data[39]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[4] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[4].acc_data[39]_i_1_n_0 ));
  FDRE \gen_data_accumulator[4].acc_data_reg[32] 
       (.C(aclk),
        .CE(\gen_data_accumulator[4].acc_data[39]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[32]),
        .R(1'b0));
  FDRE \gen_data_accumulator[4].acc_data_reg[33] 
       (.C(aclk),
        .CE(\gen_data_accumulator[4].acc_data[39]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[33]),
        .R(1'b0));
  FDRE \gen_data_accumulator[4].acc_data_reg[34] 
       (.C(aclk),
        .CE(\gen_data_accumulator[4].acc_data[39]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[34]),
        .R(1'b0));
  FDRE \gen_data_accumulator[4].acc_data_reg[35] 
       (.C(aclk),
        .CE(\gen_data_accumulator[4].acc_data[39]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[35]),
        .R(1'b0));
  FDRE \gen_data_accumulator[4].acc_data_reg[36] 
       (.C(aclk),
        .CE(\gen_data_accumulator[4].acc_data[39]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[36]),
        .R(1'b0));
  FDRE \gen_data_accumulator[4].acc_data_reg[37] 
       (.C(aclk),
        .CE(\gen_data_accumulator[4].acc_data[39]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[37]),
        .R(1'b0));
  FDRE \gen_data_accumulator[4].acc_data_reg[38] 
       (.C(aclk),
        .CE(\gen_data_accumulator[4].acc_data[39]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[38]),
        .R(1'b0));
  FDRE \gen_data_accumulator[4].acc_data_reg[39] 
       (.C(aclk),
        .CE(\gen_data_accumulator[4].acc_data[39]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[39]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[4].acc_keep[4]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[4] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[3]),
        .O(\gen_data_accumulator[4].acc_keep[4]_i_1_n_0 ));
  FDRE \gen_data_accumulator[4].acc_keep_reg[4] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[4].acc_keep[4]_i_1_n_0 ),
        .Q(m_axis_tkeep[3]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[5].acc_data[47]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[5] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[5].acc_data[47]_i_1_n_0 ));
  FDRE \gen_data_accumulator[5].acc_data_reg[40] 
       (.C(aclk),
        .CE(\gen_data_accumulator[5].acc_data[47]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[40]),
        .R(1'b0));
  FDRE \gen_data_accumulator[5].acc_data_reg[41] 
       (.C(aclk),
        .CE(\gen_data_accumulator[5].acc_data[47]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[41]),
        .R(1'b0));
  FDRE \gen_data_accumulator[5].acc_data_reg[42] 
       (.C(aclk),
        .CE(\gen_data_accumulator[5].acc_data[47]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[42]),
        .R(1'b0));
  FDRE \gen_data_accumulator[5].acc_data_reg[43] 
       (.C(aclk),
        .CE(\gen_data_accumulator[5].acc_data[47]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[43]),
        .R(1'b0));
  FDRE \gen_data_accumulator[5].acc_data_reg[44] 
       (.C(aclk),
        .CE(\gen_data_accumulator[5].acc_data[47]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[44]),
        .R(1'b0));
  FDRE \gen_data_accumulator[5].acc_data_reg[45] 
       (.C(aclk),
        .CE(\gen_data_accumulator[5].acc_data[47]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[45]),
        .R(1'b0));
  FDRE \gen_data_accumulator[5].acc_data_reg[46] 
       (.C(aclk),
        .CE(\gen_data_accumulator[5].acc_data[47]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[46]),
        .R(1'b0));
  FDRE \gen_data_accumulator[5].acc_data_reg[47] 
       (.C(aclk),
        .CE(\gen_data_accumulator[5].acc_data[47]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[47]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[5].acc_keep[5]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[5] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[4]),
        .O(\gen_data_accumulator[5].acc_keep[5]_i_1_n_0 ));
  FDRE \gen_data_accumulator[5].acc_keep_reg[5] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[5].acc_keep[5]_i_1_n_0 ),
        .Q(m_axis_tkeep[4]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[6].acc_data[55]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[6] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[6].acc_data[55]_i_1_n_0 ));
  FDRE \gen_data_accumulator[6].acc_data_reg[48] 
       (.C(aclk),
        .CE(\gen_data_accumulator[6].acc_data[55]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[48]),
        .R(1'b0));
  FDRE \gen_data_accumulator[6].acc_data_reg[49] 
       (.C(aclk),
        .CE(\gen_data_accumulator[6].acc_data[55]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[49]),
        .R(1'b0));
  FDRE \gen_data_accumulator[6].acc_data_reg[50] 
       (.C(aclk),
        .CE(\gen_data_accumulator[6].acc_data[55]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[50]),
        .R(1'b0));
  FDRE \gen_data_accumulator[6].acc_data_reg[51] 
       (.C(aclk),
        .CE(\gen_data_accumulator[6].acc_data[55]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[51]),
        .R(1'b0));
  FDRE \gen_data_accumulator[6].acc_data_reg[52] 
       (.C(aclk),
        .CE(\gen_data_accumulator[6].acc_data[55]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[52]),
        .R(1'b0));
  FDRE \gen_data_accumulator[6].acc_data_reg[53] 
       (.C(aclk),
        .CE(\gen_data_accumulator[6].acc_data[55]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[53]),
        .R(1'b0));
  FDRE \gen_data_accumulator[6].acc_data_reg[54] 
       (.C(aclk),
        .CE(\gen_data_accumulator[6].acc_data[55]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[54]),
        .R(1'b0));
  FDRE \gen_data_accumulator[6].acc_data_reg[55] 
       (.C(aclk),
        .CE(\gen_data_accumulator[6].acc_data[55]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[55]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[6].acc_keep[6]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[6] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[5]),
        .O(\gen_data_accumulator[6].acc_keep[6]_i_1_n_0 ));
  FDRE \gen_data_accumulator[6].acc_keep_reg[6] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[6].acc_keep[6]_i_1_n_0 ),
        .Q(m_axis_tkeep[5]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[7].acc_data[63]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[7] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[7].acc_data[63]_i_1_n_0 ));
  FDRE \gen_data_accumulator[7].acc_data_reg[56] 
       (.C(aclk),
        .CE(\gen_data_accumulator[7].acc_data[63]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[56]),
        .R(1'b0));
  FDRE \gen_data_accumulator[7].acc_data_reg[57] 
       (.C(aclk),
        .CE(\gen_data_accumulator[7].acc_data[63]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[57]),
        .R(1'b0));
  FDRE \gen_data_accumulator[7].acc_data_reg[58] 
       (.C(aclk),
        .CE(\gen_data_accumulator[7].acc_data[63]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[58]),
        .R(1'b0));
  FDRE \gen_data_accumulator[7].acc_data_reg[59] 
       (.C(aclk),
        .CE(\gen_data_accumulator[7].acc_data[63]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[59]),
        .R(1'b0));
  FDRE \gen_data_accumulator[7].acc_data_reg[60] 
       (.C(aclk),
        .CE(\gen_data_accumulator[7].acc_data[63]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[60]),
        .R(1'b0));
  FDRE \gen_data_accumulator[7].acc_data_reg[61] 
       (.C(aclk),
        .CE(\gen_data_accumulator[7].acc_data[63]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[61]),
        .R(1'b0));
  FDRE \gen_data_accumulator[7].acc_data_reg[62] 
       (.C(aclk),
        .CE(\gen_data_accumulator[7].acc_data[63]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[62]),
        .R(1'b0));
  FDRE \gen_data_accumulator[7].acc_data_reg[63] 
       (.C(aclk),
        .CE(\gen_data_accumulator[7].acc_data[63]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[63]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[7].acc_keep[7]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[7] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[6]),
        .O(\gen_data_accumulator[7].acc_keep[7]_i_1_n_0 ));
  FDRE \gen_data_accumulator[7].acc_keep_reg[7] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[7].acc_keep[7]_i_1_n_0 ),
        .Q(m_axis_tkeep[6]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[8].acc_data[71]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[8] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[8].acc_data[71]_i_1_n_0 ));
  FDRE \gen_data_accumulator[8].acc_data_reg[64] 
       (.C(aclk),
        .CE(\gen_data_accumulator[8].acc_data[71]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[64]),
        .R(1'b0));
  FDRE \gen_data_accumulator[8].acc_data_reg[65] 
       (.C(aclk),
        .CE(\gen_data_accumulator[8].acc_data[71]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[65]),
        .R(1'b0));
  FDRE \gen_data_accumulator[8].acc_data_reg[66] 
       (.C(aclk),
        .CE(\gen_data_accumulator[8].acc_data[71]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[66]),
        .R(1'b0));
  FDRE \gen_data_accumulator[8].acc_data_reg[67] 
       (.C(aclk),
        .CE(\gen_data_accumulator[8].acc_data[71]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[67]),
        .R(1'b0));
  FDRE \gen_data_accumulator[8].acc_data_reg[68] 
       (.C(aclk),
        .CE(\gen_data_accumulator[8].acc_data[71]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[68]),
        .R(1'b0));
  FDRE \gen_data_accumulator[8].acc_data_reg[69] 
       (.C(aclk),
        .CE(\gen_data_accumulator[8].acc_data[71]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[69]),
        .R(1'b0));
  FDRE \gen_data_accumulator[8].acc_data_reg[70] 
       (.C(aclk),
        .CE(\gen_data_accumulator[8].acc_data[71]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[70]),
        .R(1'b0));
  FDRE \gen_data_accumulator[8].acc_data_reg[71] 
       (.C(aclk),
        .CE(\gen_data_accumulator[8].acc_data[71]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[71]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[8].acc_keep[8]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[8] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[7]),
        .O(\gen_data_accumulator[8].acc_keep[8]_i_1_n_0 ));
  FDRE \gen_data_accumulator[8].acc_keep_reg[8] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[8].acc_keep[8]_i_1_n_0 ),
        .Q(m_axis_tkeep[7]),
        .R(acc_data));
  LUT5 #(
    .INIT(32'h00800000)) 
    \gen_data_accumulator[9].acc_data[79]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[9] ),
        .I3(\state_reg[1]_0 ),
        .I4(\state_reg_n_0_[2] ),
        .O(\gen_data_accumulator[9].acc_data[79]_i_1_n_0 ));
  FDRE \gen_data_accumulator[9].acc_data_reg[72] 
       (.C(aclk),
        .CE(\gen_data_accumulator[9].acc_data[79]_i_1_n_0 ),
        .D(r0_data[0]),
        .Q(m_axis_tdata[72]),
        .R(1'b0));
  FDRE \gen_data_accumulator[9].acc_data_reg[73] 
       (.C(aclk),
        .CE(\gen_data_accumulator[9].acc_data[79]_i_1_n_0 ),
        .D(r0_data[1]),
        .Q(m_axis_tdata[73]),
        .R(1'b0));
  FDRE \gen_data_accumulator[9].acc_data_reg[74] 
       (.C(aclk),
        .CE(\gen_data_accumulator[9].acc_data[79]_i_1_n_0 ),
        .D(r0_data[2]),
        .Q(m_axis_tdata[74]),
        .R(1'b0));
  FDRE \gen_data_accumulator[9].acc_data_reg[75] 
       (.C(aclk),
        .CE(\gen_data_accumulator[9].acc_data[79]_i_1_n_0 ),
        .D(r0_data[3]),
        .Q(m_axis_tdata[75]),
        .R(1'b0));
  FDRE \gen_data_accumulator[9].acc_data_reg[76] 
       (.C(aclk),
        .CE(\gen_data_accumulator[9].acc_data[79]_i_1_n_0 ),
        .D(r0_data[4]),
        .Q(m_axis_tdata[76]),
        .R(1'b0));
  FDRE \gen_data_accumulator[9].acc_data_reg[77] 
       (.C(aclk),
        .CE(\gen_data_accumulator[9].acc_data[79]_i_1_n_0 ),
        .D(r0_data[5]),
        .Q(m_axis_tdata[77]),
        .R(1'b0));
  FDRE \gen_data_accumulator[9].acc_data_reg[78] 
       (.C(aclk),
        .CE(\gen_data_accumulator[9].acc_data[79]_i_1_n_0 ),
        .D(r0_data[6]),
        .Q(m_axis_tdata[78]),
        .R(1'b0));
  FDRE \gen_data_accumulator[9].acc_data_reg[79] 
       (.C(aclk),
        .CE(\gen_data_accumulator[9].acc_data[79]_i_1_n_0 ),
        .D(r0_data[7]),
        .Q(m_axis_tdata[79]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFF20000000)) 
    \gen_data_accumulator[9].acc_keep[9]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(\state_reg[1]_0 ),
        .I2(\r0_reg_sel_reg_n_0_[9] ),
        .I3(\state_reg[0]_0 ),
        .I4(aclken),
        .I5(m_axis_tkeep[8]),
        .O(\gen_data_accumulator[9].acc_keep[9]_i_1_n_0 ));
  FDRE \gen_data_accumulator[9].acc_keep_reg[9] 
       (.C(aclk),
        .CE(1'b1),
        .D(\gen_data_accumulator[9].acc_keep[9]_i_1_n_0 ),
        .Q(m_axis_tkeep[8]),
        .R(acc_data));
  LUT2 #(
    .INIT(4'h8)) 
    \r0_data[7]_i_1 
       (.I0(\state_reg[0]_0 ),
        .I1(aclken),
        .O(r0_strb));
  FDRE \r0_data_reg[0] 
       (.C(aclk),
        .CE(r0_strb),
        .D(s_axis_tdata[0]),
        .Q(r0_data[0]),
        .R(1'b0));
  FDRE \r0_data_reg[1] 
       (.C(aclk),
        .CE(r0_strb),
        .D(s_axis_tdata[1]),
        .Q(r0_data[1]),
        .R(1'b0));
  FDRE \r0_data_reg[2] 
       (.C(aclk),
        .CE(r0_strb),
        .D(s_axis_tdata[2]),
        .Q(r0_data[2]),
        .R(1'b0));
  FDRE \r0_data_reg[3] 
       (.C(aclk),
        .CE(r0_strb),
        .D(s_axis_tdata[3]),
        .Q(r0_data[3]),
        .R(1'b0));
  FDRE \r0_data_reg[4] 
       (.C(aclk),
        .CE(r0_strb),
        .D(s_axis_tdata[4]),
        .Q(r0_data[4]),
        .R(1'b0));
  FDRE \r0_data_reg[5] 
       (.C(aclk),
        .CE(r0_strb),
        .D(s_axis_tdata[5]),
        .Q(r0_data[5]),
        .R(1'b0));
  FDRE \r0_data_reg[6] 
       (.C(aclk),
        .CE(r0_strb),
        .D(s_axis_tdata[6]),
        .Q(r0_data[6]),
        .R(1'b0));
  FDRE \r0_data_reg[7] 
       (.C(aclk),
        .CE(r0_strb),
        .D(s_axis_tdata[7]),
        .Q(r0_data[7]),
        .R(1'b0));
  LUT4 #(
    .INIT(16'hBF80)) 
    r0_last_i_1
       (.I0(s_axis_tlast),
        .I1(\state_reg[0]_0 ),
        .I2(aclken),
        .I3(r0_last),
        .O(r0_last_i_1_n_0));
  FDRE r0_last_reg
       (.C(aclk),
        .CE(1'b1),
        .D(r0_last_i_1_n_0),
        .Q(r0_last),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFFFFFFFFF7FF0000)) 
    \r0_reg_sel[0]_i_1 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\state_reg[1]_0 ),
        .I3(\state_reg_n_0_[2] ),
        .I4(\r0_reg_sel_reg_n_0_[0] ),
        .I5(p_0_in),
        .O(\r0_reg_sel[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFF80)) 
    \r0_reg_sel[31]_i_1 
       (.I0(aclken),
        .I1(m_axis_tready),
        .I2(\state_reg[1]_0 ),
        .I3(areset_r),
        .O(p_0_in));
  LUT4 #(
    .INIT(16'h0800)) 
    \r0_reg_sel[31]_i_2 
       (.I0(aclken),
        .I1(\state_reg[0]_0 ),
        .I2(\state_reg[1]_0 ),
        .I3(\state_reg_n_0_[2] ),
        .O(r0_reg_sel));
  FDRE #(
    .INIT(1'b1)) 
    \r0_reg_sel_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .D(\r0_reg_sel[0]_i_1_n_0 ),
        .Q(\r0_reg_sel_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[10] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[9] ),
        .Q(\r0_reg_sel_reg_n_0_[10] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[11] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[10] ),
        .Q(\r0_reg_sel_reg_n_0_[11] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[12] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[11] ),
        .Q(\r0_reg_sel_reg_n_0_[12] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[13] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[12] ),
        .Q(\r0_reg_sel_reg_n_0_[13] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[14] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[13] ),
        .Q(\r0_reg_sel_reg_n_0_[14] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[15] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[14] ),
        .Q(\r0_reg_sel_reg_n_0_[15] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[16] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[15] ),
        .Q(\r0_reg_sel_reg_n_0_[16] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[17] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[16] ),
        .Q(\r0_reg_sel_reg_n_0_[17] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[18] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[17] ),
        .Q(\r0_reg_sel_reg_n_0_[18] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[19] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[18] ),
        .Q(\r0_reg_sel_reg_n_0_[19] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[1] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[0] ),
        .Q(\r0_reg_sel_reg_n_0_[1] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[20] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[19] ),
        .Q(\r0_reg_sel_reg_n_0_[20] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[21] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[20] ),
        .Q(\r0_reg_sel_reg_n_0_[21] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[22] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[21] ),
        .Q(\r0_reg_sel_reg_n_0_[22] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[23] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[22] ),
        .Q(\r0_reg_sel_reg_n_0_[23] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[24] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[23] ),
        .Q(\r0_reg_sel_reg_n_0_[24] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[25] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[24] ),
        .Q(\r0_reg_sel_reg_n_0_[25] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[26] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[25] ),
        .Q(\r0_reg_sel_reg_n_0_[26] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[27] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[26] ),
        .Q(\r0_reg_sel_reg_n_0_[27] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[28] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[27] ),
        .Q(\r0_reg_sel_reg_n_0_[28] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[29] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[28] ),
        .Q(\r0_reg_sel_reg_n_0_[29] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[2] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[1] ),
        .Q(\r0_reg_sel_reg_n_0_[2] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[30] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[29] ),
        .Q(\r0_reg_sel_reg_n_0_[30] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[31] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[30] ),
        .Q(p_1_in2_in),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[3] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[2] ),
        .Q(\r0_reg_sel_reg_n_0_[3] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[4] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[3] ),
        .Q(\r0_reg_sel_reg_n_0_[4] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[5] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[4] ),
        .Q(\r0_reg_sel_reg_n_0_[5] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[6] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[5] ),
        .Q(\r0_reg_sel_reg_n_0_[6] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[7] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[6] ),
        .Q(\r0_reg_sel_reg_n_0_[7] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[8] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[7] ),
        .Q(\r0_reg_sel_reg_n_0_[8] ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \r0_reg_sel_reg[9] 
       (.C(aclk),
        .CE(r0_reg_sel),
        .D(\r0_reg_sel_reg_n_0_[8] ),
        .Q(\r0_reg_sel_reg_n_0_[9] ),
        .R(p_0_in));
  LUT4 #(
    .INIT(16'h00E2)) 
    \state[0]_i_1 
       (.I0(\state_reg[0]_0 ),
        .I1(aclken),
        .I2(state),
        .I3(areset_r),
        .O(\state[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFCFCFFFC77FFFFFF)) 
    \state[0]_i_2 
       (.I0(r0_last),
        .I1(\state_reg_n_0_[2] ),
        .I2(m_axis_tready),
        .I3(\state_reg[0]_0 ),
        .I4(s_axis_tvalid),
        .I5(\state_reg[1]_0 ),
        .O(state));
  LUT6 #(
    .INIT(64'h00000000EEE222E2)) 
    \state[1]_i_1 
       (.I0(\state_reg[1]_0 ),
        .I1(aclken),
        .I2(\state[1]_i_2_n_0 ),
        .I3(\state_reg_n_0_[2] ),
        .I4(\state[1]_i_3_n_0 ),
        .I5(areset_r),
        .O(\state[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h74444444)) 
    \state[1]_i_2 
       (.I0(m_axis_tready),
        .I1(\state_reg[1]_0 ),
        .I2(s_axis_tvalid),
        .I3(p_1_in2_in),
        .I4(\state_reg[0]_0 ),
        .O(\state[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00000000CCC88888)) 
    \state[1]_i_3 
       (.I0(r0_last),
        .I1(\state_reg[0]_0 ),
        .I2(p_1_in2_in),
        .I3(\r0_reg_sel_reg_n_0_[30] ),
        .I4(s_axis_tvalid),
        .I5(\state_reg[1]_0 ),
        .O(\state[1]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h0000EA62)) 
    \state[2]_i_1 
       (.I0(\state_reg_n_0_[2] ),
        .I1(aclken),
        .I2(\state[2]_i_2_n_0 ),
        .I3(\state[2]_i_3_n_0 ),
        .I4(areset_r),
        .O(\state[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h8B008888)) 
    \state[2]_i_2 
       (.I0(m_axis_tready),
        .I1(\state_reg[1]_0 ),
        .I2(p_1_in2_in),
        .I3(s_axis_tvalid),
        .I4(\state_reg[0]_0 ),
        .O(\state[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000040000)) 
    \state[2]_i_3 
       (.I0(\state_reg[1]_0 ),
        .I1(s_axis_tvalid),
        .I2(p_1_in2_in),
        .I3(\r0_reg_sel_reg_n_0_[30] ),
        .I4(\state_reg[0]_0 ),
        .I5(r0_last),
        .O(\state[2]_i_3_n_0 ));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[0] 
       (.C(aclk),
        .CE(1'b1),
        .D(\state[0]_i_1_n_0 ),
        .Q(\state_reg[0]_0 ),
        .R(1'b0));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[1] 
       (.C(aclk),
        .CE(1'b1),
        .D(\state[1]_i_1_n_0 ),
        .Q(\state_reg[1]_0 ),
        .R(1'b0));
  (* FSM_ENCODING = "none" *) 
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[2] 
       (.C(aclk),
        .CE(1'b1),
        .D(\state[2]_i_1_n_0 ),
        .Q(\state_reg_n_0_[2] ),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
