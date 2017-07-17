################################################################################
#Timing parameters
################################################################################
#LMS7002
	#LMS_MCLK2 period
set LMS_MCLK1_period  		6.25
set LMS_MCLK2_period			6.25
	#Setup and hold times from datasheet
set LMS_LMS7_Tsu				1.20
set LMS_LMS7_Th				1.00

	#Measured Tco_min and Tco_max values
set LMS_Tco_max				1.00
set LMS_Tco_min				2.90

	#Tco based
set LMS7_IN_MAX_DELAY [expr $LMS_Tco_max]
set LMS7_IN_MIN_DELAY [expr $LMS_Tco_min]

################################################################################
#Base clocks
################################################################################
create_clock -period $LMS_MCLK2_period 			-name LMS_MCLK2 			[get_ports LMS_MCLK2]


################################################################################
#Virtual clocks
################################################################################
create_clock -name LMS_MCLK2_VIRT			-period $LMS_MCLK2_period
################################################################################
#Generated clocks
################################################################################

#LMS TX PLL
create_generated_clock 	-name  TX_C0 \
								-source [get_pins inst11|inst5|altpll_component|auto_generated|pll1|inclk[0]] \
								-phase 0 [get_pins inst11|inst5|altpll_component|auto_generated|pll1|clk[0]]
								
create_generated_clock 	-name   TX_C1 \
								-source [get_pins inst11|inst5|altpll_component|auto_generated|pll1|inclk[0]] \
								-phase 90 [get_pins inst11|inst5|altpll_component|auto_generated|pll1|clk[1]]
								
create_generated_clock 	-name   RX_C2 \
								-source [get_pins inst11|inst5|altpll_component|auto_generated|pll1|inclk[0]] \
								-phase 0 [get_pins inst11|inst5|altpll_component|auto_generated|pll1|clk[2]]

create_generated_clock 	-name   RX_C3 \
								-source [get_pins inst11|inst5|altpll_component|auto_generated|pll1|inclk[0]] \
								-phase 90 [get_pins inst11|inst5|altpll_component|auto_generated|pll1|clk[3]]
								
#LMS1_FCLK1 clock output pin 
create_generated_clock 	-name LMS_FCLK1 \
								-master [get_clocks TX_C0] \
								-source [get_pins {inst11|inst6|ddrox1_inst|gpio_one_bit.i_loop[0].altgpio_bit_i|out_path_ddr.fr_out_data_ddio|dataout}] \
								[get_ports LMS_FCLK1]
								
create_generated_clock 	-name LMS_FCLK1_DRCT \
								-master [get_clocks LMS_MCLK2] \
								-source [get_pins {inst11|inst6|ddrox1_inst|gpio_one_bit.i_loop[0].altgpio_bit_i|out_path_ddr.fr_out_data_ddio|dataout}] \
								[get_ports LMS_FCLK1] -add
								
#LMS_FCLK2 clock 							
create_generated_clock 	-name LMS_FCLK2 \
								-master [get_clocks RX_C2] \
								-source [get_pins {inst11|inst7|ddrox1_inst|gpio_one_bit.i_loop[0].altgpio_bit_i|out_path_ddr.fr_out_data_ddio|dataout}] \
								[get_ports {LMS_FCLK2}]
								
################################################################################
#Input constraints
################################################################################
#LMS1 when MCLK2 is 160MHz
set_input_delay	-max $LMS7_IN_MAX_DELAY \
						-clock [get_clocks LMS_MCLK2_VIRT] [get_ports {LMS_DIQ2_D[*] LMS_ENABLE_IQSEL2}]
						
set_input_delay	-min $LMS7_IN_MIN_DELAY \
						-clock [get_clocks LMS_MCLK2_VIRT] [get_ports {LMS_DIQ2_D[*] LMS_ENABLE_IQSEL2}]
						
set_input_delay	-max $LMS7_IN_MAX_DELAY \
						-clock [get_clocks LMS_MCLK2_VIRT] \
						-clock_fall [get_ports {LMS_DIQ2_D[*] LMS_ENABLE_IQSEL2}] -add_delay
												
set_input_delay	-min $LMS7_IN_MIN_DELAY \
						-clock [get_clocks LMS_MCLK2_VIRT] \
						-clock_fall [get_ports {LMS_DIQ2_D[*] LMS_ENABLE_IQSEL2}] -add_delay
						
################################################################################
#Output constraints
################################################################################
				
set_output_delay	-max $LMS_LMS7_Tsu \
						-clock [get_clocks LMS_FCLK1] [get_ports {LMS_DIQ1[*] LMS_ENABLE_IQSEL1}]
						
set_output_delay	-min -$LMS_LMS7_Th \
						-clock [get_clocks LMS_FCLK1] [get_ports {LMS_DIQ1[*] LMS_ENABLE_IQSEL1}]						
						
set_output_delay	-max $LMS_LMS7_Tsu \
						-clock [get_clocks LMS_FCLK1] \
						-clock_fall [get_ports { LMS_DIQ1[*] LMS_ENABLE_IQSEL1}] -add_delay
											
set_output_delay	-min -$LMS_LMS7_Th \
						-clock [get_clocks LMS_FCLK1] \
						-clock_fall [get_ports {LMS_DIQ1[*] LMS_ENABLE_IQSEL1}] -add_delay
						
						
