
_afficher_hum:

;Project.c,28 :: 		void afficher_hum(float value)
;Project.c,30 :: 		floattostr(value,humidite);
	MOVF       FARG_afficher_hum_value+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       FARG_afficher_hum_value+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       FARG_afficher_hum_value+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       FARG_afficher_hum_value+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _humidite+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;Project.c,32 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Project.c,33 :: 		lcd_out(1,3,"Humidite=");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Project.c,34 :: 		lcd_out(2,8, humidite);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _humidite+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Project.c,35 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_afficher_hum0:
	DECFSZ     R13+0, 1
	GOTO       L_afficher_hum0
	DECFSZ     R12+0, 1
	GOTO       L_afficher_hum0
	DECFSZ     R11+0, 1
	GOTO       L_afficher_hum0
	NOP
	NOP
;Project.c,36 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Project.c,37 :: 		}
L_end_afficher_hum:
	RETURN
; end of _afficher_hum

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Project.c,42 :: 		void interrupt()
;Project.c,43 :: 		{   if(intcon.intf==1)
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt1
;Project.c,44 :: 		{  if(capt_pluit==1)
	BTFSS      PORTB+0, 0
	GOTO       L_interrupt2
;Project.c,45 :: 		{  PORTC.RC4 =0 ; //pour arreter le moteur on donne 0 aux deux bornes rc4 et rc5
	BCF        PORTC+0, 4
;Project.c,46 :: 		PORTC.RC5 =0;
	BCF        PORTC+0, 5
;Project.c,47 :: 		test_moteur=0;
	CLRF       _test_moteur+0
	CLRF       _test_moteur+1
;Project.c,48 :: 		}
L_interrupt2:
;Project.c,49 :: 		intcon.intf=0; //remettre flag à zero
	BCF        INTCON+0, 1
;Project.c,50 :: 		}
L_interrupt1:
;Project.c,52 :: 		if (intcon.rbif==1)
	BTFSS      INTCON+0, 0
	GOTO       L_interrupt3
;Project.c,53 :: 		{   if(arrosage==1)
	BTFSS      PORTB+0, 4
	GOTO       L_interrupt4
;Project.c,55 :: 		PORTC.RC4 =1 ;
	BSF        PORTC+0, 4
;Project.c,56 :: 		PORTC.RC5 =0;
	BCF        PORTC+0, 5
;Project.c,57 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_interrupt5:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt5
	DECFSZ     R12+0, 1
	GOTO       L_interrupt5
	DECFSZ     R11+0, 1
	GOTO       L_interrupt5
	NOP
	NOP
;Project.c,58 :: 		test_moteur=1;
	MOVLW      1
	MOVWF      _test_moteur+0
	MOVLW      0
	MOVWF      _test_moteur+1
;Project.c,59 :: 		interrupteur=1;
	MOVLW      1
	MOVWF      _interrupteur+0
	MOVLW      0
	MOVWF      _interrupteur+1
;Project.c,60 :: 		}
L_interrupt4:
;Project.c,62 :: 		if (consulter==1)
	BTFSS      PORTB+0, 5
	GOTO       L_interrupt6
;Project.c,63 :: 		{   flag5=1; //pour faire le test dans le main if variable flag5==1 =>afficher nb de panne
	MOVLW      1
	MOVWF      _flag5+0
	MOVLW      0
	MOVWF      _flag5+1
;Project.c,64 :: 		}
L_interrupt6:
;Project.c,66 :: 		intcon.rbif=0;//remettre le flag à 0 pour sortir de la fonction inteerupt
	BCF        INTCON+0, 0
;Project.c,67 :: 		}
L_interrupt3:
;Project.c,69 :: 		if(INTCON.T0IF == 1) // activer timer
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt7
;Project.c,70 :: 		{ INTCON.T0IF = 0;   //remettre flag a zero
	BCF        INTCON+0, 2
;Project.c,71 :: 		counter--;
	MOVLW      1
	SUBWF      _counter+0, 1
	BTFSS      STATUS+0, 0
	DECF       _counter+1, 1
;Project.c,72 :: 		if (counter==0)
	MOVLW      0
	XORWF      _counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt35
	MOVLW      0
	XORWF      _counter+0, 0
L__interrupt35:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;Project.c,73 :: 		{ counter=76;
	MOVLW      76
	MOVWF      _counter+0
	MOVLW      0
	MOVWF      _counter+1
;Project.c,74 :: 		buzzer=0; //buzzer desactiver
	BCF        PORTC+0, 6
;Project.c,75 :: 		TMR0=0;
	CLRF       TMR0+0
;Project.c,76 :: 		INTCON.T0IE = 0;   //desactiver timer
	BCF        INTCON+0, 5
;Project.c,78 :: 		delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_interrupt9:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt9
	DECFSZ     R12+0, 1
	GOTO       L_interrupt9
	DECFSZ     R11+0, 1
	GOTO       L_interrupt9
	NOP
;Project.c,79 :: 		}
L_interrupt8:
;Project.c,80 :: 		}
L_interrupt7:
;Project.c,81 :: 		}
L_end_interrupt:
L__interrupt34:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Project.c,85 :: 		void main(){
;Project.c,86 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Project.c,87 :: 		ADC_Init();
	CALL       _ADC_Init+0
;Project.c,89 :: 		trisb=0xf1; //rb0+rb4--rb7 entrée
	MOVLW      241
	MOVWF      TRISB+0
;Project.c,90 :: 		trisa.ra0=1;//capt humidite
	BSF        TRISA+0, 0
;Project.c,92 :: 		trisc=0; //buzzer +moteur
	CLRF       TRISC+0
;Project.c,93 :: 		trisd=0; //lcd sortie
	CLRF       TRISD+0
;Project.c,95 :: 		intcon.gie=1  ; // utiliser interruption
	BSF        INTCON+0, 7
;Project.c,96 :: 		intcon.rbie=1; //rb4->rb7 src interruption
	BSF        INTCON+0, 3
;Project.c,97 :: 		intcon.INTE=1;  //rb0 src interruption
	BSF        INTCON+0, 4
;Project.c,98 :: 		option_reg.intedg=1;  //front:0->1
	BSF        OPTION_REG+0, 6
;Project.c,100 :: 		option_reg=0b01000111;
	MOVLW      71
	MOVWF      OPTION_REG+0
;Project.c,101 :: 		TMR0=0;
	CLRF       TMR0+0
;Project.c,102 :: 		counter=76;  //
	MOVLW      76
	MOVWF      _counter+0
	MOVLW      0
	MOVWF      _counter+1
;Project.c,104 :: 		afficheur=0;
	CLRF       PORTD+0
;Project.c,106 :: 		Sound_Init(&PORTC, 6);
	MOVLW      PORTC+0
	MOVWF      FARG_Sound_Init_snd_port+0
	MOVLW      6
	MOVWF      FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;Project.c,108 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Project.c,109 :: 		Lcd_Out(1,1,"Smart Garden");       // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Project.c,110 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
	NOP
	NOP
;Project.c,111 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Project.c,113 :: 		value= Adc_read(0)*5/1023*10;
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	CALL       _word2double+0
	MOVF       R0+0, 0
	MOVWF      _value+0
	MOVF       R0+1, 0
	MOVWF      _value+1
	MOVF       R0+2, 0
	MOVWF      _value+2
	MOVF       R0+3, 0
	MOVWF      _value+3
;Project.c,114 :: 		afficher_hum(value);
	MOVF       R0+0, 0
	MOVWF      FARG_afficher_hum_value+0
	MOVF       R0+1, 0
	MOVWF      FARG_afficher_hum_value+1
	MOVF       R0+2, 0
	MOVWF      FARG_afficher_hum_value+2
	MOVF       R0+3, 0
	MOVWF      FARG_afficher_hum_value+3
	CALL       _afficher_hum+0
;Project.c,115 :: 		while(1)
L_main11:
;Project.c,117 :: 		if(value<31)
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      120
	MOVWF      R4+2
	MOVLW      131
	MOVWF      R4+3
	MOVF       _value+0, 0
	MOVWF      R0+0
	MOVF       _value+1, 0
	MOVWF      R0+1
	MOVF       _value+2, 0
	MOVWF      R0+2
	MOVF       _value+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main13
;Project.c,118 :: 		{ if(value<29)
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      104
	MOVWF      R4+2
	MOVLW      131
	MOVWF      R4+3
	MOVF       _value+0, 0
	MOVWF      R0+0
	MOVF       _value+1, 0
	MOVWF      R0+1
	MOVF       _value+2, 0
	MOVWF      R0+2
	MOVF       _value+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main14
;Project.c,119 :: 		{ Sound_Play(700,2000); //buzzer declenche
	MOVLW      188
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	MOVLW      2
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVLW      208
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVLW      7
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;Project.c,120 :: 		INTCON.T0IE = 1;//activer le timer tmr0
	BSF        INTCON+0, 5
;Project.c,121 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Project.c,122 :: 		Lcd_Out(1,1,"systeme en panne");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Project.c,123 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main15:
	DECFSZ     R13+0, 1
	GOTO       L_main15
	DECFSZ     R12+0, 1
	GOTO       L_main15
	DECFSZ     R11+0, 1
	GOTO       L_main15
	NOP
	NOP
;Project.c,124 :: 		nb++;
	INCF       _nb+0, 1
	BTFSC      STATUS+0, 2
	INCF       _nb+1, 1
;Project.c,125 :: 		EEPROM_Write(0x32, nb); //stocker le nb dans eeprom
	MOVLW      50
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _nb+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Project.c,126 :: 		}
	GOTO       L_main16
L_main14:
;Project.c,128 :: 		if(capt_pluit==0)
	BTFSC      PORTB+0, 0
	GOTO       L_main17
;Project.c,130 :: 		PORTC.RC4 =1 ;
	BSF        PORTC+0, 4
;Project.c,131 :: 		PORTC.RC5 =0;
	BCF        PORTC+0, 5
;Project.c,132 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main18:
	DECFSZ     R13+0, 1
	GOTO       L_main18
	DECFSZ     R12+0, 1
	GOTO       L_main18
	DECFSZ     R11+0, 1
	GOTO       L_main18
	NOP
	NOP
;Project.c,133 :: 		test_moteur=1;
	MOVLW      1
	MOVWF      _test_moteur+0
	MOVLW      0
	MOVWF      _test_moteur+1
;Project.c,135 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Project.c,136 :: 		Lcd_Out(1,1,"arrosage gazon");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Project.c,137 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main19:
	DECFSZ     R13+0, 1
	GOTO       L_main19
	DECFSZ     R12+0, 1
	GOTO       L_main19
	DECFSZ     R11+0, 1
	GOTO       L_main19
	NOP
	NOP
;Project.c,138 :: 		}
L_main17:
L_main16:
;Project.c,139 :: 		}
L_main13:
;Project.c,141 :: 		if(value>50 ||(interrupteur==1 && arrosage==0))
	MOVF       _value+0, 0
	MOVWF      R4+0
	MOVF       _value+1, 0
	MOVWF      R4+1
	MOVF       _value+2, 0
	MOVWF      R4+2
	MOVF       _value+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      72
	MOVWF      R0+2
	MOVLW      132
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main30
	MOVLW      0
	XORWF      _interrupteur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main37
	MOVLW      1
	XORWF      _interrupteur+0, 0
