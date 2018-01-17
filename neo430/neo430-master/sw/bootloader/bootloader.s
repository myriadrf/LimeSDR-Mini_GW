
main.elf:     file format elf32-msp430


Disassembly of section .image:

0000f000 <__boot_crt0>:
    f000:	11 42 e8 ff 	mov	&0xffe8,r1	;0xffe8
    f004:	11 52 ea ff 	add	&0xffea,r1	;0xffea
    f008:	b4 3d       	jmp	$+874    	;abs 0xf372

0000f00a <uart_putc>:
    f00a:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    f00e:	3d 40 a0 ff 	mov	#65440,	r13	;#0xffa0

0000f012 <.L2>:
    f012:	bd b2 00 00 	bit	#8,	0(r13)	;r2 As==11
    f016:	fd 23       	jnz	$-4      	;abs 0xf012
    f018:	82 4c a4 ff 	mov	r12,	&0xffa4	;
    f01c:	30 41       	ret			

0000f01e <uart_br_print>:
    f01e:	0a 12       	push	r10		;
    f020:	09 12       	push	r9		;
    f022:	08 12       	push	r8		;
    f024:	07 12       	push	r7		;
    f026:	09 4c       	mov	r12,	r9	;
    f028:	38 40 0a f0 	mov	#61450,	r8	;#0xf00a
    f02c:	77 40 0d 00 	mov.b	#13,	r7	;#0x000d

0000f030 <.L5>:
    f030:	6a 49       	mov.b	@r9,	r10	;
    f032:	0a 93       	cmp	#0,	r10	;r3 As==00
    f034:	02 20       	jnz	$+6      	;abs 0xf03a
    f036:	30 40 8e f5 	br	#0xf58e		;

0000f03a <.L7>:
    f03a:	3a 90 0a 00 	cmp	#10,	r10	;#0x000a
    f03e:	02 20       	jnz	$+6      	;abs 0xf044
    f040:	4c 47       	mov.b	r7,	r12	;
    f042:	88 12       	call	r8		;

0000f044 <.L6>:
    f044:	4c 4a       	mov.b	r10,	r12	;
    f046:	88 12       	call	r8		;
    f048:	19 53       	inc	r9		;
    f04a:	30 40 30 f0 	br	#0xf030		;

0000f04e <wishbone_read32>:
    f04e:	b2 40 0f 00 	mov	#15,	&0xff90	;#0x000f
    f052:	90 ff 
    f054:	0e 4c       	mov	r12,	r14	;
    f056:	3e f0 fc ff 	and	#65532,	r14	;#0xfffc
    f05a:	82 4e 92 ff 	mov	r14,	&0xff92	;
    f05e:	82 4d 94 ff 	mov	r13,	&0xff94	;
    f062:	3d 40 90 ff 	mov	#65424,	r13	;#0xff90

0000f066 <.L9>:
    f066:	2c 4d       	mov	@r13,	r12	;
    f068:	0c 93       	cmp	#0,	r12	;r3 As==00
    f06a:	fd 3b       	jl	$-4      	;abs 0xf066
    f06c:	1c 42 9a ff 	mov	&0xff9a,r12	;0xff9a
    f070:	1d 42 9c ff 	mov	&0xff9c,r13	;0xff9c
    f074:	30 41       	ret			

0000f076 <wishbone_write32>:
    f076:	b2 40 0f 00 	mov	#15,	&0xff90	;#0x000f
    f07a:	90 ff 
    f07c:	82 4e 9a ff 	mov	r14,	&0xff9a	;
    f080:	82 4f 9c ff 	mov	r15,	&0xff9c	;
    f084:	0e 4c       	mov	r12,	r14	;
    f086:	3e f0 fc ff 	and	#65532,	r14	;#0xfffc
    f08a:	82 4e 96 ff 	mov	r14,	&0xff96	;
    f08e:	82 4d 98 ff 	mov	r13,	&0xff98	;
    f092:	3d 40 90 ff 	mov	#65424,	r13	;#0xff90

0000f096 <.L12>:
    f096:	2c 4d       	mov	@r13,	r12	;
    f098:	0c 93       	cmp	#0,	r12	;r3 As==00
    f09a:	fd 3b       	jl	$-4      	;abs 0xf096
    f09c:	30 41       	ret			

0000f09e <start_app>:
    f09e:	0a 12       	push	r10		;
    f0a0:	1c 42 fa ff 	mov	&0xfffa,r12	;0xfffa
    f0a4:	3a 40 1e f0 	mov	#61470,	r10	;#0xf01e
    f0a8:	0c 93       	cmp	#0,	r12	;r3 As==00
    f0aa:	0d 24       	jz	$+28     	;abs 0xf0c6

0000f0ac <.L19>:
    f0ac:	32 40 00 40 	mov	#16384,	r2	;#0x4000
    f0b0:	3c 40 4c f6 	mov	#63052,	r12	;#0xf64c
    f0b4:	8a 12       	call	r10		;
    f0b6:	3c 40 a0 ff 	mov	#65440,	r12	;#0xffa0

0000f0ba <.L16>:
    f0ba:	bc b2 00 00 	bit	#8,	0(r12)	;r2 As==11
    f0be:	fd 23       	jnz	$-4      	;abs 0xf0ba

0000f0c0 <.L20>:
    f0c0:	00 43       	clr	r0		;
    f0c2:	30 40 c0 f0 	br	#0xf0c0		;

0000f0c6 <.L15>:
    f0c6:	3c 40 59 f6 	mov	#63065,	r12	;#0xf659
    f0ca:	8a 12       	call	r10		;
    f0cc:	3d 40 a4 ff 	mov	#65444,	r13	;#0xffa4

0000f0d0 <.L17>:
    f0d0:	2c 4d       	mov	@r13,	r12	;
    f0d2:	0c 93       	cmp	#0,	r12	;r3 As==00
    f0d4:	fd 37       	jge	$-4      	;abs 0xf0d0
    f0d6:	7c 90 79 00 	cmp.b	#121,	r12	;#0x0079
    f0da:	e8 27       	jz	$-46     	;abs 0xf0ac
    f0dc:	3a 41       	pop	r10		;
    f0de:	30 41       	ret			

0000f0e0 <I2C_write.constprop.1>:
    f0e0:	0a 12       	push	r10		;
    f0e2:	09 12       	push	r9		;
    f0e4:	3a 40 76 f0 	mov	#61558,	r10	;#0xf076
    f0e8:	4e 4c       	mov.b	r12,	r14	;
    f0ea:	4f 43       	clr.b	r15		;
    f0ec:	7c 40 6c 00 	mov.b	#108,	r12	;#0x006c
    f0f0:	4d 43       	clr.b	r13		;
    f0f2:	8a 12       	call	r10		;
    f0f4:	7e 40 10 00 	mov.b	#16,	r14	;#0x0010
    f0f8:	4f 43       	clr.b	r15		;
    f0fa:	7c 40 70 00 	mov.b	#112,	r12	;#0x0070
    f0fe:	4d 43       	clr.b	r13		;
    f100:	8a 12       	call	r10		;
    f102:	39 40 4e f0 	mov	#61518,	r9	;#0xf04e

