# ----------------------------------------------------------------------------
# FILE: 	FT601_timing.sdc
# DESCRIPTION:	Constrains file for FT601 USB3.0 IC
# DATE:	July 17, 2017
# AUTHOR(s):	Lime Microsystems
# REVISIONS:
# ----------------------------------------------------------------------------
# NOTES:
# 
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
#Timing parameters
# ----------------------------------------------------------------------------
set FT_CLK_period			10.00

# ----------------------------------------------------------------------------
#Base clocks
# ----------------------------------------------------------------------------					
create_clock 	-name FT_CLK \
					-period $FT_CLK_period \
								[get_ports FT_CLK]
					
# ----------------------------------------------------------------------------
#Virtual clocks
# ----------------------------------------------------------------------------
create_clock 	-name FT_CLK_VIRT \
					-period $FT_CLK_period
					
# ----------------------------------------------------------------------------
#Input constraints
# ----------------------------------------------------------------------------
set_input_delay 	-max 7.0 \
						-clock 	[get_clocks FT_CLK] \
									[get_ports {FT_RXFn FT_TXEn}]
						
set_input_delay 	-max 7.0 \
						-clock 	[get_clocks FT_CLK] \
									[get_ports {FT_BE[*] FT_D[*]}]
						
set_input_delay 	-min 4.0 \
						-clock 	[get_clocks FT_CLK] \
									[get_ports {FT_RXFn FT_TXEn}] \
						-add_delay
						
set_input_delay 	-min 4.0 \
						-clock 	[get_clocks FT_CLK] \
									[get_ports {FT_BE[*] FT_D[*]}] \
						-add_delay

# ----------------------------------------------------------------------------
#Output constraints
# ----------------------------------------------------------------------------
set_output_delay 	-max 0.5 \
						-clock 	[get_clocks FT_CLK] \
									[get_ports FT_WRn] \
						-add_delay
                  
set_output_delay 	-min 0.5 \
						-clock 	[get_clocks FT_CLK] \
									[get_ports FT_WRn] \
						-add_delay
							
set_output_delay 	-max 0.5 \
						-clock 	[get_clocks FT_CLK]  \
									[get_ports {FT_BE[*] FT_D[*]}] \
						-add_delay  

set_output_delay 	-min 0.5 \
						-clock 	[get_clocks FT_CLK]  \
									[get_ports {FT_BE[*] FT_D[*]}] \
						-add_delay                   
# ----------------------------------------------------------------------------
#Exceptions
# ----------------------------------------------------------------------------

