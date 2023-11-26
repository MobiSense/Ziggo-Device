// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Nov 28 19:51:26 2021
// Host        : Horace-TNS-win10 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top mult_1e9_gen_0 -prefix
//               mult_1e9_gen_0_ mult_1e9_gen_0_sim_netlist.v
// Design      : mult_1e9_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_1e9_gen_0,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module mult_1e9_gen_0
   (A,
    P);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [31:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [63:0]P;

  wire \<const0> ;
  wire [31:0]A;
  wire [63:9]\^P ;
  wire [8:0]NLW_U0_P_UNCONNECTED;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  assign P[63:9] = \^P [63:9];
  assign P[8] = \<const0> ;
  assign P[7] = \<const0> ;
  assign P[6] = \<const0> ;
  assign P[5] = \<const0> ;
  assign P[4] = \<const0> ;
  assign P[3] = \<const0> ;
  assign P[2] = \<const0> ;
  assign P[1] = \<const0> ;
  assign P[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_B_TYPE = "1" *) 
  (* C_B_VALUE = "111011100110101100101000000000" *) 
  (* C_B_WIDTH = "30" *) 
  (* C_CCM_IMP = "2" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "0" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "2" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "63" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_1e9_gen_0_mult_gen_v12_0_16 U0
       (.A(A),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CE(1'b1),
        .CLK(1'b1),
        .P({\^P ,NLW_U0_P_UNCONNECTED[8:0]}),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "32" *) (* C_B_TYPE = "1" *) 
(* C_B_VALUE = "111011100110101100101000000000" *) (* C_B_WIDTH = "30" *) (* C_CCM_IMP = "2" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "0" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "2" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "63" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "zynq" *) (* downgradeipidentifiedwarnings = "yes" *) 
module mult_1e9_gen_0_mult_gen_v12_0_16
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [31:0]A;
  input [29:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [63:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire [31:0]A;
  wire [63:9]\^P ;
  wire [8:0]NLW_i_mult_P_UNCONNECTED;
  wire [47:0]NLW_i_mult_PCASC_UNCONNECTED;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

  assign P[63:9] = \^P [63:9];
  assign P[8] = \<const0> ;
  assign P[7] = \<const0> ;
  assign P[6] = \<const0> ;
  assign P[5] = \<const0> ;
  assign P[4] = \<const0> ;
  assign P[3] = \<const0> ;
  assign P[2] = \<const0> ;
  assign P[1] = \<const0> ;
  assign P[0] = \<const0> ;
  assign PCASC[47] = \<const0> ;
  assign PCASC[46] = \<const0> ;
  assign PCASC[45] = \<const0> ;
  assign PCASC[44] = \<const0> ;
  assign PCASC[43] = \<const0> ;
  assign PCASC[42] = \<const0> ;
  assign PCASC[41] = \<const0> ;
  assign PCASC[40] = \<const0> ;
  assign PCASC[39] = \<const0> ;
  assign PCASC[38] = \<const0> ;
  assign PCASC[37] = \<const0> ;
  assign PCASC[36] = \<const0> ;
  assign PCASC[35] = \<const0> ;
  assign PCASC[34] = \<const0> ;
  assign PCASC[33] = \<const0> ;
  assign PCASC[32] = \<const0> ;
  assign PCASC[31] = \<const0> ;
  assign PCASC[30] = \<const0> ;
  assign PCASC[29] = \<const0> ;
  assign PCASC[28] = \<const0> ;
  assign PCASC[27] = \<const0> ;
  assign PCASC[26] = \<const0> ;
  assign PCASC[25] = \<const0> ;
  assign PCASC[24] = \<const0> ;
  assign PCASC[23] = \<const0> ;
  assign PCASC[22] = \<const0> ;
  assign PCASC[21] = \<const0> ;
  assign PCASC[20] = \<const0> ;
  assign PCASC[19] = \<const0> ;
  assign PCASC[18] = \<const0> ;
  assign PCASC[17] = \<const0> ;
  assign PCASC[16] = \<const0> ;
  assign PCASC[15] = \<const0> ;
  assign PCASC[14] = \<const0> ;
  assign PCASC[13] = \<const0> ;
  assign PCASC[12] = \<const0> ;
  assign PCASC[11] = \<const0> ;
  assign PCASC[10] = \<const0> ;
  assign PCASC[9] = \<const0> ;
  assign PCASC[8] = \<const0> ;
  assign PCASC[7] = \<const0> ;
  assign PCASC[6] = \<const0> ;
  assign PCASC[5] = \<const0> ;
  assign PCASC[4] = \<const0> ;
  assign PCASC[3] = \<const0> ;
  assign PCASC[2] = \<const0> ;
  assign PCASC[1] = \<const0> ;
  assign PCASC[0] = \<const0> ;
  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_B_TYPE = "1" *) 
  (* C_B_VALUE = "111011100110101100101000000000" *) 
  (* C_B_WIDTH = "30" *) 
  (* C_CCM_IMP = "2" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "0" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "2" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "63" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_1e9_gen_0_mult_gen_v12_0_16_viv i_mult
       (.A(A),
        .B({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CE(1'b0),
        .CLK(1'b1),
        .P({\^P ,NLW_i_mult_P_UNCONNECTED[8:0]}),
        .PCASC(NLW_i_mult_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
ZqI7Lq/aGyAcoaejBEIk07VX9jYIkvdeTPQu9dSbDEADopcPNa+0k8THWemULZmXocovtHBV2sQ+
UG9Mr3L0hg==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
R4vPs+jPUBq40hDi8U6b9avbUk2Eb50U4A+mDDli/Y0olyqpMjS2bHK8VDjTVAFuQ+H3qih0cQYm
+ik1m47VLNMfNDfRLbftE2okRK8Kx81MRcEafr+7z29VxyL2KSwmOKbcDCEkIT1VX5y+96x7q9/g
O5zX1cVuj6hrFncQjBI=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
RHGRLed4zRtfx3HaMZFysMR3Ua1JohlSUQn/uIq0QNaCK2P96ztDgqQoqe6ZQ11betfsHTRFzq/1
66ClFz6QxXME/fh2KrrXSgUZxYxwfstEZlyOThrSfu+qzCsdk0R654q7wyvVT8+Lni3RuXc5nFXx
raCVZl6qLm50r3EadUq562wDBW7iVkrMp3OgccKyJyw39sT1Jc+0IkzHuHqjKA44tfGTOOSTHNUj
YgsyeZCJS72pabS90ZfprHyjsELB7Bxw/M9/XLEV7l1LP+SCDJFvOP5dNLZDBmwYIJ5OoU7247Tk
wYu3m6ZFZNnTwWGI9SAZJyiXILRa8hVZPL9TSA==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
OU7rNiePgxinwm/ruLBNeniAmTTLdwPhOZ1i35IGtDWXtaPoMnsPLRF6vnJo1xeYUES1MIlBqaG4
FUeyfrnBl3ofk5rfTbxL16dBcEtA8Z/duJARcLCIBD/J+xf2VlSqIo8dG9Ww8/L9pBTHpNAObSOU
o17xArTTrLfHWXZRGfRwuRpGlTLTYOMvS1AGhQcPbXjHrlijOoz3XigDVsnyGbHfkSgOlGBCnyDS
TPebi8IC8YIl88ieW+lqTL6jl+3DZ55iTfCJKbFt/HrE1Uou1l+60xI/9h9XhrNzE5ANic5eFmyC
tdncsHEBtx+UfZhyFrHV8z72yZoLCX2rOJ+IJA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
GUoHfgebfwQKNkw122kR1rRfB4ZFf7/0xjFIvV3auOQ9RcZO2jgecvvtUAn3nocoMNPW1jFFZW0u
xgkVDSrwVJrMR/obpu7gqo1n1FD2E5BpOJV2Gwso9aZGhgTdfd0mINfCxPi4lxUYuTw1vd+iNkBH
peC7j2xzDHSu6o2S58c=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lW3oa+bS7VSdBch0q4Lk4kIel2MxeXNlqo+JkBKYCThE5vtBv3Mob32tRj6s2h8BAos9XGsKRu0r
zWpu3cgAnv8lYIL4/UPBP9T+caGqWHHoGULrLn4zuybUvPzfGPj+ANXGfPXBomTO48UgPFWBnBA2
3vlOjCiOyKLMQAUrg8RqpfdYfcnwHxk8ebrE+lZJf6NCQtrqGu/EnH7PYFH/8MSQa6yey02fLQ2J
HenzdGNam7fu3z20gETHgePuewowRrJu5bEZOzlor2RrSnb0hcSbcO4/KSA9EcbmjzBMjE5uRYAM
1y+0t4rNGr+0XAjpp8m6B8lGF+m1jIGYMJ55eQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
AYjoOGO5c2rCxRUY5RbgjfKwpMKJQrCDGPu9wzqv2ZhoT9Trod7xJlCnzNNU4kNJPTgmDf05Bkoo
EvR1hgWeTmTgCGdy7Qci0Z0L3pdxnOg9i69qsJO1qAW46sOYPeZHpvATo3irsreTIyOEcblYRdLh
Raj2T02eEhljrx1UdWXHwIq6kJGwbPaiMRXRJewJ75w53lF3nNUwTYgttUbm/hKuK4MTBvyDWlHF
UReBw5kEbERTaRF91+HNJUeoBgfLIgVhtPzX3Yzqy4fl1PxZ0BzAGNRQWfLI4TBSyl64znmxdzaS
+wcpSJ3OHZL4sBSIwGqpZ8UuNr53DWWwkd5lqw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
F93W5rP9wRsskpVAtvm9VhlFJY5TOuivcFKT2bVYmeqxn925TMU0N0nDRJZmC+O7NbtC0kbL9Hfv
iPaQAjkvtWKCEafU216A83pjNwYVINq3GbStXAtCrvf3KbYJMQPnr6FzKWLa0RlmEqf2z1LRIJMY
cR3LKzziLGgP+oQLz6W3siXeoyqxsbDm+dasSbu2YxzGAvkTos4kX2slGrQzxYSQogS6j/MzVgIk
Vhsm3BYDbtVT5TsiHGfRfi137tS2Q9o11KN44GT+JYigwORe+GyKi5xjI6kGPl1N1DK12TlRGsgC
Wq2YWMn2ABYXE2F8mkwPOJqSaaAR0S5MMCjkaQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
EO2KlFB8vWgjeXvua8SEZL2APl0WfdPtqoF/0VTjBDZhkKh8T7GBS9tSSrCin7kHRBUGF6hOUPK2
V0JQtp4yW7c3oVbMN2ePIV7UdtkAszA2lMqOqeKJbWn0TfxRWL5adG+jGlhhYEbaT6tkCGPbbtbk
y5Kew5kT3RyGP8Rb0tim3cGvqi2BdBxqdc5Sb+Vyj0havZUyZo1AsjuLnNukDIYIrPCtqOY22MTp
VlNOr/u23OIMx+xx7Z4aOvZacPCxfg662ljyHetf5a0wu31WI6zf/69lkXq1iWJtHgEJn2iDpIWs
bSWDEtGgKAFHGKVAoc0vIGP3aPG6DIsqRyQ90Q==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
H+OmX3ZKPQ2y3pjtWwjiwJ2BrUVuEEKMzrj+X21fugexX/BiM+c7PwIIieLi6tiWfRWKhtPV1rI+
HQKJY8/PFOjjlJ+hXzSDgenbT6XO5elzjeNf6wngpeXd3amMo7lzZgkJmb2kYoaYR5FLeET068b7
desX3ZZQolXvwY7Yww4hewjjNRMEQ9zLSOJkCc0T3Gg+ssALt62/ZMgqu95F28jyaJn56WDtKSGz
bTrQ+Gi4umHmd14Ao0xGwJDIwPlofg9UEHJ4I5C60ID4IUMmTJmUFpvX1LbXbfgdjEc9FlDjUgzb
CR3hH9U4s0daKsVLP2Ir5wLhY4r12U6SjYMyyQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
imrLM+qcsPPLcYwR4gpbt7tx5naEmZSr2fhAsKYk7glG7R0N6CXX6bqokOSKIWFZe3ceueZqd86d
30oMk6biHs/IDOe4DtwkjCkRA3UIz2bka++ZHoeKuGNFPzq6HJXVY05FjPNih0Tvtc0unN0EZxdG
4We2wwWIWrnX6yXte5COC4CWu1Rff6diJCJ+sRYftT8JsVvATGD9udfAcykJEwtii8mIvXvjaWdp
Ey4wBdgXEuP1PHWNv124CnYiwLJB6brLwNiz4aDIUG1GOAzTD27mKIn3a0rWidyLo1TFo2f1+A7X
gsSUjsOqGTaEBRG9G461M4KrSBoh+NCfFmQb2g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20080)
`pragma protect data_block
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
u6ZbqRXsba0petPK1jFuoQ==
`pragma protect end_protected
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
