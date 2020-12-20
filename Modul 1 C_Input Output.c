//This source code is intended to make LED light in ATMEGA8535 blink from the most right lamp to the most left lamp and then back again infinitely 

#include <avr_io.h>
#define F_CPU 8000000UL //Menggunakan 8MHz clock kristal
#include <util/delay.h>
int main(void)
{
	unsigned char i = 0xFE;
	unsigned char n;
	DDRA = 0xFF;
	PORTA = i;
	while(1)
	{
		for(n=0;n<7;n++)
		{
			PORTA = i;
			_delay_ms(120);
			i=(i<<1)|(i>>7);
		}
		
		for(n=0;n<7;n++)
		{
			PORTA = i;
			_delay_ms(120);
			i=(i>>1)|(i<<7);
		}
	}
	return 0;
}
