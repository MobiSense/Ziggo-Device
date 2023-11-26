
############################################################
# Obtain input clocks from top level XDC                   #
############################################################
set ip_gtx_clk     [get_clocks -of_objects [get_ports gtx_clk]]


#
####
#######
##########
#############
#################
#BLOCK CONSTRAINTS

############################################################
# Crossing of Clock Domain Constraints: please do not edit #
############################################################

# set a false path for the IPIF
set_max_delay -from [get_cells {axi4_lite_ipif/axi4_lite_ipif_top_wrapper/axi_lite_top/*/bus2ip_addr_i_reg[*]}] -to $ip_gtx_clk 6 -datapath_only

# set a false path for the static config registers
set_false_path -from [get_cells {tri_mode_ethernet_mac_2_core/*managen/conf/int_*reg[*]}] -to $ip_gtx_clk
set_false_path -from [get_cells {tri_mode_ethernet_mac_2_core/*managen/conf/int_*reg}] -to $ip_gtx_clk


