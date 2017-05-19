;   MC-1000 TAPE HEADER
;   versão 1.1

            org 0x03d5-10               ; início do programa BASIC
mc1_TAPEHEAD:
            db "     ",0x0d             ; nome do arquivo + CR
            dw mc1_TAPESTRT             ; endereço inicial
            dw mc1_TAPESTOP             ; endereço final
mc1_TAPESTRT:
            dw mc1_NEXTLIN              ; endereço da próxima linha do BASIC
            dw 1                        ; \
            db 0xa2                     ;  "1 CALL 992" no BASIC
            db "992"                    ; /
            dw 0                        ; fim da linha.
mc1_NEXTLIN:
            dw 0x0000 ; aqui acaba o programa em BASIC