0000f106 <.L24>:
    f106:	7c 40 70 00 	mov.b	#112,	r12	;#0x0070
    f10a:	4d 43       	clr.b	r13		;
    f10c:	89 12       	call	r9		;
    f10e:	0a 4c       	mov	r12,	r10	;
    f110:	6a f3       	and.b	#2,	r10	;r3 As==10
    f112:	0a 93       	cmp	#0,	r10	;r3 As==00
    f114:	f8 23       	jnz	$-14     	;abs 0xf106
    f116:	7c 40 70 00 	mov.b	#112,	r12	;#0x0070
    f11a:	4d 43       	clr.b	r13		;
    f11c:	89 12       	call	r9		;
    f11e:	b0 12 12 f6 	call	#62994		;#0xf612
    f122:	5c f3       	and.b	#1,	r12	;r3 As==01
    f124:	0d 4a       	mov	r10,	r13	;
    f126:	30 40 92 f5 	br	#0xf592		;

0000f12a <I2C_start.constprop.3>:
    f12a:	0a 12       	push	r10		;
    f12c:	4e 43       	clr.b	r14		;
    f12e:	0f 4e       	mov	r14,	r15	;
    f130:	0e 4c       	mov	r12,	r14	;
    f132:	5e f3       	and.b	#1,	r14	;r3 As==01
    f134:	3a 40 76 f0 	mov	#61558,	r10	;#0xf076
    f138:	3e 50 a0 00 	add	#160,	r14	;#0x00a0
    f13c:	0f 6f       	rlc	r15		;
    f13e:	7c 40 6c 00 	mov.b	#108,	r12	;#0x006c
    f142:	4d 43       	clr.b	r13		;
    f144:	8a 12       	call	r10		;
    f146:	7e 40 90 00 	mov.b	#144,	r14	;#0x0090
    f14a:	4f 43       	clr.b	r15		;
    f14c:	7c 40 70 00 	mov.b	#112,	r12	;#0x0070
    f150:	4d 43       	clr.b	r13		;
    f152:	8a 12       	call	r10		;
    f154:	3a 40 4e f0 	mov	#61518,	r10	;#0xf04e

0000f158 <.L27>:
    f158:	7c 40 70 00 	mov.b	#112,	r12	;#0x0070
    f15c:	4d 43       	clr.b	r13		;
    f15e:	8a 12       	call	r10		;
    f160:	2c b3       	bit	#2,	r12	;r3 As==10
    f162:	fa 23       	jnz	$-10     	;abs 0xf158
    f164:	7c 40 70 00 	mov.b	#112,	r12	;#0x0070
    f168:	4d 43       	clr.b	r13		;
    f16a:	8a 12       	call	r10		;
    f16c:	b0 12 12 f6 	call	#62994		;#0xf612
    f170:	5c f3       	and.b	#1,	r12	;r3 As==01
    f172:	3a 41       	pop	r10		;
    f174:	30 41       	ret			

0000f176 <timer_irq_handler>:
    f176:	92 53 fc ff 	inc	&0xfffc		;
    f17a:	92 e3 ac ff 	xor	#1,	&0xffac	;r3 As==01
    f17e:	00 13       	reti			

0000f180 <uart_print_hex_byte>:
    f180:	0a 12       	push	r10		;
    f182:	09 12       	push	r9		;
    f184:	4a 4c       	mov.b	r12,	r10	;
    f186:	0c 4a       	mov	r10,	r12	;
    f188:	b0 12 c4 f5 	call	#62916		;#0xf5c4
    f18c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    f190:	7d 40 09 00 	mov.b	#9,	r13	;
    f194:	4d 9c       	cmp.b	r12,	r13	;
    f196:	15 28       	jnc	$+44     	;abs 0xf1c2
    f198:	7c 50 30 00 	add.b	#48,	r12	;#0x0030

0000f19c <.L35>:
    f19c:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    f1a0:	39 40 0a f0 	mov	#61450,	r9	;#0xf00a
    f1a4:	89 12       	call	r9		;
    f1a6:	4c 4a       	mov.b	r10,	r12	;
    f1a8:	7c f0 0f 00 	and.b	#15,	r12	;#0x000f
    f1ac:	7d 40 09 00 	mov.b	#9,	r13	;
    f1b0:	4d 9c       	cmp.b	r12,	r13	;
    f1b2:	0b 28       	jnc	$+24     	;abs 0xf1ca
    f1b4:	7c 50 30 00 	add.b	#48,	r12	;#0x0030

0000f1b8 <.L36>:
    f1b8:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    f1bc:	89 12       	call	r9		;
    f1be:	30 40 92 f5 	br	#0xf592		;

0000f1c2 <.L31>:
    f1c2:	7c 50 37 00 	add.b	#55,	r12	;#0x0037
    f1c6:	30 40 9c f1 	br	#0xf19c		;

0000f1ca <.L33>:
    f1ca:	7c 50 37 00 	add.b	#55,	r12	;#0x0037
    f1ce:	30 40 b8 f1 	br	#0xf1b8		;

0000f1d2 <uart_print_hex_word>:
    f1d2:	0a 12       	push	r10		;
    f1d4:	09 12       	push	r9		;
    f1d6:	09 4c       	mov	r12,	r9	;
    f1d8:	b0 12 b4 f5 	call	#62900		;#0xf5b4
    f1dc:	3a 40 80 f1 	mov	#61824,	r10	;#0xf180
    f1e0:	8a 12       	call	r10		;
    f1e2:	4c 49       	mov.b	r9,	r12	;
    f1e4:	8a 12       	call	r10		;
    f1e6:	30 40 92 f5 	br	#0xf592		;

0000f1ea <system_error>:
    f1ea:	0a 12       	push	r10		;
    f1ec:	4a 4c       	mov.b	r12,	r10	;
    f1ee:	3c 40 88 f6 	mov	#63112,	r12	;#0xf688
    f1f2:	b0 12 1e f0 	call	#61470		;#0xf01e
    f1f6:	4c 4a       	mov.b	r10,	r12	;
    f1f8:	b0 12 80 f1 	call	#61824		;#0xf180
    f1fc:	02 43       	clr	r2		;
    f1fe:	92 43 ac ff 	mov	#1,	&0xffac	;r3 As==01

0000f202 <.L39>:
    f202:	30 40 02 f2 	br	#0xf202		;

0000f206 <get_image_word>:
    f206:	0a 12       	push	r10		;
    f208:	09 12       	push	r9		;
    f20a:	08 12       	push	r8		;
    f20c:	07 12       	push	r7		;
    f20e:	06 12       	push	r6		;
    f210:	4d 93       	cmp.b	#0,	r13	;r3 As==00
    f212:	11 20       	jnz	$+36     	;abs 0xf236
    f214:	3c 40 a4 ff 	mov	#65444,	r12	;#0xffa4
    f218:	0e 4c       	mov	r12,	r14	;

0000f21a <.L42>:
    f21a:	2d 4c       	mov	@r12,	r13	;
    f21c:	0d 93       	cmp	#0,	r13	;r3 As==00
    f21e:	fd 37       	jge	$-4      	;abs 0xf21a

0000f220 <.L47>:
    f220:	2c 4e       	mov	@r14,	r12	;
    f222:	0c 93       	cmp	#0,	r12	;r3 As==00
    f224:	fd 37       	jge	$-4      	;abs 0xf220
    f226:	7d f0 ff 00 	and.b	#255,	r13	;#0x00ff
    f22a:	8d 10       	swpb	r13		;
    f22c:	7c f0 ff 00 	and.b	#255,	r12	;#0x00ff
    f230:	0c dd       	bis	r13,	r12	;

0000f232 <.L40>:
    f232:	30 40 8c f5 	br	#0xf58c		;

