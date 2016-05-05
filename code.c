#include <tiny2313a.h>
#include <delay.h>
//#include <sleep.h>
#define MIN 1
#define MAX 170

enum mode
{
    pulse,
    full,
    half,
    tenth,
    strobe,
    off
}mode;


void pulse_mode()
{
    int delay = 5;
    PINB.2=1;
    OCR0A=0;
    while(OCR0A!=MAX && mode == pulse)
    {
        OCR0A++;
        delay_ms(delay);
    }

    while(OCR0A!=MIN && mode == pulse)
    {
        OCR0A--;
        if(OCR0A==MIN)
            delay_ms(150); //bottom
        delay_ms(delay);
    }
}

void full_mode()
{
    OCR0A=255;
    PINB.2=1;
}

void half_mode()
{
    OCR0A=50;
    PINB.2=1;
}

void tenth_mode()
{
    OCR0A=10;
    PINB.2=1;
}

void strobe_mode()
{
    OCR0A=255;
    delay_ms(100);
    OCR0A=0;
    delay_ms(100);
}


void off_mode()
{       
    OCR0A=0;
    PINB.2=0;
    //sleep_enable(); // разрешаем сон
    //sleep(); // спать!
}

void mode_switch()
{
    if(mode == pulse)
        mode = full;
    else if(mode == full)
        mode = half;
    else if(mode == half)
        mode = tenth;
    else if(mode == tenth)
        mode = strobe;
    else if(mode == strobe)
        mode = pulse;
}

// Timer 0 output compare B interrupt service routine
interrupt [TIM0_COMPB] void timer0_compb_isr(void)
{
// Place your code here

}

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
delay_ms(200);

if(PIND.2==0)
{
    while(PIND.2==0)
    {
        strobe_mode();
    }
}
else
{
    mode_switch();
}

}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here

}


// Declare your global variables here

void main(void)
{


// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port A initialization
// Func2=Out Func1=Out Func0=Out 
// State2=0 State1=0 State0=0 
PORTA=0x00;
DDRA=0x07;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port D initialization
// Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=Out 
// State6=0 State5=0 State4=0 State3=0 State2=P State1=0 State0=0 
PORTD=0x04;
DDRD=0x7B;
DDRD.6 = 1;
PIND.6 = 1;


// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Phase correct PWM top=0xFF
// OC0A output: Non-Inverted PWM
// OC0B output: Disconnected
TCCR0A=0x81;
TCCR0B=0x01;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;



// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Low level
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-10: Off
// Interrupt on any change on pins PCINT11-17: Off
MCUCR=0x00;
GIMSK=0x40;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x04;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
DIDR=0x00;

// Global enable interrupts
#asm("sei")
    while (1)
    {
        if(mode==pulse)
        {
            pulse_mode();
        }
        
        else if(mode == strobe)
        {
            strobe_mode();    
        }
        
        else if(mode == full)
        {
            full_mode();
        }
        
        else if(mode == half)
        {
            half_mode();
        }
        
        else if(mode == tenth)
        {
            tenth_mode();
        }
        
        else if(mode == off)
        {
            off_mode();
        }
    }
}