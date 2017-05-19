;
;    ALMOST DEMO (512 bytes)
;
;    It's almost a demo but is be a beginning! ^_^
;
;    Copyright 2017, Giovanni Nunes <giovanni.nunes@gmail.com>
;
;    This program is free software; you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation; either version 2 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program; if not, write to the Free Software
;    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
;    MA 02110-1301, USA.
;

            include "inc/mc1_bios.asm"
            include "inc/mc1_tape.asm"
;
;           início do programa
;
almostDemo:
            ld hl,demoMessage           ; aponta em 'HL' a mensagem inicial
            call mc1_MSG                ; escreve na tela a mensagem inicial

waitKey:
            call mc1_KEY?               ; verifica o teclado
            jr z,waitKey                ; faz o laço se nenhuma tecla pressionada
;
;           recria a barra arco-íris original do demo01 usando apenas um
;           padrão de 126 bytes, ao invés dos 2048 do original -- estou
;           aproveitando o fato da VRAM ser linear para fazer arte...
;           literalmente!
;
            xor a                       ; zera 'A'
            ld de,colorBar+256          ; 'DE' para o começo da barra colorida
barLoop0:
            ld hl,rainbow               ; 'HL' com o padrão a ser denhado
            ld bc,126                   ; 'BC' com 126, sério é 126 mesmo
            ldir                        ; copia o padrão de cores
            inc a                       ; incrementa 'A'
            cp 17                       ; compara 'A' com 17
            jr nz,barLoop0              ; faz o laço enquanto 'A'<17
;
;           produz duas barras em verde nas partes de cima e de baixo da
;           barra arco íris; ela é utilizada para limpar a barra sem que
;           o usuário perceba o que está acontecendo.
;
            ld de,0                     ; zera 'DE', o começo da barra
            ld bc,2048+256              ; 'BC' para o endereço após a barra
barLoop1:
            ld hl,colorBar              ; 'HL' para o início da colorBar
            add hl,de                   ; Soma 'HL' e 'DE'
            ld (hl),0x00                ; coloca 0 no endereço apontado em 'HL'
            add hl,bc                   ; Soma 'HL' (HL+DE) com 'BC'
            ld (hl),0x00                ; colora 0 tamém neste endereço
            inc de                      ; incrementa 'DE'
            ld a,d                      ; coloca 'D' em 'A'
            cp 1                        ; É 1? ('DE' é maior que 255?)
            jr nz,barLoop1              ; faz o laço enquanto 'DE'<256
;
;           entra no modo gráfico 0x98 (1001100xB) do MC6847 que é o de
;           128×192 com 4 cores (verde, azul, amarelo e vermelho)...
;
            ld a,0x97+0x01              ; também habilita a VRAM para escrita
            out (0x80),a
;
;           limpa a tela em verde (00|00|00|00)
;           tabela de cores... 00=verde, 01=azul, 10=amarelo, 11=vermelho
;
            ld b,0                      ; zera o valor de 'B'
            ld hl,vid_VRM47             ; início da memória de vídeo (VRAM)
clearScreen:
            ld (hl),b                   ; coloca o valor de 'B' no endereço 'HL'
            inc hl                      ; incrementa 'HL'
            ld a,h                      ; jogo a primeira parte de HL em A
            cp 0x98                     ; É 0x98? ('HL' é maior que 0x9800)
            jp nz,clearScreen           ; faz o laço enquanto 'HL'<0x9800

;
;           o programa começa aqui
;
scroll0:
            ld hl,vid_VRM47-2560        ; 'HL' em 2560 bytes acima da VRAM
            ld (screenPos),hl           ; e salva este valor

            xor a                       ; zera 'A'
            ld (repeat),a               ; e salva este valor

scroll1:
            call writeVRAM              ; desenha a barra na VRAM (ou quase)
            call scrollDown             ; chama a rotina de scroll para baixo

            ld de,0x0080                ; 128 bytes ou 4 linhas para baixo
            ld hl,(screenPos)           ; Posição inicial da VRAM
            add hl,de                   ; soma 'HL' com 'DE'
            ld (screenPos),hl           ; armazena o novo valor

            ld a,(repeat)               ; lê o contador de repetições
            inc a                       ; incrementa
            ld (repeat),a               ; e salva o novo valor
            cp 72                       ; compara com 72
            jr nz,scroll1               ; repete o laço se 'A'<72

            xor a                       ; zera 'A'
            ld (repeat),a               ; e salva este valor