0000f236 <.L41>:
    f236:	0a 4c       	mov	r12,	r10	;
    f238:	3a 50 04 04 	add	#1028,	r10	;#0x0404
    f23c:	39 40 2a f1 	mov	#61738,	r9	;#0xf12a
    f240:	4c 43       	clr.b	r12		;
    f242:	4d 43       	clr.b	r13		;
    f244:	89 12       	call	r9		;
    f246:	0c 4a       	mov	r10,	r12	;
    f248:	b0 12 b4 f5 	call	#62900		;#0xf5b4
    f24c:	38 40 e0 f0 	mov	#61664,	r8	;#0xf0e0
    f250:	88 12       	call	r8		;
    f252:	4c 4a       	mov.b	r10,	r12	;
    f254:	88 12       	call	r8		;
    f256:	5c 43       	mov.b	#1,	r12	;r3 As==01
    f258:	4d 43       	clr.b	r13		;
    f25a:	89 12       	call	r9		;
    f25c:	3a 40 76 f0 	mov	#61558,	r10	;#0xf076
    f260:	7e 40 20 00 	mov.b	#32,	r14	;#0x0020
    f264:	4f 43       	clr.b	r15		;
    f266:	7c 40 70 00 	mov.b	#112,	r12	;#0x0070
    f26a:	4d 43       	clr.b	r13		;
    f26c:	8a 12       	call	r10		;
    f26e:	39 40 4e f0 	mov	#61518,	r9	;#0xf04e
    f272:	76 40 70 00 	mov.b	#112,	r6	;#0x0070
    f276:	47 43       	clr.b	r7		;
    f278:	08 49       	mov	r9,	r8	;

0000f27a <.L45>:
    f27a:	0c 46       	mov	r6,	r12	;
    f27c:	0d 47       	mov	r7,	r13	;
    f27e:	89 12       	call	r9		;
    f280:	2c b3       	bit	#2,	r12	;r3 As==10
    f282:	fb 23       	jnz	$-8      	;abs 0xf27a
    f284:	7c 40 6c 00 	mov.b	#108,	r12	;#0x006c
    f288:	4d 43       	clr.b	r13		;
    f28a:	89 12       	call	r9		;
    f28c:	49 4c       	mov.b	r12,	r9	;
    f28e:	7e 40 68 00 	mov.b	#104,	r14	;#0x0068
    f292:	4f 43       	clr.b	r15		;
    f294:	7c 40 70 00 	mov.b	#112,	r12	;#0x0070
    f298:	4d 43       	clr.b	r13		;
    f29a:	8a 12       	call	r10		;
    f29c:	76 40 70 00 	mov.b	#112,	r6	;#0x0070
    f2a0:	47 43       	clr.b	r7		;

0000f2a2 <.L46>:
    f2a2:	0c 46       	mov	r6,	r12	;
    f2a4:	0d 47       	mov	r7,	r13	;
    f2a6:	88 12       	call	r8		;
    f2a8:	2c b3       	bit	#2,	r12	;r3 As==10
    f2aa:	fb 23       	jnz	$-8      	;abs 0xf2a2
    f2ac:	7c 40 6c 00 	mov.b	#108,	r12	;#0x006c
    f2b0:	4d 43       	clr.b	r13		;
    f2b2:	88 12       	call	r8		;
    f2b4:	89 10       	swpb	r9		;
    f2b6:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
    f2ba:	0c d9       	bis	r9,	r12	;
    f2bc:	30 40 32 f2 	br	#0xf232		;

0000f2c0 <get_image>:
    f2c0:	0a 12       	push	r10		;
    f2c2:	09 12       	push	r9		;
    f2c4:	08 12       	push	r8		;
    f2c6:	07 12       	push	r7		;
    f2c8:	06 12       	push	r6		;
    f2ca:	05 12       	push	r5		;
    f2cc:	04 12       	push	r4		;
    f2ce:	21 83       	decd	r1		;
    f2d0:	48 4c       	mov.b	r12,	r8	;
    f2d2:	b2 b0 00 01 	bit	#256,	&0xffe2	;#0x0100
    f2d6:	e2 ff 
    f2d8:	03 24       	jz	$+8      	;abs 0xf2e0
    f2da:	5c 43       	mov.b	#1,	r12	;r3 As==01

0000f2dc <.L65>:
    f2dc:	b0 12 ea f1 	call	#61930		;#0xf1ea

0000f2e0 <.L53>:
    f2e0:	37 40 1e f0 	mov	#61470,	r7	;#0xf01e
    f2e4:	08 93       	cmp	#0,	r8	;r3 As==00
    f2e6:	0e 20       	jnz	$+30     	;abs 0xf304
    f2e8:	3c 40 91 f6 	mov	#63121,	r12	;#0xf691

0000f2ec <.L64>:
    f2ec:	87 12       	call	r7		;
    f2ee:	39 40 06 f2 	mov	#61958,	r9	;#0xf206
    f2f2:	4d 48       	mov.b	r8,	r13	;
    f2f4:	4c 43       	clr.b	r12		;
    f2f6:	89 12       	call	r9		;
    f2f8:	3c 90 fe ca 	cmp	#51966,	r12	;#0xcafe
    f2fc:	07 24       	jz	$+16     	;abs 0xf30c
    f2fe:	6c 43       	mov.b	#2,	r12	;r3 As==10
    f300:	30 40 dc f2 	br	#0xf2dc		;

0000f304 <.L54>:
    f304:	3c 40 a5 f6 	mov	#63141,	r12	;#0xf6a5
    f308:	30 40 ec f2 	br	#0xf2ec		;

0000f30c <.L56>:
    f30c:	4d 48       	mov.b	r8,	r13	;
    f30e:	6c 43       	mov.b	#2,	r12	;r3 As==10
    f310:	89 12       	call	r9		;
    f312:	05 4c       	mov	r12,	r5	;
    f314:	4d 48       	mov.b	r8,	r13	;
    f316:	6c 42       	mov.b	#4,	r12	;r2 As==10
    f318:	89 12       	call	r9		;
    f31a:	81 4c 00 00 	mov	r12,	0(r1)	;
    f31e:	14 42 e6 ff 	mov	&0xffe6,r4	;0xffe6
    f322:	04 95       	cmp	r5,	r4	;
    f324:	13 28       	jnc	$+40     	;abs 0xf34c
    f326:	4a 43       	clr.b	r10		;
    f328:	06 4a       	mov	r10,	r6	;

0000f32a <.L58>:
    f32a:	0c 4a       	mov	r10,	r12	;
    f32c:	3c 50 06 00 	add	#6,	r12	;
    f330:	0a 95       	cmp	r5,	r10	;
    f332:	0f 28       	jnc	$+32     	;abs 0xf352

0000f334 <.L60>:
    f334:	0a 94       	cmp	r4,	r10	;
    f336:	15 28       	jnc	$+44     	;abs 0xf362
    f338:	26 91       	cmp	@r1,	r6	;
    f33a:	18 20       	jnz	$+50     	;abs 0xf36c
    f33c:	3c 40 b1 f6 	mov	#63153,	r12	;#0xf6b1
    f340:	87 12       	call	r7		;
    f342:	92 43 fa ff 	mov	#1,	&0xfffa	;r3 As==01
    f346:	21 53       	incd	r1		;
    f348:	30 40 88 f5 	br	#0xf588		;

0000f34c <.L57>:
    f34c:	6c 42       	mov.b	#4,	r12	;r2 As==10
    f34e:	30 40 dc f2 	br	#0xf2dc		;

0000f352 <.L59>:
    f352:	4d 48       	mov.b	r8,	r13	;
    f354:	89 12       	call	r9		;
    f356:	06 ec       	xor	r12,	r6	;
    f358:	8a 4c 00 00 	mov	r12,	0(r10)	;
    f35c:	2a 53       	incd	r10		;
    f35e:	30 40 2a f3 	br	#0xf32a		;

