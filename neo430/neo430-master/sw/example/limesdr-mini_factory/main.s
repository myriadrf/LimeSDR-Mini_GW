
main.elf:     file format elf32-msp430


Disassembly of section .text:

00000000 <__crt0_begin>:
   0:	18 42 e8 ff 	mov	&0xffe8,r8	;0xffe8
   4:	11 42 ea ff 	mov	&0xffea,r1	;0xffea
   8:	02 43       	clr	r2		;
   a:	01 58       	add	r8,	r1	;
   c:	b2 40 00 47 	mov	#18176,	&0xffb8	;#0x4700
  10:	b8 ff 
  12:	39 40 80 ff 	mov	#65408,	r9	;#0xff80

00000016 <__crt0_clr_io>:
  16:	09 93       	cmp	#0,	r9	;r3 As==00
  18:	04 24       	jz	$+10     	;abs 0x22
  1a:	89 43 00 00 	mov	#0,	0(r9)	;r3 As==00
  1e:	29 53       	incd	r9		;
  20:	fa 3f       	jmp	$-10     	;abs 0x16

00000022 <__crt0_clr_dmem>:
  22:	01 98       	cmp	r8,	r1	;
  24:	04 24       	jz	$+10     	;abs 0x2e
  26:	88 43 00 00 	mov	#0,	0(r8)	;r3 As==00
  2a:	28 53       	incd	r8		;
  2c:	fa 3f       	jmp	$-10     	;abs 0x22

0000002e <__crt0_clr_dmem_end>:
  2e:	35 40 dc 09 	mov	#2524,	r5	;#0x09dc
  32:	36 40 dc 09 	mov	#2524,	r6	;#0x09dc
  36:	37 40 00 80 	mov	#32768,	r7	;#0x8000

0000003a <__crt0_cpy_data>:
  3a:	06 95       	cmp	r5,	r6	;
  3c:	04 24       	jz	$+10     	;abs 0x46
  3e:	b7 45 00 00 	mov	@r5+,	0(r7)	;
  42:	27 53       	incd	r7		;
  44:	fa 3f       	jmp	$-10     	;abs 0x3a

00000046 <__crt0_cpy_data_end>:
  46:	32 40 00 40 	mov	#16384,	r2	;#0x4000
  4a:	04 43       	clr	r4		;
  4c:	0a 43       	clr	r10		;
  4e:	0b 43       	clr	r11		;
  50:	0c 43       	clr	r12		;
  52:	0d 43       	clr	r13		;
  54:	0e 43       	clr	r14		;
  56:	0f 43       	clr	r15		;

00000058 <__crt0_start_main>:
  58:	b0 12 98 01 	call	#408		;#0x0198

0000005c <__crt0_this_is_the_end>:
  5c:	02 43       	clr	r2		;
  5e:	b2 40 00 47 	mov	#18176,	&0xffb8	;#0x4700
  62:	b8 ff 
  64:	32 40 10 00 	mov	#16,	r2	;#0x0010
  68:	03 43       	nop			

0000006a <wishbone_read32>:
  6a:	b2 40 0f 00 	mov	#15,	&0xff90	;#0x000f
  6e:	90 ff 
  70:	0e 4c       	mov	r12,	r14	;
  72:	3e f0 fc ff 	and	#65532,	r14	;#0xfffc
  76:	82 4e 92 ff 	mov	r14,	&0xff92	;
  7a:	82 4d 94 ff 	mov	r13,	&0xff94	;
  7e:	3d 40 90 ff 	mov	#65424,	r13	;#0xff90

00000082 <.L2>:
  82:	2c 4d       	mov	@r13,	r12	;
  84:	0c 93       	cmp	#0,	r12	;r3 As==00
  86:	fd 3b       	jl	$-4      	;abs 0x82
  88:	1c 42 9a ff 	mov	&0xff9a,r12	;0xff9a
  8c:	1d 42 9c ff 	mov	&0xff9c,r13	;0xff9c
  90:	30 41       	ret			

00000092 <wishbone_write32>:
  92:	b2 40 0f 00 	mov	#15,	&0xff90	;#0x000f
  96:	90 ff 
  98:	82 4e 9a ff 	mov	r14,	&0xff9a	;
  9c:	82 4f 9c ff 	mov	r15,	&0xff9c	;
  a0:	0e 4c       	mov	r12,	r14	;
  a2:	3e f0 fc ff 	and	#65532,	r14	;#0xfffc
  a6:	82 4e 96 ff 	mov	r14,	&0xff96	;
  aa:	82 4d 98 ff 	mov	r13,	&0xff98	;
  ae:	3d 40 90 ff 	mov	#65424,	r13	;#0xff90

000000b2 <.L5>:
  b2:	2c 4d       	mov	@r13,	r12	;
  b4:	0c 93       	cmp	#0,	r12	;r3 As==00
  b6:	fd 3b       	jl	$-4      	;abs 0xb2
  b8:	30 41       	ret			

000000ba <reverse>:
  ba:	0a 12       	push	r10		;
  bc:	4a 4c       	mov.b	r12,	r10	;
  be:	0c 4a       	mov	r10,	r12	;
  c0:	b0 12 16 08 	call	#2070		;#0x0816
  c4:	0a 5a       	rla	r10		;
  c6:	0a 5a       	rla	r10		;
  c8:	0a 5a       	rla	r10		;
  ca:	0a 5a       	rla	r10		;
  cc:	4a dc       	bis.b	r12,	r10	;
  ce:	3a f0 ff 00 	and	#255,	r10	;#0x00ff
  d2:	0c 4a       	mov	r10,	r12	;
  d4:	b0 12 90 07 	call	#1936		;#0x0790
  d8:	7c f0 33 00 	and.b	#51,	r12	;#0x0033
  dc:	0a 5a       	rla	r10		;
  de:	0a 5a       	rla	r10		;
  e0:	7a f0 cc ff 	and.b	#65484,	r10	;#0xffcc
  e4:	4a dc       	bis.b	r12,	r10	;
  e6:	3a f0 ff 00 	and	#255,	r10	;#0x00ff
  ea:	0c 4a       	mov	r10,	r12	;
  ec:	0c 11       	rra	r12		;
  ee:	7c f0 55 00 	and.b	#85,	r12	;#0x0055
  f2:	0a 5a       	rla	r10		;
  f4:	7a f0 aa ff 	and.b	#65450,	r10	;#0xffaa
  f8:	4c da       	bis.b	r10,	r12	;
  fa:	3a 41       	pop	r10		;
  fc:	30 41       	ret			

000000fe <uart_set_baud.constprop.2>:
  fe:	0a 12       	push	r10		;
 100:	1e 42 ec ff 	mov	&0xffec,r14	;0xffec
 104:	1f 42 ee ff 	mov	&0xffee,r15	;0xffee
 108:	4c 43       	clr.b	r12		;

0000010a <.L9>:
 10a:	0a 4f       	mov	r15,	r10	;
 10c:	0f 93       	cmp	#0,	r15	;r3 As==00
 10e:	16 20       	jnz	$+46     	;abs 0x13c
 110:	3d 40 ff 95 	mov	#38399,	r13	;#0x95ff
 114:	0d 9e       	cmp	r14,	r13	;
 116:	12 28       	jnc	$+38     	;abs 0x13c

00000118 <.L12>:
 118:	7d 40 ff 00 	mov.b	#255,	r13	;#0x00ff
 11c:	0d 9c       	cmp	r12,	r13	;
 11e:	14 28       	jnc	$+42     	;abs 0x148
 120:	0d 4a       	mov	r10,	r13	;
 122:	0d 5a       	add	r10,	r13	;
 124:	0d 5d       	rla	r13		;
 126:	0d 5d       	rla	r13		;
 128:	0d 5d       	rla	r13		;
 12a:	0d 5d       	rla	r13		;
 12c:	0d 5d       	rla	r13		;
 12e:	0d 5d       	rla	r13		;
 130:	0d 5d       	rla	r13		;
 132:	0d dc       	bis	r12,	r13	;
 134:	82 4d a6 ff 	mov	r13,	&0xffa6	;
 138:	3a 41       	pop	r10		;
 13a:	30 41       	ret			

0000013c <.L10>:
 13c:	3e 50 00 6a 	add	#27136,	r14	;#0x6a00
 140:	3f 63       	addc	#-1,	r15	;r3 As==11
 142:	1c 53       	inc	r12		;
 144:	30 40 0a 01 	br	#0x010a		;

00000148 <.L16>:
 148:	6a 93       	cmp.b	#2,	r10	;r3 As==10
 14a:	02 24       	jz	$+6      	;abs 0x150
 14c:	6a 92       	cmp.b	#4,	r10	;r2 As==10
 14e:	07 20       	jnz	$+16     	;abs 0x15e

00000150 <.L13>:
 150:	b0 12 1a 08 	call	#2074		;#0x081a

00000154 <.L15>:
 154:	5a 53       	inc.b	r10		;
 156:	3a f0 ff 00 	and	#255,	r10	;#0x00ff
 15a:	30 40 18 01 	br	#0x0118		;

0000015e <.L14>:
 15e:	b0 12 22 08 	call	#2082		;#0x0822
 162:	30 40 54 01 	br	#0x0154		;

00000166 <uart_br_print>:
 166:	3e 40 a0 ff 	mov	#65440,	r14	;#0xffa0
 16a:	3f 40 a4 ff 	mov	#65444,	r15	;#0xffa4

0000016e <.L22>:
 16e:	6d 4c       	mov.b	@r12,	r13	;
 170:	0d 93       	cmp	#0,	r13	;r3 As==00
 172:	01 20       	jnz	$+4      	;abs 0x176
 174:	30 41       	ret			

