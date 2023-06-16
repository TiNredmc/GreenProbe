;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _replyD8
	.globl _main
	.globl _i2cirq
	.globl _I2CRead
	.globl _I2CInit
	.globl _prev_pin_stat
	.globl _current_pin_stat
	.globl _replycnt
	.globl _replyF4
	.globl _i2c_reply
	.globl _return_i2c
	.globl _Event
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_Event::
	.ds 2
_return_i2c::
	.ds 1
_i2c_reply::
	.ds 1
_replyF4::
	.ds 1
_replycnt::
	.ds 1
_current_pin_stat::
	.ds 1
_prev_pin_stat::
	.ds 1
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)

; default segment ordering for linker
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area CONST
	.area INITIALIZER
	.area CODE

;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
	int 0x000000 ; trap
	int 0x000000 ; int0
	int 0x000000 ; int1
	int 0x000000 ; int2
	int 0x000000 ; int3
	int 0x000000 ; int4
	int 0x000000 ; int5
	int 0x000000 ; int6
	int 0x000000 ; int7
	int 0x000000 ; int8
	int 0x000000 ; int9
	int 0x000000 ; int10
	int 0x000000 ; int11
	int 0x000000 ; int12
	int 0x000000 ; int13
	int 0x000000 ; int14
	int 0x000000 ; int15
	int 0x000000 ; int16
	int 0x000000 ; int17
	int 0x000000 ; int18
	int _i2cirq ; int19
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
__sdcc_gs_init_startup:
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	main.c: 23: void I2CInit() {
;	-----------------------------------------
;	 function I2CInit
;	-----------------------------------------
_I2CInit:
;	main.c: 24: I2C_FREQR |= 16;// 16MHz/10^6
	bset	21010, #4
;	main.c: 26: I2C_CR1 &= ~0x01;// cmd disable for i2c configurating
	bres	21008, #0
;	main.c: 28: I2C_TRISER |= (uint8_t)(17);// Riser time  
	ld	a, 0x521d
	or	a, #0x11
	ld	0x521d, a
;	main.c: 30: I2C_CCRL = 0x50;
	mov	0x521b+0, #0x50
;	main.c: 31: I2C_CCRH = 0x00;
	mov	0x521c+0, #0x00
;	main.c: 33: I2C_CR1 |= 0x80;// No clock stretching.
	bset	21008, #7
;	main.c: 35: I2C_OARL = (devID << 1);
	mov	0x5213+0, #0x10
;	main.c: 36: I2C_OARH = (1 << 6);
	mov	0x5214+0, #0x40
;	main.c: 38: I2C_CR1 |= (1 << 0);// cmd enable
	bset	21008, #0
;	main.c: 39: I2C_CR2 |= (1 << 2);
	ld	a, 0x5211
	or	a, #0x04
	ld	0x5211, a
;	main.c: 41: I2C_ITR |= (1 << 0) | (1 << 1) | (1 << 2);// enable interrupt (buffer, event and error interrupt)
	ld	a, 0x521a
	or	a, #0x07
	ld	0x521a, a
;	main.c: 42: }
	ret
;	main.c: 44: static uint16_t I2CReadStat(){
;	-----------------------------------------
;	 function I2CReadStat
;	-----------------------------------------
_I2CReadStat:
	sub	sp, #4
;	main.c: 46: (void)I2C_SR2;
	ld	a, 0x5218
;	main.c: 47: I2C_SR2 = 0;
	mov	0x5218+0, #0x00
;	main.c: 52: flag1 = I2C_SR1;
	ld	a, 0x5217
	ld	xl, a
;	main.c: 53: flag2 = I2C_SR3;
	ld	a, 0x5219
;	main.c: 54: return  ((uint16_t)((uint16_t)flag2 << (uint16_t)8) | (uint16_t)flag1);
	ld	xh, a
	clr	(0x02, sp)
	ld	a, xl
	clr	(0x03, sp)
	or	a, (0x02, sp)
	rlwa	x
	or	a, (0x03, sp)
	ld	xh, a
;	main.c: 55: }
	addw	sp, #4
	ret
;	main.c: 57: uint8_t I2CRead(){
;	-----------------------------------------
;	 function I2CRead
;	-----------------------------------------
_I2CRead:
;	main.c: 59: while(!(I2C_SR1 & 0x40));
00101$:
	ld	a, 0x5217
	bcp	a, #0x40
	jreq	00101$
;	main.c: 60: return ((uint8_t)I2C_DR);
	ld	a, 0x5216
;	main.c: 61: }
	ret