0000f362 <.L61>:
    f362:	8a 43 00 00 	mov	#0,	0(r10)	;r3 As==00
    f366:	2a 53       	incd	r10		;
    f368:	30 40 34 f3 	br	#0xf334		;

0000f36c <.L62>:
    f36c:	7c 42       	mov.b	#8,	r12	;r2 As==11
    f36e:	30 40 dc f2 	br	#0xf2dc		;

0000f372 <main>:
    f372:	0a 12       	push	r10		;
    f374:	09 12       	push	r9		;
    f376:	08 12       	push	r8		;
    f378:	07 12       	push	r7		;
    f37a:	06 12       	push	r6		;
    f37c:	b2 40 00 47 	mov	#18176,	&0xffb8	;#0x4700
    f380:	b8 ff 
    f382:	32 40 00 c0 	mov	#49152,	r2	;#0xc000
    f386:	92 43 90 ff 	mov	#1,	&0xff90	;r3 As==01
    f38a:	82 43 fa ff 	mov	#0,	&0xfffa	;r3 As==00
    f38e:	b2 40 76 f1 	mov	#61814,	&0xfff8	;#0xf176
    f392:	f8 ff 
    f394:	92 43 ac ff 	mov	#1,	&0xffac	;r3 As==01
    f398:	82 43 a0 ff 	mov	#0,	&0xffa0	;r3 As==00
    f39c:	1e 42 ec ff 	mov	&0xffec,r14	;0xffec
    f3a0:	1f 42 ee ff 	mov	&0xffee,r15	;0xffee
    f3a4:	4c 43       	clr.b	r12		;

0000f3a6 <.L67>:
    f3a6:	0a 4f       	mov	r15,	r10	;
    f3a8:	0f 93       	cmp	#0,	r15	;r3 As==00
    f3aa:	b6 20       	jnz	$+366    	;abs 0xf518
    f3ac:	3d 40 ff 95 	mov	#38399,	r13	;#0x95ff
    f3b0:	0d 9e       	cmp	r14,	r13	;
    f3b2:	b2 28       	jnc	$+358    	;abs 0xf518

0000f3b4 <.L70>:
    f3b4:	7d 40 ff 00 	mov.b	#255,	r13	;#0x00ff
    f3b8:	0d 9c       	cmp	r12,	r13	;
    f3ba:	b4 28       	jnc	$+362    	;abs 0xf524
    f3bc:	0d 4a       	mov	r10,	r13	;
    f3be:	0d 5a       	add	r10,	r13	;
    f3c0:	0d 5d       	rla	r13		;
    f3c2:	0d 5d       	rla	r13		;
    f3c4:	0d 5d       	rla	r13		;
    f3c6:	0d 5d       	rla	r13		;
    f3c8:	0d 5d       	rla	r13		;
    f3ca:	0d 5d       	rla	r13		;
    f3cc:	0d 5d       	rla	r13		;
    f3ce:	0d dc       	bis	r12,	r13	;
    f3d0:	82 4d a6 ff 	mov	r13,	&0xffa6	;
    f3d4:	b2 40 81 02 	mov	#641,	&0xffa0	;#0x0281
    f3d8:	a0 ff 
    f3da:	82 43 a2 ff 	mov	#0,	&0xffa2	;r3 As==00
    f3de:	3c 40 a0 ff 	mov	#65440,	r12	;#0xffa0

0000f3e2 <.L75>:
    f3e2:	2d 4c       	mov	@r12,	r13	;
    f3e4:	7d f0 40 00 	and.b	#64,	r13	;#0x0040
    f3e8:	0d 93       	cmp	#0,	r13	;r3 As==00
    f3ea:	fb 23       	jnz	$-8      	;abs 0xf3e2
    f3ec:	1c 42 a2 ff 	mov	&0xffa2,r12	;0xffa2
    f3f0:	1c 42 a4 ff 	mov	&0xffa4,r12	;0xffa4
    f3f4:	82 4d b0 ff 	mov	r13,	&0xffb0	;
    f3f8:	37 40 ee ff 	mov	#65518,	r7	;#0xffee
    f3fc:	2c 47       	mov	@r7,	r12	;
    f3fe:	0c 5c       	rla	r12		;
    f400:	0c 5c       	rla	r12		;
    f402:	3c 53       	add	#-1,	r12	;r3 As==11
    f404:	82 4c b4 ff 	mov	r12,	&0xffb4	;
    f408:	b2 40 7f 00 	mov	#127,	&0xffb0	;#0x007f
    f40c:	b0 ff 
    f40e:	82 4d b2 ff 	mov	r13,	&0xffb2	;
    f412:	38 40 fc ff 	mov	#65532,	r8	;#0xfffc
    f416:	88 4d 00 00 	mov	r13,	0(r8)	;
    f41a:	32 d0 00 40 	bis	#16384,	r2	;#0x4000
    f41e:	32 d2       	eint			
    f420:	3a 40 76 f0 	mov	#61558,	r10	;#0xf076
    f424:	4e 43       	clr.b	r14		;
    f426:	4f 43       	clr.b	r15		;
    f428:	7c 40 68 00 	mov.b	#104,	r12	;#0x0068
    f42c:	4d 43       	clr.b	r13		;
    f42e:	8a 12       	call	r10		;
    f430:	5e 43       	mov.b	#1,	r14	;r3 As==01
    f432:	4f 43       	clr.b	r15		;
    f434:	7c 40 70 00 	mov.b	#112,	r12	;#0x0070
    f438:	4d 43       	clr.b	r13		;
    f43a:	8a 12       	call	r10		;
    f43c:	7e 40 4f 00 	mov.b	#79,	r14	;#0x004f
    f440:	4f 43       	clr.b	r15		;
    f442:	7c 40 60 00 	mov.b	#96,	r12	;#0x0060
    f446:	4d 43       	clr.b	r13		;
    f448:	8a 12       	call	r10		;
    f44a:	4e 43       	clr.b	r14		;
    f44c:	4f 43       	clr.b	r15		;
    f44e:	7c 40 64 00 	mov.b	#100,	r12	;#0x0064
    f452:	4d 43       	clr.b	r13		;
    f454:	8a 12       	call	r10		;
    f456:	7e 40 80 00 	mov.b	#128,	r14	;#0x0080
    f45a:	4f 43       	clr.b	r15		;
    f45c:	7c 40 68 00 	mov.b	#104,	r12	;#0x0068
    f460:	4d 43       	clr.b	r13		;
    f462:	8a 12       	call	r10		;
    f464:	3a 40 1e f0 	mov	#61470,	r10	;#0xf01e
    f468:	3c 40 b4 f6 	mov	#63156,	r12	;#0xf6b4
    f46c:	8a 12       	call	r10		;
    f46e:	3c 40 e6 f6 	mov	#63206,	r12	;#0xf6e6
    f472:	8a 12       	call	r10		;
    f474:	39 40 d2 f1 	mov	#61906,	r9	;#0xf1d2
    f478:	1c 42 e0 ff 	mov	&0xffe0,r12	;0xffe0
    f47c:	89 12       	call	r9		;
    f47e:	3c 40 29 f7 	mov	#63273,	r12	;#0xf729
    f482:	8a 12       	call	r10		;
    f484:	2c 47       	mov	@r7,	r12	;
    f486:	89 12       	call	r9		;
    f488:	1c 42 ec ff 	mov	&0xffec,r12	;0xffec
    f48c:	89 12       	call	r9		;
    f48e:	3c 40 32 f7 	mov	#63282,	r12	;#0xf732
    f492:	8a 12       	call	r10		;
    f494:	1c 42 e6 ff 	mov	&0xffe6,r12	;0xffe6
    f498:	89 12       	call	r9		;
    f49a:	3c 40 3b f7 	mov	#63291,	r12	;#0xf73b
    f49e:	8a 12       	call	r10		;
    f4a0:	1c 42 ea ff 	mov	&0xffea,r12	;0xffea
    f4a4:	89 12       	call	r9		;
    f4a6:	3c 40 44 f7 	mov	#63300,	r12	;#0xf744
    f4aa:	8a 12       	call	r10		;
    f4ac:	1c 42 e2 ff 	mov	&0xffe2,r12	;0xffe2
    f4b0:	89 12       	call	r9		;
    f4b2:	3c 40 4d f7 	mov	#63309,	r12	;#0xf74d
    f4b6:	8a 12       	call	r10		;
    f4b8:	09 4a       	mov	r10,	r9	;
    f4ba:	37 40 c0 f2 	mov	#62144,	r7	;#0xf2c0
    f4be:	36 40 9e f0 	mov	#61598,	r6	;#0xf09e

