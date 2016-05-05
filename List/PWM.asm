
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313A
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313A
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 223
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _mode=R3

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_compb_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;#include <tiny2313a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;//#include <sleep.h>
;#define MIN 1
;#define MAX 170
;
;enum mode
;{
;    pulse,
;    full,
;    half,
;    tenth,
;    strobe,
;    off
;}mode;
;
;
;void pulse_mode()
; 0000 0013 {

	.CSEG
_pulse_mode:
; 0000 0014     int delay = 5;
; 0000 0015     PINB.2=1;
	RCALL __SAVELOCR2
;	delay -> R16,R17
	__GETWRN 16,17,5
	SBI  0x16,2
; 0000 0016     OCR0A=0;
	RCALL SUBOPT_0x0
; 0000 0017     while(OCR0A!=MAX && mode == pulse)
_0x5:
	IN   R30,0x36
	CPI  R30,LOW(0xAA)
	BREQ _0x8
	LDI  R30,LOW(0)
	CP   R30,R3
	BREQ _0x9
_0x8:
	RJMP _0x7
_0x9:
; 0000 0018     {
; 0000 0019         OCR0A++;
	IN   R30,0x36
	SUBI R30,-LOW(1)
	OUT  0x36,R30
; 0000 001A         delay_ms(delay);
	MOVW R26,R16
	RCALL _delay_ms
; 0000 001B     }
	RJMP _0x5
_0x7:
; 0000 001C 
; 0000 001D     while(OCR0A!=MIN && mode == pulse)
_0xA:
	IN   R30,0x36
	CPI  R30,LOW(0x1)
	BREQ _0xD
	LDI  R30,LOW(0)
	CP   R30,R3
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
; 0000 001E     {
; 0000 001F         OCR0A--;
	IN   R30,0x36
	SUBI R30,LOW(1)
	OUT  0x36,R30
; 0000 0020         if(OCR0A==MIN)
	IN   R30,0x36
	CPI  R30,LOW(0x1)
	BRNE _0xF
; 0000 0021             delay_ms(150); //bottom
	LDI  R26,LOW(150)
	RCALL SUBOPT_0x1
; 0000 0022         delay_ms(delay);
_0xF:
	MOVW R26,R16
	RCALL _delay_ms
; 0000 0023     }
	RJMP _0xA
_0xC:
; 0000 0024 }
	RCALL __LOADLOCR2P
	RET
;
;void full_mode()
; 0000 0027 {
_full_mode:
; 0000 0028     OCR0A=255;
	LDI  R30,LOW(255)
	RJMP _0x2000001
; 0000 0029     PINB.2=1;
; 0000 002A }
;
;void half_mode()
; 0000 002D {
_half_mode:
; 0000 002E     OCR0A=50;
	LDI  R30,LOW(50)
	RJMP _0x2000001
; 0000 002F     PINB.2=1;
; 0000 0030 }
;
;void tenth_mode()
; 0000 0033 {
_tenth_mode:
; 0000 0034     OCR0A=10;
	LDI  R30,LOW(10)
_0x2000001:
	OUT  0x36,R30
; 0000 0035     PINB.2=1;
	SBI  0x16,2
; 0000 0036 }
	RET
;
;void strobe_mode()
; 0000 0039 {
_strobe_mode:
; 0000 003A     OCR0A=255;
	LDI  R30,LOW(255)
	OUT  0x36,R30
; 0000 003B     delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x1
; 0000 003C     OCR0A=0;
	RCALL SUBOPT_0x0
; 0000 003D     delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x1
; 0000 003E }
	RET
;
;
;void off_mode()
; 0000 0042 {
_off_mode:
; 0000 0043     OCR0A=0;
	RCALL SUBOPT_0x0
; 0000 0044     PINB.2=0;
	CBI  0x16,2
; 0000 0045     //sleep_enable(); // разрешаем сон
; 0000 0046     //sleep(); // спать!
; 0000 0047 }
	RET
