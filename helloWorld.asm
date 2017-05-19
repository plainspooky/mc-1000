;
;    OLA MUNDO
;
            include "inc/mc1_bios.asm"  ; rótulos da BIOS do MC-1000

            include "inc/mc1_tape.asm"  ; cabeçalho para fita cassete

printMessage:
            ld hl,helloWorld            ; aponta para o endereço da mensagem
            call mc1_MSG                ; chama a rotina de escrita de strings
            ret                         ; volta para o BASIC

helloWorld:
            ;   01234567890123456789012345678901 (32 caracteres)
            db "OLA MUNDO!",0x0d,0x0a
            db 0x00

mc1_TAPESTOP:
            end
