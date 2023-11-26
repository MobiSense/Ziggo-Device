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
	assign 			tx_offset[{:d}]\t\t\t= {{slv_reg{:d}, slv_reg{:d}}};\n\n\
    "
    with open("gen_reg_mapping.txt", "w") as f:
        for i in range(0,32):
            f.write(template.format(i,i,i,i,i,
                i, 9*i+10, 9*i+9, 9*i+8, 9*i+7,
                i, 9*i+11,
                i, 9*i+11,
                i, 9*i+12,
                i, 9*i+13,
                i, 9*i+15, 9*i+14))


if __name__ == "__main__":
    gen_reg_mapping()