00000176 <.L26>:
 176:	3d 90 0a 00 	cmp	#10,	r13	;#0x000a
 17a:	06 20       	jnz	$+14     	;abs 0x188

0000017c <.L24>:
 17c:	be b2 00 00 	bit	#8,	0(r14)	;r2 As==11
 180:	fd 23       	jnz	$-4      	;abs 0x17c
 182:	b2 40 0d 00 	mov	#13,	&0xffa4	;#0x000d
 186:	a4 ff 

00000188 <.L25>:
 188:	be b2 00 00 	bit	#8,	0(r14)	;r2 As==11
 18c:	fd 23       	jnz	$-4      	;abs 0x188
 18e:	8f 4d 00 00 	mov	r13,	0(r15)	;
 192:	1c 53       	inc	r12		;
 194:	30 40 6e 01 	br	#0x016e		;

00000198 <main>:
 198:	0a 12       	push	r10		;
 19a:	09 12       	push	r9		;
 19c:	08 12       	push	r8		;
 19e:	07 12       	push	r7		;
 1a0:	06 12       	push	r6		;
 1a2:	05 12       	push	r5		;
 1a4:	04 12       	push	r4		;
 1a6:	31 82       	sub	#8,	r1	;r2 As==11
 1a8:	39 40 fe 00 	mov	#254,	r9	;#0x00fe
 1ac:	89 12       	call	r9		;
 1ae:	92 43 a0 ff 	mov	#1,	&0xffa0	;r3 As==01
 1b2:	3a 40 92 00 	mov	#146,	r10	;#0x0092
 1b6:	5e 43       	mov.b	#1,	r14	;r3 As==01
 1b8:	4f 43       	clr.b	r15		;
 1ba:	3c 40 0c 04 	mov	#1036,	r12	;#0x040c
 1be:	4d 43       	clr.b	r13		;
 1c0:	8a 12       	call	r10		;
 1c2:	4e 43       	clr.b	r14		;
 1c4:	4f 43       	clr.b	r15		;
 1c6:	3c 40 0c 04 	mov	#1036,	r12	;#0x040c
 1ca:	4d 43       	clr.b	r13		;
 1cc:	8a 12       	call	r10		;
 1ce:	89 12       	call	r9		;
 1d0:	92 43 a0 ff 	mov	#1,	&0xffa0	;r3 As==01
 1d4:	39 40 66 01 	mov	#358,	r9	;#0x0166
 1d8:	3c 40 b2 08 	mov	#2226,	r12	;#0x08b2
 1dc:	89 12       	call	r9		;
 1de:	4e 43       	clr.b	r14		;
 1e0:	4f 43       	clr.b	r15		;
 1e2:	7c 40 68 00 	mov.b	#104,	r12	;#0x0068
 1e6:	4d 43       	clr.b	r13		;
 1e8:	8a 12       	call	r10		;
 1ea:	5e 43       	mov.b	#1,	r14	;r3 As==01
 1ec:	4f 43       	clr.b	r15		;
 1ee:	7c 40 70 00 	mov.b	#112,	r12	;#0x0070
 1f2:	4d 43       	clr.b	r13		;
 1f4:	8a 12       	call	r10		;
 1f6:	7e 40 4f 00 	mov.b	#79,	r14	;#0x004f
 1fa:	4f 43       	clr.b	r15		;
 1fc:	7c 40 60 00 	mov.b	#96,	r12	;#0x0060
 200:	4d 43       	clr.b	r13		;
 202:	8a 12       	call	r10		;
 204:	4e 43       	clr.b	r14		;
 206:	4f 43       	clr.b	r15		;
 208:	7c 40 64 00 	mov.b	#100,	r12	;#0x0064
 20c:	4d 43       	clr.b	r13		;
 20e:	8a 12       	call	r10		;
 210:	7e 40 80 00 	mov.b	#128,	r14	;#0x0080
 214:	4f 43       	clr.b	r15		;
 216:	7c 40 68 00 	mov.b	#104,	r12	;#0x0068
 21a:	4d 43       	clr.b	r13		;
 21c:	8a 12       	call	r10		;
 21e:	b2 b2 e2 ff 	bit	#8,	&0xffe2	;r2 As==11
 222:	02 20       	jnz	$+6      	;abs 0x228
 224:	30 40 e4 06 	br	#0x06e4		;
 228:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
 22c:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
 230:	48 43       	clr.b	r8		;
 232:	81 48 04 00 	mov	r8,	4(r1)	;
 236:	39 40 6a 00 	mov	#106,	r9	;#0x006a

0000023a <.L32>:
 23a:	3c 40 08 04 	mov	#1032,	r12	;#0x0408
 23e:	4d 43       	clr.b	r13		;
 240:	89 12       	call	r9		;
 242:	5c f3       	and.b	#1,	r12	;r3 As==01
 244:	0c 93       	cmp	#0,	r12	;r3 As==00
 246:	f9 23       	jnz	$-12     	;abs 0x23a
 248:	05 4c       	mov	r12,	r5	;
 24a:	36 40 04 04 	mov	#1028,	r6	;#0x0404
 24e:	47 43       	clr.b	r7		;

00000250 <.L33>:
 250:	3c 40 08 04 	mov	#1032,	r12	;#0x0408
 254:	4d 43       	clr.b	r13		;
 256:	89 12       	call	r9		;
 258:	0a 4c       	mov	r12,	r10	;
 25a:	5a f3       	and.b	#1,	r10	;r3 As==01
 25c:	0a 93       	cmp	#0,	r10	;r3 As==00
 25e:	f8 23       	jnz	$-14     	;abs 0x250
 260:	0c 46       	mov	r6,	r12	;
 262:	0d 47       	mov	r7,	r13	;
 264:	89 12       	call	r9		;
 266:	85 4c 40 80 	mov	r12,	-32704(r5); 0x8040
 26a:	85 4d 42 80 	mov	r13,	-32702(r5); 0x8042
 26e:	25 52       	add	#4,	r5	;r2 As==10
 270:	35 90 40 00 	cmp	#64,	r5	;#0x0040
 274:	ed 23       	jnz	$-36     	;abs 0x250
 276:	37 40 00 80 	mov	#32768,	r7	;#0x8000
 27a:	0e 45       	mov	r5,	r14	;
 27c:	0d 4a       	mov	r10,	r13	;
 27e:	0c 47       	mov	r7,	r12	;
 280:	b0 12 9e 08 	call	#2206		;#0x089e
 284:	35 40 40 80 	mov	#32832,	r5	;#0x8040
 288:	6c 45       	mov.b	@r5,	r12	;
 28a:	c7 4c 00 00 	mov.b	r12,	0(r7)	;
 28e:	d7 45 02 00 	mov.b	2(r5),	2(r7)	;
 292:	02 00 
 294:	d7 45 03 00 	mov.b	3(r5),	3(r7)	;
 298:	03 00 
 29a:	f2 40 03 00 	mov.b	#3,	&0x8001	;
 29e:	01 80 
 2a0:	4c 93       	cmp.b	#0,	r12	;r3 As==00
 2a2:	0b 24       	jz	$+24     	;abs 0x2ba
 2a4:	7c 90 53 00 	cmp.b	#83,	r12	;#0x0053
 2a8:	15 24       	jz	$+44     	;abs 0x2d4
 2aa:	3c 40 ca 09 	mov	#2506,	r12	;#0x09ca
 2ae:	b0 12 66 01 	call	#358		;#0x0166
 2b2:	e2 43 01 80 	mov.b	#2,	&0x8001	;r3 As==10
 2b6:	30 40 f6 02 	br	#0x02f6		;

000002ba <.L36>:
 2ba:	e2 43 08 80 	mov.b	#2,	&0x8008	;r3 As==10
 2be:	f2 40 11 00 	mov.b	#17,	&0x8009	;#0x0011
 2c2:	09 80 
 2c4:	d2 43 0a 80 	mov.b	#1,	&0x800a	;r3 As==01
 2c8:	d2 43 0c 80 	mov.b	#1,	&0x800c	;r3 As==01

000002cc <.L94>:
 2cc:	d2 43 01 80 	mov.b	#1,	&0x8001	;r3 As==01
 2d0:	30 40 f6 02 	br	#0x02f6		;

000002d4 <.L37>:
 2d4:	5c 45 08 00 	mov.b	8(r5),	r12	;
 2d8:	5c 93       	cmp.b	#1,	r12	;r3 As==01
 2da:	3a 24       	jz	$+118    	;abs 0x350
 2dc:	4c 93       	cmp.b	#0,	r12	;r3 As==00
 2de:	08 24       	jz	$+18     	;abs 0x2f0
 2e0:	6c 93       	cmp.b	#2,	r12	;r3 As==10
 2e2:	f4 23       	jnz	$-22     	;abs 0x2cc
 2e4:	d2 43 01 80 	mov.b	#1,	&0x8001	;r3 As==01
 2e8:	91 43 04 00 	mov	#1,	4(r1)	;r3 As==01
 2ec:	30 40 f6 02 	br	#0x02f6		;

000002f0 <.L41>:
 2f0:	f2 40 05 00 	mov.b	#5,	&0x8001	;
 2f4:	01 80 

000002f6 <.L38>:
 2f6:	4a 43       	clr.b	r10		;
 2f8:	35 40 92 00 	mov	#146,	r5	;#0x0092
 2fc:	36 40 00 04 	mov	#1024,	r6	;#0x0400
 300:	47 43       	clr.b	r7		;
 302:	04 45       	mov	r5,	r4	;

