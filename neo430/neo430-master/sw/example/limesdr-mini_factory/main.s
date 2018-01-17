
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
  2e:	35 40 94 09 	mov	#2452,	r5	;#0x0994
  32:	36 40 94 09 	mov	#2452,	r6	;#0x0994
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
  c0:	b0 12 ce 07 	call	#1998		;#0x07ce
  c4:	0a 5a       	rla	r10		;
  c6:	0a 5a       	rla	r10		;
  c8:	0a 5a       	rla	r10		;
  ca:	0a 5a       	rla	r10		;
  cc:	4a dc       	bis.b	r12,	r10	;
  ce:	3a f0 ff 00 	and	#255,	r10	;#0x00ff
  d2:	0c 4a       	mov	r10,	r12	;
  d4:	b0 12 48 07 	call	#1864		;#0x0748
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
 150:	b0 12 d2 07 	call	#2002		;#0x07d2

00000154 <.L15>:
 154:	5a 53       	inc.b	r10		;
 156:	3a f0 ff 00 	and	#255,	r10	;#0x00ff
 15a:	30 40 18 01 	br	#0x0118		;

0000015e <.L14>:
 15e:	b0 12 da 07 	call	#2010		;#0x07da
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
 1a6:	21 82       	sub	#4,	r1	;r2 As==10
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
 1d8:	3c 40 6a 08 	mov	#2154,	r12	;#0x086a
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
 224:	30 40 9c 06 	br	#0x069c		;
 228:	44 43       	clr.b	r4		;
 22a:	45 43       	clr.b	r5		;
 22c:	49 43       	clr.b	r9		;

0000022e <.L71>:
 22e:	3a 40 6a 00 	mov	#106,	r10	;#0x006a
 232:	08 4a       	mov	r10,	r8	;

00000234 <.L31>:
 234:	3c 40 08 04 	mov	#1032,	r12	;#0x0408
 238:	4d 43       	clr.b	r13		;
 23a:	8a 12       	call	r10		;
 23c:	5c f3       	and.b	#1,	r12	;r3 As==01
 23e:	0c 93       	cmp	#0,	r12	;r3 As==00
 240:	f9 23       	jnz	$-12     	;abs 0x234
 242:	07 4c       	mov	r12,	r7	;

00000244 <.L32>:
 244:	3c 40 08 04 	mov	#1032,	r12	;#0x0408
 248:	4d 43       	clr.b	r13		;
 24a:	88 12       	call	r8		;
 24c:	0a 4c       	mov	r12,	r10	;
 24e:	5a f3       	and.b	#1,	r10	;r3 As==01
 250:	0a 93       	cmp	#0,	r10	;r3 As==00
 252:	f8 23       	jnz	$-14     	;abs 0x244
 254:	3c 40 04 04 	mov	#1028,	r12	;#0x0404
 258:	4d 43       	clr.b	r13		;
 25a:	88 12       	call	r8		;
 25c:	87 4c 40 80 	mov	r12,	-32704(r7); 0x8040
 260:	87 4d 42 80 	mov	r13,	-32702(r7); 0x8042
 264:	27 52       	add	#4,	r7	;r2 As==10
 266:	37 90 40 00 	cmp	#64,	r7	;#0x0040
 26a:	ec 23       	jnz	$-38     	;abs 0x244
 26c:	38 40 00 80 	mov	#32768,	r8	;#0x8000
 270:	0e 47       	mov	r7,	r14	;
 272:	0d 4a       	mov	r10,	r13	;
 274:	0c 48       	mov	r8,	r12	;
 276:	b0 12 56 08 	call	#2134		;#0x0856
 27a:	37 40 40 80 	mov	#32832,	r7	;#0x8040
 27e:	6c 47       	mov.b	@r7,	r12	;
 280:	c8 4c 00 00 	mov.b	r12,	0(r8)	;
 284:	d8 47 02 00 	mov.b	2(r7),	2(r8)	;
 288:	02 00 
 28a:	d8 47 03 00 	mov.b	3(r7),	3(r8)	;
 28e:	03 00 
 290:	f2 40 03 00 	mov.b	#3,	&0x8001	;
 294:	01 80 
 296:	4c 93       	cmp.b	#0,	r12	;r3 As==00
 298:	0b 24       	jz	$+24     	;abs 0x2b0
 29a:	7c 90 53 00 	cmp.b	#83,	r12	;#0x0053
 29e:	15 24       	jz	$+44     	;abs 0x2ca
 2a0:	3c 40 82 09 	mov	#2434,	r12	;#0x0982
 2a4:	b0 12 66 01 	call	#358		;#0x0166
 2a8:	e2 43 01 80 	mov.b	#2,	&0x8001	;r3 As==10
 2ac:	30 40 e4 03 	br	#0x03e4		;

000002b0 <.L35>:
 2b0:	d2 43 08 80 	mov.b	#1,	&0x8008	;r3 As==01
 2b4:	f2 40 11 00 	mov.b	#17,	&0x8009	;#0x0011
 2b8:	09 80 
 2ba:	d2 43 0a 80 	mov.b	#1,	&0x800a	;r3 As==01
 2be:	d2 43 0c 80 	mov.b	#1,	&0x800c	;r3 As==01

000002c2 <.L90>:
 2c2:	d2 43 01 80 	mov.b	#1,	&0x8001	;r3 As==01
 2c6:	30 40 e4 03 	br	#0x03e4		;

000002ca <.L36>:
 2ca:	5c 47 08 00 	mov.b	8(r7),	r12	;
 2ce:	5c 93       	cmp.b	#1,	r12	;r3 As==01
 2d0:	09 24       	jz	$+20     	;abs 0x2e4
 2d2:	4c 93       	cmp.b	#0,	r12	;r3 As==00
 2d4:	02 24       	jz	$+6      	;abs 0x2da
 2d6:	6c 93       	cmp.b	#2,	r12	;r3 As==10
 2d8:	f4 23       	jnz	$-22     	;abs 0x2c2

000002da <.L41>:
 2da:	f2 40 05 00 	mov.b	#5,	&0x8001	;
 2de:	01 80 
 2e0:	30 40 e4 03 	br	#0x03e4		;

