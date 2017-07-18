# ----------------------------------------------------------------------------
# FILE: 	Clock_groups.sdc
# DESCRIPTION:	Clock group exceptions
# DATE:	July 17, 2017
# AUTHOR(s):	Lime Microsystems
# REVISIONS:
# ----------------------------------------------------------------------------
# NOTES: This file must be last in .sdc file list
# 
# ----------------------------------------------------------------------------


# ----------------------------------------------------------------------------
#Exceptions
# ----------------------------------------------------------------------------
set_clock_groups 	-asynchronous \
						-group { LMK_CLK \
									FPGA_SPI_SCLK \
									FPGA_SPI_SCLK_out \
									DUAL_BOOT_CLK \
									ONCHIP_FLASH_CLK } \
						-group { FT_CLK } \
						-group { LMS_MCLK2 } \
						-group { LMS_MCLK2_5MHz LMS_FCLK1_DRCT LMS_FCLK2_DRCT} \
						-group { TX_C0 } \
						-group { TX_C1 LMS_FCLK1} \
						-group { RX_C2 } \
						-group { RX_C3 LMS_FCLK2}
						
set_false_path	 	-from [get_clocks LMS_MCLK2_VIRT_5MHz] \
						-to	[get_clocks RX_C3]
					
set_false_path	 	-from [get_clocks LMS_MCLK2] \
						-to	[get_clocks LMS_MCLK2]	
						
set_false_path	 	-from [get_clocks LMS_MCLK2_VIRT] \
						-to	[get_clocks LMS_MCLK2]
						
set_false_path	 	-from [get_clocks LMS_MCLK2] \
						-to	[get_clocks LMS_MCLK2_5MHz]

set_false_path	 	-from [get_clocks LMS_MCLK2_VIRT_5MHz] \
						-to	[get_clocks LMS_MCLK2]

set_false_path	 	-from [get_clocks LMS_MCLK2_VIRT] \
						-to	[get_clocks LMS_MCLK2_5MHz]						