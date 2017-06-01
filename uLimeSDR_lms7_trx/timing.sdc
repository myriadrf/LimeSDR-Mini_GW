#=======================Base clocks=====================================
create_clock -period "40MHz"		-name LMK_CLK 		[get_ports LMK_CLK]
create_clock -period "100MHz"		-name FT_CLK		[get_ports FT_CLK]


################################################################################
#Read periphery constraints files
################################################################################
read_sdc LMS7002_timing.sdc


################################################################################
#Virtual clocks
################################################################################
create_clock -name FT_CLK_VIRT				-period 10

#// Inputs
set_input_delay -clock [get_clocks FT_CLK] -max 7.0 [get_ports {FT_RXFn}]
set_input_delay -clock [get_clocks FT_CLK] -max 7.0  [get_ports {FT_BE[*] FT_D[*]}]
set_input_delay -clock [get_clocks FT_CLK] -min 4.0 [get_ports FT_RXFn] -add_delay
set_input_delay -clock [get_clocks FT_CLK] -min 4.0  [get_ports {FT_BE[*] FT_D[*]}] -add_delay

#// outputs
set_output_delay -clock [get_clocks FT_CLK]  -add_delay -max 0.5 [get_ports FT_WRn]
set_output_delay -clock [get_clocks FT_CLK]  -add_delay -max 0.5 [get_ports {FT_BE[*] FT_D[*]}]

#// multicycle paths
#set_false_path -from {fifo_mst_fsm:i_fifo_mst_fsm|tp_be_oe*} -to [get_ports {FT_D[*] FT_BE}]
#set_false_path -from {fifo_mst_fsm:i_fifo_mst_fsm|tp_dt_oe*} -to [get_ports {FT_D[*]}]

derive_clock_uncertainty

#====================Asyncronous clocks==========================================

# Set to be mutually exclusive clocks.
set_clock_groups -asynchronous 	-group {LMK_CLK} \
											-group {FT_CLK} \
											-group {LMS_MCLK2} \
											-group {TX_C0} \
											-group {TX_C1} \
											-group {RX_C2} \
											-group {RX_C3}
											
# Apply a 2ns max delay for an input port to an output port (TPD)
set_max_delay -from [get_ports LMS_MCLK2] -to [get_ports FPGA_GPIO0] 2.000

#Force fitter to make interconnect delays between nets  
set_net_delay -from [get_pins {inst11|inst53|combout}] -max 5
set_net_delay -from [get_pins {inst11|inst53|combout}] -min 4
set_net_delay -from [get_pins {inst11|inst52|combout}] -max 5
set_net_delay -from [get_pins {inst11|inst52|combout}] -min 4
											
#============================false paths========================================
#set false paths between low speed signals
# LED's
set_false_path -from * -to [get_ports FPGA_LED_* ]
set_false_path -from * -to [get_ports RFSW*]
set_false_path -from [get_ports SPARE_IO_PULL_UP*] -to *
