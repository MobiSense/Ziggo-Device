set_clock_groups -logically_exclusive -group [get_clocks -of [get_pins rtc_clk]] -group [get_clocks -of [get_pins s00_axi_aclk]]