000002e4 <.L39>:
 2e4:	5c 47 09 00 	mov.b	9(r7),	r12	;
 2e8:	0d 4a       	mov	r10,	r13	;
 2ea:	7e 40 18 00 	mov.b	#24,	r14	;#0x0018
 2ee:	b0 12 28 07 	call	#1832		;#0x0728
 2f2:	08 4c       	mov	r12,	r8	;
 2f4:	06 4d       	mov	r13,	r6	;
 2f6:	5c 47 0a 00 	mov.b	10(r7),	r12	;0x0000a
 2fa:	0d 4a       	mov	r10,	r13	;
 2fc:	7e 40 10 00 	mov.b	#16,	r14	;#0x0010
 300:	b0 12 28 07 	call	#1832		;#0x0728
 304:	0c d8       	bis	r8,	r12	;
 306:	0d d6       	bis	r6,	r13	;
 308:	5e 47 0c 00 	mov.b	12(r7),	r14	;0x0000c
 30c:	0c de       	bis	r14,	r12	;
 30e:	5e 47 0b 00 	mov.b	11(r7),	r14	;0x0000b
 312:	0e 5e       	rla	r14		;
 314:	0a 6a       	rlc	r10		;
 316:	0e 5e       	rla	r14		;
 318:	0a 6a       	rlc	r10		;
 31a:	0e 5e       	rla	r14		;
 31c:	0a 6a       	rlc	r10		;
 31e:	0e 5e       	rla	r14		;
 320:	0a 6a       	rlc	r10		;
 322:	0e 5e       	rla	r14		;
 324:	0a 6a       	rlc	r10		;
 326:	0e 5e       	rla	r14		;
 328:	0a 6a       	rlc	r10		;
 32a:	0e 5e       	rla	r14		;
 32c:	0a 6a       	rlc	r10		;
 32e:	0e 5e       	rla	r14		;
 330:	0a 6a       	rlc	r10		;
 332:	0e dc       	bis	r12,	r14	;
 334:	0d da       	bis	r10,	r13	;
 336:	0d de       	bis	r14,	r13	;
 338:	0d 93       	cmp	#0,	r13	;r3 As==00
 33a:	02 20       	jnz	$+6      	;abs 0x340
 33c:	79 40 0a 00 	mov.b	#10,	r9	;#0x000a

00000340 <.L42>:
 340:	c2 93 4d 80 	cmp.b	#0,	&0x804d	;r3 As==00
 344:	41 24       	jz	$+132    	;abs 0x3c8
 346:	3a 40 6a 00 	mov	#106,	r10	;#0x006a
 34a:	38 40 66 01 	mov	#358,	r8	;#0x0166

0000034e <.L72>:
 34e:	4c 49       	mov.b	r9,	r12	;
 350:	79 90 0e 00 	cmp.b	#14,	r9	;#0x000e
 354:	a0 24       	jz	$+322    	;abs 0x496
 356:	7d 40 0e 00 	mov.b	#14,	r13	;#0x000e
 35a:	4d 99       	cmp.b	r9,	r13	;
 35c:	20 28       	jnc	$+66     	;abs 0x39e
 35e:	79 90 0b 00 	cmp.b	#11,	r9	;#0x000b
 362:	53 24       	jz	$+168    	;abs 0x40a
 364:	39 40 92 00 	mov	#146,	r9	;#0x0092
 368:	7c 90 0d 00 	cmp.b	#13,	r12	;#0x000d
 36c:	82 24       	jz	$+262    	;abs 0x472
 36e:	7c 90 0a 00 	cmp.b	#10,	r12	;#0x000a
 372:	1f 20       	jnz	$+64     	;abs 0x3b2
 374:	3e 43       	mov	#-1,	r14	;r3 As==11
 376:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 37a:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 37e:	4d 43       	clr.b	r13		;
 380:	89 12       	call	r9		;
 382:	3e 43       	mov	#-1,	r14	;r3 As==11
 384:	3f 40 5f f6 	mov	#63071,	r15	;#0xf65f
 388:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 38c:	4d 43       	clr.b	r13		;
 38e:	89 12       	call	r9		;
 390:	44 43       	clr.b	r4		;
 392:	45 43       	clr.b	r5		;
 394:	77 40 0b 00 	mov.b	#11,	r7	;#0x000b

00000398 <.L54>:
 398:	09 47       	mov	r7,	r9	;
 39a:	30 40 4e 03 	br	#0x034e		;

0000039e <.L46>:
 39e:	79 90 11 00 	cmp.b	#17,	r9	;#0x0011
 3a2:	be 24       	jz	$+382    	;abs 0x520
 3a4:	7e 40 11 00 	mov.b	#17,	r14	;#0x0011
 3a8:	4e 99       	cmp.b	r9,	r14	;
 3aa:	08 28       	jnc	$+18     	;abs 0x3bc
 3ac:	79 90 10 00 	cmp.b	#16,	r9	;#0x0010
 3b0:	a3 24       	jz	$+328    	;abs 0x4f8

000003b2 <.L44>:
 3b2:	f2 40 05 00 	mov.b	#5,	&0x8001	;
 3b6:	01 80 
 3b8:	30 40 e2 03 	br	#0x03e2		;

000003bc <.L51>:
 3bc:	79 90 14 00 	cmp.b	#20,	r9	;#0x0014
 3c0:	e1 24       	jz	$+452    	;abs 0x584
 3c2:	79 90 1e 00 	cmp.b	#30,	r9	;#0x001e
 3c6:	f5 23       	jnz	$-20     	;abs 0x3b2

000003c8 <.L43>:
 3c8:	3e 43       	mov	#-1,	r14	;r3 As==11
 3ca:	3f 43       	mov	#-1,	r15	;r3 As==11
 3cc:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 3d0:	4d 43       	clr.b	r13		;
 3d2:	b0 12 92 00 	call	#146		;#0x0092
 3d6:	d2 43 01 80 	mov.b	#1,	&0x8001	;r3 As==01
 3da:	3c 40 68 09 	mov	#2408,	r12	;#0x0968
 3de:	b0 12 66 01 	call	#358		;#0x0166

000003e2 <.L93>:
 3e2:	49 43       	clr.b	r9		;

000003e4 <.L37>:
 3e4:	4a 43       	clr.b	r10		;
 3e6:	38 40 92 00 	mov	#146,	r8	;#0x0092
 3ea:	36 40 00 04 	mov	#1024,	r6	;#0x0400
 3ee:	47 43       	clr.b	r7		;

000003f0 <.L70>:
 3f0:	1e 4a 00 80 	mov	-32768(r10),r14	;0xffff8000
 3f4:	1f 4a 02 80 	mov	-32766(r10),r15	;0xffff8002
 3f8:	0c 46       	mov	r6,	r12	;
 3fa:	0d 47       	mov	r7,	r13	;
 3fc:	88 12       	call	r8		;
 3fe:	2a 52       	add	#4,	r10	;r2 As==10
 400:	3a 90 40 00 	cmp	#64,	r10	;#0x0040
 404:	f5 23       	jnz	$-20     	;abs 0x3f0
 406:	30 40 2e 02 	br	#0x022e		;