;
;void mode_switch()
; 0000 004A {
_mode_switch:
; 0000 004B     if(mode == pulse)
	TST  R3
	BRNE _0x18
; 0000 004C         mode = full;
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0000 004D     else if(mode == full)
	RJMP _0x19
_0x18:
	LDI  R30,LOW(1)
	CP   R30,R3
	BRNE _0x1A
; 0000 004E         mode = half;
	LDI  R30,LOW(2)
	MOV  R3,R30
; 0000 004F     else if(mode == half)
	RJMP _0x1B
_0x1A:
	LDI  R30,LOW(2)
	CP   R30,R3
	BRNE _0x1C
; 0000 0050         mode = tenth;
	LDI  R30,LOW(3)
	MOV  R3,R30
; 0000 0051     else if(mode == tenth)
	RJMP _0x1D
_0x1C:
	LDI  R30,LOW(3)
	CP   R30,R3
	BRNE _0x1E
; 0000 0052         mode = strobe;
	LDI  R30,LOW(4)
	MOV  R3,R30
; 0000 0053     else if(mode == strobe)
	RJMP _0x1F
_0x1E:
	LDI  R30,LOW(4)
	CP   R30,R3
	BRNE _0x20
; 0000 0054         mode = pulse;
	CLR  R3
; 0000 0055 }
_0x20:
_0x1F:
_0x1D:
_0x1B:
_0x19:
	RET
