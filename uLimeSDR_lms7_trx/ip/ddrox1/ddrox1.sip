set_global_assignment -entity "ddrox1" -library "lib_ddrox1" -name IP_TOOL_NAME "altera_gpio_lite"
set_global_assignment -entity "ddrox1" -library "lib_ddrox1" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "ddrox1" -library "lib_ddrox1" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_ddrox1" -name SPD_FILE [file join $::quartus(sip_path) "ddrox1.spd"]

set_global_assignment -library "lib_ddrox1" -name MISC_FILE [file join $::quartus(sip_path) "ddrox1_sim/ddrox1.vhd"]
set_global_assignment -library "lib_ddrox1" -name MISC_FILE [file join $::quartus(sip_path) "ddrox1_sim/altera_gpio_lite/altera_gpio_lite.sv"]
set_global_assignment -library "lib_ddrox1" -name MISC_FILE [file join $::quartus(sip_path) "ddrox1_sim/altera_gpio_lite/mentor/altera_gpio_lite.sv"]
