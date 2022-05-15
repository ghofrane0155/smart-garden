// LCD module connections
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
/******************define************************/
#define consulter portb.RB5
#define arrosage portb.RB4
#define capt_pluit portb.RB0
#define afficheur portd
#define buzzer portc.rc6
//************************ variables****************
int nb=0;
char panne[5];
int test_moteur=0;
/*************humidite************************/
float  value;
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
/**********interruption************/
int flag5=0;
 int interrupteur=0;
 int counter;
void interrupt()
{   if(intcon.intf==1)
    {  if(capt_pluit==1)
          {  PORTC.RC4 =0 ; //pour arreter le moteur on donne 0 aux deux bornes rc4 et rc5
             PORTC.RC5 =0;
             test_moteur=0;
          }
     intcon.intf=0; //remettre flag à zero
    }

  if (intcon.rbif==1)
   {   if(arrosage==1)
          {   //sens du montre
              PORTC.RC4 =1 ;
              PORTC.RC5 =0;
               delay_ms(1000);
               test_moteur=1;
               interrupteur=1;
          }

        if (consulter==1)
            {   flag5=1; //pour faire le test dans le main if variable flag5==1 =>afficher nb de panne
            }

      intcon.rbif=0;//remettre le flag à 0 pour sortir de la fonction inteerupt
    }

    if(INTCON.T0IF == 1) // activer timer
      { INTCON.T0IF = 0;   //remettre flag a zero
       counter--;
        if (counter==0)
           { counter=76;
             buzzer=0; //buzzer desactiver
             TMR0=0;
             INTCON.T0IE = 0;   //desactiver timer

             delay_ms(2000);
            }
     }
}
/***************************************/
char i;                              // Loop variable

void main(){
  Lcd_Init();
  ADC_Init();
  //config
  trisb=0xf1; //rb0+rb4--rb7 entrée
  trisa.ra0=1;//capt humidite

  trisc=0; //buzzer +moteur
  trisd=0; //lcd sortie

  intcon.gie=1  ; // utiliser interruption
  intcon.rbie=1; //rb4->rb7 src interruption
  intcon.INTE=1;  //rb0 src interruption
  option_reg.intedg=1;  //front:0->1

  option_reg=0b01000111;
  TMR0=0;
  counter=76;  //
//initialisation
   afficheur=0;
   //portc.rc6=0;
   Sound_Init(&PORTC, 6);

      Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
      Lcd_Out(1,1,"Smart Garden");       // Write text in first row
      Delay_ms(1000);
      Lcd_Cmd(_LCD_CLEAR);

      value= Adc_read(0)*5/1023*10;
      afficher_hum(value);
    while(1)
    {
         if(value<31)
            { if(value<29)
                  { Sound_Play(700,2000); //buzzer declenche
                      INTCON.T0IE = 1;//activer le timer tmr0
                     Lcd_Cmd(_LCD_CLEAR);
                     Lcd_Out(1,1,"systeme en panne");
                     Delay_ms(500);
                       nb++;
                      EEPROM_Write(0x32, nb); //stocker le nb dans eeprom
                  }
                else
                  if(capt_pluit==0)
                  {//sens du montre
                     PORTC.RC4 =1 ;
                     PORTC.RC5 =0;
                     delay_ms(1000);
                     test_moteur=1;

                  Lcd_Cmd(_LCD_CLEAR);
                  Lcd_Out(1,1,"arrosage gazon");
                  Delay_ms(500);
                }
            }

         if(value>50 ||(interrupteur==1 && arrosage==0))
          {      if(test_moteur==1)
                     {  PORTC.RC4 =0 ; //tourner moteur dans sens inverse
                        PORTC.RC5 =1;
                           delay_ms(700);
                       PORTC.RC4 =0 ; //pour arreter le moteur on donne 0 aux deux bornes rc4 et rc5
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

        if(flag5==1)   //afficher le nombre de panne
        {       EEPROM_Write(0x32, nb);  //ecrire la valeur de nb dans eeprom
                inttostr(EEPROM_Read(0x32),panne);  //read le nombre stocké dans eeprom & le convertir en string

                Lcd_Cmd(_LCD_CLEAR);     //effacer l'ecran
                lcd_out(1,1,panne);       //afficher le nb
                lcd_out(2,1,"pannes");    //ajouter un msg
                Delay_ms(800);
                flag5=0;
        }
   value= Adc_read(0)*5/1023*10;
   afficher_hum(value);
   }
}