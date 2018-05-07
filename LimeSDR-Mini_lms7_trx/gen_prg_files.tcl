qexec "quartus_cpf -c ../LimeSDR-Mini_bitstreams/gen_pof_file.cof"
post_message "*******************************************************************"
post_message "Generated programming file: LimeSDR-Mini_lms7_trx_HW_1.2.pof" -submsgs [list "Output file saved in ../LimeSDR-Mini_bitstreams/ directory"]
post_message "*******************************************************************"
file copy -force -- output_files/LimeSDR-Mini_lms7_trx.sof ../LimeSDR-Mini_bitstreams/LimeSDR-Mini_lms7_trx_HW_1.2.sof