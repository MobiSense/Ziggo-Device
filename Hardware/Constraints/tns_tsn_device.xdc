# PART is zynq xc7z020clg484

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP [current_design]

set_property PACKAGE_PIN A17 [get_ports glbl_rstn]
set_property IOSTANDARD LVCMOS33 [get_ports glbl_rstn]
set_false_path -from [get_ports glbl_rstn]

set_property PACKAGE_PIN Y9 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]

set_property PACKAGE_PIN L19 [get_ports {phy_resetn[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {phy_resetn[0]}]

set_property PACKAGE_PIN T16 [get_ports {phy_resetn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {phy_resetn[1]}]

set_property PACKAGE_PIN AA14 [get_ports {phy_resetn[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {phy_resetn[2]}]

set_property PACKAGE_PIN V19 [get_ports {phy_resetn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {phy_resetn[3]}]

set_property PACKAGE_PIN J17 [get_ports {mdc[0]}]
set_property PACKAGE_PIN J16 [get_ports {mdio[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {mdc[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mdio[0]}]

set_property PACKAGE_PIN M20 [get_ports {mdc[1]}]
set_property PACKAGE_PIN T17 [get_ports {mdio[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {mdc[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mdio[1]}]

set_property PACKAGE_PIN Y16 [get_ports {mdc[2]}]
set_property PACKAGE_PIN Y14 [get_ports {mdio[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {mdc[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mdio[2]}]

set_property PACKAGE_PIN Y18 [get_ports {mdc[3]}]
set_property PACKAGE_PIN AA18 [get_ports {mdio[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {mdc[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {mdio[3]}]

set_property PACKAGE_PIN K19 [get_ports {rgmii_rxc[0]}]
set_property PACKAGE_PIN K20 [get_ports {rgmii_rx_ctl[0]}]
set_property PACKAGE_PIN J18 [get_ports {rgmii_rxd_flat[0]}]
set_property PACKAGE_PIN K18 [get_ports {rgmii_rxd_flat[1]}]
set_property PACKAGE_PIN J15 [get_ports {rgmii_rxd_flat[2]}]
set_property PACKAGE_PIN K15 [get_ports {rgmii_rxd_flat[3]}]
set_property PACKAGE_PIN R21 [get_ports {rgmii_txc[0]}]
set_property PACKAGE_PIN R20 [get_ports {rgmii_tx_ctl[0]}]
set_property PACKAGE_PIN N17 [get_ports {rgmii_txd_flat[0]}]
set_property PACKAGE_PIN N18 [get_ports {rgmii_txd_flat[1]}]
set_property PACKAGE_PIN N19 [get_ports {rgmii_txd_flat[2]}]
set_property PACKAGE_PIN N20 [get_ports {rgmii_txd_flat[3]}]


set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxc[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rx_ctl[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txc[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_tx_ctl[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[3]}]

set_property PACKAGE_PIN M19 [get_ports {rgmii_rxc[1]}]
set_property PACKAGE_PIN P17 [get_ports {rgmii_rx_ctl[1]}]
set_property PACKAGE_PIN P18 [get_ports {rgmii_rxd_flat[4]}]
set_property PACKAGE_PIN P22 [get_ports {rgmii_rxd_flat[5]}]
set_property PACKAGE_PIN N22 [get_ports {rgmii_rxd_flat[6]}]
set_property PACKAGE_PIN M21 [get_ports {rgmii_rxd_flat[7]}]
set_property PACKAGE_PIN K16 [get_ports {rgmii_txc[1]}]
set_property PACKAGE_PIN M22 [get_ports {rgmii_tx_ctl[1]}]
set_property PACKAGE_PIN L18 [get_ports {rgmii_txd_flat[4]}]
set_property PACKAGE_PIN L22 [get_ports {rgmii_txd_flat[5]}]
set_property PACKAGE_PIN L21 [get_ports {rgmii_txd_flat[6]}]
set_property PACKAGE_PIN L16 [get_ports {rgmii_txd_flat[7]}]


set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxc[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rx_ctl[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txc[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_tx_ctl[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[7]}]

set_property PACKAGE_PIN W16 [get_ports {rgmii_rxc[2]}]
set_property PACKAGE_PIN U15 [get_ports {rgmii_rx_ctl[2]}]
set_property PACKAGE_PIN U16 [get_ports {rgmii_rxd_flat[8]}]
set_property PACKAGE_PIN V14 [get_ports {rgmii_rxd_flat[9]}]
set_property PACKAGE_PIN V15 [get_ports {rgmii_rxd_flat[10]}]
set_property PACKAGE_PIN AB22 [get_ports {rgmii_rxd_flat[11]}]
set_property PACKAGE_PIN AA17 [get_ports {rgmii_txc[2]}]
set_property PACKAGE_PIN AA22 [get_ports {rgmii_tx_ctl[2]}]
set_property PACKAGE_PIN V18 [get_ports {rgmii_txd_flat[8]}]
set_property PACKAGE_PIN U17 [get_ports {rgmii_txd_flat[9]}]
set_property PACKAGE_PIN V17 [get_ports {rgmii_txd_flat[10]}]
set_property PACKAGE_PIN AB17 [get_ports {rgmii_txd_flat[11]}]


set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxc[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rx_ctl[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txc[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_tx_ctl[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[11]}]

set_property PACKAGE_PIN W17 [get_ports {rgmii_rxc[3]}]
set_property PACKAGE_PIN W18 [get_ports {rgmii_rx_ctl[3]}]
set_property PACKAGE_PIN AB16 [get_ports {rgmii_rxd_flat[12]}]
set_property PACKAGE_PIN AA16 [get_ports {rgmii_rxd_flat[13]}]
set_property PACKAGE_PIN Y15 [get_ports {rgmii_rxd_flat[14]}]
set_property PACKAGE_PIN W15 [get_ports {rgmii_rxd_flat[15]}]
set_property PACKAGE_PIN AB15 [get_ports {rgmii_txc[3]}]
set_property PACKAGE_PIN AB14 [get_ports {rgmii_tx_ctl[3]}]
set_property PACKAGE_PIN V13 [get_ports {rgmii_txd_flat[12]}]
set_property PACKAGE_PIN W13 [get_ports {rgmii_txd_flat[13]}]
set_property PACKAGE_PIN Y13 [get_ports {rgmii_txd_flat[14]}]
set_property PACKAGE_PIN AA13 [get_ports {rgmii_txd_flat[15]}]


set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxc[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rx_ctl[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rxd_flat[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txc[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_tx_ctl[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_txd_flat[15]}]

set_clock_groups -logically_exclusive -group [get_clocks -of [get_pins zynq_ps_i/s_axi_time_sync_clk]] -group [get_clocks -of [get_pins clk_wiz_0_i/clk125]]

# The ps clock (clk_fpga_0) and pl clock (clk_wiz_0_i/clk125) should be exclusive by default. Our logic can already handle this.
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks clk_fpga_0] -group [get_clocks -of [get_pins clk_wiz_0_i/clk125]]

set _xlnx_shared_i0 [get_cells -hier -filter {name =~*tsu_axis_rx_i/parser*}]
set_multicycle_path -setup -end -from $_xlnx_shared_i0 -to $_xlnx_shared_i0 4
set_multicycle_path -hold -end -from $_xlnx_shared_i0 -to $_xlnx_shared_i0 3

set _xlnx_shared_i1 [get_cells -hier -filter {name =~*tsu_axis_tx_i/parser*}]
set_multicycle_path -setup -end -from $_xlnx_shared_i1 -to $_xlnx_shared_i1 4
set_multicycle_path -hold -end -from $_xlnx_shared_i1 -to $_xlnx_shared_i1 3

set_output_delay -clock [get_clocks -of [get_pins clk_wiz_0_i/clk100]] 1.000 [get_ports {mdc[*]}]

set_false_path -from [get_cells -hier -filter {name =~ *phy_resetn_int_reg}] -to [get_cells -hier -filter {name =~ *axi_lite_reset_gen/reset_sync*}]

############################################################
# Ignore paths to resync flops
############################################################
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ PRE} -of [get_cells -hier -regexp {.*\/reset_sync.*}]]
set_false_path -to [get_pins -filter {REF_PIN_NAME =~ D} -of [get_cells -regexp {.*\/.*_sync.*}]]

############################################################
# FIFO Clock Crossing Constraints                          #
############################################################

# control signal is synched separately so this is a false path
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *rx_fifo/rd_addr_reg[*]}] -to [get_cells -hier -filter {name =~ *fifo*wr_rd_addr_reg[*]}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *rx_fifo/wr_store_frame_tog_reg}] -to [get_cells -hier -filter {name =~ *fifo/resync_wr_store_frame_tog/data_sync_reg0}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *rx_fifo/update_addr_tog_reg}] -to [get_cells -hier -filter {name =~ *rx_fifo/sync_rd_addr_tog/data_sync_reg0}] 3.200

set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_legacy/rd_addr_txfer_reg[*]}] -to [get_cells -hier -filter {name =~ *fifo*wr_rd_addr_reg[*]}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_legacy/wr_frame_in_fifo_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_legacy/resync_wr_frame_in_fifo/data_sync_reg0}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_legacy/wr_frames_in_fifo_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_legacy/resync_wr_frames_in_fifo/data_sync_reg0}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_legacy/frame_in_fifo_valid_tog_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_legacy/resync_fif_valid_tog/data_sync_reg0}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_legacy/rd_txfer_tog_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_legacy/resync_rd_txfer_tog/data_sync_reg0}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_legacy/rd_tran_frame_tog_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_legacy/resync_rd_tran_frame_tog/data_sync_reg0}] 3.200

set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_bv/rd_addr_txfer_reg[*]}] -to [get_cells -hier -filter {name =~ *fifo*wr_rd_addr_reg[*]}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_bv/wr_frame_in_fifo_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_bv/resync_wr_frame_in_fifo/data_sync_reg0}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_bv/wr_frames_in_fifo_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_bv/resync_wr_frames_in_fifo/data_sync_reg0}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_bv/frame_in_fifo_valid_tog_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_bv/resync_fif_valid_tog/data_sync_reg0}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_bv/rd_txfer_tog_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_bv/resync_rd_txfer_tog/data_sync_reg0}] 3.200
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_bv/rd_tran_frame_tog_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_bv/resync_rd_tran_frame_tog/data_sync_reg0}] 3.200

set_power_opt -exclude_cells [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ *.bram.* }]











############################################################
# Hardware Debug Core                                      #
############################################################














connect_debug_port u_ila_1/probe22 [get_nets [list axis_it_checker_ins/is_header]]




connect_debug_port dbg_hub/clk [get_nets rx_mac_aclk_0]






