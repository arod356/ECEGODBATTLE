#include <stdint.h>
#include "tm4c123gh6pm.h"

// **************DAC_Init*********************
// Initialize 4-bit DAC, called once 
// Input: none
// Output: none

uint8_t delay;
void DAC_Init(void){
	delay = 100;
	GPIO_PORTB_DIR_R |= (0x0F);   // PB 0-3 configured as Output (4 bit Binary DAC)
	GPIO_PORTB_AFSEL_R &= ~(0x0F); // Disable Alt. Functions for PB pins
	GPIO_PORTB_DEN_R |= (0x0F);    // Enable Digital I/O for PORTB
  GPIO_PORTB_AMSEL_R &= ~(0x0F);	// Disable Analog I/O for PortB
	GPIO_PORTB_DR8R_R |=(0x0F);    // Max Current = 8mA
}

// **************DAC_Out*********************
// output to DAC
// Input: 4-bit data, 0 to 15 
// Output: none
void DAC_Out(unsigned long data){
  GPIO_PORTB_DATA_R = data;
}