#set_output_delay	-max 0 \
#						-clock [get_clocks LMS_FCLK1_DRCT] [get_ports {LMS_DIQ1[*] LMS_ENABLE_IQSEL1}] -add_delay
#						
#set_output_delay	-min 0 \
#						-clock [get_clocks LMS_FCLK1_DRCT] [get_ports {LMS_DIQ1[*] LMS_ENABLE_IQSEL1}] -add_delay						
#						
#set_output_delay	-max 0 \
#						-clock [get_clocks LMS_FCLK1_DRCT] \
#						-clock_fall [get_ports { LMS_DIQ1[*] LMS_ENABLE_IQSEL1}] -add_delay
#											
#set_output_delay	-min 0 \
#						-clock [get_clocks LMS_FCLK1_DRCT] \
#						-clock_fall [get_ports {LMS_DIQ1[*] LMS_ENABLE_IQSEL1}] -add_delay

################################################################################
#Exceptions
################################################################################
#Between Center aligned different edge transfers in DIQ2 interface (when sampling with PLL phase shifted clock >5MHz)
#set_false_path -setup 	-rise_from 	[get_clocks LMS_MCLK2_VIRT] -fall_to \
#												[get_clocks RX_PLLCLK_C1]
#set_false_path -setup 	-fall_from 	[get_clocks LMS_MCLK2_VIRT] -rise_to \
#												[get_clocks RX_PLLCLK_C1]
#set_false_path -hold 	-rise_from 	[get_clocks LMS_MCLK2_VIRT] -rise_to \
#												[get_clocks RX_PLLCLK_C1]
#set_false_path -hold 	-fall_from 	[get_clocks LMS_MCLK2_VIRT] -fall_to \
#												[get_clocks RX_PLLCLK_C1]	
												
#Between Edge aligned same edge transfers in DIQ2 interface (When sampling with direct LMS_MCLK2 clock <5MHz)
set_false_path -setup 	-fall_from 	[get_clocks LMS_MCLK2_VIRT] -rise_to \
												[get_clocks RX_C3]
set_false_path -setup 	-rise_from 	[get_clocks LMS_MCLK2_VIRT] -fall_to \
												[get_clocks RX_C3]
set_false_path -hold 	-rise_from 	[get_clocks LMS_MCLK2_VIRT] -rise_to \
												[get_clocks RX_C3]
set_false_path -hold 	-fall_from 	[get_clocks LMS_MCLK2_VIRT] -fall_to \
												[get_clocks RX_C3]
											
												
set_false_path -setup 	-rise_from 	[get_clocks LMS_MCLK2_VIRT] -rise_to \
												[get_clocks LMS_MCLK2]
set_false_path -setup 	-fall_from 	[get_clocks LMS_MCLK2_VIRT] -fall_to \
												[get_clocks LMS_MCLK2]
set_false_path -hold 	-rise_from 	[get_clocks LMS_MCLK2_VIRT] -fall_to \
												[get_clocks LMS_MCLK2]
set_false_path -hold 	-fall_from 	[get_clocks LMS_MCLK2_VIRT] -rise_to \
												[get_clocks LMS_MCLK2]
												
#set_multicycle_path -hold -end -from [get_clocks {LMS_MCLK2_VIRT}] -to [get_clocks {RX_C3}] [expr -1]

#Between Center aligned same edge transfers in DIQ1 interface
set_false_path -setup 	-rise_from 	[get_clocks TX_C1] -rise_to \
												[get_clocks LMS_FCLK1]
set_false_path -setup 	-fall_from 	[get_clocks TX_C1] -fall_to \
												[get_clocks LMS_FCLK1]
set_false_path -hold 	-rise_from 	[get_clocks TX_C1] -fall_to \
												[get_clocks LMS_FCLK1]
set_false_path -hold 	-fall_from 	[get_clocks TX_C1] -rise_to \
												[get_clocks LMS_FCLK1]
												
#Between Center aligned same edge transfers in DIQ1 interface (When MCLK2 <5MHz)
set_false_path -setup 	-rise_from 	[get_clocks LMS_MCLK2] -rise_to \
												[get_clocks LMS_FCLK1_DRCT]
set_false_path -setup 	-fall_from 	[get_clocks LMS_MCLK2] -fall_to \
												[get_clocks LMS_FCLK1_DRCT]
set_false_path -hold 	-rise_from 	[get_clocks LMS_MCLK2] -fall_to \
												[get_clocks LMS_FCLK1_DRCT]
set_false_path -hold 	-fall_from 	[get_clocks LMS_MCLK2] -rise_to \
												[get_clocks LMS_FCLK1_DRCT]

#Clock groups					
#Other clock groups are set in top .sdc file
set_clock_groups -exclusive 	-group {LMS_FCLK1} \
										-group {LMS_FCLK1_DRCT}
#										
#set_clock_groups -exclusive 	-group {LMS_MCLK1} \
#										-group {LMS_MCLK1_5MHZ}
#										
#set_clock_groups -exclusive 	-group {LMS_MCLK2} \
#										-group {LMS_MCLK2_5MHZ}
										
#False Path between PLL output and clock output ports LMS2_FCLK1 an LMS2_FCLK2
set_false_path -to [get_ports LMS_FCLK*]	
#False path between unrelated clock transfers
#There ar no paths between 160MHZ LMS_MCLK2_VIRT and LMS_MCLK2 
#set_false_path -from [get_clocks LMS_MCLK2_VIRT] 	-to [get_clocks LMS_MCLK2]
##To cut paths for TX interface clock mux
#set_false_path -from [get_clocks {LMS_MCLK1}] 		-to [get_clocks {LMS_FCLK1_PLL}]
#set_false_path -from [get_clocks {LMS_MCLK1}] 		-to [get_clocks {LMS_FCLK1_DRCT}]
#set_false_path -from [get_clocks {TX_PLLCLK_C1}] 	-to [get_clocks {LMS_FCLK1_DRCT}]
#set_false_path -from [get_clocks {LMS_MCLK1_5MHZ}] -to [get_clocks {LMS_FCLK1_PLL}]