0000f4c2 <.L77>:
    f4c2:	2c 48       	mov	@r8,	r12	;
    f4c4:	1c 93       	cmp	#1,	r12	;r3 As==01
    f4c6:	05 20       	jnz	$+12     	;abs 0xf4d2
    f4c8:	87 12       	call	r7		;
    f4ca:	3c 40 74 f7 	mov	#63348,	r12	;#0xf774
    f4ce:	89 12       	call	r9		;
    f4d0:	86 12       	call	r6		;

0000f4d2 <.L76>:
    f4d2:	3a 40 a4 ff 	mov	#65444,	r10	;#0xffa4
    f4d6:	2c 4a       	mov	@r10,	r12	;
    f4d8:	0c 93       	cmp	#0,	r12	;r3 As==00
    f4da:	f3 37       	jge	$-24     	;abs 0xf4c2
    f4dc:	3c 40 76 f7 	mov	#63350,	r12	;#0xf776
    f4e0:	89 12       	call	r9		;
    f4e2:	3c 40 81 f7 	mov	#63361,	r12	;#0xf781
    f4e6:	89 12       	call	r9		;
    f4e8:	08 4a       	mov	r10,	r8	;
    f4ea:	37 40 0a f0 	mov	#61450,	r7	;#0xf00a
    f4ee:	36 40 9e f0 	mov	#61598,	r6	;#0xf09e

0000f4f2 <.L78>:
    f4f2:	3c 40 e7 f7 	mov	#63463,	r12	;#0xf7e7
    f4f6:	89 12       	call	r9		;

0000f4f8 <.L79>:
    f4f8:	2c 48       	mov	@r8,	r12	;
    f4fa:	0c 93       	cmp	#0,	r12	;r3 As==00
    f4fc:	fd 37       	jge	$-4      	;abs 0xf4f8
    f4fe:	4a 4c       	mov.b	r12,	r10	;
    f500:	4c 4a       	mov.b	r10,	r12	;
    f502:	87 12       	call	r7		;
    f504:	3c 40 74 f7 	mov	#63348,	r12	;#0xf774
    f508:	89 12       	call	r9		;
    f50a:	7a 90 72 00 	cmp.b	#114,	r10	;#0x0072
    f50e:	19 20       	jnz	$+52     	;abs 0xf542
    f510:	30 40 00 f0 	br	#0xf000		;
    f514:	30 40 f2 f4 	br	#0xf4f2		;

0000f518 <.L68>:
    f518:	3e 50 00 6a 	add	#27136,	r14	;#0x6a00
    f51c:	3f 63       	addc	#-1,	r15	;r3 As==11
    f51e:	1c 53       	inc	r12		;
    f520:	30 40 a6 f3 	br	#0xf3a6		;

0000f524 <.L74>:
    f524:	6a 93       	cmp.b	#2,	r10	;r3 As==10
    f526:	02 24       	jz	$+6      	;abs 0xf52c
    f528:	6a 92       	cmp.b	#4,	r10	;r2 As==10
    f52a:	07 20       	jnz	$+16     	;abs 0xf53a

0000f52c <.L71>:
    f52c:	b0 12 c8 f5 	call	#62920		;#0xf5c8

0000f530 <.L73>:
    f530:	5a 53       	inc.b	r10		;
    f532:	3a f0 ff 00 	and	#255,	r10	;#0x00ff
    f536:	30 40 b4 f3 	br	#0xf3b4		;

0000f53a <.L72>:
    f53a:	b0 12 d0 f5 	call	#62928		;#0xf5d0
    f53e:	30 40 30 f5 	br	#0xf530		;

0000f542 <.L80>:
    f542:	7a 90 68 00 	cmp.b	#104,	r10	;#0x0068
    f546:	05 20       	jnz	$+12     	;abs 0xf552
    f548:	3c 40 81 f7 	mov	#63361,	r12	;#0xf781

0000f54c <.L96>:
    f54c:	89 12       	call	r9		;
    f54e:	30 40 f2 f4 	br	#0xf4f2		;

0000f552 <.L82>:
    f552:	7a 90 75 00 	cmp.b	#117,	r10	;#0x0075
    f556:	05 20       	jnz	$+12     	;abs 0xf562
    f558:	4c 43       	clr.b	r12		;

0000f55a <.L97>:
    f55a:	b0 12 c0 f2 	call	#62144		;#0xf2c0
    f55e:	30 40 f2 f4 	br	#0xf4f2		;

0000f562 <.L83>:
    f562:	7a 90 70 00 	cmp.b	#112,	r10	;#0x0070
    f566:	c5 27       	jz	$-116    	;abs 0xf4f2
    f568:	7a 90 65 00 	cmp.b	#101,	r10	;#0x0065
    f56c:	03 20       	jnz	$+8      	;abs 0xf574
    f56e:	5c 43       	mov.b	#1,	r12	;r3 As==01
    f570:	30 40 5a f5 	br	#0xf55a		;

0000f574 <.L84>:
    f574:	7a 90 73 00 	cmp.b	#115,	r10	;#0x0073
    f578:	03 20       	jnz	$+8      	;abs 0xf580
    f57a:	86 12       	call	r6		;
    f57c:	30 40 f2 f4 	br	#0xf4f2		;

0000f580 <.L85>:
    f580:	3c 40 ef f7 	mov	#63471,	r12	;#0xf7ef
    f584:	30 40 4c f5 	br	#0xf54c		;

0000f588 <__mspabi_func_epilog_7>:
    f588:	34 41       	pop	r4		;

0000f58a <__mspabi_func_epilog_6>:
    f58a:	35 41       	pop	r5		;

0000f58c <__mspabi_func_epilog_5>:
    f58c:	36 41       	pop	r6		;

0000f58e <__mspabi_func_epilog_4>:
    f58e:	37 41       	pop	r7		;

0000f590 <__mspabi_func_epilog_3>:
    f590:	38 41       	pop	r8		;

0000f592 <__mspabi_func_epilog_2>:
    f592:	39 41       	pop	r9		;

0000f594 <__mspabi_func_epilog_1>:
    f594:	3a 41       	pop	r10		;
    f596:	30 41       	ret			

0000f598 <__mspabi_srli_15>:
    f598:	12 c3       	clrc			
    f59a:	0c 10       	rrc	r12		;

