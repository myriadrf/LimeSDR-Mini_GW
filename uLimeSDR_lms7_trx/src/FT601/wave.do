onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/clk
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/reset_n
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/enable
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/fsm_epgo
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/fsm_rdwr
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/fsm_ch
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/fsm_rdy
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/fsm_datavalid
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/fsm_rddata
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/fsm_wrdata
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/ep_status
add wave -noupdate -expand -group arbiter /ft601_top_tb/FT601_top_inst0/ftdi_arbiter/current_state
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/clk
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/reset_n
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/trnsf_en
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/ready
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/rd_wr
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/ch_n
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/valid_data
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/RD_data
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/WR_data
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/wr_n
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/rxf_n
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/data
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/be
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/txe_n
add wave -noupdate -expand -group fsm /ft601_top_tb/FT601_top_inst0/ft_fsm/current_state
add wave -noupdate -expand -group EP82 /ft601_top_tb/FT601_top_inst0/EP02_fifo/data
add wave -noupdate -expand -group EP82 /ft601_top_tb/FT601_top_inst0/EP02_fifo/wrreq
add wave -noupdate -expand -group EP83 /ft601_top_tb/FT601_top_inst0/EP82_fifo/rdclk
add wave -noupdate -expand -group EP83 /ft601_top_tb/FT601_top_inst0/EP82_fifo/rdreq
add wave -noupdate -expand -group EP83 /ft601_top_tb/FT601_top_inst0/EP82_fifo/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {553208 ps} 0}
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
WaveRestoreZoom {388762 ps} {713458 ps}