0000040a <.L47>:
 40a:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 40e:	4d 43       	clr.b	r13		;
 410:	8a 12       	call	r10		;
 412:	7c f0 13 00 	and.b	#19,	r12	;#0x0013
 416:	3c 90 10 00 	cmp	#16,	r12	;#0x0010
 41a:	28 20       	jnz	$+82     	;abs 0x46c
 41c:	3e 43       	mov	#-1,	r14	;r3 As==11
 41e:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 422:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 426:	4d 43       	clr.b	r13		;
 428:	b0 12 92 00 	call	#146		;#0x0092
 42c:	3c 40 b6 08 	mov	#2230,	r12	;#0x08b6
 430:	88 12       	call	r8		;
 432:	77 40 0d 00 	mov.b	#13,	r7	;#0x000d

00000436 <.L55>:
 436:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 43a:	4d 43       	clr.b	r13		;
 43c:	8a 12       	call	r10		;
 43e:	7c f0 13 00 	and.b	#19,	r12	;#0x0013
 442:	1c 93       	cmp	#1,	r12	;r3 As==01
 444:	04 20       	jnz	$+10     	;abs 0x44e
 446:	3c 40 c3 08 	mov	#2243,	r12	;#0x08c3
 44a:	88 12       	call	r8		;
 44c:	07 49       	mov	r9,	r7	;

0000044e <.L56>:
 44e:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 452:	4d 43       	clr.b	r13		;
 454:	8a 12       	call	r10		;
 456:	09 4c       	mov	r12,	r9	;
 458:	79 f0 13 00 	and.b	#19,	r9	;#0x0013
 45c:	09 93       	cmp	#0,	r9	;r3 As==00
 45e:	9c 23       	jnz	$-198    	;abs 0x398
 460:	3c 40 d1 08 	mov	#2257,	r12	;#0x08d1

00000464 <.L94>:
 464:	88 12       	call	r8		;
 466:	07 49       	mov	r9,	r7	;
 468:	30 40 98 03 	br	#0x0398		;

0000046c <.L73>:
 46c:	07 49       	mov	r9,	r7	;
 46e:	30 40 36 04 	br	#0x0436		;

00000472 <.L48>:
 472:	3e 43       	mov	#-1,	r14	;r3 As==11
 474:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 478:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 47c:	4d 43       	clr.b	r13		;
 47e:	89 12       	call	r9		;
 480:	3e 43       	mov	#-1,	r14	;r3 As==11
 482:	3f 40 1f f6 	mov	#63007,	r15	;#0xf61f
 486:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 48a:	4d 43       	clr.b	r13		;
 48c:	89 12       	call	r9		;
 48e:	77 40 0e 00 	mov.b	#14,	r7	;#0x000e
 492:	30 40 98 03 	br	#0x0398		;

00000496 <.L45>:
 496:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 49a:	4d 43       	clr.b	r13		;
 49c:	8a 12       	call	r10		;
 49e:	07 4c       	mov	r12,	r7	;
 4a0:	77 f0 13 00 	and.b	#19,	r7	;#0x0013
 4a4:	37 90 10 00 	cmp	#16,	r7	;#0x0010
 4a8:	24 20       	jnz	$+74     	;abs 0x4f2
 4aa:	3e 43       	mov	#-1,	r14	;r3 As==11
 4ac:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 4b0:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 4b4:	4d 43       	clr.b	r13		;
 4b6:	b0 12 92 00 	call	#146		;#0x0092
 4ba:	3c 40 e4 08 	mov	#2276,	r12	;#0x08e4
 4be:	88 12       	call	r8		;

000004c0 <.L57>:
 4c0:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 4c4:	4d 43       	clr.b	r13		;
 4c6:	8a 12       	call	r10		;
 4c8:	7c f0 13 00 	and.b	#19,	r12	;#0x0013
 4cc:	1c 93       	cmp	#1,	r12	;r3 As==01
 4ce:	04 20       	jnz	$+10     	;abs 0x4d8
 4d0:	3c 40 f4 08 	mov	#2292,	r12	;#0x08f4
 4d4:	88 12       	call	r8		;
 4d6:	07 49       	mov	r9,	r7	;

000004d8 <.L58>:
 4d8:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 4dc:	4d 43       	clr.b	r13		;
 4de:	8a 12       	call	r10		;
 4e0:	09 4c       	mov	r12,	r9	;
 4e2:	79 f0 13 00 	and.b	#19,	r9	;#0x0013
 4e6:	09 93       	cmp	#0,	r9	;r3 As==00
 4e8:	57 23       	jnz	$-336    	;abs 0x398
 4ea:	3c 40 05 09 	mov	#2309,	r12	;#0x0905
 4ee:	30 40 64 04 	br	#0x0464		;

000004f2 <.L74>:
 4f2:	07 49       	mov	r9,	r7	;
 4f4:	30 40 c0 04 	br	#0x04c0		;

000004f8 <.L52>:
 4f8:	39 40 92 00 	mov	#146,	r9	;#0x0092
 4fc:	3e 43       	mov	#-1,	r14	;r3 As==11
 4fe:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 502:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 506:	4d 43       	clr.b	r13		;
 508:	89 12       	call	r9		;
 50a:	3e 43       	mov	#-1,	r14	;r3 As==11
 50c:	3f 40 2f f6 	mov	#63023,	r15	;#0xf62f
 510:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 514:	4d 43       	clr.b	r13		;
 516:	89 12       	call	r9		;
 518:	77 40 11 00 	mov.b	#17,	r7	;#0x0011
 51c:	30 40 98 03 	br	#0x0398		;

00000520 <.L50>:
 520:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 524:	4d 43       	clr.b	r13		;
 526:	8a 12       	call	r10		;
 528:	7c f0 13 00 	and.b	#19,	r12	;#0x0013
 52c:	3c 90 10 00 	cmp	#16,	r12	;#0x0010
 530:	26 20       	jnz	$+78     	;abs 0x57e
 532:	3e 43       	mov	#-1,	r14	;r3 As==11
 534:	3f 40 7f f6 	mov	#63103,	r15	;#0xf67f
 538:	7c 40 44 00 	mov.b	#68,	r12	;#0x0044
 53c:	4d 43       	clr.b	r13		;
 53e:	b0 12 92 00 	call	#146		;#0x0092
 542:	3c 40 1b 09 	mov	#2331,	r12	;#0x091b
 546:	88 12       	call	r8		;
 548:	77 40 14 00 	mov.b	#20,	r7	;#0x0014

