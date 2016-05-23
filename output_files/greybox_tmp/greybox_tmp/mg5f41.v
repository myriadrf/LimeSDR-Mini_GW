//dcfifo ADD_USEDW_MSB_BIT="ON" CBX_SINGLE_OUTPUT_FILE="ON" INTENDED_DEVICE_FAMILY=""MAX 10"" LPM_NUMWORDS=256 LPM_SHOWAHEAD="OFF" LPM_TYPE="dcfifo_mixed_widths" LPM_WIDTH=12 LPM_WIDTHU=9 OVERFLOW_CHECKING="ON" RDSYNC_DELAYPIPE=4 READ_ACLR_SYNCH="OFF" UNDERFLOW_CHECKING="ON" USE_EAB="ON" WRITE_ACLR_SYNCH="OFF" WRSYNC_DELAYPIPE=4 aclr data q rdclk rdempty rdreq rdusedw wrclk wrfull wrreq wrusedw
//VERSION_BEGIN 15.1 cbx_mgl 2016:02:01:19:07:00:SJ cbx_stratixii 2016:02:01:19:05:00:SJ cbx_util_mgl 2016:02:01:19:04:59:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, the Altera Quartus Prime License Agreement,
//  the Altera MegaCore Function License Agreement, or other 
//  applicable license agreement, including, without limitation, 
//  that your use is for the sole purpose of programming logic 
//  devices manufactured by Altera and sold by Altera or its 
//  authorized distributors.  Please refer to the applicable 
//  agreement for further details.



//synthesis_resources = dcfifo 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mg5f41
	( 
	aclr,
	data,
	q,
	rdclk,
	rdempty,
	rdreq,
	rdusedw,
	wrclk,
	wrfull,
	wrreq,
	wrusedw) /* synthesis synthesis_clearbox=1 */;
	input   aclr;
	input   [11:0]  data;
	output   [11:0]  q;
	input   rdclk;
	output   rdempty;
	input   rdreq;
	output   [8:0]  rdusedw;
	input   wrclk;
	output   wrfull;
	input   wrreq;
	output   [8:0]  wrusedw;

	wire  [11:0]   wire_mgl_prim1_q;
	wire  wire_mgl_prim1_rdempty;
	wire  [8:0]   wire_mgl_prim1_rdusedw;
	wire  wire_mgl_prim1_wrfull;
	wire  [8:0]   wire_mgl_prim1_wrusedw;

	dcfifo   mgl_prim1
	( 
	.aclr(aclr),
	.data(data),
	.q(wire_mgl_prim1_q),
	.rdclk(rdclk),
	.rdempty(wire_mgl_prim1_rdempty),
	.rdreq(rdreq),
	.rdusedw(wire_mgl_prim1_rdusedw),
	.wrclk(wrclk),
	.wrfull(wire_mgl_prim1_wrfull),
	.wrreq(wrreq),
	.wrusedw(wire_mgl_prim1_wrusedw));
	defparam
		mgl_prim1.add_usedw_msb_bit = "ON",
		mgl_prim1.intended_device_family = ""MAX 10"",
		mgl_prim1.lpm_numwords = 256,
		mgl_prim1.lpm_showahead = "OFF",
		mgl_prim1.lpm_type = "dcfifo_mixed_widths",
		mgl_prim1.lpm_width = 12,
		mgl_prim1.lpm_widthu = 9,
		mgl_prim1.overflow_checking = "ON",
		mgl_prim1.rdsync_delaypipe = 4,
		mgl_prim1.read_aclr_synch = "OFF",
		mgl_prim1.underflow_checking = "ON",
		mgl_prim1.use_eab = "ON",
		mgl_prim1.write_aclr_synch = "OFF",
		mgl_prim1.wrsync_delaypipe = 4;
	assign
		q = wire_mgl_prim1_q,
		rdempty = wire_mgl_prim1_rdempty,
		rdusedw = wire_mgl_prim1_rdusedw,
		wrfull = wire_mgl_prim1_wrfull,
		wrusedw = wire_mgl_prim1_wrusedw;
endmodule //mg5f41
//VALID FILE