00000304 <.L71>:
 304:	1e 4a 00 80 	mov	-32768(r10),r14	;0xffff8000
 308:	1f 4a 02 80 	mov	-32766(r10),r15	;0xffff8002
 30c:	0c 46       	mov	r6,	r12	;
 30e:	0d 47       	mov	r7,	r13	;
 310:	85 12       	call	r5		;
 312:	2a 52       	add	#4,	r10	;r2 As==10
 314:	3a 90 40 00 	cmp	#64,	r10	;#0x0040
 318:	f5 23       	jnz	$-20     	;abs 0x304
 31a:	81 93 04 00 	cmp	#0,	4(r1)	;r3 As==00
 31e:	8d 27       	jz	$-228    	;abs 0x23a
 320:	5e 43       	mov.b	#1,	r14	;r3 As==01
 322:	4f 43       	clr.b	r15		;
 324:	7c 40 24 00 	mov.b	#36,	r12	;#0x0024
 328:	4d 43       	clr.b	r13		;
 32a:	85 12       	call	r5		;
 32c:	76 40 2c 00 	mov.b	#44,	r6	;#0x002c
 330:	47 43       	clr.b	r7		;

00000332 <.L73>:
 332:	0c 46       	mov	r6,	r12	;
 334:	0d 47       	mov	r7,	r13	;
 336:	89 12       	call	r9		;
 338:	1c 93       	cmp	#1,	r12	;r3 As==01
 33a:	02 20       	jnz	$+6      	;abs 0x340
 33c:	0d 93       	cmp	#0,	r13	;r3 As==00
 33e:	f9 27       	jz	$-12     	;abs 0x332

00000340 <.L83>:
 340:	5e 43       	mov.b	#1,	r14	;r3 As==01
 342:	4f 43       	clr.b	r15		;
 344:	7c 40 20 00 	mov.b	#32,	r12	;#0x0020
 348:	4d 43       	clr.b	r13		;
 34a:	84 12       	call	r4		;
 34c:	30 40 3a 02 	br	#0x023a		;

00000350 <.L40>:
 350:	5c 45 09 00 	mov.b	9(r5),	r12	;
 354:	0d 4a       	mov	r10,	r13	;
 356:	7e 40 18 00 	mov.b	#24,	r14	;#0x0018
 35a:	b0 12 70 07 	call	#1904		;#0x0770
 35e:	07 4c       	mov	r12,	r7	;
 360:	06 4d       	mov	r13,	r6	;
 362:	5c 45 0a 00 	mov.b	10(r5),	r12	;0x0000a
 366:	0d 4a       	mov	r10,	r13	;
 368:	7e 40 10 00 	mov.b	#16,	r14	;#0x0010
 36c:	b0 12 70 07 	call	#1904		;#0x0770
 370:	0c d7       	bis	r7,	r12	;
 372:	0d d6       	bis	r6,	r13	;
 374:	5e 45 0c 00 	mov.b	12(r5),	r14	;0x0000c
 378:	0c de       	bis	r14,	r12	;
 37a:	5e 45 0b 00 	mov.b	11(r5),	r14	;0x0000b
 37e:	06 4a       	mov	r10,	r6	;
 380:	0e 5e       	rla	r14		;
 382:	06 6a       	addc	r10,	r6	;
 384:	0e 5e       	rla	r14		;
 386:	06 66       	rlc	r6		;
 388:	0e 5e       	rla	r14		;
 38a:	06 66       	rlc	r6		;
 38c:	0e 5e       	rla	r14		;
 38e:	06 66       	rlc	r6		;
 390:	0e 5e       	rla	r14		;
 392:	06 66       	rlc	r6		;
 394:	0e 5e       	rla	r14		;
 396:	06 66       	rlc	r6		;
 398:	0e 5e       	rla	r14		;
 39a:	06 66       	rlc	r6		;
 39c:	0e 5e       	rla	r14		;
 39e:	06 66       	rlc	r6		;
 3a0:	0e dc       	bis	r12,	r14	;
 3a2:	06 dd       	bis	r13,	r6	;
 3a4:	06 de       	bis	r14,	r6	;
 3a6:	06 93       	cmp	#0,	r6	;r3 As==00
 3a8:	02 20       	jnz	$+6      	;abs 0x3ae
 3aa:	78 40 0a 00 	mov.b	#10,	r8	;#0x000a

000003ae <.L43>:
 3ae:	c2 93 4d 80 	cmp.b	#0,	&0x804d	;r3 As==00
 3b2:	44 24       	jz	$+138    	;abs 0x43c
 3b4:	76 40 40 00 	mov.b	#64,	r6	;#0x0040
 3b8:	47 43       	clr.b	r7		;
 3ba:	3a 40 66 01 	mov	#358,	r10	;#0x0166

000003be <.L75>:
 3be:	4c 48       	mov.b	r8,	r12	;
 3c0:	78 90 0e 00 	cmp.b	#14,	r8	;#0x000e
 3c4:	8e 24       	jz	$+286    	;abs 0x4e2
 3c6:	7d 40 0e 00 	mov.b	#14,	r13	;#0x000e
 3ca:	4d 98       	cmp.b	r8,	r13	;
 3cc:	22 28       	jnc	$+70     	;abs 0x412
 3ce:	78 90 0b 00 	cmp.b	#11,	r8	;#0x000b
 3d2:	44 24       	jz	$+138    	;abs 0x45c
 3d4:	38 40 92 00 	mov	#146,	r8	;#0x0092
 3d8:	7c 90 0d 00 	cmp.b	#13,	r12	;#0x000d
 3dc:	70 24       	jz	$+226    	;abs 0x4be
 3de:	7c 90 0a 00 	cmp.b	#10,	r12	;#0x000a
 3e2:	21 20       	jnz	$+68     	;abs 0x426
 3e4:	3e 43       	mov	#-1,	r14	;r3 As==11
 3e6:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 3ea:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 3ee:	4d 43       	clr.b	r13		;
 3f0:	88 12       	call	r8		;
 3f2:	3e 43       	mov	#-1,	r14	;r3 As==11
 3f4:	3f 40 5f f6 	mov	#63071,	r15	;#0xf65f
 3f8:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 3fc:	4d 43       	clr.b	r13		;
 3fe:	88 12       	call	r8		;
 400:	81 43 00 00 	mov	#0,	0(r1)	;r3 As==00
 404:	81 43 02 00 	mov	#0,	2(r1)	;r3 As==00
 408:	75 40 0b 00 	mov.b	#11,	r5	;#0x000b

0000040c <.L55>:
 40c:	08 45       	mov	r5,	r8	;
 40e:	30 40 be 03 	br	#0x03be		;

00000412 <.L47>:
 412:	78 90 11 00 	cmp.b	#17,	r8	;#0x0011
 416:	a7 24       	jz	$+336    	;abs 0x566
 418:	7e 40 11 00 	mov.b	#17,	r14	;#0x0011
 41c:	4e 98       	cmp.b	r8,	r14	;
 41e:	08 28       	jnc	$+18     	;abs 0x430
 420:	78 90 10 00 	cmp.b	#16,	r8	;#0x0010
 424:	8c 24       	jz	$+282    	;abs 0x53e

00000426 <.L45>:
 426:	f2 40 05 00 	mov.b	#5,	&0x8001	;
 42a:	01 80 
 42c:	30 40 56 04 	br	#0x0456		;

00000430 <.L52>:
 430:	78 90 14 00 	cmp.b	#20,	r8	;#0x0014
 434:	c7 24       	jz	$+400    	;abs 0x5c4
 436:	78 90 1e 00 	cmp.b	#30,	r8	;#0x001e
 43a:	f5 23       	jnz	$-20     	;abs 0x426

0000043c <.L44>:
 43c:	3e 43       	mov	#-1,	r14	;r3 As==11
 43e:	3f 43       	mov	#-1,	r15	;r3 As==11
 440:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 444:	4d 43       	clr.b	r13		;
 446:	b0 12 92 00 	call	#146		;#0x0092
 44a:	d2 43 01 80 	mov.b	#1,	&0x8001	;r3 As==01
 44e:	3c 40 b0 09 	mov	#2480,	r12	;#0x09b0
 452:	b0 12 66 01 	call	#358		;#0x0166

00000456 <.L96>:
 456:	48 43       	clr.b	r8		;
 458:	30 40 f6 02 	br	#0x02f6		;

0000045c <.L48>:
 45c:	0c 46       	mov	r6,	r12	;
 45e:	0d 47       	mov	r7,	r13	;
 460:	89 12       	call	r9		;
 462:	7c f0 13 00 	and.b	#19,	r12	;#0x0013
 466:	3c 90 10 00 	cmp	#16,	r12	;#0x0010
 46a:	26 20       	jnz	$+78     	;abs 0x4b8
 46c:	3e 43       	mov	#-1,	r14	;r3 As==11
 46e:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 472:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 476:	4d 43       	clr.b	r13		;
 478:	b0 12 92 00 	call	#146		;#0x0092
 47c:	3c 40 fe 08 	mov	#2302,	r12	;#0x08fe
 480:	8a 12       	call	r10		;
 482:	75 40 0d 00 	mov.b	#13,	r5	;#0x000d

00000486 <.L56>:
 486:	0c 46       	mov	r6,	r12	;
 488:	0d 47       	mov	r7,	r13	;
 48a:	89 12       	call	r9		;
 48c:	7c f0 13 00 	and.b	#19,	r12	;#0x0013
 490:	1c 93       	cmp	#1,	r12	;r3 As==01
 492:	04 20       	jnz	$+10     	;abs 0x49c
 494:	3c 40 0b 09 	mov	#2315,	r12	;#0x090b
 498:	8a 12       	call	r10		;
 49a:	05 48       	mov	r8,	r5	;