0000054c <.L59>:
 54c:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 550:	4d 43       	clr.b	r13		;
 552:	8a 12       	call	r10		;
 554:	7c f0 13 00 	and.b	#19,	r12	;#0x0013
 558:	1c 93       	cmp	#1,	r12	;r3 As==01
 55a:	04 20       	jnz	$+10     	;abs 0x564
 55c:	3c 40 2b 09 	mov	#2347,	r12	;#0x092b
 560:	88 12       	call	r8		;
 562:	07 49       	mov	r9,	r7	;

00000564 <.L60>:
 564:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 568:	4d 43       	clr.b	r13		;
 56a:	8a 12       	call	r10		;
 56c:	09 4c       	mov	r12,	r9	;
 56e:	79 f0 13 00 	and.b	#19,	r9	;#0x0013
 572:	09 93       	cmp	#0,	r9	;r3 As==00
 574:	11 23       	jnz	$-476    	;abs 0x398
 576:	3c 40 3c 09 	mov	#2364,	r12	;#0x093c
 57a:	30 40 64 04 	br	#0x0464		;

0000057e <.L75>:
 57e:	07 49       	mov	r9,	r7	;
 580:	30 40 4c 05 	br	#0x054c		;

00000584 <.L53>:
 584:	38 40 60 80 	mov	#32864,	r8	;#0x8060
 588:	37 40 ba 00 	mov	#186,	r7	;#0x00ba

0000058c <.L68>:
 58c:	6c 48       	mov.b	@r8,	r12	;
 58e:	87 12       	call	r7		;
 590:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
 594:	81 4c 02 00 	mov	r12,	2(r1)	;
 598:	5c 48 01 00 	mov.b	1(r8),	r12	;
 59c:	87 12       	call	r7		;
 59e:	46 4c       	mov.b	r12,	r6	;
 5a0:	5c 48 02 00 	mov.b	2(r8),	r12	;
 5a4:	87 12       	call	r7		;
 5a6:	4a 4c       	mov.b	r12,	r10	;
 5a8:	5c 48 03 00 	mov.b	3(r8),	r12	;
 5ac:	87 12       	call	r7		;
 5ae:	3c f0 ff 00 	and	#255,	r12	;#0x00ff
 5b2:	81 4c 00 00 	mov	r12,	0(r1)	;
 5b6:	6d 43       	mov.b	#2,	r13	;r3 As==10
 5b8:	0d 95       	cmp	r5,	r13	;
 5ba:	66 28       	jnc	$+206    	;abs 0x688
 5bc:	05 9d       	cmp	r13,	r5	;
 5be:	04 20       	jnz	$+10     	;abs 0x5c8
 5c0:	3c 40 ff 2f 	mov	#12287,	r12	;#0x2fff
 5c4:	0c 94       	cmp	r4,	r12	;
 5c6:	60 28       	jnc	$+194    	;abs 0x688

000005c8 <.L77>:
 5c8:	1c 41 02 00 	mov	2(r1),	r12	;
 5cc:	4d 43       	clr.b	r13		;
 5ce:	7e 40 18 00 	mov.b	#24,	r14	;#0x0018
 5d2:	b0 12 28 07 	call	#1832		;#0x0728
 5d6:	0e 4a       	mov	r10,	r14	;
 5d8:	4f 43       	clr.b	r15		;
 5da:	0e 5a       	add	r10,	r14	;
 5dc:	0f 6f       	rlc	r15		;
 5de:	0e 5e       	rla	r14		;
 5e0:	0f 6f       	rlc	r15		;
 5e2:	0e 5e       	rla	r14		;
 5e4:	0f 6f       	rlc	r15		;
 5e6:	0e 5e       	rla	r14		;
 5e8:	0f 6f       	rlc	r15		;
 5ea:	0e 5e       	rla	r14		;
 5ec:	0f 6f       	rlc	r15		;
 5ee:	0e 5e       	rla	r14		;
 5f0:	0f 6f       	rlc	r15		;
 5f2:	0e 5e       	rla	r14		;
 5f4:	0f 6f       	rlc	r15		;
 5f6:	0e 5e       	rla	r14		;
 5f8:	0f 6f       	rlc	r15		;
 5fa:	0e dc       	bis	r12,	r14	;
 5fc:	0a 4d       	mov	r13,	r10	;
 5fe:	0a df       	bis	r15,	r10	;
 600:	2e d1       	bis	@r1,	r14	;
 602:	81 4e 00 00 	mov	r14,	0(r1)	;
 606:	0c 46       	mov	r6,	r12	;
 608:	4d 43       	clr.b	r13		;
 60a:	7e 40 10 00 	mov.b	#16,	r14	;#0x0010
 60e:	b0 12 28 07 	call	#1832		;#0x0728
 612:	4f 4d       	mov.b	r13,	r15	;
 614:	0c 44       	mov	r4,	r12	;
 616:	0c 54       	add	r4,	r12	;
 618:	0d 45       	mov	r5,	r13	;
 61a:	0d 65       	addc	r5,	r13	;
 61c:	0c 5c       	rla	r12		;
 61e:	0d 6d       	rlc	r13		;
 620:	2e 41       	mov	@r1,	r14	;
 622:	0f da       	bis	r10,	r15	;
 624:	0c 53       	add	#0,	r12	;r3 As==00
 626:	3d 60 10 00 	addc	#16,	r13	;#0x0010
 62a:	b0 12 92 00 	call	#146		;#0x0092
 62e:	36 40 6a 00 	mov	#106,	r6	;#0x006a
 632:	0a 46       	mov	r6,	r10	;

00000634 <.L63>:
 634:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 638:	4d 43       	clr.b	r13		;
 63a:	86 12       	call	r6		;
 63c:	7c f0 0b 00 	and.b	#11,	r12	;#0x000b
 640:	2c 93       	cmp	#2,	r12	;r3 As==10
 642:	f8 27       	jz	$-14     	;abs 0x634
 644:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 648:	4d 43       	clr.b	r13		;
 64a:	8a 12       	call	r10		;
 64c:	3c b0 0b 00 	bit	#11,	r12	;#0x000b
 650:	08 20       	jnz	$+18     	;abs 0x662
 652:	3c 40 52 09 	mov	#2386,	r12	;#0x0952
 656:	b0 12 66 01 	call	#358		;#0x0166
 65a:	34 40 60 ae 	mov	#44640,	r4	;#0xae60
 65e:	75 40 0a 00 	mov.b	#10,	r5	;#0x000a