;	main.c: 65: void i2cirq(void) __interrupt(19){
;	-----------------------------------------
;	 function i2cirq
;	-----------------------------------------
_i2cirq:
;	main.c: 67: uint8_t i2cint = I2C_SR2 & 0x0F;
	ld	a, 0x5218
	bcp	a, #0x0f
	jreq	00102$
;	main.c: 68: if(i2cint){
;	main.c: 69: I2C_SR2 &= ~(0x0F);
	ld	a, 0x5218
	and	a, #0xf0
	ld	0x5218, a
00102$:
;	main.c: 72: switch(I2CReadStat()){
	call	_I2CReadStat
	cpw	x, #0x0010
	jreq	00114$
	cpw	x, #0x0202
	jreq	00103$
	cpw	x, #0x0240
	jreq	00111$
	cpw	x, #0x0680
	jreq	00116$
	jp	00128$
;	main.c: 74: case 0x0202 : //I2C_EVENT_SLAVE_RECEIVER_ADDRESS_MATCHED 
00103$:
;	main.c: 76: switch(I2CRead()){
	call	_I2CRead
	cp	a, #0xd8
	jreq	00107$
	cp	a, #0xe5
	jreq	00104$
	cp	a, #0xe6
	jreq	00105$
	cp	a, #0xe8
	jreq	00106$
	cp	a, #0xf4
	jreq	00108$
	jp	00128$
;	main.c: 77: case 0xE5: 
00104$:
;	main.c: 78: i2c_reply = 0xE5;
	mov	_i2c_reply+0, #0xe5
;	main.c: 80: break;
	jp	00128$
;	main.c: 82: case 0xE6:
00105$:
;	main.c: 83: i2c_reply = 0xE6;
	mov	_i2c_reply+0, #0xe6
;	main.c: 85: break;
	jp	00128$
;	main.c: 87: case 0xE8:
00106$:
;	main.c: 88: i2c_reply = 0xE8;
	mov	_i2c_reply+0, #0xe8
;	main.c: 90: break;
	jp	00128$
;	main.c: 92: case 0xD8:
00107$:
;	main.c: 93: i2c_reply = 0xD8;
	mov	_i2c_reply+0, #0xd8
;	main.c: 95: break;
	jp	00128$
;	main.c: 97: case 0xF4:
00108$:
;	main.c: 98: i2c_reply = 0xF4;
	mov	_i2c_reply+0, #0xf4
;	main.c: 100: break;
	jp	00128$
;	main.c: 107: case 0x0240: //I2C_EVENT_SLAVE_BYTE_RECEIVED
00111$:
;	main.c: 110: if(i2c_reply == 0xF4){
	ld	a, _i2c_reply+0
	cp	a, #0xf4
	jreq	00245$
	jp	00128$
00245$:
;	main.c: 111: replyF4 = I2CRead();// LED status parameter.
	call	_I2CRead
	ld	_replyF4+0, a
;	main.c: 112: i2c_reply = 0;
	clr	_i2c_reply+0
;	main.c: 119: break;
	jra	00128$
;	main.c: 121: case 0x0010:// I2C_EVENT_SLAVE_STOP_RECEIVED	
00114$:
;	main.c: 122: I2C_CR2 |= (1 << I2C_CR2_ACK);// send ack 
	bset	21009, #2
;	main.c: 124: break;
	jra	00128$
;	main.c: 131: case 0x0680: //I2C_EVENT_SLAVE_BYTE_TRANSMITTING
00116$:
;	main.c: 132: (void)I2C_SR1;
	ld	a, 0x5217
;	main.c: 133: (void)I2C_SR3;
	ld	a, 0x5219
;	main.c: 134: switch(i2c_reply){
	ld	a, _i2c_reply+0
	cp	a, #0xd8
	jreq	00120$
	cp	a, #0xe5
	jreq	00117$
	cp	a, #0xe6
	jreq	00118$
	cp	a, #0xe8
	jreq	00119$
	cp	a, #0xf4
	jreq	00123$
	jra	00128$
;	main.c: 135: case 0xE5:// Read NVM status
00117$:
;	main.c: 136: I2C_DR = 0x45;// NVM is locked 
	mov	0x5216+0, #0x45
;	main.c: 137: i2c_reply = 0;
	clr	_i2c_reply+0
;	main.c: 139: break;
	jra	00128$
;	main.c: 141: case 0xE6:// Pattern ID (need more investigation).
00118$:
;	main.c: 142: I2C_DR = 0x69;
	mov	0x5216+0, #0x69
;	main.c: 143: i2c_reply = 0;
	clr	_i2c_reply+0
;	main.c: 145: break;
	jra	00128$
;	main.c: 147: case 0xE8:// Read from reserved... (need more investigation).
00119$:
;	main.c: 148: I2C_DR = 0x52;
	mov	0x5216+0, #0x52
;	main.c: 149: i2c_reply = 0;
	clr	_i2c_reply+0
;	main.c: 151: break;
	jra	00128$
;	main.c: 153: case 0xD8:// Read from SLG46582V OTP memory (6 bytes respond)
00120$:
;	main.c: 154: I2C_DR = replyD8[replycnt];
	clrw	x
	ld	a, _replycnt+0
	ld	xl, a
	addw	x, #(_replyD8 + 0)
	ld	a, (x)
	ld	0x5216, a
;	main.c: 155: replycnt += 1;
	inc	_replycnt+0
;	main.c: 156: if(replycnt == 6){
	ld	a, _replycnt+0
	cp	a, #0x06
	jrne	00128$
;	main.c: 157: replycnt = 0;
	clr	_replycnt+0
;	main.c: 158: i2c_reply = 0;
	clr	_i2c_reply+0
;	main.c: 161: break;
	jra	00128$
;	main.c: 163: case 0xF4:// set virtual input to toggle something inside SLG46582V.
00123$:
;	main.c: 164: I2C_DR = replyF4;// Register read-back capability.
	mov	0x5216+0, _replyF4+0
;	main.c: 165: i2c_reply = 0;
	clr	_i2c_reply+0
;	main.c: 178: }
00128$:
;	main.c: 180: }
	iret
;	main.c: 185: void main(){
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	main.c: 186: PC_DDR |= (1 << 3);
	bset	20492, #3
;	main.c: 187: PC_CR1 |= (1 << 3);
	ld	a, 0x500d
	or	a, #0x08
	ld	0x500d, a
;	main.c: 188: CLK_CKDIVR = 0;
	mov	0x50c6+0, #0x00
;	main.c: 189: I2CInit();// init i2c as slave having address 0x65
	call	_I2CInit
;	main.c: 190: prev_pin_stat = 1;
	mov	_prev_pin_stat+0, #0x01
;	main.c: 191: __asm__("rim");// enble interrupt
	rim
;	main.c: 193: while(1){
00107$:
;	main.c: 197: current_pin_stat = PD_IDR & (1 << 6);// detect pin change on GP0
	ld	a, 0x5010
	and	a, #0x40
;	main.c: 198: if(prev_pin_stat != current_pin_stat){
	ld	_current_pin_stat+0, a
	cp	a, _prev_pin_stat+0
	jreq	00107$
;	main.c: 204: PC_ODR |= (1 << 3);
	ld	a, 0x500a
;	main.c: 200: if(current_pin_stat){
	tnz	_current_pin_stat+0
	jreq	00102$
;	main.c: 202: __asm__("sim");
	sim
;	main.c: 204: PC_ODR |= (1 << 3);
	or	a, #0x08
	ld	0x500a, a
;	main.c: 205: I2C_CR1 &= ~(1 << 0);
	ld	a, 0x5210
	and	a, #0xfe
	ld	0x5210, a
;	main.c: 206: __asm__("rim");
	rim
	jra	00103$
00102$:
;	main.c: 210: __asm__("sim");
	sim
;	main.c: 212: PC_ODR &= ~(1 << 3);	
	and	a, #0xf7
	ld	0x500a, a
;	main.c: 213: I2CInit();
	call	_I2CInit
;	main.c: 214: __asm__("rim");
	rim
00103$:
;	main.c: 218: prev_pin_stat = current_pin_stat;
	mov	_prev_pin_stat+0, _current_pin_stat+0
	jra	00107$
;	main.c: 224: }// main 
	ret
	.area CODE
	.area CONST
_replyD8:
	.db #0x11	; 17
	.db #0x12	; 18
	.db #0x13	; 19
	.db #0x14	; 20
	.db #0x15	; 21
	.db #0x16	; 22
	.area INITIALIZER
__xinit__Event:
	.dw #0x0000
__xinit__return_i2c:
	.db #0x00	; 0
__xinit__i2c_reply:
	.db #0x00	; 0
__xinit__replyF4:
	.db #0x00	; 0
__xinit__replycnt:
	.db #0x00	; 0
__xinit__current_pin_stat:
	.db #0x00	; 0
__xinit__prev_pin_stat:
	.db #0x00	; 0
	.area CABS (ABS)
