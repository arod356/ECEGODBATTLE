// Sound.c
// Runs on any computer
// Sound assets based off the original Space Invaders 
// Import these constants into your SpaceInvaders.c for sounds!
// Jonathan Valvano
// November 17, 2014
#include <stdint.h>
#include "Sound.h"
#include "DAC.h"
#include "Timer0.h"
#include "Timer1.h"

const uint8_t *Sound_pt;
volatile uint32_t Sound_Count;
volatile uint32_t Timer_Count;
void GameTime(void);

//Set up global variables here
void Sound_Play(const uint8_t *pt, uint32_t count){
	Sound_Count=count;
  Sound_pt=pt;
	Timer_Count=0;

};

//Output to the DAC
void Sound_Out(void){
	if(Timer_Count<Sound_Count){												//Check to see when the sound array has finished playing.
		DAC_Out(Sound_pt[Timer_Count]);
		Timer_Count++;
	}
}

void Sound_Init(void){
	Timer0_Init(&Sound_Out, 80000000/11025);		//Periodically run Sound_Out to output sound at 11KHz
	DAC_Init();
};


