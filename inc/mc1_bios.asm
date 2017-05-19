;
;	MC-1000 MONITOR LABELS
;	(C) CCE Informática 1985
;
;	versão 1.1

;
; Chamadas às rotinas da BIOS (monitor)
;
	mc1_ST:		equ	0xc000
	mc1_BAENT0:	equ	0xc003
	mc1_KEY:	equ	0xc006
	mc1_KEY?:	equ	0xc009
	mc1_CO:		equ	0xc00c
	mc1_TAPIN:	equ	0xc00f
	mc1_TAPOUT:	equ	0xc012
	mc1_GET1:	equ	0xc015
	mc1_MSG:	equ	0xc018
	mc1_TLOAD:	equ	0xc01b
	mc1_GETL:	equ	0xc01e
	mc1_ISCN:	equ	0xc021
	mc1_INTRUP:	equ	0xc024
	mc1_SKEY?:	equ	0xc027
	mc1_MPY:	equ	0xc02a
	mc1_DIV:	equ	0xc02d
	mc1_XCLEAR:	equ	0xc030
	mc1_XCLR1:	equ	0xc033
	mc1_D4X5:	equ	0xc036
	mc1_TOP:	equ	0xc039
	mc1_PLAYNO:	equ	0xc03c
	mc1_DISPY2:	equ	0xc03f
	mc1_SHOWNO:	equ	0xc042
	mc1_NEXTGM:	equ	0xc045
	mc1_DELAYB:	equ	0xc048
	mc1_SCORE:	equ	0xc04b
	mc1_LSCORE:	equ	0xc04e
	mc1_SHAPON:	equ	0xc051
	mc1_SHAPOF:	equ	0xc054
	mc1_DISPY:	equ	0xc057
	mc1_LPDRV:	equ	0xc05a
	mc1_LPSTS:	equ	0xc05d
	mc1_BEEP:	equ	0xc060

;
; Constantes
;
	vid_VRM47:	equ 0x8000
	vid_VRM45:	equ 0x2000

;
; Variáveis do Sistema
;
	mc1_SNDSW:	equ 0x0002
	mc1_C40C80:	equ 0x000f
	mc1_MODBUF:	equ 0x00f5
	mc1_CLR:	equ 0x00f6
	mc1_UPDMB:	equ 0x00f7
	mc1_UPDBCM:	equ 0x00f8
	mc1_STAR:	equ 0x00fb
	mc1_ENDT:	equ 0x00fd
	mc1_BORDER:	equ 0x00ff
	mc1_JOBM:	equ 0x0130
	mc1_TONEC:	equ 0x017e
	mc1_OBUF:	equ 0x017f
	mc1_FILNAM:	equ 0x018d
