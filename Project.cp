#line 1 "C:/Users/asus/Downloads/projet/Project.c"

sbit LCD_RS at RD4_bit;
sbit LCD_EN at RD5_bit;
sbit LCD_D4 at RD0_bit;
sbit LCD_D5 at RD1_bit;
sbit LCD_D6 at RD2_bit;
sbit LCD_D7 at RD3_bit;

sbit LCD_RS_Direction at TRISD4_bit;
sbit LCD_EN_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD0_bit;
sbit LCD_D5_Direction at TRISD1_bit;
sbit LCD_D6_Direction at TRISD2_bit;
sbit LCD_D7_Direction at TRISD3_bit;







int nb=0;
char panne[5];
int test_moteur=0;

float value;
char humidite[5];
void afficher_hum(float value)
{
 floattostr(value,humidite);

 Lcd_Cmd(_LCD_CLEAR);
 lcd_out(1,3,"Humidite=");
 lcd_out(2,8, humidite);
 Delay_ms(500);
 Lcd_Cmd(_LCD_CLEAR);
}

int flag5=0;
 int interrupteur=0;
 int counter;
void interrupt()
{ if(intcon.intf==1)
 { if( portb.RB0 ==1)
 { PORTC.RC4 =0 ;
 PORTC.RC5 =0;
 test_moteur=0;
 }
 intcon.intf=0;
 }

 if (intcon.rbif==1)
 { if( portb.RB4 ==1)
 {
 PORTC.RC4 =1 ;
 PORTC.RC5 =0;
 delay_ms(1000);
 test_moteur=1;
 interrupteur=1;
 }

 if ( portb.RB5 ==1)
 { flag5=1;
 }

 intcon.rbif=0;
 }

 if(INTCON.T0IF == 1)
 { INTCON.T0IF = 0;
 counter--;
 if (counter==0)
 { counter=76;
  portc.rc6 =0;
 TMR0=0;
 INTCON.T0IE = 0;

 delay_ms(2000);
 }
 }
}

char i;

void main(){
 Lcd_Init();
 ADC_Init();

 trisb=0xf1;
 trisa.ra0=1;

 trisc=0;
 trisd=0;

 intcon.gie=1 ;
 intcon.rbie=1;
 intcon.INTE=1;
 option_reg.intedg=1;

 option_reg=0b01000111;
 TMR0=0;
 counter=76;

  portd =0;

 Sound_Init(&PORTC, 6);

 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"Smart Garden");
 Delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);

 value= Adc_read(0)*5/1023*10;
 afficher_hum(value);
 while(1)
 {
 if(value<31)
 { if(value<29)
 { Sound_Play(700,2000);
 INTCON.T0IE = 1;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"systeme en panne");
 Delay_ms(500);
 nb++;
 EEPROM_Write(0x32, nb);
 }
 else
 if( portb.RB0 ==0)
 {
 PORTC.RC4 =1 ;
 PORTC.RC5 =0;
 delay_ms(1000);
 test_moteur=1;

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"arrosage gazon");
 Delay_ms(500);
 }
 }

 if(value>50 ||(interrupteur==1 &&  portb.RB4 ==0))
 { if(test_moteur==1)
 { PORTC.RC4 =0 ;
 PORTC.RC5 =1;
 delay_ms(700);
 PORTC.RC4 =0 ;
 PORTC.RC5 =0;
 test_moteur=0;
 }

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"fin arrosage");
 Lcd_Out(2,8,"gazon");
 Delay_ms(1000);
 Lcd_Cmd(_LCD_CLEAR);
 interrupteur=0;
 }

 if(flag5==1)
 { EEPROM_Write(0x32, nb);
 inttostr(EEPROM_Read(0x32),panne);

 Lcd_Cmd(_LCD_CLEAR);
 lcd_out(1,1,panne);
 lcd_out(2,1,"pannes");
 Delay_ms(800);
 flag5=0;
 }
 value= Adc_read(0)*5/1023*10;
 afficher_hum(value);
 }
}
