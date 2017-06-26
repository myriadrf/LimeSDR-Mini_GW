#=======================Base clocks=====================================
create_clock -period "40MHz"		-name LMK_CLK 		[get_ports LMK_CLK]
create_clock -period "100MHz"		-name FT_CLK		[get_ports FT_CLK]


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

#NIOS spi
create_generated_clock 	-name FPGA_SPI_SCLK \
								-source [get_ports {LMK_CLK}] \
								-divide_by 2 \
								[get_registers {nios_cpu:inst10|lms_ctr:u0|lms_ctr_dac_spi:dac_spi|SCLK_reg}]

create_generated_clock 	-name FPGA_SPI_SCLK_out \
								-source [get_registers {get_registers {nios_cpu:inst10|lms_ctr:u0|lms_ctr_dac_spi:dac_spi|SCLK_reg}}] \
								[get_ports FPGA_SPI_SCLK]


create_generated_clock 	-name DUAL_BOOT_CLK \
								-source [get_ports {LMK_CLK}] \
								[get_registers {nios_cpu:inst10|lms_ctr:u0|altera_dual_boot:dual_boot_0|alt_dual_boot_avmm:alt_dual_boot_avmm_comp|alt_dual_boot:alt_dual_boot|ru_clk}]

create_generated_clock 	-name ONCHIP_FLASH_CLK \
								-source [get_ports {LMK_CLK}] \
								-divide_by 2 \
								[get_registers {nios_cpu:inst10|lms_ctr:u0|altera_onchip_flash:onchip_flash_0|altera_onchip_flash_avmm_data_controller:avmm_data_controller|flash_se_neg_reg}]

#NIOS SPI0
#To overcontrain inputs setup time only for fitter by 10%
if {$::quartus(nameofexecutable) ne "quartus_sta"} {
	set_input_delay -clock [get_clocks FPGA_SPI_SCLK_out] -max 20.9 [get_ports {FPGA_SPI_MISO}] -clock_fall
	set_input_delay -clock [get_clocks FPGA_SPI_SCLK_out] -min 16.2 [get_ports {FPGA_SPI_MISO}] -clock_fall
} else {
	set_input_delay -clock [get_clocks FPGA_SPI_SCLK_out] -max 19.0 [get_ports {FPGA_SPI_MISO}] -clock_fall
	set_input_delay -clock [get_clocks FPGA_SPI_SCLK_out] -min 16.2 [get_ports {FPGA_SPI_MISO}] -clock_fall
}

set_output_delay -clock [get_clocks FPGA_SPI_SCLK_out] -max 15 [get_ports {FPGA_SPI_MOSI FPGA_SPI_DAC_SS FPGA_SPI_LMS_SS}] 
set_output_delay -clock [get_clocks FPGA_SPI_SCLK_out] -min -15 [get_ports {FPGA_SPI_MOSI FPGA_SPI_DAC_SS FPGA_SPI_LMS_SS}]

set_multicycle_path -setup -end -from [get_clocks {FPGA_SPI_SCLK_out}] -to [get_clocks {LMK_CLK}] [expr 1]
set_multicycle_path -hold -end -from [get_clocks {FPGA_SPI_SCLK_out}] -to [get_clocks {LMK_CLK}] [expr 1]

set_multicycle_path -setup -start -from [get_clocks LMK_CLK] -to [get_clocks FPGA_SPI_SCLK_out] 1
set_multicycle_path -hold -start -from [get_clocks LMK_CLK] -to [get_clocks FPGA_SPI_SCLK_out] 1

set_false_path -to [get_ports FPGA_SPI_SCLK]

#====================Asyncronous clocks==========================================

# Set to be mutually exclusive clocks.
set_clock_groups -asynchronous 	-group {LMK_CLK FPGA_SPI_SCLK FPGA_SPI_SCLK_out DUAL_BOOT_CLK ONCHIP_FLASH_CLK} \
											-group {FT_CLK} \
											-group {LMS_MCLK2} \
											-group {TX_C0 LMS_FCLK1} \
											-group {TX_C1} \
											-group {RX_C2 LMS_FCLK2} \
											-group {RX_C3}
											

#Force fitter to make interconnect delays between nets  
set_net_delay -from [get_pins {inst11|inst53|combout}] -max 5
set_net_delay -from [get_pins {inst11|inst53|combout}] -min 4
set_net_delay -from [get_pins {inst11|inst52|combout}] -max 5
set_net_delay -from [get_pins {inst11|inst52|combout}] -min 4

################################################################################
#NIOS constraints
################################################################################
# JTAG Signal Constraints constrain the TCK port											
create_clock -period 10MHz {altera_reserved_tck}
# Cut all paths to and from tck
set_clock_groups -asynchronous -group {altera_reserved_tck}											
# Constrain the TDI port
set_input_delay -clock altera_reserved_tck -clock_fall .1 [get_ports altera_reserved_tdi]
# Constrain the TMS port
set_input_delay -clock altera_reserved_tck -clock_fall .1 [get_ports altera_reserved_tms]
# Constrain the TDO port
set_output_delay -clock altera_reserved_tck -clock_fall .1 [get_ports altera_reserved_tdo]
											
#============================false paths========================================

#For synchronizer chain in design (sync_reg and bus_sync_reg)
set_false_path -to [get_keepers *sync_reg[0]*]
set_false_path -to [get_keepers *sync_reg0[*]*]

#set false paths between low speed signals
# LED's
set_false_path -from * -to [get_ports FPGA_LED_* ]
set_false_path -from [get_ports FPGA_GPIO[*] ]
set_false_path -from [get_ports SPARE_IO_PULL_UP*] -to *
set_false_path -from [get_ports LM75_OS]

set_false_path -from [get_ports FPGA_I2C_SCL]
set_false_path -from [get_ports FPGA_I2C_SDA]



set_false_path -to [get_ports FPGA_GPIO[*] ]
set_false_path -to [get_ports FPGA_I2C_SCL]
set_false_path -to [get_ports FPGA_I2C_SDA]
set_false_path -to [get_ports LMS_CORE_LDO_EN]
set_false_path -to [get_ports LMS_RESET]
set_false_path -to [get_ports LMS_RXEN]
set_false_path -to [get_ports LMS_TXEN]
set_false_path -to [get_ports LMS_TXNRX1]
set_false_path -to [get_ports LMS_TXNRX2]
