/*
 * LEDMatrix.c
 *
 * Created: 11-Apr-21 7:15:25 PM
 * Author : Romel
 */ 


#define F_CPU 1000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

volatile uint8_t mode = 1;

unsigned char r[] = {0b11111111, 0b10000001, 0b10110101, 0b10110101, 0b10110101, 0b10110101, 0b10110101, 0b11111111};
unsigned char c[] = {1, 2, 4, 8, 16, 32, 64, 128};

ISR(INT1_vect){
	if (!mode) mode = 1;
	else mode = 0;
}
	
int main(void)
{
    DDRB = 0xFF;
	DDRC = 0xFF;
	int i = 0, j = 0, k = 0;
	
	GICR = (1<<INT1); 
	MCUCR = 0b00001000;
	sei();
	
    while (1) 
    {
		
		for(k = 0; k < 200; k++){
			PORTC = c[(i+k)%8];
			PORTB = r[(i+k)%8];
			_delay_ms(1);
		}
		
		for(k = 0; k < 8; k++){
			r[k] = (((r[k] >> mode) & 0xFF) | (r[k] << (8-mode)));
		}
		
		_delay_ms(10);
		
		i+=1;
		if(i>7){
			i = 0;
		}
		
    }
}