0000049c <.L57>:
 49c:	0c 46       	mov	r6,	r12	;
 49e:	0d 47       	mov	r7,	r13	;
 4a0:	89 12       	call	r9		;
 4a2:	08 4c       	mov	r12,	r8	;
 4a4:	78 f0 13 00 	and.b	#19,	r8	;#0x0013
 4a8:	08 93       	cmp	#0,	r8	;r3 As==00
 4aa:	b0 23       	jnz	$-158    	;abs 0x40c
 4ac:	3c 40 19 09 	mov	#2329,	r12	;#0x0919

000004b0 <.L97>:
 4b0:	8a 12       	call	r10		;
 4b2:	05 48       	mov	r8,	r5	;
 4b4:	30 40 0c 04 	br	#0x040c		;

000004b8 <.L76>:
 4b8:	05 48       	mov	r8,	r5	;
 4ba:	30 40 86 04 	br	#0x0486		;

000004be <.L49>:
 4be:	3e 43       	mov	#-1,	r14	;r3 As==11
 4c0:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 4c4:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 4c8:	4d 43       	clr.b	r13		;
 4ca:	88 12       	call	r8		;
 4cc:	3e 43       	mov	#-1,	r14	;r3 As==11
 4ce:	3f 40 1f f6 	mov	#63007,	r15	;#0xf61f
 4d2:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 4d6:	4d 43       	clr.b	r13		;
 4d8:	88 12       	call	r8		;
 4da:	75 40 0e 00 	mov.b	#14,	r5	;#0x000e
 4de:	30 40 0c 04 	br	#0x040c		;

000004e2 <.L46>:
 4e2:	0c 46       	mov	r6,	r12	;
 4e4:	0d 47       	mov	r7,	r13	;
 4e6:	89 12       	call	r9		;
 4e8:	05 4c       	mov	r12,	r5	;
 4ea:	75 f0 13 00 	and.b	#19,	r5	;#0x0013
 4ee:	35 90 10 00 	cmp	#16,	r5	;#0x0010
 4f2:	22 20       	jnz	$+70     	;abs 0x538
 4f4:	3e 43       	mov	#-1,	r14	;r3 As==11
 4f6:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 4fa:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 4fe:	4d 43       	clr.b	r13		;
 500:	b0 12 92 00 	call	#146		;#0x0092
 504:	3c 40 2c 09 	mov	#2348,	r12	;#0x092c
 508:	8a 12       	call	r10		;

0000050a <.L58>:
 50a:	0c 46       	mov	r6,	r12	;
 50c:	0d 47       	mov	r7,	r13	;
 50e:	89 12       	call	r9		;
 510:	7c f0 13 00 	and.b	#19,	r12	;#0x0013
 514:	1c 93       	cmp	#1,	r12	;r3 As==01
 516:	04 20       	jnz	$+10     	;abs 0x520
 518:	3c 40 3c 09 	mov	#2364,	r12	;#0x093c
 51c:	8a 12       	call	r10		;
 51e:	05 48       	mov	r8,	r5	;

00000520 <.L59>:
 520:	0c 46       	mov	r6,	r12	;
 522:	0d 47       	mov	r7,	r13	;
 524:	89 12       	call	r9		;
 526:	08 4c       	mov	r12,	r8	;
 528:	78 f0 13 00 	and.b	#19,	r8	;#0x0013
 52c:	08 93       	cmp	#0,	r8	;r3 As==00
 52e:	6e 23       	jnz	$-290    	;abs 0x40c
 530:	3c 40 4d 09 	mov	#2381,	r12	;#0x094d
 534:	30 40 b0 04 	br	#0x04b0		;

00000538 <.L77>:
 538:	05 48       	mov	r8,	r5	;
 53a:	30 40 0a 05 	br	#0x050a		;

0000053e <.L53>:
 53e:	38 40 92 00 	mov	#146,	r8	;#0x0092
 542:	3e 43       	mov	#-1,	r14	;r3 As==11
 544:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 548:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 54c:	4d 43       	clr.b	r13		;
 54e:	88 12       	call	r8		;
 550:	3e 43       	mov	#-1,	r14	;r3 As==11
 552:	3f 40 2f f6 	mov	#63023,	r15	;#0xf62f
 556:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 55a:	4d 43       	clr.b	r13		;
 55c:	88 12       	call	r8		;
 55e:	75 40 11 00 	mov.b	#17,	r5	;#0x0011
 562:	30 40 0c 04 	br	#0x040c		;

00000566 <.L51>:
 566:	0c 46       	mov	r6,	r12	;
 568:	0d 47       	mov	r7,	r13	;
 56a:	89 12       	call	r9		;
 56c:	7c f0 13 00 	and.b	#19,	r12	;#0x0013
 570:	3c 90 10 00 	cmp	#16,	r12	;#0x0010
 574:	24 20       	jnz	$+74     	;abs 0x5be
 576:	3e 43       	mov	#-1,	r14	;r3 As==11
 578:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 57c:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 580:	4d 43       	clr.b	r13		;
 582:	b0 12 92 00 	call	#146		;#0x0092
 586:	3c 40 63 09 	mov	#2403,	r12	;#0x0963
 58a:	8a 12       	call	r10		;
 58c:	75 40 14 00 	mov.b	#20,	r5	;#0x0014

00000590 <.L60>:
 590:	0c 46       	mov	r6,	r12	;
 592:	0d 47       	mov	r7,	r13	;
 594:	89 12       	call	r9		;
 596:	7c f0 13 00 	and.b	#19,	r12	;#0x0013
 59a:	1c 93       	cmp	#1,	r12	;r3 As==01
 59c:	04 20       	jnz	$+10     	;abs 0x5a6
 59e:	3c 40 73 09 	mov	#2419,	r12	;#0x0973
 5a2:	8a 12       	call	r10		;
 5a4:	05 48       	mov	r8,	r5	;

000005a6 <.L61>:
 5a6:	0c 46       	mov	r6,	r12	;
 5a8:	0d 47       	mov	r7,	r13	;
 5aa:	89 12       	call	r9		;
 5ac:	08 4c       	mov	r12,	r8	;
 5ae:	78 f0 13 00 	and.b	#19,	r8	;#0x0013
 5b2:	08 93       	cmp	#0,	r8	;r3 As==00
 5b4:	2b 23       	jnz	$-424    	;abs 0x40c
 5b6:	3c 40 84 09 	mov	#2436,	r12	;#0x0984
 5ba:	30 40 b0 04 	br	#0x04b0		;

000005be <.L78>:
 5be:	05 48       	mov	r8,	r5	;
 5c0:	30 40 90 05 	br	#0x0590		;

000005c4 <.L54>:
 5c4:	37 40 60 80 	mov	#32864,	r7	;#0x8060
 5c8:	36 40 ba 00 	mov	#186,	r6	;#0x00ba

000005cc <.L69>:
 5cc:	6c 47       	mov.b	@r7,	r12	;
 5ce:	86 12       	call	r6		;
 5d0:	44 4c       	mov.b	r12,	r4	;
 5d2:	5c 47 01 00 	mov.b	1(r7),	r12	;
 5d6:	86 12       	call	r6		;
 5d8:	45 4c       	mov.b	r12,	r5	;
 5da:	5c 47 02 00 	mov.b	2(r7),	r12	;
 5de:	86 12       	call	r6		;
 5e0:	4a 4c       	mov.b	r12,	r10	;
 5e2:	5c 47 03 00 	mov.b	3(r7),	r12	;
 5e6:	86 12       	call	r6		;
 5e8:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
 5ec:	81 4c 06 00 	mov	r12,	6(r1)	;
 5f0:	6c 43       	mov.b	#2,	r12	;r3 As==10
 5f2:	1c 91 02 00 	cmp	2(r1),	r12	;
 5f6:	6a 28       	jnc	$+214    	;abs 0x6cc
 5f8:	1c 41 02 00 	mov	2(r1),	r12	;
 5fc:	2c 93       	cmp	#2,	r12	;r3 As==10
 5fe:	04 20       	jnz	$+10     	;abs 0x608
 600:	3d 40 ff 2f 	mov	#12287,	r13	;#0x2fff
 604:	2d 91       	cmp	@r1,	r13	;
 606:	62 28       	jnc	$+198    	;abs 0x6cc

00000608 <.L80>:
 608:	0c 44       	mov	r4,	r12	;
 60a:	4d 43       	clr.b	r13		;
 60c:	7e 40 18 00 	mov.b	#24,	r14	;#0x0018
 610:	b0 12 70 07 	call	#1904		;#0x0770
 614:	04 4a       	mov	r10,	r4	;
 616:	4e 43       	clr.b	r14		;
 618:	04 5a       	add	r10,	r4	;
 61a:	0e 6e       	rlc	r14		;
 61c:	04 54       	rla	r4		;
 61e:	0e 6e       	rlc	r14		;
 620:	04 54       	rla	r4		;
 622:	0e 6e       	rlc	r14		;
 624:	04 54       	rla	r4		;
 626:	0e 6e       	rlc	r14		;
 628:	04 54       	rla	r4		;
 62a:	0e 6e       	rlc	r14		;
 62c:	04 54       	rla	r4		;
 62e:	0e 6e       	rlc	r14		;
 630:	04 54       	rla	r4		;
 632:	0e 6e       	rlc	r14		;
 634:	04 54       	rla	r4		;
 636:	0e 6e       	rlc	r14		;
 638:	04 dc       	bis	r12,	r4	;
 63a:	0a 4d       	mov	r13,	r10	;
 63c:	0a de       	bis	r14,	r10	;
 63e:	14 d1 06 00 	bis	6(r1),	r4	;
 642:	0c 45       	mov	r5,	r12	;
 644:	4d 43       	clr.b	r13		;
 646:	7e 40 10 00 	mov.b	#16,	r14	;#0x0010
 64a:	b0 12 70 07 	call	#1904		;#0x0770
 64e:	4f 4d       	mov.b	r13,	r15	;
 650:	2c 41       	mov	@r1,	r12	;
 652:	0c 5c       	rla	r12		;
 654:	1d 41 02 00 	mov	2(r1),	r13	;
 658:	0d 6d       	rlc	r13		;
 65a:	0c 5c       	rla	r12		;
 65c:	0d 6d       	rlc	r13		;
 65e:	0e 44       	mov	r4,	r14	;
 660:	0f da       	bis	r10,	r15	;
 662:	0c 53       	add	#0,	r12	;r3 As==00
 664:	3d 60 10 00 	addc	#16,	r13	;#0x0010
 668:	b0 12 92 00 	call	#146		;#0x0092