0000f59c <__mspabi_srli_14>:
    f59c:	12 c3       	clrc			
    f59e:	0c 10       	rrc	r12		;

0000f5a0 <__mspabi_srli_13>:
    f5a0:	12 c3       	clrc			
    f5a2:	0c 10       	rrc	r12		;

0000f5a4 <__mspabi_srli_12>:
    f5a4:	12 c3       	clrc			
    f5a6:	0c 10       	rrc	r12		;

0000f5a8 <__mspabi_srli_11>:
    f5a8:	12 c3       	clrc			
    f5aa:	0c 10       	rrc	r12		;

0000f5ac <__mspabi_srli_10>:
    f5ac:	12 c3       	clrc			
    f5ae:	0c 10       	rrc	r12		;

0000f5b0 <__mspabi_srli_9>:
    f5b0:	12 c3       	clrc			
    f5b2:	0c 10       	rrc	r12		;

0000f5b4 <__mspabi_srli_8>:
    f5b4:	12 c3       	clrc			
    f5b6:	0c 10       	rrc	r12		;

0000f5b8 <__mspabi_srli_7>:
    f5b8:	12 c3       	clrc			
    f5ba:	0c 10       	rrc	r12		;

0000f5bc <__mspabi_srli_6>:
    f5bc:	12 c3       	clrc			
    f5be:	0c 10       	rrc	r12		;

0000f5c0 <__mspabi_srli_5>:
    f5c0:	12 c3       	clrc			
    f5c2:	0c 10       	rrc	r12		;

0000f5c4 <__mspabi_srli_4>:
    f5c4:	12 c3       	clrc			
    f5c6:	0c 10       	rrc	r12		;

0000f5c8 <__mspabi_srli_3>:
    f5c8:	12 c3       	clrc			
    f5ca:	0c 10       	rrc	r12		;

0000f5cc <__mspabi_srli_2>:
    f5cc:	12 c3       	clrc			
    f5ce:	0c 10       	rrc	r12		;

0000f5d0 <__mspabi_srli_1>:
    f5d0:	12 c3       	clrc			
    f5d2:	0c 10       	rrc	r12		;
    f5d4:	30 41       	ret			

0000f5d6 <.L11>:
    f5d6:	3d 53       	add	#-1,	r13	;r3 As==11
    f5d8:	12 c3       	clrc			
    f5da:	0c 10       	rrc	r12		;

0000f5dc <__mspabi_srli>:
    f5dc:	0d 93       	cmp	#0,	r13	;r3 As==00
    f5de:	fb 23       	jnz	$-8      	;abs 0xf5d6
    f5e0:	30 41       	ret			

0000f5e2 <__mspabi_srll_15>:
    f5e2:	12 c3       	clrc			
    f5e4:	0d 10       	rrc	r13		;
    f5e6:	0c 10       	rrc	r12		;

0000f5e8 <__mspabi_srll_14>:
    f5e8:	12 c3       	clrc			
    f5ea:	0d 10       	rrc	r13		;
    f5ec:	0c 10       	rrc	r12		;

0000f5ee <__mspabi_srll_13>:
    f5ee:	12 c3       	clrc			
    f5f0:	0d 10       	rrc	r13		;
    f5f2:	0c 10       	rrc	r12		;

0000f5f4 <__mspabi_srll_12>:
    f5f4:	12 c3       	clrc			
    f5f6:	0d 10       	rrc	r13		;
    f5f8:	0c 10       	rrc	r12		;

0000f5fa <__mspabi_srll_11>:
    f5fa:	12 c3       	clrc			
    f5fc:	0d 10       	rrc	r13		;
    f5fe:	0c 10       	rrc	r12		;

0000f600 <__mspabi_srll_10>:
    f600:	12 c3       	clrc			
    f602:	0d 10       	rrc	r13		;
    f604:	0c 10       	rrc	r12		;

0000f606 <__mspabi_srll_9>:
    f606:	12 c3       	clrc			
    f608:	0d 10       	rrc	r13		;
    f60a:	0c 10       	rrc	r12		;

0000f60c <__mspabi_srll_8>:
    f60c:	12 c3       	clrc			
    f60e:	0d 10       	rrc	r13		;
    f610:	0c 10       	rrc	r12		;

0000f612 <__mspabi_srll_7>:
    f612:	12 c3       	clrc			
    f614:	0d 10       	rrc	r13		;
    f616:	0c 10       	rrc	r12		;

0000f618 <__mspabi_srll_6>:
    f618:	12 c3       	clrc			
    f61a:	0d 10       	rrc	r13		;
    f61c:	0c 10       	rrc	r12		;

0000f61e <__mspabi_srll_5>:
    f61e:	12 c3       	clrc			
    f620:	0d 10       	rrc	r13		;
    f622:	0c 10       	rrc	r12		;

0000f624 <__mspabi_srll_4>:
    f624:	12 c3       	clrc			
    f626:	0d 10       	rrc	r13		;
    f628:	0c 10       	rrc	r12		;

0000f62a <__mspabi_srll_3>:
    f62a:	12 c3       	clrc			
    f62c:	0d 10       	rrc	r13		;
    f62e:	0c 10       	rrc	r12		;

0000f630 <__mspabi_srll_2>:
    f630:	12 c3       	clrc			
    f632:	0d 10       	rrc	r13		;
    f634:	0c 10       	rrc	r12		;

0000f636 <__mspabi_srll_1>:
    f636:	12 c3       	clrc			
    f638:	0d 10       	rrc	r13		;
    f63a:	0c 10       	rrc	r12		;
    f63c:	30 41       	ret			

0000f63e <.L12>:
    f63e:	3e 53       	add	#-1,	r14	;r3 As==11
    f640:	12 c3       	clrc			
    f642:	0d 10       	rrc	r13		;
    f644:	0c 10       	rrc	r12		;