00000662 <.L65>:
 662:	7c 40 40 00 	mov.b	#64,	r12	;#0x0040
 666:	4d 43       	clr.b	r13		;
 668:	b0 12 6a 00 	call	#106		;#0x006a
 66c:	34 90 ff 1f 	cmp	#8191,	r4	;#0x1fff
 670:	02 20       	jnz	$+6      	;abs 0x676
 672:	05 93       	cmp	#0,	r5	;r3 As==00
 674:	0e 24       	jz	$+30     	;abs 0x692

00000676 <.L79>:
 676:	14 53       	inc	r4		;
 678:	05 63       	adc	r5		;

0000067a <.L66>:
 67a:	28 52       	add	#4,	r8	;r2 As==10
 67c:	3c 40 80 80 	mov	#32896,	r12	;#0x8080
 680:	0c 98       	cmp	r8,	r12	;
 682:	84 23       	jnz	$-246    	;abs 0x58c
 684:	30 40 c2 02 	br	#0x02c2		;

00000688 <.L61>:
 688:	f2 40 05 00 	mov.b	#5,	&0x8001	;
 68c:	01 80 
 68e:	30 40 7a 06 	br	#0x067a		;

00000692 <.L91>:
 692:	34 40 00 28 	mov	#10240,	r4	;#0x2800
 696:	55 43       	mov.b	#1,	r5	;r3 As==01
 698:	30 40 7a 06 	br	#0x067a		;

0000069c <.L92>:
 69c:	3c 40 95 08 	mov	#2197,	r12	;#0x0895
 6a0:	89 12       	call	r9		;
 6a2:	5c 43       	mov.b	#1,	r12	;r3 As==01
 6a4:	21 52       	add	#4,	r1	;r2 As==10
 6a6:	30 40 aa 06 	br	#0x06aa		;

000006aa <__mspabi_func_epilog_7>:
 6aa:	34 41       	pop	r4		;

000006ac <__mspabi_func_epilog_6>:
 6ac:	35 41       	pop	r5		;

000006ae <__mspabi_func_epilog_5>:
 6ae:	36 41       	pop	r6		;

000006b0 <__mspabi_func_epilog_4>:
 6b0:	37 41       	pop	r7		;

000006b2 <__mspabi_func_epilog_3>:
 6b2:	38 41       	pop	r8		;

000006b4 <__mspabi_func_epilog_2>:
 6b4:	39 41       	pop	r9		;

000006b6 <__mspabi_func_epilog_1>:
 6b6:	3a 41       	pop	r10		;
 6b8:	30 41       	ret			

000006ba <__mspabi_slli_15>:
 6ba:	0c 5c       	rla	r12		;

000006bc <__mspabi_slli_14>:
 6bc:	0c 5c       	rla	r12		;

000006be <__mspabi_slli_13>:
 6be:	0c 5c       	rla	r12		;

000006c0 <__mspabi_slli_12>:
 6c0:	0c 5c       	rla	r12		;

000006c2 <__mspabi_slli_11>:
 6c2:	0c 5c       	rla	r12		;

000006c4 <__mspabi_slli_10>:
 6c4:	0c 5c       	rla	r12		;

000006c6 <__mspabi_slli_9>:
 6c6:	0c 5c       	rla	r12		;

000006c8 <__mspabi_slli_8>:
 6c8:	0c 5c       	rla	r12		;

000006ca <__mspabi_slli_7>:
 6ca:	0c 5c       	rla	r12		;

000006cc <__mspabi_slli_6>:
 6cc:	0c 5c       	rla	r12		;

000006ce <__mspabi_slli_5>:
 6ce:	0c 5c       	rla	r12		;

000006d0 <__mspabi_slli_4>:
 6d0:	0c 5c       	rla	r12		;

000006d2 <__mspabi_slli_3>:
 6d2:	0c 5c       	rla	r12		;

000006d4 <__mspabi_slli_2>:
 6d4:	0c 5c       	rla	r12		;

000006d6 <__mspabi_slli_1>:
 6d6:	0c 5c       	rla	r12		;
 6d8:	30 41       	ret			

000006da <.L11>:
 6da:	3d 53       	add	#-1,	r13	;r3 As==11
 6dc:	0c 5c       	rla	r12		;

000006de <__mspabi_slli>:
 6de:	0d 93       	cmp	#0,	r13	;r3 As==00
 6e0:	fc 23       	jnz	$-6      	;abs 0x6da
 6e2:	30 41       	ret			

000006e4 <__mspabi_slll_15>:
 6e4:	0c 5c       	rla	r12		;
 6e6:	0d 6d       	rlc	r13		;

000006e8 <__mspabi_slll_14>:
 6e8:	0c 5c       	rla	r12		;
 6ea:	0d 6d       	rlc	r13		;

000006ec <__mspabi_slll_13>:
 6ec:	0c 5c       	rla	r12		;
 6ee:	0d 6d       	rlc	r13		;

000006f0 <__mspabi_slll_12>:
 6f0:	0c 5c       	rla	r12		;
 6f2:	0d 6d       	rlc	r13		;

000006f4 <__mspabi_slll_11>:
 6f4:	0c 5c       	rla	r12		;
 6f6:	0d 6d       	rlc	r13		;

000006f8 <__mspabi_slll_10>:
 6f8:	0c 5c       	rla	r12		;
 6fa:	0d 6d       	rlc	r13		;

000006fc <__mspabi_slll_9>:
 6fc:	0c 5c       	rla	r12		;
 6fe:	0d 6d       	rlc	r13		;

00000700 <__mspabi_slll_8>:
 700:	0c 5c       	rla	r12		;
 702:	0d 6d       	rlc	r13		;

00000704 <__mspabi_slll_7>:
 704:	0c 5c       	rla	r12		;
 706:	0d 6d       	rlc	r13		;

00000708 <__mspabi_slll_6>:
 708:	0c 5c       	rla	r12		;
 70a:	0d 6d       	rlc	r13		;

0000070c <__mspabi_slll_5>:
 70c:	0c 5c       	rla	r12		;
 70e:	0d 6d       	rlc	r13		;

00000710 <__mspabi_slll_4>:
 710:	0c 5c       	rla	r12		;
 712:	0d 6d       	rlc	r13		;

00000714 <__mspabi_slll_3>:
 714:	0c 5c       	rla	r12		;
 716:	0d 6d       	rlc	r13		;

00000718 <__mspabi_slll_2>:
 718:	0c 5c       	rla	r12		;
 71a:	0d 6d       	rlc	r13		;

0000071c <__mspabi_slll_1>:
 71c:	0c 5c       	rla	r12		;
 71e:	0d 6d       	rlc	r13		;
 720:	30 41       	ret			

00000722 <.L12>:
 722:	3e 53       	add	#-1,	r14	;r3 As==11
 724:	0c 5c       	rla	r12		;
 726:	0d 6d       	rlc	r13		;