0000066c <.L64>:
 66c:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 670:	4d 43       	clr.b	r13		;
 672:	89 12       	call	r9		;
 674:	7c f0 0b 00 	and.b	#11,	r12	;#0x000b
 678:	2c 93       	cmp	#2,	r12	;r3 As==10
 67a:	f8 27       	jz	$-14     	;abs 0x66c
 67c:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 680:	4d 43       	clr.b	r13		;
 682:	89 12       	call	r9		;
 684:	3c b0 0b 00 	bit	#11,	r12	;#0x000b
 688:	0a 20       	jnz	$+22     	;abs 0x69e
 68a:	3c 40 9a 09 	mov	#2458,	r12	;#0x099a
 68e:	b0 12 66 01 	call	#358		;#0x0166
 692:	b1 40 60 ae 	mov	#44640,	0(r1)	;#0xae60
 696:	00 00 
 698:	b1 40 0a 00 	mov	#10,	2(r1)	;#0x000a
 69c:	02 00 

0000069e <.L66>:
 69e:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 6a2:	4d 43       	clr.b	r13		;
 6a4:	89 12       	call	r9		;
 6a6:	2c 41       	mov	@r1,	r12	;
 6a8:	3c 90 ff 1f 	cmp	#8191,	r12	;#0x1fff
 6ac:	04 20       	jnz	$+10     	;abs 0x6b6
 6ae:	1c 41 02 00 	mov	2(r1),	r12	;
 6b2:	0c 93       	cmp	#0,	r12	;r3 As==00
 6b4:	10 24       	jz	$+34     	;abs 0x6d6

000006b6 <.L82>:
 6b6:	91 53 00 00 	inc	0(r1)		;
 6ba:	81 63 02 00 	adc	2(r1)		;

000006be <.L67>:
 6be:	27 52       	add	#4,	r7	;r2 As==10
 6c0:	3e 40 80 80 	mov	#32896,	r14	;#0x8080
 6c4:	0e 97       	cmp	r7,	r14	;
 6c6:	82 23       	jnz	$-250    	;abs 0x5cc
 6c8:	30 40 cc 02 	br	#0x02cc		;

000006cc <.L62>:
 6cc:	f2 40 05 00 	mov.b	#5,	&0x8001	;
 6d0:	01 80 
 6d2:	30 40 be 06 	br	#0x06be		;

000006d6 <.L95>:
 6d6:	b1 40 00 28 	mov	#10240,	0(r1)	;#0x2800
 6da:	00 00 
 6dc:	91 43 02 00 	mov	#1,	2(r1)	;r3 As==01
 6e0:	30 40 be 06 	br	#0x06be		;

000006e4 <.L30>:
 6e4:	3c 40 dd 08 	mov	#2269,	r12	;#0x08dd
 6e8:	89 12       	call	r9		;
 6ea:	5c 43       	mov.b	#1,	r12	;r3 As==01
 6ec:	31 52       	add	#8,	r1	;r2 As==11
 6ee:	30 40 f2 06 	br	#0x06f2		;

000006f2 <__mspabi_func_epilog_7>:
 6f2:	34 41       	pop	r4		;

000006f4 <__mspabi_func_epilog_6>:
 6f4:	35 41       	pop	r5		;

000006f6 <__mspabi_func_epilog_5>:
 6f6:	36 41       	pop	r6		;

000006f8 <__mspabi_func_epilog_4>:
 6f8:	37 41       	pop	r7		;

000006fa <__mspabi_func_epilog_3>:
 6fa:	38 41       	pop	r8		;

000006fc <__mspabi_func_epilog_2>:
 6fc:	39 41       	pop	r9		;

000006fe <__mspabi_func_epilog_1>:
 6fe:	3a 41       	pop	r10		;
 700:	30 41       	ret			

00000702 <__mspabi_slli_15>:
 702:	0c 5c       	rla	r12		;

00000704 <__mspabi_slli_14>:
 704:	0c 5c       	rla	r12		;

00000706 <__mspabi_slli_13>:
 706:	0c 5c       	rla	r12		;

00000708 <__mspabi_slli_12>:
 708:	0c 5c       	rla	r12		;

0000070a <__mspabi_slli_11>:
 70a:	0c 5c       	rla	r12		;

0000070c <__mspabi_slli_10>:
 70c:	0c 5c       	rla	r12		;

0000070e <__mspabi_slli_9>:
 70e:	0c 5c       	rla	r12		;

00000710 <__mspabi_slli_8>:
 710:	0c 5c       	rla	r12		;

00000712 <__mspabi_slli_7>:
 712:	0c 5c       	rla	r12		;

00000714 <__mspabi_slli_6>:
 714:	0c 5c       	rla	r12		;

00000716 <__mspabi_slli_5>:
 716:	0c 5c       	rla	r12		;

00000718 <__mspabi_slli_4>:
 718:	0c 5c       	rla	r12		;

0000071a <__mspabi_slli_3>:
 71a:	0c 5c       	rla	r12		;

0000071c <__mspabi_slli_2>:
 71c:	0c 5c       	rla	r12		;

0000071e <__mspabi_slli_1>:
 71e:	0c 5c       	rla	r12		;
 720:	30 41       	ret			

00000722 <.L11>:
 722:	3d 53       	add	#-1,	r13	;r3 As==11
 724:	0c 5c       	rla	r12		;

00000726 <__mspabi_slli>:
 726:	0d 93       	cmp	#0,	r13	;r3 As==00
 728:	fc 23       	jnz	$-6      	;abs 0x722
 72a:	30 41       	ret			

0000072c <__mspabi_slll_15>:
 72c:	0c 5c       	rla	r12		;
 72e:	0d 6d       	rlc	r13		;

00000730 <__mspabi_slll_14>:
 730:	0c 5c       	rla	r12		;
 732:	0d 6d       	rlc	r13		;

00000734 <__mspabi_slll_13>:
 734:	0c 5c       	rla	r12		;
 736:	0d 6d       	rlc	r13		;

00000738 <__mspabi_slll_12>:
 738:	0c 5c       	rla	r12		;
 73a:	0d 6d       	rlc	r13		;

0000073c <__mspabi_slll_11>:
 73c:	0c 5c       	rla	r12		;
 73e:	0d 6d       	rlc	r13		;

00000740 <__mspabi_slll_10>:
 740:	0c 5c       	rla	r12		;
 742:	0d 6d       	rlc	r13		;

00000744 <__mspabi_slll_9>:
 744:	0c 5c       	rla	r12		;
 746:	0d 6d       	rlc	r13		;

00000748 <__mspabi_slll_8>:
 748:	0c 5c       	rla	r12		;
 74a:	0d 6d       	rlc	r13		;

0000074c <__mspabi_slll_7>:
 74c:	0c 5c       	rla	r12		;
 74e:	0d 6d       	rlc	r13		;

00000750 <__mspabi_slll_6>:
 750:	0c 5c       	rla	r12		;
 752:	0d 6d       	rlc	r13		;

00000754 <__mspabi_slll_5>:
 754:	0c 5c       	rla	r12		;
 756:	0d 6d       	rlc	r13		;

00000758 <__mspabi_slll_4>:
 758:	0c 5c       	rla	r12		;
 75a:	0d 6d       	rlc	r13		;

0000075c <__mspabi_slll_3>:
 75c:	0c 5c       	rla	r12		;
 75e:	0d 6d       	rlc	r13		;

00000760 <__mspabi_slll_2>:
 760:	0c 5c       	rla	r12		;
 762:	0d 6d       	rlc	r13		;

00000764 <__mspabi_slll_1>:
 764:	0c 5c       	rla	r12		;
 766:	0d 6d       	rlc	r13		;
 768:	30 41       	ret			

0000076a <.L12>:
 76a:	3e 53       	add	#-1,	r14	;r3 As==11
 76c:	0c 5c       	rla	r12		;
 76e:	0d 6d       	rlc	r13		;

00000770 <__mspabi_slll>:
 770:	0e 93       	cmp	#0,	r14	;r3 As==00
 772:	fb 23       	jnz	$-8      	;abs 0x76a
 774:	30 41       	ret			

00000776 <__mspabi_srai_15>:
 776:	0c 11       	rra	r12		;

00000778 <__mspabi_srai_14>:
 778:	0c 11       	rra	r12		;

0000077a <__mspabi_srai_13>:
 77a:	0c 11       	rra	r12		;

0000077c <__mspabi_srai_12>:
 77c:	0c 11       	rra	r12		;

0000077e <__mspabi_srai_11>:
 77e:	0c 11       	rra	r12		;

00000780 <__mspabi_srai_10>:
 780:	0c 11       	rra	r12		;

00000782 <__mspabi_srai_9>:
 782:	0c 11       	rra	r12		;

00000784 <__mspabi_srai_8>:
 784:	0c 11       	rra	r12		;

00000786 <__mspabi_srai_7>:
 786:	0c 11       	rra	r12		;

