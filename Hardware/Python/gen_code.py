'''
    Simple Python script to generate code samples in pkt_gen_controller
'''

def gen_reg_mapping():
    template = "\
// sequence {:d}\n\
    assign          valid[{:d}]\t\t\t= slv_reg4[{:d}];\n\
    assign          enable_vlan[{:d}]\t\t\t= slv_reg5[{:d}];\n\
	assign 			pkt_hdr[{:d}]\t\t\t= {{slv_reg{:d}, slv_reg{:d}, slv_reg{:d}, slv_reg{:d}}};\n\
	assign 			seq_id[{:d}]\t\t\t= slv_reg{:d}[15:0];\n\
    assign 			pkt_number_sent[{:d}]\t\t\t= slv_reg{:d}[31:16];\n\
	assign 			pkt_id_start[{:d}]\t\t\t= slv_reg{:d};\n\
	assign 			pkt_id_update[{:d}]\t\t\t= slv_reg{:d};\n\
    assign 			pkt_size[{:d}]\t\t\t= slv_reg{:d};\n\
	assign 			tx_offset[{:d}]\t\t\t= {{slv_reg{:d}, slv_reg{:d}}};\n\n\
    "
    with open("gen_reg_mapping.txt", "w") as f:
        for i in range(0,32):
            f.write(template.format(i,i,i,i,i,
                i, 10*i+10, 10*i+9, 10*i+8, 10*i+7,
                i, 10*i+11,
                i, 10*i+11,
                i, 10*i+12,
                i, 10*i+13,
                i, 10*i+14,
                i, 10*i+16, 10*i+15))


if __name__ == "__main__":
    gen_reg_mapping()