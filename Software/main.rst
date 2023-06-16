                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _replyD8
                                     12 	.globl _main
                                     13 	.globl _i2cirq
                                     14 	.globl _I2CRead
                                     15 	.globl _I2CInit
                                     16 	.globl _prev_pin_stat
                                     17 	.globl _current_pin_stat
                                     18 	.globl _replycnt
                                     19 	.globl _replyF4
                                     20 	.globl _i2c_reply
                                     21 	.globl _return_i2c
                                     22 	.globl _Event
                                     23 ;--------------------------------------------------------
                                     24 ; ram data
                                     25 ;--------------------------------------------------------
                                     26 	.area DATA
                                     27 ;--------------------------------------------------------
                                     28 ; ram data
                                     29 ;--------------------------------------------------------
                                     30 	.area INITIALIZED
      000001                         31 _Event::
      000001                         32 	.ds 2
      000003                         33 _return_i2c::
      000003                         34 	.ds 1
      000004                         35 _i2c_reply::
      000004                         36 	.ds 1
      000005                         37 _replyF4::
      000005                         38 	.ds 1
      000006                         39 _replycnt::
      000006                         40 	.ds 1
      000007                         41 _current_pin_stat::
      000007                         42 	.ds 1
      000008                         43 _prev_pin_stat::
      000008                         44 	.ds 1
                                     45 ;--------------------------------------------------------
                                     46 ; Stack segment in internal ram 
                                     47 ;--------------------------------------------------------
                                     48 	.area	SSEG
      FFFFFF                         49 __start__stack:
      FFFFFF                         50 	.ds	1
                                     51 
                                     52 ;--------------------------------------------------------
                                     53 ; absolute external ram data
                                     54 ;--------------------------------------------------------
                                     55 	.area DABS (ABS)
                                     56 
                                     57 ; default segment ordering for linker
                                     58 	.area HOME
                                     59 	.area GSINIT
                                     60 	.area GSFINAL
                                     61 	.area CONST
                                     62 	.area INITIALIZER
                                     63 	.area CODE
                                     64 
                                     65 ;--------------------------------------------------------
                                     66 ; interrupt vector 
                                     67 ;--------------------------------------------------------
                                     68 	.area HOME
      008000                         69 __interrupt_vect:
      008000 82 00 80 5B             70 	int s_GSINIT ; reset
      008004 82 00 00 00             71 	int 0x000000 ; trap
      008008 82 00 00 00             72 	int 0x000000 ; int0
      00800C 82 00 00 00             73 	int 0x000000 ; int1
      008010 82 00 00 00             74 	int 0x000000 ; int2
      008014 82 00 00 00             75 	int 0x000000 ; int3
      008018 82 00 00 00             76 	int 0x000000 ; int4
      00801C 82 00 00 00             77 	int 0x000000 ; int5
      008020 82 00 00 00             78 	int 0x000000 ; int6
      008024 82 00 00 00             79 	int 0x000000 ; int7
      008028 82 00 00 00             80 	int 0x000000 ; int8
      00802C 82 00 00 00             81 	int 0x000000 ; int9
      008030 82 00 00 00             82 	int 0x000000 ; int10
      008034 82 00 00 00             83 	int 0x000000 ; int11
      008038 82 00 00 00             84 	int 0x000000 ; int12
      00803C 82 00 00 00             85 	int 0x000000 ; int13
      008040 82 00 00 00             86 	int 0x000000 ; int14
      008044 82 00 00 00             87 	int 0x000000 ; int15
      008048 82 00 00 00             88 	int 0x000000 ; int16
      00804C 82 00 00 00             89 	int 0x000000 ; int17
      008050 82 00 00 00             90 	int 0x000000 ; int18
      008054 82 00 80 E9             91 	int _i2cirq ; int19
                                     92 ;--------------------------------------------------------
                                     93 ; global & static initialisations
                                     94 ;--------------------------------------------------------
                                     95 	.area HOME
                                     96 	.area GSINIT
                                     97 	.area GSFINAL
                                     98 	.area GSINIT
      00805B                         99 __sdcc_gs_init_startup:
      00805B                        100 __sdcc_init_data:
                                    101 ; stm8_genXINIT() start
      00805B AE 00 00         [ 2]  102 	ldw x, #l_DATA
      00805E 27 07            [ 1]  103 	jreq	00002$
      008060                        104 00001$:
      008060 72 4F 00 00      [ 1]  105 	clr (s_DATA - 1, x)
      008064 5A               [ 2]  106 	decw x
      008065 26 F9            [ 1]  107 	jrne	00001$
      008067                        108 00002$:
      008067 AE 00 08         [ 2]  109 	ldw	x, #l_INITIALIZER
      00806A 27 09            [ 1]  110 	jreq	00004$
      00806C                        111 00003$:
      00806C D6 80 7D         [ 1]  112 	ld	a, (s_INITIALIZER - 1, x)
      00806F D7 00 00         [ 1]  113 	ld	(s_INITIALIZED - 1, x), a
      008072 5A               [ 2]  114 	decw	x
      008073 26 F7            [ 1]  115 	jrne	00003$
      008075                        116 00004$:
                                    117 ; stm8_genXINIT() end
                                    118 	.area GSFINAL
      008075 CC 80 58         [ 2]  119 	jp	__sdcc_program_startup
                                    120 ;--------------------------------------------------------
                                    121 ; Home
                                    122 ;--------------------------------------------------------
                                    123 	.area HOME
                                    124 	.area HOME
      008058                        125 __sdcc_program_startup:
      008058 CC 81 D3         [ 2]  126 	jp	_main
                                    127 ;	return from main will return to caller
                                    128 ;--------------------------------------------------------
                                    129 ; code
                                    130 ;--------------------------------------------------------
                                    131 	.area CODE
                                    132 ;	main.c: 23: void I2CInit() {
                                    133 ;	-----------------------------------------
                                    134 ;	 function I2CInit
                                    135 ;	-----------------------------------------
      008086                        136 _I2CInit:
                                    137 ;	main.c: 24: I2C_FREQR |= 16;// 16MHz/10^6
      008086 72 18 52 12      [ 1]  138 	bset	21010, #4
                                    139 ;	main.c: 26: I2C_CR1 &= ~0x01;// cmd disable for i2c configurating
      00808A 72 11 52 10      [ 1]  140 	bres	21008, #0
                                    141 ;	main.c: 28: I2C_TRISER |= (uint8_t)(17);// Riser time  
      00808E C6 52 1D         [ 1]  142 	ld	a, 0x521d
      008091 AA 11            [ 1]  143 	or	a, #0x11
      008093 C7 52 1D         [ 1]  144 	ld	0x521d, a
                                    145 ;	main.c: 30: I2C_CCRL = 0x50;
      008096 35 50 52 1B      [ 1]  146 	mov	0x521b+0, #0x50
                                    147 ;	main.c: 31: I2C_CCRH = 0x00;
      00809A 35 00 52 1C      [ 1]  148 	mov	0x521c+0, #0x00
                                    149 ;	main.c: 33: I2C_CR1 |= 0x80;// No clock stretching.
      00809E 72 1E 52 10      [ 1]  150 	bset	21008, #7
                                    151 ;	main.c: 35: I2C_OARL = (devID << 1);
      0080A2 35 10 52 13      [ 1]  152 	mov	0x5213+0, #0x10
                                    153 ;	main.c: 36: I2C_OARH = (1 << 6);
      0080A6 35 40 52 14      [ 1]  154 	mov	0x5214+0, #0x40
                                    155 ;	main.c: 38: I2C_CR1 |= (1 << 0);// cmd enable
      0080AA 72 10 52 10      [ 1]  156 	bset	21008, #0
                                    157 ;	main.c: 39: I2C_CR2 |= (1 << 2);
      0080AE C6 52 11         [ 1]  158 	ld	a, 0x5211
      0080B1 AA 04            [ 1]  159 	or	a, #0x04
      0080B3 C7 52 11         [ 1]  160 	ld	0x5211, a
                                    161 ;	main.c: 41: I2C_ITR |= (1 << 0) | (1 << 1) | (1 << 2);// enable interrupt (buffer, event and error interrupt)
      0080B6 C6 52 1A         [ 1]  162 	ld	a, 0x521a
      0080B9 AA 07            [ 1]  163 	or	a, #0x07
      0080BB C7 52 1A         [ 1]  164 	ld	0x521a, a
                                    165 ;	main.c: 42: }
      0080BE 81               [ 4]  166 	ret
                                    167 ;	main.c: 44: static uint16_t I2CReadStat(){
                                    168 ;	-----------------------------------------
                                    169 ;	 function I2CReadStat
                                    170 ;	-----------------------------------------
      0080BF                        171 _I2CReadStat:
      0080BF 52 04            [ 2]  172 	sub	sp, #4
                                    173 ;	main.c: 46: (void)I2C_SR2;
      0080C1 C6 52 18         [ 1]  174 	ld	a, 0x5218
                                    175 ;	main.c: 47: I2C_SR2 = 0;
      0080C4 35 00 52 18      [ 1]  176 	mov	0x5218+0, #0x00
                                    177 ;	main.c: 52: flag1 = I2C_SR1;
      0080C8 C6 52 17         [ 1]  178 	ld	a, 0x5217
      0080CB 97               [ 1]  179 	ld	xl, a
                                    180 ;	main.c: 53: flag2 = I2C_SR3;
      0080CC C6 52 19         [ 1]  181 	ld	a, 0x5219
                                    182 ;	main.c: 54: return  ((uint16_t)((uint16_t)flag2 << (uint16_t)8) | (uint16_t)flag1);
      0080CF 95               [ 1]  183 	ld	xh, a
      0080D0 0F 02            [ 1]  184 	clr	(0x02, sp)
      0080D2 9F               [ 1]  185 	ld	a, xl
      0080D3 0F 03            [ 1]  186 	clr	(0x03, sp)
      0080D5 1A 02            [ 1]  187 	or	a, (0x02, sp)
      0080D7 02               [ 1]  188 	rlwa	x
      0080D8 1A 03            [ 1]  189 	or	a, (0x03, sp)
      0080DA 95               [ 1]  190 	ld	xh, a
                                    191 ;	main.c: 55: }
      0080DB 5B 04            [ 2]  192 	addw	sp, #4
      0080DD 81               [ 4]  193 	ret
                                    194 ;	main.c: 57: uint8_t I2CRead(){
                                    195 ;	-----------------------------------------
                                    196 ;	 function I2CRead
                                    197 ;	-----------------------------------------
      0080DE                        198 _I2CRead:
                                    199 ;	main.c: 59: while(!(I2C_SR1 & 0x40));
      0080DE                        200 00101$:
      0080DE C6 52 17         [ 1]  201 	ld	a, 0x5217
      0080E1 A5 40            [ 1]  202 	bcp	a, #0x40
      0080E3 27 F9            [ 1]  203 	jreq	00101$
                                    204 ;	main.c: 60: return ((uint8_t)I2C_DR);
      0080E5 C6 52 16         [ 1]  205 	ld	a, 0x5216
                                    206 ;	main.c: 61: }
      0080E8 81               [ 4]  207 	ret
                                    208 ;	main.c: 65: void i2cirq(void) __interrupt(19){
                                    209 ;	-----------------------------------------
                                    210 ;	 function i2cirq
                                    211 ;	-----------------------------------------
      0080E9                        212 _i2cirq:
                                    213 ;	main.c: 67: uint8_t i2cint = I2C_SR2 & 0x0F;
      0080E9 C6 52 18         [ 1]  214 	ld	a, 0x5218
      0080EC A5 0F            [ 1]  215 	bcp	a, #0x0f
      0080EE 27 08            [ 1]  216 	jreq	00102$
                                    217 ;	main.c: 68: if(i2cint){
                                    218 ;	main.c: 69: I2C_SR2 &= ~(0x0F);
      0080F0 C6 52 18         [ 1]  219 	ld	a, 0x5218
      0080F3 A4 F0            [ 1]  220 	and	a, #0xf0
      0080F5 C7 52 18         [ 1]  221 	ld	0x5218, a
      0080F8                        222 00102$:
                                    223 ;	main.c: 72: switch(I2CReadStat()){
      0080F8 CD 80 BF         [ 4]  224 	call	_I2CReadStat
      0080FB A3 00 10         [ 2]  225 	cpw	x, #0x0010
      0080FE 27 65            [ 1]  226 	jreq	00114$
      008100 A3 02 02         [ 2]  227 	cpw	x, #0x0202
      008103 27 0D            [ 1]  228 	jreq	00103$
      008105 A3 02 40         [ 2]  229 	cpw	x, #0x0240
      008108 27 45            [ 1]  230 	jreq	00111$
      00810A A3 06 80         [ 2]  231 	cpw	x, #0x0680
      00810D 27 5C            [ 1]  232 	jreq	00116$
      00810F CC 81 D2         [ 2]  233 	jp	00128$
                                    234 ;	main.c: 74: case 0x0202 : //I2C_EVENT_SLAVE_RECEIVER_ADDRESS_MATCHED 
      008112                        235 00103$:
                                    236 ;	main.c: 76: switch(I2CRead()){
      008112 CD 80 DE         [ 4]  237 	call	_I2CRead
      008115 A1 D8            [ 1]  238 	cp	a, #0xd8
      008117 27 28            [ 1]  239 	jreq	00107$
      008119 A1 E5            [ 1]  240 	cp	a, #0xe5
      00811B 27 0F            [ 1]  241 	jreq	00104$
      00811D A1 E6            [ 1]  242 	cp	a, #0xe6
      00811F 27 12            [ 1]  243 	jreq	00105$
      008121 A1 E8            [ 1]  244 	cp	a, #0xe8
      008123 27 15            [ 1]  245 	jreq	00106$
      008125 A1 F4            [ 1]  246 	cp	a, #0xf4
      008127 27 1F            [ 1]  247 	jreq	00108$
      008129 CC 81 D2         [ 2]  248 	jp	00128$
                                    249 ;	main.c: 77: case 0xE5: 
      00812C                        250 00104$:
                                    251 ;	main.c: 78: i2c_reply = 0xE5;
      00812C 35 E5 00 04      [ 1]  252 	mov	_i2c_reply+0, #0xe5
                                    253 ;	main.c: 80: break;
      008130 CC 81 D2         [ 2]  254 	jp	00128$
                                    255 ;	main.c: 82: case 0xE6:
      008133                        256 00105$:
                                    257 ;	main.c: 83: i2c_reply = 0xE6;
      008133 35 E6 00 04      [ 1]  258 	mov	_i2c_reply+0, #0xe6
                                    259 ;	main.c: 85: break;
      008137 CC 81 D2         [ 2]  260 	jp	00128$
                                    261 ;	main.c: 87: case 0xE8:
      00813A                        262 00106$:
                                    263 ;	main.c: 88: i2c_reply = 0xE8;
      00813A 35 E8 00 04      [ 1]  264 	mov	_i2c_reply+0, #0xe8
                                    265 ;	main.c: 90: break;
      00813E CC 81 D2         [ 2]  266 	jp	00128$
                                    267 ;	main.c: 92: case 0xD8:
      008141                        268 00107$:
                                    269 ;	main.c: 93: i2c_reply = 0xD8;
      008141 35 D8 00 04      [ 1]  270 	mov	_i2c_reply+0, #0xd8
                                    271 ;	main.c: 95: break;
      008145 CC 81 D2         [ 2]  272 	jp	00128$
                                    273 ;	main.c: 97: case 0xF4:
      008148                        274 00108$:
                                    275 ;	main.c: 98: i2c_reply = 0xF4;
      008148 35 F4 00 04      [ 1]  276 	mov	_i2c_reply+0, #0xf4
                                    277 ;	main.c: 100: break;
      00814C CC 81 D2         [ 2]  278 	jp	00128$
                                    279 ;	main.c: 107: case 0x0240: //I2C_EVENT_SLAVE_BYTE_RECEIVED
      00814F                        280 00111$:
                                    281 ;	main.c: 110: if(i2c_reply == 0xF4){
      00814F C6 00 04         [ 1]  282 	ld	a, _i2c_reply+0
      008152 A1 F4            [ 1]  283 	cp	a, #0xf4
      008154 27 03            [ 1]  284 	jreq	00245$
      008156 CC 81 D2         [ 2]  285 	jp	00128$
      008159                        286 00245$:
                                    287 ;	main.c: 111: replyF4 = I2CRead();// LED status parameter.
      008159 CD 80 DE         [ 4]  288 	call	_I2CRead
      00815C C7 00 05         [ 1]  289 	ld	_replyF4+0, a
                                    290 ;	main.c: 112: i2c_reply = 0;
      00815F 72 5F 00 04      [ 1]  291 	clr	_i2c_reply+0
                                    292 ;	main.c: 119: break;
      008163 20 6D            [ 2]  293 	jra	00128$
                                    294 ;	main.c: 121: case 0x0010:// I2C_EVENT_SLAVE_STOP_RECEIVED	
      008165                        295 00114$:
                                    296 ;	main.c: 122: I2C_CR2 |= (1 << I2C_CR2_ACK);// send ack 
      008165 72 14 52 11      [ 1]  297 	bset	21009, #2
                                    298 ;	main.c: 124: break;
      008169 20 67            [ 2]  299 	jra	00128$
                                    300 ;	main.c: 131: case 0x0680: //I2C_EVENT_SLAVE_BYTE_TRANSMITTING
      00816B                        301 00116$:
                                    302 ;	main.c: 132: (void)I2C_SR1;
      00816B C6 52 17         [ 1]  303 	ld	a, 0x5217
                                    304 ;	main.c: 133: (void)I2C_SR3;
      00816E C6 52 19         [ 1]  305 	ld	a, 0x5219
                                    306 ;	main.c: 134: switch(i2c_reply){
      008171 C6 00 04         [ 1]  307 	ld	a, _i2c_reply+0
      008174 A1 D8            [ 1]  308 	cp	a, #0xd8
      008176 27 30            [ 1]  309 	jreq	00120$
      008178 A1 E5            [ 1]  310 	cp	a, #0xe5
      00817A 27 0E            [ 1]  311 	jreq	00117$
      00817C A1 E6            [ 1]  312 	cp	a, #0xe6
      00817E 27 14            [ 1]  313 	jreq	00118$
      008180 A1 E8            [ 1]  314 	cp	a, #0xe8
      008182 27 1A            [ 1]  315 	jreq	00119$
      008184 A1 F4            [ 1]  316 	cp	a, #0xf4
      008186 27 41            [ 1]  317 	jreq	00123$
      008188 20 48            [ 2]  318 	jra	00128$
                                    319 ;	main.c: 135: case 0xE5:// Read NVM status
      00818A                        320 00117$:
                                    321 ;	main.c: 136: I2C_DR = 0x45;// NVM is locked 
      00818A 35 45 52 16      [ 1]  322 	mov	0x5216+0, #0x45
                                    323 ;	main.c: 137: i2c_reply = 0;
      00818E 72 5F 00 04      [ 1]  324 	clr	_i2c_reply+0
                                    325 ;	main.c: 139: break;
      008192 20 3E            [ 2]  326 	jra	00128$
                                    327 ;	main.c: 141: case 0xE6:// Pattern ID (need more investigation).
      008194                        328 00118$:
                                    329 ;	main.c: 142: I2C_DR = 0x69;
      008194 35 69 52 16      [ 1]  330 	mov	0x5216+0, #0x69
                                    331 ;	main.c: 143: i2c_reply = 0;
      008198 72 5F 00 04      [ 1]  332 	clr	_i2c_reply+0
                                    333 ;	main.c: 145: break;
      00819C 20 34            [ 2]  334 	jra	00128$
                                    335 ;	main.c: 147: case 0xE8:// Read from reserved... (need more investigation).
      00819E                        336 00119$:
                                    337 ;	main.c: 148: I2C_DR = 0x52;
      00819E 35 52 52 16      [ 1]  338 	mov	0x5216+0, #0x52
                                    339 ;	main.c: 149: i2c_reply = 0;
      0081A2 72 5F 00 04      [ 1]  340 	clr	_i2c_reply+0
                                    341 ;	main.c: 151: break;
      0081A6 20 2A            [ 2]  342 	jra	00128$
                                    343 ;	main.c: 153: case 0xD8:// Read from SLG46582V OTP memory (6 bytes respond)
      0081A8                        344 00120$:
                                    345 ;	main.c: 154: I2C_DR = replyD8[replycnt];
      0081A8 5F               [ 1]  346 	clrw	x
      0081A9 C6 00 06         [ 1]  347 	ld	a, _replycnt+0
      0081AC 97               [ 1]  348 	ld	xl, a
      0081AD 1C 80 78         [ 2]  349 	addw	x, #(_replyD8 + 0)
      0081B0 F6               [ 1]  350 	ld	a, (x)
      0081B1 C7 52 16         [ 1]  351 	ld	0x5216, a
                                    352 ;	main.c: 155: replycnt += 1;
      0081B4 72 5C 00 06      [ 1]  353 	inc	_replycnt+0
                                    354 ;	main.c: 156: if(replycnt == 6){
      0081B8 C6 00 06         [ 1]  355 	ld	a, _replycnt+0
      0081BB A1 06            [ 1]  356 	cp	a, #0x06
      0081BD 26 13            [ 1]  357 	jrne	00128$
                                    358 ;	main.c: 157: replycnt = 0;
      0081BF 72 5F 00 06      [ 1]  359 	clr	_replycnt+0
                                    360 ;	main.c: 158: i2c_reply = 0;
      0081C3 72 5F 00 04      [ 1]  361 	clr	_i2c_reply+0
                                    362 ;	main.c: 161: break;
      0081C7 20 09            [ 2]  363 	jra	00128$
                                    364 ;	main.c: 163: case 0xF4:// set virtual input to toggle something inside SLG46582V.
      0081C9                        365 00123$:
                                    366 ;	main.c: 164: I2C_DR = replyF4;// Register read-back capability.
      0081C9 55 00 05 52 16   [ 1]  367 	mov	0x5216+0, _replyF4+0
                                    368 ;	main.c: 165: i2c_reply = 0;
      0081CE 72 5F 00 04      [ 1]  369 	clr	_i2c_reply+0
                                    370 ;	main.c: 178: }
      0081D2                        371 00128$:
                                    372 ;	main.c: 180: }
      0081D2 80               [11]  373 	iret
                                    374 ;	main.c: 185: void main(){
                                    375 ;	-----------------------------------------
                                    376 ;	 function main
                                    377 ;	-----------------------------------------
      0081D3                        378 _main:
                                    379 ;	main.c: 186: PC_DDR |= (1 << 3);
      0081D3 72 16 50 0C      [ 1]  380 	bset	20492, #3
                                    381 ;	main.c: 187: PC_CR1 |= (1 << 3);
      0081D7 C6 50 0D         [ 1]  382 	ld	a, 0x500d
      0081DA AA 08            [ 1]  383 	or	a, #0x08
      0081DC C7 50 0D         [ 1]  384 	ld	0x500d, a
                                    385 ;	main.c: 188: CLK_CKDIVR = 0;
      0081DF 35 00 50 C6      [ 1]  386 	mov	0x50c6+0, #0x00
                                    387 ;	main.c: 189: I2CInit();// init i2c as slave having address 0x65
      0081E3 CD 80 86         [ 4]  388 	call	_I2CInit
                                    389 ;	main.c: 190: prev_pin_stat = 1;
      0081E6 35 01 00 08      [ 1]  390 	mov	_prev_pin_stat+0, #0x01
                                    391 ;	main.c: 191: __asm__("rim");// enble interrupt
      0081EA 9A               [ 1]  392 	rim
                                    393 ;	main.c: 193: while(1){
      0081EB                        394 00107$:
                                    395 ;	main.c: 197: current_pin_stat = PD_IDR & (1 << 6);// detect pin change on GP0
      0081EB C6 50 10         [ 1]  396 	ld	a, 0x5010
      0081EE A4 40            [ 1]  397 	and	a, #0x40
                                    398 ;	main.c: 198: if(prev_pin_stat != current_pin_stat){
      0081F0 C7 00 07         [ 1]  399 	ld	_current_pin_stat+0, a
      0081F3 C1 00 08         [ 1]  400 	cp	a, _prev_pin_stat+0
      0081F6 27 F3            [ 1]  401 	jreq	00107$
                                    402 ;	main.c: 204: PC_ODR |= (1 << 3);
      0081F8 C6 50 0A         [ 1]  403 	ld	a, 0x500a
                                    404 ;	main.c: 200: if(current_pin_stat){
      0081FB 72 5D 00 07      [ 1]  405 	tnz	_current_pin_stat+0
      0081FF 27 11            [ 1]  406 	jreq	00102$
                                    407 ;	main.c: 202: __asm__("sim");
      008201 9B               [ 1]  408 	sim
                                    409 ;	main.c: 204: PC_ODR |= (1 << 3);
      008202 AA 08            [ 1]  410 	or	a, #0x08
      008204 C7 50 0A         [ 1]  411 	ld	0x500a, a
                                    412 ;	main.c: 205: I2C_CR1 &= ~(1 << 0);
      008207 C6 52 10         [ 1]  413 	ld	a, 0x5210
      00820A A4 FE            [ 1]  414 	and	a, #0xfe
      00820C C7 52 10         [ 1]  415 	ld	0x5210, a
                                    416 ;	main.c: 206: __asm__("rim");
      00820F 9A               [ 1]  417 	rim
      008210 20 0A            [ 2]  418 	jra	00103$
      008212                        419 00102$:
                                    420 ;	main.c: 210: __asm__("sim");
      008212 9B               [ 1]  421 	sim
                                    422 ;	main.c: 212: PC_ODR &= ~(1 << 3);	
      008213 A4 F7            [ 1]  423 	and	a, #0xf7
      008215 C7 50 0A         [ 1]  424 	ld	0x500a, a
                                    425 ;	main.c: 213: I2CInit();
      008218 CD 80 86         [ 4]  426 	call	_I2CInit
                                    427 ;	main.c: 214: __asm__("rim");
      00821B 9A               [ 1]  428 	rim
      00821C                        429 00103$:
                                    430 ;	main.c: 218: prev_pin_stat = current_pin_stat;
      00821C 55 00 07 00 08   [ 1]  431 	mov	_prev_pin_stat+0, _current_pin_stat+0
      008221 20 C8            [ 2]  432 	jra	00107$
                                    433 ;	main.c: 224: }// main 
      008223 81               [ 4]  434 	ret
                                    435 	.area CODE
                                    436 	.area CONST
      008078                        437 _replyD8:
      008078 11                     438 	.db #0x11	; 17
      008079 12                     439 	.db #0x12	; 18
      00807A 13                     440 	.db #0x13	; 19
      00807B 14                     441 	.db #0x14	; 20
      00807C 15                     442 	.db #0x15	; 21
      00807D 16                     443 	.db #0x16	; 22
                                    444 	.area INITIALIZER
      00807E                        445 __xinit__Event:
      00807E 00 00                  446 	.dw #0x0000
      008080                        447 __xinit__return_i2c:
      008080 00                     448 	.db #0x00	; 0
      008081                        449 __xinit__i2c_reply:
      008081 00                     450 	.db #0x00	; 0
      008082                        451 __xinit__replyF4:
      008082 00                     452 	.db #0x00	; 0
      008083                        453 __xinit__replycnt:
      008083 00                     454 	.db #0x00	; 0
      008084                        455 __xinit__current_pin_stat:
      008084 00                     456 	.db #0x00	; 0
      008085                        457 __xinit__prev_pin_stat:
      008085 00                     458 	.db #0x00	; 0
                                    459 	.area CABS (ABS)