00000788 <__mspabi_srai_6>:
 788:	0c 11       	rra	r12		;

0000078a <__mspabi_srai_5>:
 78a:	0c 11       	rra	r12		;

0000078c <__mspabi_srai_4>:
 78c:	0c 11       	rra	r12		;

0000078e <__mspabi_srai_3>:
 78e:	0c 11       	rra	r12		;

00000790 <__mspabi_srai_2>:
 790:	0c 11       	rra	r12		;

00000792 <__mspabi_srai_1>:
 792:	0c 11       	rra	r12		;
 794:	30 41       	ret			

00000796 <.L11>:
 796:	3d 53       	add	#-1,	r13	;r3 As==11
 798:	0c 11       	rra	r12		;

0000079a <__mspabi_srai>:
 79a:	0d 93       	cmp	#0,	r13	;r3 As==00
 79c:	fc 23       	jnz	$-6      	;abs 0x796
 79e:	30 41       	ret			

000007a0 <__mspabi_sral_15>:
 7a0:	0d 11       	rra	r13		;
 7a2:	0c 10       	rrc	r12		;

000007a4 <__mspabi_sral_14>:
 7a4:	0d 11       	rra	r13		;
 7a6:	0c 10       	rrc	r12		;

000007a8 <__mspabi_sral_13>:
 7a8:	0d 11       	rra	r13		;
 7aa:	0c 10       	rrc	r12		;

000007ac <__mspabi_sral_12>:
 7ac:	0d 11       	rra	r13		;
 7ae:	0c 10       	rrc	r12		;

000007b0 <__mspabi_sral_11>:
 7b0:	0d 11       	rra	r13		;
 7b2:	0c 10       	rrc	r12		;

000007b4 <__mspabi_sral_10>:
 7b4:	0d 11       	rra	r13		;
 7b6:	0c 10       	rrc	r12		;

000007b8 <__mspabi_sral_9>:
 7b8:	0d 11       	rra	r13		;
 7ba:	0c 10       	rrc	r12		;

000007bc <__mspabi_sral_8>:
 7bc:	0d 11       	rra	r13		;
 7be:	0c 10       	rrc	r12		;

000007c0 <__mspabi_sral_7>:
 7c0:	0d 11       	rra	r13		;
 7c2:	0c 10       	rrc	r12		;

000007c4 <__mspabi_sral_6>:
 7c4:	0d 11       	rra	r13		;
 7c6:	0c 10       	rrc	r12		;

000007c8 <__mspabi_sral_5>:
 7c8:	0d 11       	rra	r13		;
 7ca:	0c 10       	rrc	r12		;

000007cc <__mspabi_sral_4>:
 7cc:	0d 11       	rra	r13		;
 7ce:	0c 10       	rrc	r12		;

000007d0 <__mspabi_sral_3>:
 7d0:	0d 11       	rra	r13		;
 7d2:	0c 10       	rrc	r12		;

000007d4 <__mspabi_sral_2>:
 7d4:	0d 11       	rra	r13		;
 7d6:	0c 10       	rrc	r12		;

000007d8 <__mspabi_sral_1>:
 7d8:	0d 11       	rra	r13		;
 7da:	0c 10       	rrc	r12		;
 7dc:	30 41       	ret			

000007de <.L12>:
 7de:	3e 53       	add	#-1,	r14	;r3 As==11
 7e0:	0d 11       	rra	r13		;
 7e2:	0c 10       	rrc	r12		;

000007e4 <__mspabi_sral>:
 7e4:	0e 93       	cmp	#0,	r14	;r3 As==00
 7e6:	fb 23       	jnz	$-8      	;abs 0x7de
 7e8:	30 41       	ret			

000007ea <__mspabi_srli_15>:
 7ea:	12 c3       	clrc			
 7ec:	0c 10       	rrc	r12		;

000007ee <__mspabi_srli_14>:
 7ee:	12 c3       	clrc			
 7f0:	0c 10       	rrc	r12		;

000007f2 <__mspabi_srli_13>:
 7f2:	12 c3       	clrc			
 7f4:	0c 10       	rrc	r12		;

000007f6 <__mspabi_srli_12>:
 7f6:	12 c3       	clrc			
 7f8:	0c 10       	rrc	r12		;

000007fa <__mspabi_srli_11>:
 7fa:	12 c3       	clrc			
 7fc:	0c 10       	rrc	r12		;

000007fe <__mspabi_srli_10>:
 7fe:	12 c3       	clrc			
 800:	0c 10       	rrc	r12		;

00000802 <__mspabi_srli_9>:
 802:	12 c3       	clrc			
 804:	0c 10       	rrc	r12		;

00000806 <__mspabi_srli_8>:
 806:	12 c3       	clrc			
 808:	0c 10       	rrc	r12		;

0000080a <__mspabi_srli_7>:
 80a:	12 c3       	clrc			
 80c:	0c 10       	rrc	r12		;

0000080e <__mspabi_srli_6>:
 80e:	12 c3       	clrc			
 810:	0c 10       	rrc	r12		;

00000812 <__mspabi_srli_5>:
 812:	12 c3       	clrc			
 814:	0c 10       	rrc	r12		;

00000816 <__mspabi_srli_4>:
 816:	12 c3       	clrc			
 818:	0c 10       	rrc	r12		;

0000081a <__mspabi_srli_3>:
 81a:	12 c3       	clrc			
 81c:	0c 10       	rrc	r12		;

0000081e <__mspabi_srli_2>:
 81e:	12 c3       	clrc			
 820:	0c 10       	rrc	r12		;

00000822 <__mspabi_srli_1>:
 822:	12 c3       	clrc			
 824:	0c 10       	rrc	r12		;
 826:	30 41       	ret			

00000828 <.L11>:
 828:	3d 53       	add	#-1,	r13	;r3 As==11
 82a:	12 c3       	clrc			
 82c:	0c 10       	rrc	r12		;

0000082e <__mspabi_srli>:
 82e:	0d 93       	cmp	#0,	r13	;r3 As==00
 830:	fb 23       	jnz	$-8      	;abs 0x828
 832:	30 41       	ret			

00000834 <__mspabi_srll_15>:
 834:	12 c3       	clrc			
 836:	0d 10       	rrc	r13		;
 838:	0c 10       	rrc	r12		;

0000083a <__mspabi_srll_14>:
 83a:	12 c3       	clrc			
 83c:	0d 10       	rrc	r13		;
 83e:	0c 10       	rrc	r12		;

00000840 <__mspabi_srll_13>:
 840:	12 c3       	clrc			
 842:	0d 10       	rrc	r13		;
 844:	0c 10       	rrc	r12		;

00000846 <__mspabi_srll_12>:
 846:	12 c3       	clrc			
 848:	0d 10       	rrc	r13		;
 84a:	0c 10       	rrc	r12		;

0000084c <__mspabi_srll_11>:
 84c:	12 c3       	clrc			
 84e:	0d 10       	rrc	r13		;
 850:	0c 10       	rrc	r12		;

00000852 <__mspabi_srll_10>:
 852:	12 c3       	clrc			
 854:	0d 10       	rrc	r13		;
 856:	0c 10       	rrc	r12		;

00000858 <__mspabi_srll_9>:
 858:	12 c3       	clrc			
 85a:	0d 10       	rrc	r13		;
 85c:	0c 10       	rrc	r12		;

0000085e <__mspabi_srll_8>:
 85e:	12 c3       	clrc			
 860:	0d 10       	rrc	r13		;
 862:	0c 10       	rrc	r12		;

00000864 <__mspabi_srll_7>:
 864:	12 c3       	clrc			
 866:	0d 10       	rrc	r13		;
 868:	0c 10       	rrc	r12		;

0000086a <__mspabi_srll_6>:
 86a:	12 c3       	clrc			
 86c:	0d 10       	rrc	r13		;
 86e:	0c 10       	rrc	r12		;

00000870 <__mspabi_srll_5>:
 870:	12 c3       	clrc			
 872:	0d 10       	rrc	r13		;
 874:	0c 10       	rrc	r12		;

00000876 <__mspabi_srll_4>:
 876:	12 c3       	clrc			
 878:	0d 10       	rrc	r13		;
 87a:	0c 10       	rrc	r12		;

0000087c <__mspabi_srll_3>:
 87c:	12 c3       	clrc			
 87e:	0d 10       	rrc	r13		;
 880:	0c 10       	rrc	r12		;

00000882 <__mspabi_srll_2>:
 882:	12 c3       	clrc			
 884:	0d 10       	rrc	r13		;
 886:	0c 10       	rrc	r12		;

00000888 <__mspabi_srll_1>:
 888:	12 c3       	clrc			
 88a:	0d 10       	rrc	r13		;
 88c:	0c 10       	rrc	r12		;
 88e:	30 41       	ret			

00000890 <.L12>:
 890:	3e 53       	add	#-1,	r14	;r3 As==11
 892:	12 c3       	clrc			
 894:	0d 10       	rrc	r13		;
 896:	0c 10       	rrc	r12		;

00000898 <__mspabi_srll>:
 898:	0e 93       	cmp	#0,	r14	;r3 As==00
 89a:	fa 23       	jnz	$-10     	;abs 0x890
 89c:	30 41       	ret			

0000089e <memset>:
 89e:	0f 4c       	mov	r12,	r15	;
 8a0:	0e 5c       	add	r12,	r14	;

000008a2 <.L2>:
 8a2:	0f 9e       	cmp	r14,	r15	;
 8a4:	01 20       	jnz	$+4      	;abs 0x8a8

000008a6 <.Loc.104.1>:
 8a6:	30 41       	ret			

000008a8 <.L3>:
 8a8:	cf 4d 00 00 	mov.b	r13,	0(r15)	;
 8ac:	1f 53       	inc	r15		;