0000f646 <__mspabi_srll>:
    f646:	0e 93       	cmp	#0,	r14	;r3 As==00
    f648:	fa 23       	jnz	$-10     	;abs 0xf63e
    f64a:	30 41       	ret			
    f64c:	42 6f       	addc.b	r15,	r2	;
    f64e:	6f 74       	subc.b	@r4,	r15	;
    f650:	69 6e       	addc.b	@r14,	r9	;
    f652:	67 2e       	jc	$-816    	;abs 0xf322
    f654:	2e 2e       	jc	$-930    	;abs 0xf2b2
    f656:	0a 0a       	mova	@r10,	r10	;
    f658:	00 50       	rla	r0		;
    f65a:	6f 74       	subc.b	@r4,	r15	;
    f65c:	65 6e       	addc.b	@r14,	r5	;
    f65e:	74 69       	addc.b	@r9+,	r4	;
    f660:	61 6c       	addc.b	@r12,	r1	;
    f662:	6c 79       	subc.b	@r9,	r12	;
    f664:	20 69       	addc	@r9,	r0	;
    f666:	6e 76       	subc.b	@r6,	r14	;
    f668:	61 6c       	addc.b	@r12,	r1	;
    f66a:	69 64       	addc.b	@r4,	r9	;
    f66c:	20 69       	addc	@r9,	r0	;
    f66e:	6d 61       	addc.b	@r1,	r13	;
    f670:	67 65       	addc.b	@r5,	r7	;
    f672:	2e 20       	jnz	$+94     	;abs 0xf6d0
    f674:	42 6f       	addc.b	r15,	r2	;
    f676:	6f 74       	subc.b	@r4,	r15	;
    f678:	20 61       	addc	@r1,	r0	;
    f67a:	6e 79       	subc.b	@r9,	r14	;
    f67c:	77 61       	addc.b	@r1+,	r7	;
    f67e:	79 20       	jnz	$+244    	;abs 0xf772
    f680:	28 79       	subc	@r9,	r8	;
    f682:	2f 6e       	addc	@r14,	r15	;
    f684:	29 3f       	jmp	$-428    	;abs 0xf4d8
    f686:	20 00 07 0a 	bra	&2567		;0x00a07
    f68a:	45 52       	add.b	r2,	r5	;
    f68c:	52 4f 52 20 	mov.b	8274(r15),r2	;0x02052
    f690:	00 41       	br	r1		;
    f692:	77 61       	addc.b	@r1+,	r7	;
    f694:	69 74       	subc.b	@r4,	r9	;
    f696:	69 6e       	addc.b	@r14,	r9	;
    f698:	67 20       	jnz	$+208    	;abs 0xf768
    f69a:	42 49       	mov.b	r9,	r2	;
    f69c:	4e 45       	mov.b	r5,	r14	;
    f69e:	58 45 2e 2e 	mov.b	11822(r5),r8	;0x02e2e
    f6a2:	2e 20       	jnz	$+94     	;abs 0xf700
    f6a4:	00 4c       	br	r12		;
    f6a6:	6f 61       	addc.b	@r1,	r15	;
    f6a8:	64 69       	addc.b	@r9,	r4	;
    f6aa:	6e 67       	addc.b	@r7,	r14	;
    f6ac:	2e 2e       	jc	$-930    	;abs 0xf30a
    f6ae:	2e 20       	jnz	$+94     	;abs 0xf70c
    f6b0:	00 4f       	br	r15		;
    f6b2:	4b 00       	rrcm.a	#1,	r11	;
    f6b4:	0a 0a       	mova	@r10,	r10	;
    f6b6:	4e 45       	mov.b	r5,	r14	;
    f6b8:	4f 34       	jge	$+160    	;abs 0xf758
    f6ba:	33 30       	jn	$+104    	;abs 0xf722
    f6bc:	20 42       	br	#4		;r2 As==10
    f6be:	6f 6f       	addc.b	@r15,	r15	;
    f6c0:	74 6c       	addc.b	@r12+,	r4	;
    f6c2:	6f 61       	addc.b	@r1,	r15	;
    f6c4:	64 65       	addc.b	@r5,	r4	;
    f6c6:	72 20       	jnz	$+230    	;abs 0xf7ac
    f6c8:	56 32       	jn	$-850    	;abs 0xf376
    f6ca:	30 31       	jn	$+610    	;abs 0xf92c
    f6cc:	37 31       	jn	$+624    	;abs 0xf93c
    f6ce:	32 32       	jn	$-922    	;abs 0xf334
    f6d0:	38 20       	jnz	$+114    	;abs 0xf742
    f6d2:	62 79       	subc.b	@r9,	r2	;
    f6d4:	20 53       	incd	r0		;
    f6d6:	74 65       	addc.b	@r5+,	r4	;
    f6d8:	70 68       	addc.b	@r8+,	r0	;
    f6da:	61 6e       	addc.b	@r14,	r1	;
    f6dc:	20 4e       	br	@r14		;
    f6de:	6f 6c       	addc.b	@r12,	r15	;
    f6e0:	74 69       	addc.b	@r9+,	r4	;
    f6e2:	6e 67       	addc.b	@r7,	r14	;
    f6e4:	0a 00       	mova	@r0,	r10	;
    f6e6:	41 64       	addc.b	r4,	r1	;
    f6e8:	6f 70       	subc.b	@r0,	r15	;
    f6ea:	74 65       	addc.b	@r5+,	r4	;
    f6ec:	64 20       	jnz	$+202    	;abs 0xf7b6
    f6ee:	66 6f       	addc.b	@r15,	r6	;
    f6f0:	72 20       	jnz	$+230    	;abs 0xf7d6
    f6f2:	49 32       	jn	$-876    	;abs 0xf386
    f6f4:	43 20       	jnz	$+136    	;abs 0xf77c
    f6f6:	45 45       	mov.b	r5,	r5	;
    f6f8:	50 52 4f 4d 	add.b	&0x4d4f,r0	;0x4d4f
    f6fc:	20 62       	addc	#4,	r0	;r2 As==10
    f6fe:	79 20       	jnz	$+244    	;abs 0xf7f2
    f700:	5a 79 64 72 	subc.b	29284(r9),r10	;0x07264
    f704:	75 6e       	addc.b	@r14+,	r5	;
    f706:	61 73       	subc.b	#2,	r1	;r3 As==10
    f708:	20 54       	add	@r4,	r0	;
    f70a:	61 6d       	addc.b	@r13,	r1	;
    f70c:	6f 73       	subc.b	#2,	r15	;r3 As==10
    f70e:	65 76       	subc.b	@r6,	r5	;
    f710:	69 63       	addc.b	#2,	r9	;r3 As==10
    f712:	69 75       	subc.b	@r5,	r9	;
    f714:	73 20       	jnz	$+232    	;abs 0xf7fc
    f716:	56 32       	jn	$-850    	;abs 0xf3c4
    f718:	30 31       	jn	$+610    	;abs 0xf97a
    f71a:	38 30       	jn	$+114    	;abs 0xf78c
    f71c:	31 31       	jn	$+612    	;abs 0xf980
    f71e:	37 0a 0a 48 	mova	18442(r10),r7	;0x0480a
    f722:	57 56 3a 20 	add.b	8250(r6),r7	;0x0203a
    f726:	30 78       	subc	@r8+,	r0	;
    f728:	00 0a       	bra	@r10		;
    f72a:	43 4c       	.word	0x4c43;	????
    f72c:	4b 3a       	jl	$-872    	;abs 0xf3c4
    f72e:	20 30       	jn	$+66     	;abs 0xf770
    f730:	78 00 0a 52 	mova	r0,	21002(r8); 0x0520a
    f734:	4f 4d       	mov.b	r13,	r15	;
    f736:	3a 20       	jnz	$+118    	;abs 0xf7ac
    f738:	30 78       	subc	@r8+,	r0	;
    f73a:	00 0a       	bra	@r10		;
    f73c:	52 41 4d 3a 	mov.b	14925(r1),r2	;0x03a4d
    f740:	20 30       	jn	$+66     	;abs 0xf782
    f742:	78 00 0a 53 	mova	r0,	21258(r8); 0x0530a
    f746:	59 53       	inc.b	r9		;
    f748:	3a 20       	jnz	$+118    	;abs 0xf7be
    f74a:	30 78       	subc	@r8+,	r0	;
    f74c:	00 0a       	bra	@r10		;
    f74e:	0a 41       	mov	r1,	r10	;
    f750:	75 74       	subc.b	@r4+,	r5	;
    f752:	6f 62       	addc.b	#4,	r15	;r2 As==10
    f754:	6f 6f       	addc.b	@r15,	r15	;
    f756:	74 20       	jnz	$+234    	;abs 0xf840
    f758:	69 6e       	addc.b	@r14,	r9	;
    f75a:	20 31       	jn	$+578    	;abs 0xf99c
    f75c:	73 2e       	jc	$-792    	;abs 0xf444
    f75e:	20 50       	add	@r0,	r0	;
    f760:	72 65       	addc.b	@r5+,	r2	;
    f762:	73 73       	.word	0x7373;	????
    f764:	20 6b       	addc	@r11,	r0	;
    f766:	65 79       	subc.b	@r9,	r5	;
    f768:	20 74       	subc	@r4,	r0	;
    f76a:	6f 20       	jnz	$+224    	;abs 0xf84a
    f76c:	61 62       	addc.b	#4,	r1	;r2 As==10
    f76e:	6f 72       	subc.b	#4,	r15	;r2 As==10
    f770:	74 2e       	jc	$-790    	;abs 0xf45a
    f772:	0a 00       	mova	@r0,	r10	;
    f774:	0a 00       	mova	@r0,	r10	;
    f776:	41 62       	addc.b	r2,	r1	;
    f778:	6f 72       	subc.b	#4,	r15	;r2 As==10
    f77a:	74 65       	addc.b	@r5+,	r4	;
    f77c:	64 2e       	jc	$-822    	;abs 0xf446
    f77e:	0a 0a       	mova	@r10,	r10	;
    f780:	00 43       	clr	r0		;
    f782:	6f 6d       	addc.b	@r13,	r15	;
    f784:	6d 61       	addc.b	@r1,	r13	;
    f786:	6e 64       	addc.b	@r4,	r14	;
    f788:	73 3a       	jl	$-792    	;abs 0xf470
    f78a:	0a 20       	jnz	$+22     	;abs 0xf7a0
    f78c:	64 3a       	jl	$-822    	;abs 0xf456
    f78e:	20 44       	br	@r4		;
    f790:	75 6d       	addc.b	@r13+,	r5	;
    f792:	70 20       	jnz	$+226    	;abs 0xf874
    f794:	4d 45       	mov.b	r5,	r13	;
    f796:	4d 0a       	rlam.a	#3,	r13	;
    f798:	20 65       	addc	@r5,	r0	;
    f79a:	3a 20       	jnz	$+118    	;abs 0xf810
    f79c:	4c 6f       	addc.b	r15,	r12	;
    f79e:	61 64       	addc.b	@r4,	r1	;
    f7a0:	20 45       	br	@r5		;
    f7a2:	45 50       	add.b	r0,	r5	;
    f7a4:	52 4f 4d 0a 	mov.b	2637(r15),r2	;0x00a4d
    f7a8:	20 68       	addc	@r8,	r0	;
    f7aa:	3a 20       	jnz	$+118    	;abs 0xf820
    f7ac:	48 65       	addc.b	r5,	r8	;
    f7ae:	6c 70       	subc.b	@r0,	r12	;
    f7b0:	0a 20       	jnz	$+22     	;abs 0xf7c6
    f7b2:	70 3a       	jl	$-798    	;abs 0xf494
    f7b4:	20 53       	incd	r0		;
    f7b6:	74 6f       	addc.b	@r15+,	r4	;
    f7b8:	72 65       	addc.b	@r5+,	r2	;
    f7ba:	20 45       	br	@r5		;
    f7bc:	45 50       	add.b	r0,	r5	;
    f7be:	52 4f 4d 0a 	mov.b	2637(r15),r2	;0x00a4d
    f7c2:	20 72       	subc	#4,	r0	;r2 As==10
    f7c4:	3a 20       	jnz	$+118    	;abs 0xf83a
    f7c6:	52 65 73 74 	addc.b	29811(r5),r2	;0x07473
    f7ca:	61 72       	subc.b	#4,	r1	;r2 As==10
    f7cc:	74 0a 20 73 	mova	r10,	29472(r4); 0x07320
    f7d0:	3a 20       	jnz	$+118    	;abs 0xf846
    f7d2:	53 74       	.word	0x7453;	????
    f7d4:	61 72       	subc.b	#4,	r1	;r2 As==10
    f7d6:	74 20       	jnz	$+234    	;abs 0xf8c0
    f7d8:	61 70       	subc.b	@r0,	r1	;
    f7da:	70 0a 20 75 	mova	r10,	29984(r0); PC rel. 0x16cfc
    f7de:	3a 20       	jnz	$+118    	;abs 0xf854
    f7e0:	55 70 6c 6f 	subc.b	0x6f6c,	r5	;PC rel. 0x674e
    f7e4:	61 64       	addc.b	@r4,	r1	;
    f7e6:	00 0a       	bra	@r10		;
    f7e8:	43 4d       	.word	0x4d43;	????
    f7ea:	44 3a       	jl	$-886    	;abs 0xf474
    f7ec:	3e 20       	jnz	$+126    	;abs 0xf86a
    f7ee:	00 42       	br	r2		;
    f7f0:	61 64       	addc.b	@r4,	r1	;
    f7f2:	20 43       	br	#2		;r3 As==10
    f7f4:	4d 44       	mov.b	r4,	r13	;
    f7f6:	21 00 0f 97 	Address 0x0000f7f8 is out of bounds.