L__main37:
	BTFSS      STATUS+0, 2
	GOTO       L__main31
	BTFSC      PORTB+0, 4
	GOTO       L__main31
	GOTO       L__main30
L__main31:
	GOTO       L_main24
L__main30:
;Project.c,142 :: 		{      if(test_moteur==1)
	MOVLW      0
	XORWF      _test_moteur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main38
	MOVLW      1
	XORWF      _test_moteur+0, 0
L__main38:
	BTFSS      STATUS+0, 2
	GOTO       L_main25
;Project.c,143 :: 		{  PORTC.RC4 =0 ; //tourner moteur dans sens inverse
	BCF        PORTC+0, 4
;Project.c,144 :: 		PORTC.RC5 =1;
	BSF        PORTC+0, 5
;Project.c,145 :: 		delay_ms(700);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      27
	MOVWF      R12+0
	MOVLW      39
	MOVWF      R13+0
L_main26:
	DECFSZ     R13+0, 1
	GOTO       L_main26
	DECFSZ     R12+0, 1
	GOTO       L_main26
	DECFSZ     R11+0, 1
	GOTO       L_main26
;Project.c,146 :: 		PORTC.RC4 =0 ; //pour arreter le moteur on donne 0 aux deux bornes rc4 et rc5
	BCF        PORTC+0, 4
;Project.c,147 :: 		PORTC.RC5 =0;
	BCF        PORTC+0, 5
;Project.c,148 :: 		test_moteur=0;
	CLRF       _test_moteur+0
	CLRF       _test_moteur+1
;Project.c,149 :: 		}
L_main25:
;Project.c,151 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Project.c,152 :: 		Lcd_Out(1,1,"fin arrosage");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Project.c,153 :: 		Lcd_Out(2,8,"gazon");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Project.c,154 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main27:
	DECFSZ     R13+0, 1
	GOTO       L_main27
	DECFSZ     R12+0, 1
	GOTO       L_main27
	DECFSZ     R11+0, 1
	GOTO       L_main27
	NOP
	NOP
;Project.c,155 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Project.c,156 :: 		interrupteur=0;
	CLRF       _interrupteur+0
	CLRF       _interrupteur+1
;Project.c,157 :: 		}
L_main24:
;Project.c,159 :: 		if(flag5==1)   //afficher le nombre de panne
	MOVLW      0
	XORWF      _flag5+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main39
	MOVLW      1
	XORWF      _flag5+0, 0
