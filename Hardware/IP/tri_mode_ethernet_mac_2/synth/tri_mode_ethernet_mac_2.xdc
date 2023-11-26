
# PART is zynq xc7z020clg484

############################################################
# Clock Period Constraints                                 #
############################################################

#
####
#######
##########
#############
#################
#BLOCK CONSTRAINTS

############################################################
# None
############################################################


#
####
#######
##########
#############
#################
#CORE CONSTRAINTS



############################################################
# Crossing of Clock Domain Constraints: please do not edit #
############################################################




# false path due to synced control path
set_max_delay -from [get_cells {tri_mode_ethernet_mac_2_core/*statistics_counters/rd_data_ref_reg[*]}] -to [get_cells {tri_mode_ethernet_mac_2_core/*statistics_counters/ip2bus_data_reg[*]}] 6 -datapath_only
set_max_delay -from [get_cells {tri_mode_ethernet_mac_2_core/*statistics_counters/response_toggle_reg}] -to [get_cells {tri_mode_ethernet_mac_2_core/*statistics_counters/sync_response/data_sync_reg0}] 6 -datapath_only
set_max_delay -from [get_cells {tri_mode_ethernet_mac_2_core/*statistics_counters/request_toggle_reg}] -to [get_cells {tri_mode_ethernet_mac_2_core/*statistics_counters/sync_request/data_sync_reg0}] 6 -datapath_only


############################################################
# Ignore paths to resync flops
############################################################
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ PRE} -of [get_cells -hier -regexp {.*\/async_rst.*}]]
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ CLR} -of [get_cells -hier -regexp {.*\/async_rst.*}]]

set_max_delay -from [get_cells {tri_mode_ethernet_mac_2_core/addr_filter_top/addr_regs.promiscuous_mode_reg_reg}] -to [get_cells {tri_mode_ethernet_mac_2_core/addr_filter_top/address_filter_inst/resync_promiscuous_mode/data_sync_reg0}] 6 -datapath_only
set_max_delay -from [get_cells {tri_mode_ethernet_mac_2_core/*managen/conf/update_pause_ad_int_reg}] -to [get_cells {tri_mode_ethernet_mac_2_core/addr_filter_top/address_filter_inst/sync_update/data_sync_reg0}] 6 -datapath_only


