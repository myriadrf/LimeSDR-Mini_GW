onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ft601_tb/FT601_inst0/clk
add wave -noupdate /ft601_tb/FT601_inst0/reset_n
add wave -noupdate /ft601_tb/FT601_inst0/trnsf_en
add wave -noupdate /ft601_tb/FT601_inst0/ready
add wave -noupdate /ft601_tb/FT601_inst0/rd_wr
add wave -noupdate /ft601_tb/FT601_inst0/ch_n
add wave -noupdate /ft601_tb/FT601_inst0/RD_data_valid
add wave -noupdate /ft601_tb/FT601_inst0/RD_data
add wave -noupdate /ft601_tb/FT601_inst0/WR_data_req
add wave -noupdate -radix hexadecimal /ft601_tb/FT601_inst0/WR_data
add wave -noupdate /ft601_tb/FT601_inst0/wr_n
add wave -noupdate /ft601_tb/FT601_inst0/rxf_n
add wave -noupdate -radix hexadecimal /ft601_tb/FT601_inst0/data
add wave -noupdate /ft601_tb/FT601_inst0/be
add wave -noupdate /ft601_tb/FT601_inst0/txe_n
add wave -noupdate /ft601_tb/FT601_inst0/current_state
add wave -noupdate /ft601_tb/FT601_inst0/master_is_writting
add wave -noupdate /ft601_tb/FT601_inst0/EP82_rd_end
add wave -noupdate /ft601_tb/FT601_inst0/EP83_rd_end
add wave -noupdate /ft601_tb/FT601_inst0/EP82_trnsf_end
add wave -noupdate /ft601_tb/FT601_inst0/EP83_trnsf_end
add wave -noupdate -radix unsigned /ft601_tb/FT601_inst0/term_cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {444143 ps} 0}
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
WaveRestoreZoom {0 ps} {1707452 ps}