000008ae <.LVL4>:
 8ae:	30 40 a2 08 	br	#0x08a2		;

Disassembly of section .rodata:

000008b2 <_etext-0x12a>:
 8b2:	0a 4c       	mov	r12,	r10	;
 8b4:	69 6d       	addc.b	@r13,	r9	;
 8b6:	65 53       	incd.b	r5		;
 8b8:	44 52       	add.b	r2,	r4	;
 8ba:	2d 4d       	mov	@r13,	r13	;
 8bc:	69 6e       	addc.b	@r14,	r9	;
 8be:	69 20       	jnz	$+212    	;abs 0x992
 8c0:	46 61       	addc.b	r1,	r6	;
 8c2:	63 74       	.word	0x7463;	????
 8c4:	6f 72       	subc.b	#4,	r15	;r2 As==10
 8c6:	79 20       	jnz	$+244    	;abs 0x9ba
 8c8:	46 69       	addc.b	r9,	r6	;
 8ca:	72 6d       	addc.b	@r13+,	r2	;
 8cc:	77 61       	addc.b	@r1+,	r7	;
 8ce:	72 65       	addc.b	@r5+,	r2	;
 8d0:	20 56       	add	@r6,	r0	;
 8d2:	65 72       	subc.b	#4,	r5	;r2 As==10
 8d4:	73 69       	.word	0x6973;	????
 8d6:	6f 6e       	addc.b	@r14,	r15	;
 8d8:	3a 20       	jnz	$+118    	;abs 0x94e
 8da:	32 0a 00 45 	mova	17664(r10),r2	;0x04500
 8de:	72 72       	subc.b	#8,	r2	;r2 As==11
 8e0:	6f 72       	subc.b	#4,	r15	;r2 As==10
 8e2:	21 20       	jnz	$+68     	;abs 0x926
 8e4:	4e 6f       	addc.b	r15,	r14	;
 8e6:	20 47       	br	@r7		;
 8e8:	50 49 4f 20 	br	8271(r9)		;
 8ec:	75 6e       	addc.b	@r14+,	r5	;
 8ee:	69 74       	subc.b	@r4,	r9	;
 8f0:	20 73       	subc	#2,	r0	;r3 As==10
 8f2:	79 6e       	addc.b	@r14+,	r9	;
 8f4:	74 68       	addc.b	@r8+,	r4	;
 8f6:	65 73       	subc.b	#2,	r5	;r3 As==10
 8f8:	69 7a       	subc.b	@r10,	r9	;
 8fa:	65 64       	addc.b	@r4,	r5	;
 8fc:	21 00 43 46 	mova	&17987,	r1	;0x04643
 900:	4d 30       	jn	$+156    	;abs 0x99c
 902:	20 45       	br	@r5		;
 904:	72 61       	addc.b	@r1+,	r2	;
 906:	73 65       	.word	0x6573;	????
 908:	64 0a 00 45 	mova	r10,	&279808	; 0x44500
 90c:	72 61       	addc.b	@r1+,	r2	;
 90e:	73 69       	.word	0x6973;	????
 910:	6e 67       	addc.b	@r7,	r14	;
 912:	20 43       	br	#2		;r3 As==10
 914:	46 4d       	mov.b	r13,	r6	;
 916:	30 0a 00 45 	bra	17664(r10)	;0x04500
 91a:	72 61       	addc.b	@r1+,	r2	;
 91c:	73 65       	.word	0x6573;	????
 91e:	20 43       	br	#2		;r3 As==10
 920:	46 4d       	mov.b	r13,	r6	;
 922:	30 20       	jnz	$+98     	;abs 0x984
 924:	46 61       	addc.b	r1,	r6	;
 926:	69 6c       	addc.b	@r12,	r9	;
 928:	65 64       	addc.b	@r4,	r5	;
 92a:	0a 00       	mova	@r0,	r10	;
 92c:	55 46 4d 20 	mov.b	8269(r6),r5	;0x0204d
 930:	49 44       	mov.b	r4,	r9	;
 932:	31 20       	jnz	$+100    	;abs 0x996
 934:	45 72       	subc.b	r2,	r5	;
 936:	61 73       	subc.b	#2,	r1	;r3 As==10
 938:	65 64       	addc.b	@r4,	r5	;
 93a:	0a 00       	mova	@r0,	r10	;
 93c:	45 72       	subc.b	r2,	r5	;
 93e:	61 73       	subc.b	#2,	r1	;r3 As==10
 940:	69 6e       	addc.b	@r14,	r9	;
 942:	67 20       	jnz	$+208    	;abs 0xa12
 944:	55 46 4d 20 	mov.b	8269(r6),r5	;0x0204d
 948:	49 44       	mov.b	r4,	r9	;
 94a:	31 0a 00 45 	mova	17664(r10),r1	;0x04500
 94e:	72 61       	addc.b	@r1+,	r2	;
 950:	73 65       	.word	0x6573;	????
 952:	20 55       	add	@r5,	r0	;
 954:	46 4d       	mov.b	r13,	r6	;
 956:	20 49       	br	@r9		;
 958:	44 31       	jn	$+650    	;abs 0xbe2
 95a:	20 46       	br	@r6		;
 95c:	61 69       	addc.b	@r9,	r1	;
 95e:	6c 65       	addc.b	@r5,	r12	;
 960:	64 0a 00 55 	mova	r10,	&283904	; 0x45500
 964:	46 4d       	mov.b	r13,	r6	;
 966:	20 49       	br	@r9		;
 968:	44 32       	jn	$-886    	;abs 0x5f2
 96a:	20 45       	br	@r5		;
 96c:	72 61       	addc.b	@r1+,	r2	;
 96e:	73 65       	.word	0x6573;	????
 970:	64 0a 00 45 	mova	r10,	&279808	; 0x44500
 974:	72 61       	addc.b	@r1+,	r2	;
 976:	73 69       	.word	0x6973;	????
 978:	6e 67       	addc.b	@r7,	r14	;
 97a:	20 55       	add	@r5,	r0	;
 97c:	46 4d       	mov.b	r13,	r6	;
 97e:	20 49       	br	@r9		;
 980:	44 32       	jn	$-886    	;abs 0x60a
 982:	0a 00       	mova	@r0,	r10	;
 984:	45 72       	subc.b	r2,	r5	;
 986:	61 73       	subc.b	#2,	r1	;r3 As==10
 988:	65 20       	jnz	$+204    	;abs 0xa54
 98a:	55 46 4d 20 	mov.b	8269(r6),r5	;0x0204d
 98e:	49 44       	mov.b	r4,	r9	;
 990:	32 20       	jnz	$+102    	;abs 0x9f6
 992:	46 61       	addc.b	r1,	r6	;
 994:	69 6c       	addc.b	@r12,	r9	;
 996:	65 64       	addc.b	@r4,	r5	;
 998:	0a 00       	mova	@r0,	r10	;
 99a:	57 72 69 74 	subc.b	&0x7469,r7	;0x7469
 99e:	65 20       	jnz	$+204    	;abs 0xa6a
 9a0:	74 6f       	addc.b	@r15+,	r4	;
 9a2:	20 61       	addc	@r1,	r0	;
 9a4:	64 64       	addc.b	@r4,	r4	;
 9a6:	72 20       	jnz	$+230    	;abs 0xa8c
 9a8:	66 61       	addc.b	@r1,	r6	;
 9aa:	69 6c       	addc.b	@r12,	r9	;
 9ac:	65 64       	addc.b	@r4,	r5	;
 9ae:	0a 00       	mova	@r0,	r10	;
 9b0:	50 72 6f 67 	subc.b	&0x676f,r0	;0x676f
 9b4:	72 61       	addc.b	@r1+,	r2	;
 9b6:	6d 69       	addc.b	@r9,	r13	;
 9b8:	6e 67       	addc.b	@r7,	r14	;
 9ba:	20 43       	br	#2		;r3 As==10
 9bc:	46 4d       	mov.b	r13,	r6	;
 9be:	30 20       	jnz	$+98     	;abs 0xa20
 9c0:	46 69       	addc.b	r9,	r6	;
 9c2:	6e 69       	addc.b	@r9,	r14	;
 9c4:	73 68       	.word	0x6873;	????
 9c6:	65 64       	addc.b	@r4,	r5	;
 9c8:	0a 00       	mova	@r0,	r10	;
 9ca:	43 6f       	.word	0x6f43;	????
 9cc:	6d 6d       	addc.b	@r13,	r13	;
 9ce:	61 6e       	addc.b	@r14,	r1	;
 9d0:	64 3a       	jl	$-822    	;abs 0x69a
 9d2:	20 55       	add	@r5,	r0	;
 9d4:	4e 4b       	mov.b	r11,	r14	;
 9d6:	4e 4f       	mov.b	r15,	r14	;
 9d8:	57 4e 0a 00 	mov.b	10(r14),r7	;0x0000a

Disassembly of section .bss:

00008000 <__bssstart>:
    8000:	00 00       	beq			
    8002:	00 00       	beq			
    8004:	00 00       	beq			
    8006:	00 00       	beq			
    8008:	00 00       	beq			
    800a:	00 00       	beq			
    800c:	00 00       	beq			
    800e:	00 00       	beq			
    8010:	00 00       	beq			
    8012:	00 00       	beq			
    8014:	00 00       	beq			
    8016:	00 00       	beq			
    8018:	00 00       	beq			
    801a:	00 00       	beq			
    801c:	00 00       	beq			
    801e:	00 00       	beq			
    8020:	00 00       	beq			
    8022:	00 00       	beq			
    8024:	00 00       	beq			
    8026:	00 00       	beq			
    8028:	00 00       	beq			
    802a:	00 00       	beq			
    802c:	00 00       	beq			
    802e:	00 00       	beq			
    8030:	00 00       	beq			
    8032:	00 00       	beq			
    8034:	00 00       	beq			
    8036:	00 00       	beq			
    8038:	00 00       	beq			
    803a:	00 00       	beq			
    803c:	00 00       	beq			
    803e:	00 00       	beq			