;
;// Timer 0 output compare B interrupt service routine
;interrupt [TIM0_COMPB] void timer0_compb_isr(void)
; 0000 0059 {
_timer0_compb_isr:
; 0000 005A // Place your code here
; 0000 005B 
; 0000 005C }
	RETI
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0060 {
_ext_int0_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0061 delay_ms(200);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x1
; 0000 0062 
; 0000 0063 if(PIND.2==0)
	SBIC 0x10,2
	RJMP _0x21
; 0000 0064 {
; 0000 0065     while(PIND.2==0)
_0x22:
	SBIC 0x10,2
	RJMP _0x24
; 0000 0066     {
; 0000 0067         strobe_mode();
	RCALL _strobe_mode
; 0000 0068     }
	RJMP _0x22
_0x24:
; 0000 0069 }
; 0000 006A else
	RJMP _0x25
_0x21:
; 0000 006B {
; 0000 006C     mode_switch();
	RCALL _mode_switch
; 0000 006D }
_0x25:
; 0000 006E 
; 0000 006F }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0073 {
_ext_int1_isr:
; 0000 0074 // Place your code here
; 0000 0075 
; 0000 0076 }
	RETI
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 007C {
_main:
; 0000 007D 
; 0000 007E 
; 0000 007F // Declare your local variables here
; 0000 0080 
; 0000 0081 // Crystal Oscillator division factor: 1
; 0000 0082 #pragma optsize-
; 0000 0083 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0084 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0085 #ifdef _OPTIMIZE_SIZE_
; 0000 0086 #pragma optsize+
; 0000 0087 #endif
; 0000 0088 
; 0000 0089 // Input/Output Ports initialization
; 0000 008A // Port A initialization
; 0000 008B // Func2=Out Func1=Out Func0=Out
; 0000 008C // State2=0 State1=0 State0=0
; 0000 008D PORTA=0x00;
	OUT  0x1B,R30
; 0000 008E DDRA=0x07;
	LDI  R30,LOW(7)
	OUT  0x1A,R30
; 0000 008F 
; 0000 0090 // Port B initialization
; 0000 0091 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0092 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0093 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0094 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0095 
; 0000 0096 // Port D initialization
; 0000 0097 // Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=Out
; 0000 0098 // State6=0 State5=0 State4=0 State3=0 State2=P State1=0 State0=0
; 0000 0099 PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 009A DDRD=0x7B;
	LDI  R30,LOW(123)
	OUT  0x11,R30
; 0000 009B DDRD.6 = 1;
	SBI  0x11,6
; 0000 009C PIND.6 = 1;
	SBI  0x10,6
; 0000 009D 
; 0000 009E 
; 0000 009F // Timer/Counter 0 initialization
; 0000 00A0 // Clock source: System Clock
; 0000 00A1 // Clock value: 8000,000 kHz
; 0000 00A2 // Mode: Phase correct PWM top=0xFF
; 0000 00A3 // OC0A output: Non-Inverted PWM
; 0000 00A4 // OC0B output: Disconnected
; 0000 00A5 TCCR0A=0x81;
	LDI  R30,LOW(129)
	OUT  0x30,R30
; 0000 00A6 TCCR0B=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 00A7 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00A8 OCR0A=0x00;
	RCALL SUBOPT_0x0
; 0000 00A9 OCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 00AA 
; 0000 00AB 
; 0000 00AC 
; 0000 00AD // Timer/Counter 1 initialization
; 0000 00AE // Clock source: System Clock
; 0000 00AF // Clock value: Timer1 Stopped
; 0000 00B0 // Mode: Normal top=0xFFFF
; 0000 00B1 // OC1A output: Discon.
; 0000 00B2 // OC1B output: Discon.
; 0000 00B3 // Noise Canceler: Off
; 0000 00B4 // Input Capture on Falling Edge
; 0000 00B5 // Timer1 Overflow Interrupt: Off
; 0000 00B6 // Input Capture Interrupt: Off
; 0000 00B7 // Compare A Match Interrupt: Off
; 0000 00B8 // Compare B Match Interrupt: Off
; 0000 00B9 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00BA TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00BB TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00BC TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00BD ICR1H=0x00;
	OUT  0x25,R30
; 0000 00BE ICR1L=0x00;
	OUT  0x24,R30
; 0000 00BF OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00C0 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00C1 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00C2 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00C3 // External Interrupt(s) initialization
; 0000 00C4 // INT0: On
; 0000 00C5 // INT0 Mode: Low level
; 0000 00C6 // INT1: Off
; 0000 00C7 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00C8 // Interrupt on any change on pins PCINT8-10: Off
; 0000 00C9 // Interrupt on any change on pins PCINT11-17: Off
; 0000 00CA MCUCR=0x00;
	OUT  0x35,R30
; 0000 00CB GIMSK=0x40;
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 00CC GIFR=0x40;
	OUT  0x3A,R30
; 0000 00CD 
; 0000 00CE // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00CF TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 00D0 
; 0000 00D1 // Universal Serial Interface initialization
; 0000 00D2 // Mode: Disabled
; 0000 00D3 // Clock source: Register & Counter=no clk.
; 0000 00D4 // USI Counter Overflow Interrupt: Off
; 0000 00D5 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00D6 
; 0000 00D7 // USART initialization
; 0000 00D8 // USART disabled
; 0000 00D9 UCSRB=0x00;
	OUT  0xA,R30
; 0000 00DA 
; 0000 00DB // Analog Comparator initialization
; 0000 00DC // Analog Comparator: Off
; 0000 00DD // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00DE ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00DF DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 00E0 
; 0000 00E1 // Global enable interrupts
; 0000 00E2 #asm("sei")
	sei
; 0000 00E3     while (1)
_0x2A:
; 0000 00E4     {
; 0000 00E5         if(mode==pulse)
	TST  R3
	BRNE _0x2D
; 0000 00E6         {
; 0000 00E7             pulse_mode();
	RCALL _pulse_mode
; 0000 00E8         }
; 0000 00E9 
; 0000 00EA         else if(mode == strobe)
	RJMP _0x2E
_0x2D:
	LDI  R30,LOW(4)
	CP   R30,R3
	BRNE _0x2F
; 0000 00EB         {
; 0000 00EC             strobe_mode();
	RCALL _strobe_mode
; 0000 00ED         }
; 0000 00EE 
; 0000 00EF         else if(mode == full)
	RJMP _0x30
_0x2F:
	LDI  R30,LOW(1)
	CP   R30,R3
	BRNE _0x31
; 0000 00F0         {
; 0000 00F1             full_mode();
	RCALL _full_mode
; 0000 00F2         }
; 0000 00F3 
; 0000 00F4         else if(mode == half)
	RJMP _0x32
_0x31:
	LDI  R30,LOW(2)
	CP   R30,R3
	BRNE _0x33
; 0000 00F5         {
; 0000 00F6             half_mode();
	RCALL _half_mode
; 0000 00F7         }
; 0000 00F8 
; 0000 00F9         else if(mode == tenth)
	RJMP _0x34
_0x33:
	LDI  R30,LOW(3)
	CP   R30,R3
	BRNE _0x35
; 0000 00FA         {
; 0000 00FB             tenth_mode();
	RCALL _tenth_mode
; 0000 00FC         }
; 0000 00FD 
; 0000 00FE         else if(mode == off)
	RJMP _0x36
_0x35:
	LDI  R30,LOW(5)
	CP   R30,R3
	BRNE _0x37
; 0000 00FF         {
; 0000 0100             off_mode();
	RCALL _off_mode
; 0000 0101         }
; 0000 0102     }
_0x37:
_0x36:
_0x34:
_0x32:
_0x30:
_0x2E:
	RJMP _0x2A
; 0000 0103 }
_0x38:
	RJMP _0x38

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x36,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDI  R27,0
	RJMP _delay_ms


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