00000728 <__mspabi_slll>:
 728:	0e 93       	cmp	#0,	r14	;r3 As==00
 72a:	fb 23       	jnz	$-8      	;abs 0x722
 72c:	30 41       	ret			

0000072e <__mspabi_srai_15>:
 72e:	0c 11       	rra	r12		;

00000730 <__mspabi_srai_14>:
 730:	0c 11       	rra	r12		;

00000732 <__mspabi_srai_13>:
 732:	0c 11       	rra	r12		;

00000734 <__mspabi_srai_12>:
 734:	0c 11       	rra	r12		;

00000736 <__mspabi_srai_11>:
 736:	0c 11       	rra	r12		;

00000738 <__mspabi_srai_10>:
 738:	0c 11       	rra	r12		;

0000073a <__mspabi_srai_9>:
 73a:	0c 11       	rra	r12		;

0000073c <__mspabi_srai_8>:
 73c:	0c 11       	rra	r12		;

0000073e <__mspabi_srai_7>:
 73e:	0c 11       	rra	r12		;

00000740 <__mspabi_srai_6>:
 740:	0c 11       	rra	r12		;

00000742 <__mspabi_srai_5>:
 742:	0c 11       	rra	r12		;

00000744 <__mspabi_srai_4>:
 744:	0c 11       	rra	r12		;

00000746 <__mspabi_srai_3>:
 746:	0c 11       	rra	r12		;

00000748 <__mspabi_srai_2>:
 748:	0c 11       	rra	r12		;

0000074a <__mspabi_srai_1>:
 74a:	0c 11       	rra	r12		;
 74c:	30 41       	ret			

0000074e <.L11>:
 74e:	3d 53       	add	#-1,	r13	;r3 As==11
 750:	0c 11       	rra	r12		;

00000752 <__mspabi_srai>:
 752:	0d 93       	cmp	#0,	r13	;r3 As==00
 754:	fc 23       	jnz	$-6      	;abs 0x74e
 756:	30 41       	ret			

00000758 <__mspabi_sral_15>:
 758:	0d 11       	rra	r13		;
 75a:	0c 10       	rrc	r12		;

0000075c <__mspabi_sral_14>:
 75c:	0d 11       	rra	r13		;
 75e:	0c 10       	rrc	r12		;

00000760 <__mspabi_sral_13>:
 760:	0d 11       	rra	r13		;
 762:	0c 10       	rrc	r12		;

00000764 <__mspabi_sral_12>:
 764:	0d 11       	rra	r13		;
 766:	0c 10       	rrc	r12		;

00000768 <__mspabi_sral_11>:
 768:	0d 11       	rra	r13		;
 76a:	0c 10       	rrc	r12		;

0000076c <__mspabi_sral_10>:
 76c:	0d 11       	rra	r13		;
 76e:	0c 10       	rrc	r12		;

00000770 <__mspabi_sral_9>:
 770:	0d 11       	rra	r13		;
 772:	0c 10       	rrc	r12		;

00000774 <__mspabi_sral_8>:
 774:	0d 11       	rra	r13		;
 776:	0c 10       	rrc	r12		;

00000778 <__mspabi_sral_7>:
 778:	0d 11       	rra	r13		;
 77a:	0c 10       	rrc	r12		;

0000077c <__mspabi_sral_6>:
 77c:	0d 11       	rra	r13		;
 77e:	0c 10       	rrc	r12		;

00000780 <__mspabi_sral_5>:
 780:	0d 11       	rra	r13		;
 782:	0c 10       	rrc	r12		;

00000784 <__mspabi_sral_4>:
 784:	0d 11       	rra	r13		;
 786:	0c 10       	rrc	r12		;

00000788 <__mspabi_sral_3>:
 788:	0d 11       	rra	r13		;
 78a:	0c 10       	rrc	r12		;

0000078c <__mspabi_sral_2>:
 78c:	0d 11       	rra	r13		;
 78e:	0c 10       	rrc	r12		;

00000790 <__mspabi_sral_1>:
 790:	0d 11       	rra	r13		;
 792:	0c 10       	rrc	r12		;
 794:	30 41       	ret			

00000796 <.L12>:
 796:	3e 53       	add	#-1,	r14	;r3 As==11
 798:	0d 11       	rra	r13		;
 79a:	0c 10       	rrc	r12		;

0000079c <__mspabi_sral>:
 79c:	0e 93       	cmp	#0,	r14	;r3 As==00
 79e:	fb 23       	jnz	$-8      	;abs 0x796
 7a0:	30 41       	ret			

000007a2 <__mspabi_srli_15>:
 7a2:	12 c3       	clrc			
 7a4:	0c 10       	rrc	r12		;

000007a6 <__mspabi_srli_14>:
 7a6:	12 c3       	clrc			
 7a8:	0c 10       	rrc	r12		;

000007aa <__mspabi_srli_13>:
 7aa:	12 c3       	clrc			
 7ac:	0c 10       	rrc	r12		;

000007ae <__mspabi_srli_12>:
 7ae:	12 c3       	clrc			
 7b0:	0c 10       	rrc	r12		;

000007b2 <__mspabi_srli_11>:
 7b2:	12 c3       	clrc			
 7b4:	0c 10       	rrc	r12		;

000007b6 <__mspabi_srli_10>:
 7b6:	12 c3       	clrc			
 7b8:	0c 10       	rrc	r12		;

000007ba <__mspabi_srli_9>:
 7ba:	12 c3       	clrc			
 7bc:	0c 10       	rrc	r12		;

000007be <__mspabi_srli_8>:
 7be:	12 c3       	clrc			
 7c0:	0c 10       	rrc	r12		;

000007c2 <__mspabi_srli_7>:
 7c2:	12 c3       	clrc			
 7c4:	0c 10       	rrc	r12		;

000007c6 <__mspabi_srli_6>:
 7c6:	12 c3       	clrc			
 7c8:	0c 10       	rrc	r12		;

000007ca <__mspabi_srli_5>:
 7ca:	12 c3       	clrc			
 7cc:	0c 10       	rrc	r12		;

000007ce <__mspabi_srli_4>:
 7ce:	12 c3       	clrc			
 7d0:	0c 10       	rrc	r12		;

000007d2 <__mspabi_srli_3>:
 7d2:	12 c3       	clrc			
 7d4:	0c 10       	rrc	r12		;

000007d6 <__mspabi_srli_2>:
 7d6:	12 c3       	clrc			
 7d8:	0c 10       	rrc	r12		;

000007da <__mspabi_srli_1>:
 7da:	12 c3       	clrc			
 7dc:	0c 10       	rrc	r12		;
 7de:	30 41       	ret			