00008040 <glEp0Buffer_Rx>:
    8040:	00 00       	beq			
    8042:	00 00       	beq			
    8044:	00 00       	beq			
    8046:	00 00       	beq			
    8048:	00 00       	beq			
    804a:	00 00       	beq			
    804c:	00 00       	beq			
    804e:	00 00       	beq			
    8050:	00 00       	beq			
    8052:	00 00       	beq			
    8054:	00 00       	beq			
    8056:	00 00       	beq			
    8058:	00 00       	beq			
    805a:	00 00       	beq			
    805c:	00 00       	beq			
    805e:	00 00       	beq			
    8060:	00 00       	beq			
    8062:	00 00       	beq			
    8064:	00 00       	beq			
    8066:	00 00       	beq			
    8068:	00 00       	beq			
    806a:	00 00       	beq			
    806c:	00 00       	beq			
    806e:	00 00       	beq			
    8070:	00 00       	beq			
    8072:	00 00       	beq			
    8074:	00 00       	beq			
    8076:	00 00       	beq			
    8078:	00 00       	beq			
    807a:	00 00       	beq			
    807c:	00 00       	beq			
    807e:	00 00       	beq			

Disassembly of section .MP430.attributes:

00000000 <.MP430.attributes>:
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
  16:	01 41       	mov	r1,	r1	;
  18:	16 00       	mova	@r0+,	r6	;
  1a:	00 00       	beq			
  1c:	6d 73       	subc.b	#2,	r13	;r3 As==10
  1e:	70 61       	addc.b	@r1+,	r0	;
  20:	62 69       	addc.b	@r9,	r2	;
  22:	00 01       	bra	@r1		;
  24:	0b 00       	mova	@r0,	r11	;
  26:	00 00       	beq			
  28:	04 01       	mova	@r1,	r4	;
  2a:	06 01       	mova	@r1,	r6	;
  2c:	08 01       	mova	@r1,	r8	;
  2e:	41 16       	popm.a	#5,	r5	;20-bit words
  30:	00 00       	beq			
  32:	00 6d       	addc	r13,	r0	;
  34:	73 70       	.word	0x7073;	????
  36:	61 62       	addc.b	#4,	r1	;r2 As==10
  38:	69 00 01 0b 	mova	r0,	&592641	; 0x90b01
  3c:	00 00       	beq			
  3e:	00 04       	bra	@r4		;
  40:	01 06       	mova	@r6,	r1	;
  42:	01 08       	mova	@r8,	r1	;
  44:	01 41       	mov	r1,	r1	;
  46:	16 00       	mova	@r0+,	r6	;
  48:	00 00       	beq			
  4a:	6d 73       	subc.b	#2,	r13	;r3 As==10
  4c:	70 61       	addc.b	@r1+,	r0	;
  4e:	62 69       	addc.b	@r9,	r2	;
  50:	00 01       	bra	@r1		;
  52:	0b 00       	mova	@r0,	r11	;
  54:	00 00       	beq			
  56:	04 01       	mova	@r1,	r4	;
  58:	06 01       	mova	@r1,	r6	;
  5a:	08 01       	mova	@r1,	r8	;
  5c:	41 16       	popm.a	#5,	r5	;20-bit words
  5e:	00 00       	beq			
  60:	00 6d       	addc	r13,	r0	;
  62:	73 70       	.word	0x7073;	????
  64:	61 62       	addc.b	#4,	r1	;r2 As==10
  66:	69 00 01 0b 	mova	r0,	&592641	; 0x90b01
  6a:	00 00       	beq			
  6c:	00 04       	bra	@r4		;
  6e:	01 06       	mova	@r6,	r1	;
  70:	01 08       	mova	@r8,	r1	;
  72:	01 41       	mov	r1,	r1	;
  74:	16 00       	mova	@r0+,	r6	;
  76:	00 00       	beq			
  78:	6d 73       	subc.b	#2,	r13	;r3 As==10
  7a:	70 61       	addc.b	@r1+,	r0	;
  7c:	62 69       	addc.b	@r9,	r2	;
  7e:	00 01       	bra	@r1		;
  80:	0b 00       	mova	@r0,	r11	;
  82:	00 00       	beq			
  84:	04 01       	mova	@r1,	r4	;
  86:	06 01       	mova	@r1,	r6	;
  88:	08 01       	mova	@r1,	r8	;
  8a:	41 16       	popm.a	#5,	r5	;20-bit words
  8c:	00 00       	beq			
  8e:	00 6d       	addc	r13,	r0	;
  90:	73 70       	.word	0x7073;	????
  92:	61 62       	addc.b	#4,	r1	;r2 As==10
  94:	69 00 01 0b 	mova	r0,	&592641	; 0x90b01
  98:	00 00       	beq			
  9a:	00 04       	bra	@r4		;
  9c:	01 06       	mova	@r6,	r1	;
  9e:	01 08       	mova	@r8,	r1	;
  a0:	01 41       	mov	r1,	r1	;
  a2:	16 00       	mova	@r0+,	r6	;
  a4:	00 00       	beq			
  a6:	6d 73       	subc.b	#2,	r13	;r3 As==10
  a8:	70 61       	addc.b	@r1+,	r0	;
  aa:	62 69       	addc.b	@r9,	r2	;
  ac:	00 01       	bra	@r1		;
  ae:	0b 00       	mova	@r0,	r11	;
  b0:	00 00       	beq			
  b2:	04 01       	mova	@r1,	r4	;
  b4:	06 01       	mova	@r1,	r6	;
  b6:	08 01       	mova	@r1,	r8	;
  b8:	41 16       	popm.a	#5,	r5	;20-bit words
  ba:	00 00       	beq			
  bc:	00 6d       	addc	r13,	r0	;
  be:	73 70       	.word	0x7073;	????
  c0:	61 62       	addc.b	#4,	r1	;r2 As==10
  c2:	69 00 01 0b 	mova	r0,	&592641	; 0x90b01
  c6:	00 00       	beq			
  c8:	00 04       	bra	@r4		;
  ca:	01 06       	mova	@r6,	r1	;
  cc:	01 08       	mova	@r8,	r1	;
  ce:	01 41       	mov	r1,	r1	;
  d0:	16 00       	mova	@r0+,	r6	;
  d2:	00 00       	beq			
  d4:	6d 73       	subc.b	#2,	r13	;r3 As==10
  d6:	70 61       	addc.b	@r1+,	r0	;
  d8:	62 69       	addc.b	@r9,	r2	;
  da:	00 01       	bra	@r1		;
  dc:	0b 00       	mova	@r0,	r11	;
  de:	00 00       	beq			
  e0:	04 01       	mova	@r1,	r4	;
  e2:	06 01       	mova	@r1,	r6	;
  e4:	08 01       	mova	@r1,	r8	;
  e6:	41 16       	popm.a	#5,	r5	;20-bit words
  e8:	00 00       	beq			
  ea:	00 6d       	addc	r13,	r0	;
  ec:	73 70       	.word	0x7073;	????
  ee:	61 62       	addc.b	#4,	r1	;r2 As==10
  f0:	69 00 01 0b 	mova	r0,	&592641	; 0x90b01
  f4:	00 00       	beq			
  f6:	00 04       	bra	@r4		;
  f8:	01 06       	mova	@r6,	r1	;
  fa:	01 08       	mova	@r8,	r1	;
  fc:	01 41       	mov	r1,	r1	;
  fe:	16 00       	mova	@r0+,	r6	;
 100:	00 00       	beq			
 102:	6d 73       	subc.b	#2,	r13	;r3 As==10
 104:	70 61       	addc.b	@r1+,	r0	;
 106:	62 69       	addc.b	@r9,	r2	;
 108:	00 01       	bra	@r1		;
 10a:	0b 00       	mova	@r0,	r11	;
 10c:	00 00       	beq			
 10e:	04 01       	mova	@r1,	r4	;
 110:	06 01       	mova	@r1,	r6	;
 112:	08 01       	mova	@r1,	r8	;
 114:	41 16       	popm.a	#5,	r5	;20-bit words
 116:	00 00       	beq			
 118:	00 6d       	addc	r13,	r0	;
 11a:	73 70       	.word	0x7073;	????
 11c:	61 62       	addc.b	#4,	r1	;r2 As==10
 11e:	69 00 01 0b 	mova	r0,	&592641	; 0x90b01
 122:	00 00       	beq			
 124:	00 04       	bra	@r4		;
 126:	01 06       	mova	@r6,	r1	;
 128:	01 08       	mova	@r8,	r1	;
 12a:	01 41       	mov	r1,	r1	;
 12c:	16 00       	mova	@r0+,	r6	;
 12e:	00 00       	beq			
 130:	6d 73       	subc.b	#2,	r13	;r3 As==10
 132:	70 61       	addc.b	@r1+,	r0	;
 134:	62 69       	addc.b	@r9,	r2	;
 136:	00 01       	bra	@r1		;
 138:	0b 00       	mova	@r0,	r11	;
 13a:	00 00       	beq			
 13c:	04 01       	mova	@r1,	r4	;
 13e:	06 01       	mova	@r1,	r6	;
 140:	08 01       	mova	@r1,	r8	;

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
  3e:	30 00 a3 89 	Address 0x00000040 is out of bounds.
bra	-1(r0)		;PC rel. 0x0003f
