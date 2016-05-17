#=======================Base clocks=====================================
create_clock -period "30.72MHz"	-name LMK_CLK 		[get_ports LMK_CLK]
create_clock -period "100MHz"		-name FT_CLK		[get_ports FT_CLK]
create_clock -period "20MHz"		-name LMS_MCLK2	[get_ports LMS_MCLK2]


#// Inputs
set_input_delay -clock [get_clocks FT_CLK] -max 7.0 [get_ports {FT_RXFn}]
set_input_delay -clock [get_clocks FT_CLK] -max 7.0  [get_ports {FT_BE[*] FT_D[*]}]
set_input_delay -clock [get_clocks FT_CLK] -add_delay -min 4.0 [get_ports FT_RXFn]
set_input_delay -clock [get_clocks FT_CLK] -add_delay -min 4.0  [get_ports {FT_BE[*] FT_D[*]}]

#// outputs
set_output_delay -clock [get_clocks FT_CLK] -add_delay -max 0.5 [get_ports FT_WRn]
set_output_delay -clock [get_clocks FT_CLK] -add_delay -max 0.5 [get_ports {FT_BE[*] FT_D[*]}]

#// multicycle paths
#set_false_path -from {fifo_mst_fsm:i_fifo_mst_fsm|tp_be_oe*} -to [get_ports {FT_D[*] FT_BE}]
#set_false_path -from {fifo_mst_fsm:i_fifo_mst_fsm|tp_dt_oe*} -to [get_ports {FT_D[*]}]

derive_clock_uncertainty
derive_pll_clocks