L__main39:
	BTFSS      STATUS+0, 2
	GOTO       L_main28
;Project.c,160 :: 		{       EEPROM_Write(0x32, nb);  //ecrire la valeur de nb dans eeprom
	MOVLW      50
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _nb+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Project.c,161 :: 		inttostr(EEPROM_Read(0x32),panne);  //read le nombre stocké dans eeprom & le convertir en string
	MOVLW      50
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _panne+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Project.c,163 :: 		Lcd_Cmd(_LCD_CLEAR);     //effacer l'ecran
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Project.c,164 :: 		lcd_out(1,1,panne);       //afficher le nb
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _panne+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Project.c,165 :: 		lcd_out(2,1,"pannes");    //ajouter un msg
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_Project+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Project.c,166 :: 		Delay_ms(800);
	MOVLW      9
	MOVWF      R11+0
	MOVLW      30
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_main29:
	DECFSZ     R13+0, 1
	GOTO       L_main29
	DECFSZ     R12+0, 1
	GOTO       L_main29
	DECFSZ     R11+0, 1
	GOTO       L_main29
	NOP
;Project.c,167 :: 		flag5=0;
	CLRF       _flag5+0
	CLRF       _flag5+1
;Project.c,168 :: 		}
L_main28:
;Project.c,169 :: 		value= Adc_read(0)*5/1023*10;
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	CALL       _word2double+0
	MOVF       R0+0, 0
	MOVWF      _value+0
	MOVF       R0+1, 0
	MOVWF      _value+1
	MOVF       R0+2, 0
	MOVWF      _value+2
	MOVF       R0+3, 0
	MOVWF      _value+3
;Project.c,170 :: 		afficher_hum(value);
	MOVF       R0+0, 0
	MOVWF      FARG_afficher_hum_value+0
	MOVF       R0+1, 0
	MOVWF      FARG_afficher_hum_value+1
	MOVF       R0+2, 0
	MOVWF      FARG_afficher_hum_value+2
	MOVF       R0+3, 0
	MOVWF      FARG_afficher_hum_value+3
	CALL       _afficher_hum+0
;Project.c,171 :: 		}
	GOTO       L_main11
;Project.c,172 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
