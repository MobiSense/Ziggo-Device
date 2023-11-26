'''
    Simple Python script to generate code samples in pkt_gen_controller
'''

def gen_reg_mapping():
    template = "reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg{};\n"
    with open("gen_reg_define.txt", "w") as f:
        for i in range(300, 350):
            f.write(template.format(i))

def gen_reg_eq():
    template = "\t\t  slv_reg{} <= 0;\n"
    with open("gen_reg_eq.txt", "w") as f:
        for i in range(300, 350):
            f.write(template.format(i))

def gen_reg_self():
    template = "\t\t\t\t\t\t  slv_reg{} <= slv_reg{};\n"
    with open("gen_reg_self.txt", "w") as f:
        for i in range(300, 350):
            f.write(template.format(i, i))    

def gen_complate():
    template = "\
	          9'h{}:\n\
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )\n\
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin\n\
	                // Respective byte enables are asserted as per write strobes\n\
	                // Slave register {} \n\
	                slv_reg{}[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];\n \
	              end \n\
    "
    with open("gen_reg_complate.txt", "w") as f:
        for i in range(300, 350):
            f.write(template.format(hex(i)[2:], i, i))    

def gen_reg_eqeq():
    template = "\t\t\t9'h{}   : reg_data_out <= slv_reg{};\n"
    with open("gen_reg_eqeq.txt", "w") as f:
        for i in range(300, 350):
            f.write(template.format(hex(i)[2:], i))    

if __name__ == "__main__":
    gen_reg_eqeq()