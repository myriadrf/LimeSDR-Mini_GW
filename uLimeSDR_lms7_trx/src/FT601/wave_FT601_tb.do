onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {EP02_fifo PC to FPGA} /ft601_top_tb/FT601_top_inst0/EP02_fifo/wrclk
add wave -noupdate -group {EP02_fifo PC to FPGA} /ft601_top_tb/FT601_top_inst0/EP02_fifo/wrreq
add wave -noupdate -group {EP02_fifo PC to FPGA} /ft601_top_tb/FT601_top_inst0/EP02_fifo/data
add wave -noupdate -group {EP02_fifo PC to FPGA} /ft601_top_tb/FT601_top_inst0/EP02_fifo/rdclk
add wave -noupdate -group {EP02_fifo PC to FPGA} /ft601_top_tb/FT601_top_inst0/EP02_fifo/rdreq
add wave -noupdate -group {EP02_fifo PC to FPGA} /ft601_top_tb/FT601_top_inst0/EP02_fifo/q
add wave -noupdate -group {EP02_fifo PC to FPGA} /ft601_top_tb/FT601_top_inst0/EP02_fifo/rdempty
add wave -noupdate -group {EP02_fifo PC to FPGA} /ft601_top_tb/FT601_top_inst0/EP02_fifo/aclr
add wave -noupdate -expand -group {EP82 FPGA to PC } /ft601_top_tb/FT601_top_inst0/EP82_fifo/wrclk
add wave -noupdate -expand -group {EP82 FPGA to PC } /ft601_top_tb/FT601_top_inst0/EP82_fifo/wrreq
add wave -noupdate -expand -group {EP82 FPGA to PC } -radix hexadecimal /ft601_top_tb/FT601_top_inst0/EP82_fifo/data
add wave -noupdate -expand -group {EP82 FPGA to PC } /ft601_top_tb/FT601_top_inst0/EP82_fifo/wrempty
add wave -noupdate -expand -group {EP82 FPGA to PC } /ft601_top_tb/FT601_top_inst0/EP82_fifo/rdclk
add wave -noupdate -expand -group {EP82 FPGA to PC } /ft601_top_tb/FT601_top_inst0/EP82_fifo/rdreq
add wave -noupdate -expand -group {EP82 FPGA to PC } -radix hexadecimal /ft601_top_tb/FT601_top_inst0/EP82_fifo/q
add wave -noupdate -expand -group {EP82 FPGA to PC } /ft601_top_tb/FT601_top_inst0/EP82_fifo/rdempty
add wave -noupdate -expand -group {EP82 FPGA to PC } /ft601_top_tb/FT601_top_inst0/EP82_fifo/aclr
add wave -noupdate -expand -group {FT601 interface} /ft601_top_tb/FT601_top_inst0/ft_fsm/clk
add wave -noupdate -expand -group {FT601 interface} /ft601_top_tb/FT601_top_inst0/ft_fsm/reset_n
add wave -noupdate -expand -group {FT601 interface} /ft601_top_tb/FT601_top_inst0/ft_fsm/wr_n
add wave -noupdate -expand -group {FT601 interface} /ft601_top_tb/FT601_top_inst0/ft_fsm/rxf_n
add wave -noupdate -expand -group {FT601 interface} /ft601_top_tb/FT601_top_inst0/ft_fsm/data
add wave -noupdate -expand -group {FT601 interface} /ft601_top_tb/FT601_top_inst0/ft_fsm/be
add wave -noupdate -expand -group {FT601 interface} /ft601_top_tb/FT601_top_inst0/ft_fsm/txe_n
add wave -noupdate -expand -group {FT601 interface} /ft601_top_tb/FT601_top_inst0/ft_fsm/current_state
add wave -noupdate /ft601_top_tb/FT601_top_inst0/ft_fsm/WR_data_req
add wave -noupdate -radix hexadecimal /ft601_top_tb/FT601_top_inst0/ft_fsm/WR_data
add wave -noupdate /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/ep_priority
add wave -noupdate /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/fsm_wrdata
add wave -noupdate /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/EP82_fifo_data
add wave -noupdate /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/EP83_fifo_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {254643 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {998786 ps}
