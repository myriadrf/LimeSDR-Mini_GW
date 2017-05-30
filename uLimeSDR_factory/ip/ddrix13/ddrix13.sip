set_global_assignment -entity "ddrix13" -library "lib_ddrix13" -name IP_TOOL_NAME "altera_gpio_lite"
set_global_assignment -entity "ddrix13" -library "lib_ddrix13" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "ddrix13" -library "lib_ddrix13" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_ddrix13" -name SPD_FILE [file join $::quartus(sip_path) "ddrix13.spd"]

set_global_assignment -library "lib_ddrix13" -name MISC_FILE [file join $::quartus(sip_path) "ddrix13_sim/ddrix13.vhd"]
set_global_assignment -library "lib_ddrix13" -name MISC_FILE [file join $::quartus(sip_path) "ddrix13_sim/altera_gpio_lite/altera_gpio_lite.sv"]
set_global_assignment -library "lib_ddrix13" -name MISC_FILE [file join $::quartus(sip_path) "ddrix13_sim/altera_gpio_lite/mentor/altera_gpio_lite.sv"]