000007e0 <.L11>:
 7e0:	3d 53       	add	#-1,	r13	;r3 As==11
 7e2:	12 c3       	clrc			
 7e4:	0c 10       	rrc	r12		;

000007e6 <__mspabi_srli>:
 7e6:	0d 93       	cmp	#0,	r13	;r3 As==00
 7e8:	fb 23       	jnz	$-8      	;abs 0x7e0
 7ea:	30 41       	ret			

000007ec <__mspabi_srll_15>:
 7ec:	12 c3       	clrc			
 7ee:	0d 10       	rrc	r13		;
 7f0:	0c 10       	rrc	r12		;

000007f2 <__mspabi_srll_14>:
 7f2:	12 c3       	clrc			
 7f4:	0d 10       	rrc	r13		;
 7f6:	0c 10       	rrc	r12		;

000007f8 <__mspabi_srll_13>:
 7f8:	12 c3       	clrc			
 7fa:	0d 10       	rrc	r13		;
 7fc:	0c 10       	rrc	r12		;

000007fe <__mspabi_srll_12>:
 7fe:	12 c3       	clrc			
 800:	0d 10       	rrc	r13		;
 802:	0c 10       	rrc	r12		;

00000804 <__mspabi_srll_11>:
 804:	12 c3       	clrc			
 806:	0d 10       	rrc	r13		;
 808:	0c 10       	rrc	r12		;

0000080a <__mspabi_srll_10>:
 80a:	12 c3       	clrc			
 80c:	0d 10       	rrc	r13		;
 80e:	0c 10       	rrc	r12		;

00000810 <__mspabi_srll_9>:
 810:	12 c3       	clrc			
 812:	0d 10       	rrc	r13		;
 814:	0c 10       	rrc	r12		;

00000816 <__mspabi_srll_8>:
 816:	12 c3       	clrc			
 818:	0d 10       	rrc	r13		;
 81a:	0c 10       	rrc	r12		;

0000081c <__mspabi_srll_7>:
 81c:	12 c3       	clrc			
 81e:	0d 10       	rrc	r13		;
 820:	0c 10       	rrc	r12		;

00000822 <__mspabi_srll_6>:
 822:	12 c3       	clrc			
 824:	0d 10       	rrc	r13		;
 826:	0c 10       	rrc	r12		;

00000828 <__mspabi_srll_5>:
 828:	12 c3       	clrc			
 82a:	0d 10       	rrc	r13		;
 82c:	0c 10       	rrc	r12		;

0000082e <__mspabi_srll_4>:
 82e:	12 c3       	clrc			
 830:	0d 10       	rrc	r13		;
 832:	0c 10       	rrc	r12		;

00000834 <__mspabi_srll_3>:
 834:	12 c3       	clrc			
 836:	0d 10       	rrc	r13		;
 838:	0c 10       	rrc	r12		;

0000083a <__mspabi_srll_2>:
 83a:	12 c3       	clrc			
 83c:	0d 10       	rrc	r13		;
 83e:	0c 10       	rrc	r12		;

00000840 <__mspabi_srll_1>:
 840:	12 c3       	clrc			
 842:	0d 10       	rrc	r13		;
 844:	0c 10       	rrc	r12		;
 846:	30 41       	ret			

00000848 <.L12>:
 848:	3e 53       	add	#-1,	r14	;r3 As==11
 84a:	12 c3       	clrc			
 84c:	0d 10       	rrc	r13		;
 84e:	0c 10       	rrc	r12		;

00000850 <__mspabi_srll>:
 850:	0e 93       	cmp	#0,	r14	;r3 As==00
 852:	fa 23       	jnz	$-10     	;abs 0x848
 854:	30 41       	ret			

00000856 <memset>:
 856:	0f 4c       	mov	r12,	r15	;
 858:	0e 5c       	add	r12,	r14	;

0000085a <.L2>:
 85a:	0f 9e       	cmp	r14,	r15	;
 85c:	01 20       	jnz	$+4      	;abs 0x860

0000085e <.Loc.104.1>:
 85e:	30 41       	ret			

00000860 <.L3>:
 860:	cf 4d 00 00 	mov.b	r13,	0(r15)	;
 864:	1f 53       	inc	r15		;

00000866 <.LVL4>:
 866:	30 40 5a 08 	br	#0x085a		;

Disassembly of section .rodata:

