/* Project GreenProbe.
 * STM8s as Communication controller for the SLG4DVKGSD "compatible clone".
 * Coded by TinLethax 2023/06/14 +7
 */

#include "stm8s.h"
// Pin connection
// PD6 -> GP0 of MCP2221
// PC4 -> LV pin of I2C logic level translator OR Enable Pin of I2C gate (gating I2C bus of Target GreenPAK, Active HIGH).

#define devID (uint8_t)0x08 // slave address for the stm8s

volatile uint16_t Event = 0x00;// I2C event value keeper 
volatile uint8_t return_i2c = 0x00;
volatile uint8_t i2c_reply = 0x00;
volatile uint8_t replyF4 = 0;
const uint8_t replyD8[6] = {0x11, 0x12, 0x13, 0x14, 0x15, 0x16};// Still figuring out the meaning of these.
volatile uint8_t replycnt = 0;

// For I2C
//////////////////////////////////////////////////
// uint16_t SCLSpeed = 0x0050; 100kHz I2C
void I2CInit() {
    I2C_FREQR |= 16;// 16MHz/10^6
	
    I2C_CR1 &= ~0x01;// cmd disable for i2c configurating

    I2C_TRISER |= (uint8_t)(17);// Riser time  

    I2C_CCRL = 0x50;
    I2C_CCRH = 0x00;

    I2C_CR1 |= 0x80;// No clock stretching.
	
    I2C_OARL = (devID << 1);
    I2C_OARH = (1 << 6);

    I2C_CR1 |= (1 << 0);// cmd enable
	I2C_CR2 |= (1 << 2);

    I2C_ITR |= (1 << 0) | (1 << 1) | (1 << 2);// enable interrupt (buffer, event and error interrupt)
}

static uint16_t I2CReadStat(){
	/* Dummy reaing the SR2 */
	(void)I2C_SR2;
	I2C_SR2 = 0;
	
	/*event reading*/
	uint8_t flag1 = 0x00;
	uint8_t flag2 = 0x00;
	flag1 = I2C_SR1;
	flag2 = I2C_SR3;
	return  ((uint16_t)((uint16_t)flag2 << (uint16_t)8) | (uint16_t)flag1);
}

uint8_t I2CRead(){
  /* Return the data present in the DR register */
  while(!(I2C_SR1 & 0x40));
  return ((uint8_t)I2C_DR);
}

/* Interrupt handlers */

void i2cirq(void) __interrupt(19){
	// Clear Interrupt flag
	uint8_t i2cint = I2C_SR2 & 0x0F;
	if(i2cint){
		I2C_SR2 &= ~(0x0F);
	}
		
	switch(I2CReadStat()){

    	case 0x0202 : //I2C_EVENT_SLAVE_RECEIVER_ADDRESS_MATCHED 

			switch(I2CRead()){
			case 0xE5: 
				i2c_reply = 0xE5;
				
				break;
			
			case 0xE6:
				i2c_reply = 0xE6;
				
				break;
				
			case 0xE8:
				i2c_reply = 0xE8;
				
				break;
				
			case 0xD8:
				i2c_reply = 0xD8;
				
				break;
				
			case 0xF4:
				i2c_reply = 0xF4;
				
				break;
				
			default:
				break;
			}
      	break;
		
		case 0x0240: //I2C_EVENT_SLAVE_BYTE_RECEIVED
		
			// In case of Updating LED status.
			if(i2c_reply == 0xF4){
				replyF4 = I2CRead();// LED status parameter.
				i2c_reply = 0;
				// Recorded data that I have seen so far.
				// 0x01
				// 0x81
				// 0x91
			}
			
		break;

		case 0x0010:// I2C_EVENT_SLAVE_STOP_RECEIVED	
			I2C_CR2 |= (1 << I2C_CR2_ACK);// send ack 
		
		break;
		
		case 0x0682: //  I2C_EVENT_SLAVE_TRANSMITTER_ADDRESS_MATCHED
		
		break;
		
		
		case 0x0680: //I2C_EVENT_SLAVE_BYTE_TRANSMITTING
			(void)I2C_SR1;
			(void)I2C_SR3;
			switch(i2c_reply){
			case 0xE5:// Read NVM status
				I2C_DR = 0x45;// NVM is locked 
				i2c_reply = 0;
				
				break;
			
			case 0xE6:// Pattern ID (need more investigation).
				I2C_DR = 0x69;
				i2c_reply = 0;
				
				break;
			
			case 0xE8:// Read from reserved... (need more investigation).
				I2C_DR = 0x52;
				i2c_reply = 0;
				
				break;
			
			case 0xD8:// Read from SLG46582V OTP memory (6 bytes respond)
				I2C_DR = replyD8[replycnt];
				replycnt += 1;
				if(replycnt == 6){
					replycnt = 0;
					i2c_reply = 0;
				}
				
				break;
			
			case 0xF4:// set virtual input to toggle something inside SLG46582V.
				I2C_DR = replyF4;// Register read-back capability.
				i2c_reply = 0;
				
				break;
			
			default:
				break;
				
			}	
			
		break;

    	default:
		break;
	}
	
}

uint8_t current_pin_stat = 0;
uint8_t prev_pin_stat = 0;

void main(){
	PC_DDR |= (1 << 3);
	PC_CR1 |= (1 << 3);
	CLK_CKDIVR = 0;
	I2CInit();// init i2c as slave having address 0x65
	prev_pin_stat = 1;
	__asm__("rim");// enble interrupt

	while(1){
		// MCP2221 select On board GreenPAK and Target GreenPAK with GP0 pin
		// HIGH -> Select Target GreenPAK
		// LOW -> Select on-board GreenPAK (the SLG46582V)
		current_pin_stat = PD_IDR & (1 << 6);// detect pin change on GP0
		if(prev_pin_stat != current_pin_stat){
			
			if(current_pin_stat){
				//De-init I2C
				__asm__("sim");
				// Enable I2C gate to Target GreenPAK
				PC_ODR |= (1 << 3);
				I2C_CR1 &= ~(1 << 0);
				__asm__("rim");
				
			}else{
				//Re-init I2C
				__asm__("sim");
				// Disable I2C gate to Target GreenPAK
				PC_ODR &= ~(1 << 3);	
				I2CInit();
				__asm__("rim");
				
			}
			
			prev_pin_stat = current_pin_stat;
		}
		
		
	}

}// main 
