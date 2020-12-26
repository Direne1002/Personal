#include "io.h"
#include "pgmspace.h"
#include "delay.h"
#include "lcd_lib.h"

//Strings stored in AVR Flash memory
const uint8_t LCDtombol1[] PROGMEM="Percobaan LCD\0";
int x, y, z;

//delay 1s
void delay1s(void)
{
	uint8_t i;
	for(i=0;i<100;i++)
	{
		_delay_ms(10);
	}
}

int main(void)
{
	LCDinit();//init LCD bit, dual line, cursor right
	LCDclr();//clears LCD
	
	DDRA=0xFF;
	PORTA=0x00;
	DDRD=(1<<PD4)|(1<<PD5)|(1<<PC7)|(1<<PC6);
	SFIOR=(0<<PUD);
	
	delay1s();
	LCDGotoXY(0, 1);
	delay1s();
	x=0;
	y=0;
	z=0;
	while(1)//loop demos
	{
		CopyStringtoLCD(LCDtombol1, 0, 0);
		
		PORTD =(1<<PD4)|(1<<PD5)|(1<<PC7)|(0<<PC6);
		if(bit_is_clear(PIND,0))
		{
			//LCDclr();
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('a');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,1))
		{
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('8');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,2))
		{
			//LCDclr();
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('5');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,3))
		{
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('2');
			delay1s();
		}
		_delay_ms(25);
		
		PORTD =(1<<PD4)|(1<<PD5)|(0<<PC7)|(1<<PC6);
			if(bit_is_clear(PIND,0))
		{
			//LCDclr();
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('e');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,1))
		{
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('7');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,2))
		{
			//LCDclr();
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('4');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,3))
		{
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('1');
			delay1s();
		}
		_delay_ms(25);
		
		PORTD =(1<<PD4)|(0<<PD5)|(1<<PC7)|(1<<PC6);
			if(bit_is_clear(PIND,0))
		{
			//LCDclr();
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('i');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,1))
		{
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('9');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,2))
		{
			//LCDclr();
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('6');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,3))
		{
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('3');
			delay1s();
		}
		_delay_ms(25);
		
		PORTD =(0<<PD4)|(1<<PD5)|(1<<PC7)|(1<<PC6);
			if(bit_is_clear(PIND,0))
		{
			//LCDclr();
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('m');
			delay1s();
		}
		_delay_ms(10);
		
		if(bit_is_clear(PIND,1))
		{
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('C');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,2))
		{
			//LCDclr();
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('B');
			delay1s();
		}
		_delay_ms(25);
		
		if(bit_is_clear(PIND,3))
		{
			LCDGotoXY(x, 1);
			x++;
			y++;
			LCDsendChar('A');
			delay1s();
		}
		_delay_ms(25);
		
		/*if (y==4 && z==0)
		{x=4;
		y=0;
		z=1;
		LCDshiftRight(2);}
		
		if (y==2 && z!=0)
		{
		y=0;
		LCDshiftRight(2);}*/
	}
	return 0;
} 