0000086a <_etext-0x12a>:
 86a:	0a 4c       	mov	r12,	r10	;
 86c:	69 6d       	addc.b	@r13,	r9	;
 86e:	65 53       	incd.b	r5		;
 870:	44 52       	add.b	r2,	r4	;
 872:	2d 4d       	mov	@r13,	r13	;
 874:	69 6e       	addc.b	@r14,	r9	;
 876:	69 20       	jnz	$+212    	;abs 0x94a
 878:	46 61       	addc.b	r1,	r6	;
 87a:	63 74       	.word	0x7463;	????
 87c:	6f 72       	subc.b	#4,	r15	;r2 As==10
 87e:	79 20       	jnz	$+244    	;abs 0x972
 880:	46 69       	addc.b	r9,	r6	;
 882:	72 6d       	addc.b	@r13+,	r2	;
 884:	77 61       	addc.b	@r1+,	r7	;
 886:	72 65       	addc.b	@r5+,	r2	;
 888:	20 56       	add	@r6,	r0	;
 88a:	65 72       	subc.b	#4,	r5	;r2 As==10
 88c:	73 69       	.word	0x6973;	????
 88e:	6f 6e       	addc.b	@r14,	r15	;
 890:	3a 20       	jnz	$+118    	;abs 0x906
 892:	31 0a 00 45 	mova	17664(r10),r1	;0x04500
 896:	72 72       	subc.b	#8,	r2	;r2 As==11
 898:	6f 72       	subc.b	#4,	r15	;r2 As==10
 89a:	21 20       	jnz	$+68     	;abs 0x8de
 89c:	4e 6f       	addc.b	r15,	r14	;
 89e:	20 47       	br	@r7		;
 8a0:	50 49 4f 20 	br	8271(r9)		;
 8a4:	75 6e       	addc.b	@r14+,	r5	;
 8a6:	69 74       	subc.b	@r4,	r9	;
 8a8:	20 73       	subc	#2,	r0	;r3 As==10
 8aa:	79 6e       	addc.b	@r14+,	r9	;
 8ac:	74 68       	addc.b	@r8+,	r4	;
 8ae:	65 73       	subc.b	#2,	r5	;r3 As==10
 8b0:	69 7a       	subc.b	@r10,	r9	;
 8b2:	65 64       	addc.b	@r4,	r5	;
 8b4:	21 00 43 46 	mova	&17987,	r1	;0x04643
 8b8:	4d 30       	jn	$+156    	;abs 0x954
 8ba:	20 45       	br	@r5		;
 8bc:	72 61       	addc.b	@r1+,	r2	;
 8be:	73 65       	.word	0x6573;	????
 8c0:	64 0a 00 45 	mova	r10,	&279808	; 0x44500
 8c4:	72 61       	addc.b	@r1+,	r2	;
 8c6:	73 69       	.word	0x6973;	????
 8c8:	6e 67       	addc.b	@r7,	r14	;
 8ca:	20 43       	br	#2		;r3 As==10
 8cc:	46 4d       	mov.b	r13,	r6	;
 8ce:	30 0a 00 45 	bra	17664(r10)	;0x04500
 8d2:	72 61       	addc.b	@r1+,	r2	;
 8d4:	73 65       	.word	0x6573;	????
 8d6:	20 43       	br	#2		;r3 As==10
 8d8:	46 4d       	mov.b	r13,	r6	;
 8da:	30 20       	jnz	$+98     	;abs 0x93c
 8dc:	46 61       	addc.b	r1,	r6	;
 8de:	69 6c       	addc.b	@r12,	r9	;
 8e0:	65 64       	addc.b	@r4,	r5	;
 8e2:	0a 00       	mova	@r0,	r10	;
 8e4:	55 46 4d 20 	mov.b	8269(r6),r5	;0x0204d
 8e8:	49 44       	mov.b	r4,	r9	;
 8ea:	31 20       	jnz	$+100    	;abs 0x94e
 8ec:	45 72       	subc.b	r2,	r5	;
 8ee:	61 73       	subc.b	#2,	r1	;r3 As==10
 8f0:	65 64       	addc.b	@r4,	r5	;
 8f2:	0a 00       	mova	@r0,	r10	;
 8f4:	45 72       	subc.b	r2,	r5	;
 8f6:	61 73       	subc.b	#2,	r1	;r3 As==10
 8f8:	69 6e       	addc.b	@r14,	r9	;
 8fa:	67 20       	jnz	$+208    	;abs 0x9ca
 8fc:	55 46 4d 20 	mov.b	8269(r6),r5	;0x0204d
 900:	49 44       	mov.b	r4,	r9	;
 902:	31 0a 00 45 	mova	17664(r10),r1	;0x04500
 906:	72 61       	addc.b	@r1+,	r2	;
 908:	73 65       	.word	0x6573;	????
 90a:	20 55       	add	@r5,	r0	;
 90c:	46 4d       	mov.b	r13,	r6	;
 90e:	20 49       	br	@r9		;
 910:	44 31       	jn	$+650    	;abs 0xb9a
 912:	20 46       	br	@r6		;
 914:	61 69       	addc.b	@r9,	r1	;
 916:	6c 65       	addc.b	@r5,	r12	;
 918:	64 0a 00 55 	mova	r10,	&283904	; 0x45500
 91c:	46 4d       	mov.b	r13,	r6	;
 91e:	20 49       	br	@r9		;
 920:	44 32       	jn	$-886    	;abs 0x5aa
 922:	20 45       	br	@r5		;
 924:	72 61       	addc.b	@r1+,	r2	;
 926:	73 65       	.word	0x6573;	????
 928:	64 0a 00 45 	mova	r10,	&279808	; 0x44500
 92c:	72 61       	addc.b	@r1+,	r2	;
 92e:	73 69       	.word	0x6973;	????
 930:	6e 67       	addc.b	@r7,	r14	;
 932:	20 55       	add	@r5,	r0	;
 934:	46 4d       	mov.b	r13,	r6	;
 936:	20 49       	br	@r9		;
 938:	44 32       	jn	$-886    	;abs 0x5c2
 93a:	0a 00       	mova	@r0,	r10	;
 93c:	45 72       	subc.b	r2,	r5	;
 93e:	61 73       	subc.b	#2,	r1	;r3 As==10
 940:	65 20       	jnz	$+204    	;abs 0xa0c
 942:	55 46 4d 20 	mov.b	8269(r6),r5	;0x0204d
 946:	49 44       	mov.b	r4,	r9	;
 948:	32 20       	jnz	$+102    	;abs 0x9ae
 94a:	46 61       	addc.b	r1,	r6	;
 94c:	69 6c       	addc.b	@r12,	r9	;
 94e:	65 64       	addc.b	@r4,	r5	;
 950:	0a 00       	mova	@r0,	r10	;
 952:	57 72 69 74 	subc.b	&0x7469,r7	;0x7469
 956:	65 20       	jnz	$+204    	;abs 0xa22
 958:	74 6f       	addc.b	@r15+,	r4	;
 95a:	20 61       	addc	@r1,	r0	;
 95c:	64 64       	addc.b	@r4,	r4	;
 95e:	72 20       	jnz	$+230    	;abs 0xa44
 960:	66 61       	addc.b	@r1,	r6	;
 962:	69 6c       	addc.b	@r12,	r9	;
 964:	65 64       	addc.b	@r4,	r5	;
 966:	0a 00       	mova	@r0,	r10	;
 968:	50 72 6f 67 	subc.b	&0x676f,r0	;0x676f
 96c:	72 61       	addc.b	@r1+,	r2	;
 96e:	6d 69       	addc.b	@r9,	r13	;
 970:	6e 67       	addc.b	@r7,	r14	;
 972:	20 43       	br	#2		;r3 As==10
 974:	46 4d       	mov.b	r13,	r6	;
 976:	30 20       	jnz	$+98     	;abs 0x9d8
 978:	46 69       	addc.b	r9,	r6	;
 97a:	6e 69       	addc.b	@r9,	r14	;
 97c:	73 68       	.word	0x6873;	????
 97e:	65 64       	addc.b	@r4,	r5	;
 980:	0a 00       	mova	@r0,	r10	;
 982:	43 6f       	.word	0x6f43;	????
 984:	6d 6d       	addc.b	@r13,	r13	;
 986:	61 6e       	addc.b	@r14,	r1	;
 988:	64 3a       	jl	$-822    	;abs 0x652
 98a:	20 55       	add	@r5,	r0	;
 98c:	4e 4b       	mov.b	r11,	r14	;
 98e:	4e 4f       	mov.b	r15,	r14	;
 990:	57 4e 0a 00 	mov.b	10(r14),r7	;0x0000a

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
  3e:	30 00 fb d1 	Address 0x00000040 is out of bounds.
bra	-1(r0)		;PC rel. 0x0003f
