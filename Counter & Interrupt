// This source code will demonstrate how intterrupt and counter is used in ATMEGA8535 to change certain behavior pattern

#include <avr_io.h>
#define F_CPU 8000000UL   
#include <delay.h>
#include <interrupt.h>

void init_int(void); 

ISR(TIMER1_OVF_vect) 
{ 
	unsigned char i; 
	for (i=0;i<2;++i) 
	{ 
	// Behavior I
  PORTA=0x0F; 
	_delay_ms(500); 
	PORTA=0xF0; 
	_delay_ms(500); 
	} 
	TIFR=(1<<TOV1); 
	TIMSK=0x00;  
	TCNT1H = 0x00;
	TCNT1L = 0xF6;
} 

int main(void) 
{ 
	init_int(); 
	DDRA=0xFF; 
	while (1) 
	{ 
  // Behavior II
			PORTA = 0xFF; 
			_delay_ms(500); 
			PORTA = 0b10101010; 
			_delay_ms(500); 
			TIMSK=0b00000100; 
		} 
	return 0;    
} 
void init_int(void) 
{ 
	TIMSK=0b00000000;  
	TCCR1B=0b00000101; 
	TCNT1H=0xC2;
	TCNT1L=0xF6;
	sei();   
}