mova	&65535,	r1	;0x0ffff

Disassembly of section .comment:

00000000 <.comment>:
   0:	47 43       	clr.b	r7		;
   2:	43 3a       	jl	$-888    	;abs 0xfffffc8a
   4:	20 28       	jnc	$+66     	;abs 0x46
   6:	53 4f       	.word	0x4f53;	????
   8:	4d 4e       	mov.b	r14,	r13	;
   a:	49 55       	add.b	r5,	r9	;
   c:	4d 20       	jnz	$+156    	;abs 0xa8
   e:	54 65 63 68 	addc.b	26723(r5),r4	;0x06863
  12:	6e 6f       	addc.b	@r15,	r14	;
  14:	6c 6f       	addc.b	@r15,	r12	;
  16:	67 69       	addc.b	@r9,	r7	;
  18:	65 73       	subc.b	#2,	r5	;r3 As==10
  1a:	20 4c       	br	@r12		;
  1c:	69 6d       	addc.b	@r13,	r9	;
  1e:	69 74       	subc.b	@r4,	r9	;
  20:	65 64       	addc.b	@r4,	r5	;
  22:	20 2d       	jc	$+578    	;abs 0x264
  24:	20 6d       	addc	@r13,	r0	;
  26:	73 70       	.word	0x7073;	????
  28:	34 33       	jn	$-406    	;abs 0xfffffe92
  2a:	30 2d       	jc	$+610    	;abs 0x28c
  2c:	67 63       	addc.b	#2,	r7	;r3 As==10
  2e:	63 20       	jnz	$+200    	;abs 0xf6
  30:	36 2e       	jc	$-914    	;abs 0xfffffc9e
  32:	34 2e       	jc	$-918    	;abs 0xfffffc9c
  34:	30 2e       	jc	$-926    	;abs 0xfffffc96
  36:	33 32       	jn	$-920    	;abs 0xfffffc9e
  38:	29 20       	jnz	$+84     	;abs 0x8c
  3a:	36 2e       	jc	$-914    	;abs 0xfffffca8
  3c:	34 2e       	jc	$-918    	;abs 0xfffffca6
  3e:	30 00 5a 97 	Address 0x00000040 is out of bounds.
bra	-1(r0)		;PC rel. 0x0003f

Disassembly of section .MSP430.attributes:

00000000 <.MSP430.attributes>:
   0:	41 16       	popm.a	#5,	r5	;20-bit words
   2:	00 00       	beq			
   4:	00 6d       	addc	r13,	r0	;
   6:	73 70       	.word	0x7073;	????
   8:	61 62       	addc.b	#4,	r1	;r2 As==10
   a:	69 00 01 0b 	mova	r0,	&592641	; 0x90b01
   e:	00 00       	beq			
  10:	00 04       	bra	@r4		;
  12:	01 06       	mova	@r6,	r1	;
  14:	01 08       	mova	@r8,	r1	;
  16:	01 69       	Address 0x00000016 is out of bounds.
.word	0xffff;	????