scroll2:
            call writeVRAM              ; desenha a barra na VRAM (ou quase)
            call scrollUp               ; chama a rotina de scroll para cima

            ld de,0x0080                ; 128 bytes ou 4 linhas para baixo
            ld hl,(screenPos)           ; Posição inicial da VRAM
            sbc hl,de                   ; subtrai 'HL' com 'DE'
            ld (screenPos),hl           ; armazena o novo valor

            ld a,(repeat)               ; lê o contador de repetições
            inc a                       ; incrementa
            ld (repeat),a               ; e salva o novo valor
            cp 71                       ; compara com 72
            jr nz,scroll2               ; repete o laço se 'A'<71

            jp scroll0

screenPos:
            dw 0x0000                   ; posição inicial da VRAM
repeat:
            db 0                        ; contador de repetições

;
;           Scroll de 4 em 4 linhas para cima
;
scrollUp:
            ld hl,colorBar+256+128
            ld de,colorBar+2560
            ld bc,1920
            ldir                        ; copia a parte inferior da barra

            ld hl,colorBar+256
            ld de,colorBar+2560+1920
            ld bc,128
            ldir                        ; copia a primeira linha para baixo

            jp scrollSave               ; atualiza o padrão

;
;           Scroll de 4 em 4 linhas para cima
;
scrollDown:
            ld hl,colorBar+256
            ld de,colorBar+2560+128
            ld bc,1920
            ldir                        ; copia a parte superior da barra

            ld hl,colorBar+256+1920
            ld de,colorBar+2560
            ld bc,128
            ldir                        ; copia a última linha para cima

scrollSave:
            ld hl,colorBar+2560
            ld de,colorBar+256
            ld bc,2048
            ldir                        ; copia o padrão rotacionado

;
;           escreve na VRAM
;
writeVRAM:  ; 98
            ld a,0x98+0                 ; bit 0 -> 0=VRAM e 1=RAM
            out (0x80),a                ; habilita a VRAM para escrita

            ld hl,colorBar
            ld de,(screenPos)
            ld bc,2560
            ldir                        ; copia a barra para a VRAM

            ld a,0x98+1                 ; bit 0 -> 0=VRAM e 1=RAM
            out (0x80),a                ; desabiliza a VRAM para escrita

            ret                         ; sai da rotina

;
;           Aqui está todo aquele efeito (apenas em 126 bytes)
;
rainbow:
            db 0x00, 0x00, 0x00, 0x44, 0x44, 0x44, 0x44, 0x55
            db 0x55, 0x55, 0x55, 0xdd, 0xdd, 0xdd, 0xdd, 0xff
            db 0xff, 0xff, 0xff, 0xbb, 0xbb, 0xbb, 0xbb, 0xaa
            db 0xaa, 0xaa, 0xaa, 0x22, 0x22, 0x22, 0x22, 0x00
            db 0x00, 0x00, 0x00, 0x11, 0x11, 0x11, 0x11, 0x55
            db 0x55, 0x55, 0x55, 0x77, 0x77, 0x77, 0x77, 0xff
            db 0xff, 0xff, 0xff, 0xee, 0xee, 0xee, 0xee, 0xaa
            db 0xaa, 0xaa, 0xaa, 0x88, 0x88, 0x88, 0x88, 0x00
            db 0x00, 0x00, 0x44, 0x44, 0x44, 0x44, 0x55, 0x55
            db 0x55, 0x55, 0xdd, 0xdd, 0xdd, 0xdd, 0xff, 0xff
            db 0xff, 0xff, 0xbb, 0xbb, 0xbb, 0xbb, 0xaa, 0xaa
            db 0xaa, 0xaa, 0x22, 0x22, 0x22, 0x22, 0x00, 0x00
            db 0x00, 0x01, 0x11, 0x11, 0x11, 0x11, 0x55, 0x55
            db 0x55, 0x57, 0x77, 0x77, 0x77, 0x77, 0xff, 0xff
            db 0xff, 0xfe, 0xee, 0xee, 0xee, 0xee, 0xaa, 0xaa
            db 0xaa, 0xa8, 0x88, 0x88, 0x88, 0x88

demoMessage:
;               01234567890123456789012345678901 (régua)
            db "ALMOST DEMO (512)",0xd,0xa
            db "BY GIOVANNI NUNES",0xd,0xa
            db "   GIOVANNI.NUNES@GMAIL.COM",0xd,0xa
            db 0xd,0xa
            db "FREE SOFTWARE UNDER GPL",0xd,0xa
            db 0xd,0xa
            db "HTTPS://GITHUB.COM/PLAINSPOOKY/",0xd,0xa
            db 0xd,0xa
            db "PRESS A KEY",0x00

colorBar:
mc1_TAPESTOP:
            db 0xff

            end
