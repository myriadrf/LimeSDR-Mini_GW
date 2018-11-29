# ----------------------------------------------------------------------------
# FILE: 	timing.sdc
# DESCRIPTION:	
# DATE:	June 2, 2017
# AUTHOR(s):	Lime Microsystems
# REVISIONS:
# ----------------------------------------------------------------------------
# NOTES:
# 
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Timing parameters
# ----------------------------------------------------------------------------
set LMK_CLK_period  		25.00

# ----------------------------------------------------------------------------
# Base clocks
# ----------------------------------------------------------------------------
create_clock	-name LMK_CLK \
					-period 	$LMK_CLK_period \
								[get_ports LMK_CLK]

# ----------------------------------------------------------------------------
# Virtual clocks
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
# Altera specific constrains
# ----------------------------------------------------------------------------
derive_clock_uncertainty

# ----------------------------------------------------------------------------
# Generated clocks
# ----------------------------------------------------------------------------
#NIOS spi
create_generated_clock 	-name FPGA_SPI_SCLK \
								-source 	[get_ports {LMK_CLK}] \
								-divide_by 4 \
											[get_registers *nios_cpu*|*dac_spi*|SCLK_reg]
                                 
create_generated_clock 	-name FPGA_SPI_SCLK_FPGA \
								-source 	[get_ports {LMK_CLK}] \
								-divide_by 4 \
											[get_registers *nios_cpu*|*fpga_spi*|SCLK_reg]

create_generated_clock 	-name FPGA_SPI_SCLK_out \
								-source 	[get_registers *nios_cpu*|*dac_spi*|SCLK_reg] \
											[get_ports FPGA_SPI_SCLK]


create_generated_clock 	-name DUAL_BOOT_CLK \
								-source 	[get_ports {LMK_CLK}] \
											[get_registers *nios_cpu*|*alt_dual_boot*|ru_clk]

create_generated_clock 	-name ONCHIP_FLASH_CLK \
								-source 	[get_ports {LMK_CLK}] \
								-divide_by 4 \
											[get_registers *nios_cpu*|*altera_onchip*|flash_se_neg_reg]
# ----------------------------------------------------------------------------
# Input constraints
# ----------------------------------------------------------------------------
#NIOS SPI0
#To overcontrain inputs setup time only for fitter by 10%
if {$::quartus(nameofexecutable) ne "quartus_sta"} {
	set_input_delay 	-max 20.9 \
							-clock_fall \
							-clock 	[get_clocks FPGA_SPI_SCLK_out] \
										[get_ports {FPGA_SPI_MISO}]
							
	set_input_delay 	-min 16.2 \
							-clock_fall \
							-clock 	[get_clocks FPGA_SPI_SCLK_out] \
										[get_ports {FPGA_SPI_MISO}]
} else {
	set_input_delay 	-max 19.0 \
							-clock_fall \
							-clock 	[get_clocks FPGA_SPI_SCLK_out] \
										[get_ports {FPGA_SPI_MISO}] 
	set_input_delay 	-min 16.2 \
							-clock_fall \
							-clock [get_clocks FPGA_SPI_SCLK_out] \
							[get_ports {FPGA_SPI_MISO}] 
}


# ----------------------------------------------------------------------------
# Output constraints
# ----------------------------------------------------------------------------
set_output_delay 	-max 15 \
						-clock 	[get_clocks FPGA_SPI_SCLK_out] \
									[get_ports {FPGA_SPI_MOSI FPGA_SPI_DAC_SS FPGA_SPI_LMS_SS}]
									
set_output_delay 	-min -15 \
						-clock 	[get_clocks FPGA_SPI_SCLK_out] \
									[get_ports {FPGA_SPI_MOSI FPGA_SPI_DAC_SS FPGA_SPI_LMS_SS}]
									
									
# ----------------------------------------------------------------------------
# IO interface exceptions
# ----------------------------------------------------------------------------
set_multicycle_path 	-setup \
							-end \
							-from [get_clocks {FPGA_SPI_SCLK_out}] \
							-to 	[get_clocks {LMK_CLK}] \
									2
							
set_multicycle_path 	-hold \
							-end \
							-from [get_clocks {FPGA_SPI_SCLK_out}] \
							-to 	[get_clocks {LMK_CLK}] \
									3

set_multicycle_path 	-setup \
							-start \
							-from [get_clocks LMK_CLK] \
							-to 	[get_clocks FPGA_SPI_SCLK_out] \
									2
									
set_multicycle_path 	-hold \
							-start \
							-from [get_clocks LMK_CLK] \
							-to 	[get_clocks FPGA_SPI_SCLK_out] \
									3
										
# ----------------------------------------------------------------------------
# NIOS constrains
# ----------------------------------------------------------------------------
# JTAG Signal Constraints constrain the TCK port											
create_clock 	-period 10MHz {altera_reserved_tck}
# Cut all paths to and from tck
set_clock_groups 	-asynchronous -group {altera_reserved_tck}											
# Constrain the TDI port
set_input_delay -clock altera_reserved_tck -clock_fall .1 [get_ports altera_reserved_tdi]
# Constrain the TMS port
set_input_delay -clock altera_reserved_tck -clock_fall .1 [get_ports altera_reserved_tms]
# Constrain the TDO port
set_output_delay -clock altera_reserved_tck -clock_fall .1 [get_ports altera_reserved_tdo]
											
# ----------------------------------------------------------------------------
# Exceptions
# ----------------------------------------------------------------------------
#Force fitter to make interconnect delays between nets  
set_net_delay 	-max 5.1 \
					-from [get_pins -compatibility_mode *pll_top*|*lcell*|combout*] 
set_net_delay 	-min 4 \
					-from [get_pins -compatibility_mode *pll_top*|*lcell*|combout*]

#For synchronizer chain in design (sync_reg and bus_sync_reg)
set_false_path -to [get_keepers *sync_reg[0]*]
set_false_path -to [get_keepers *sync_reg0[*]*]

set_false_path -to [get_ports FPGA_SPI_SCLK]

#set false paths between low speed signals
#Inputs
set_false_path -from [get_ports FPGA_GPIO[*] ]
set_false_path -from [get_ports LM75_OS]
set_false_path -from [get_ports FPGA_I2C_SCL]
set_false_path -from [get_ports FPGA_I2C_SDA]

#Outputs
set_false_path -to [get_ports FPGA_LED_* ]
set_false_path -to [get_ports FPGA_GPIO[*] ]
set_false_path -to [get_ports FPGA_I2C_SCL]
set_false_path -to [get_ports FPGA_I2C_SDA]
set_false_path -to [get_ports LMS_CORE_LDO_EN]
set_false_path -to [get_ports LMS_RESET]
set_false_path -to [get_ports LMS_RXEN]
set_false_path -to [get_ports LMS_TXEN]
set_false_path -to [get_ports LMS_TXNRX1]
set_false_path -to [get_ports LMS_TXNRX2]
