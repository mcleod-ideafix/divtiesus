; API de ESXDOS.
include "esxdos.inc"
include "errors.inc"

; GO3E: un comando para cargar la ROM del +3e en la memoria del DivTIESUS para, a continuación,
; bloquear esa memoria y usarla como si fuera la ROM del equipo. La autopaginación queda deshabilitada
; Esto debería funcionar con cualquier equipo que soporte 128K, aunque no sea un +2A/B/3

; La ROM de 64KB es cargada en los bancos 8 a 15 de la memoria DivMMC. Para activar este modo, hay
; que enviar el byte $AA al puerto $55EF y justo después saltar a la dirección 0000h. Esto debe hacerse
; desde la RAM principal, no desde la RAM del dot command, y, muy recomendable, con las interrupciones
; deshabilitadas.

;Para ensamblar con PASMO como archivo binario (no TAP)

PILA                equ 3deah   ;valor sugerido por Miguel Ângelo para poner la pila en el área de comando
DIVCTRL             equ 0E3h
ZXUNOADDR           equ 0FC3Bh
MODE                equ 0DFh

                    org 2000h  ;comienzo de la ejecución de los comandos ESXDOS.

Main                proc
                    ld hl,ROMDivMMCES
                    call TryOpenFile
                    jr nc,FileFound

                    ld hl,ROMDivMMCEN
                    call TryOpenFile
                    jr nc,FileFound

                    push af
                    ld hl,FileNotFoundError
                    call Print
                    pop af
                    ret

FileFound           di
                    ld (BackupSP),sp
                    ld sp,PILA

                    ; usaré las páginas 1,3,4,6 para almacenar temporalmente la ROM
                    ld a,16+1
                    call Read16KChunk
                    ld a,16+3
                    call Read16KChunk
                    ld a,16+4
                    call Read16KChunk
                    ld a,16+6
                    call Read16KChunk

                    ld a,(FHandle)
                    rst 08h
                    db F_CLOSE

                    ld a,16
                    ld bc,7ffdh
                    out (c),a
                    ld sp,(BackupSP)

                    ld hl,ReadyToGo
                    call Print

                    ld bc,00FEh
EsperaNoPulsada     in a,(c)
                    cpl
                    and 31
                    jr nz,EsperaNoPulsada
EsperaPulsada       in a,(c)
                    cpl
                    and 31
                    jr z,EsperaPulsada

           ld a,4
           out (254),a

                    ld hl,CodigoEnRAM
                    ld de,32768
                    ld bc,LCodigoEnRAM
                    ldir
                    jp 32768
                    endp

Read16KChunk        proc
                    ld bc,7ffdh
                    out (c),a
                    ld bc,16384
                    ld hl,49152
                    ld a,(FHandle)
                    rst 08h
                    db F_READ
                    ret nc

                    push af

             ld a,2
             out (254),a

                    ld a,(FHandle)
                    rst 08h
                    db F_CLOSE
                    ld a,16
                    ld bc,7ffdh
                    out (c),a

                    pop af
                    ld sp,(BackupSP)
                    ret  ;esto vuelve directamente al BASIC, no a la función que llamó a ésta
                    endp

ROMDivMMCEN         db "/bin/dvmen3eE.rom",0
ROMDivMMCES         db "/bin/dvmes3eE.rom",0

                    ;   01234567890123456789012345678901
FileNotFoundError   db 13
                    db "Neither dvmen3eE.rom nor ",13
                    db "dvmes3eE.rom were found in /bin."
                    db "Process aborted.",0

ReadyToGo           db 13
                    db "Insert a IDEDOS formatted card",13
                    db "and press a key to enter +3E",0


TryOpenFile         proc
                    xor a
                    rst 08h
                    db M_GETSETDRV  ;A = unidad actual
                    ld b,FA_READ    ;B = modo de apertura
                    rst 08h
                    db F_OPEN
                    ret c   ;Volver si hay error
                    ld (FHandle),a
                    ret
                    endp

Print               proc
                    ld a,(hl)
                    or a
                    ret z
                    rst 10h
                    inc hl
                    jr Print
                    endp

CodigoEnRAM         proc     ;codigo en RAM, a partir de 8000h
                    di
                    ld sp,49151
                    ld a,8   ;valor para DIVCTRL (COMEN activado por si acaso)
                    ld l,16+1   ;L es el banco de RAM 128K: 1,3,4 y 6
                    call FuncionCopia16K
                    ld l,16+3
                    call FuncionCopia16K
                    ld l,16+4
                    call FuncionCopia16K
                    ld l,16+6
                    call FuncionCopia16K

                    ld a,128+0   ;banco 0 de DivMMC, para borrarlo
                    out (DIVCTRL),a
                    ld hl,8192
                    ld de,8193
                    ld (hl),l
                    ld bc,8191
                    ldir

             ld a,6
             out (254),a

                    ;Establecemos ROM 0 para arrancar
                    xor a
                    ld bc,7ffdh
                    out (c),a
                    ld b,1fh
                    out (c),a

                    ;Activamos el "modo 3E" del DivTIESUS
                    ld bc,ZXUNOADDR
                    ld a,MODE
                    out (c),a
                    inc b
                    in a,(c)
                    set 7,a   ;modo 3E, respetando la conf. de ratón
                    out (c),a

                    jp 0
                    ;////////////////////////////

Copia16K            out (DIVCTRL),a
                    inc a
                    ld bc,7ffdh
                    out (c),l
                    ld hl,49152
                    ld de,8192
                    ld bc,8192
                    ldir
                    out (DIVCTRL),a
                    inc a
                    ld de,8192
                    ld bc,8192
                    ldir
                    ret
                    endp

LCodigoEnRAM        equ $-CodigoEnRAM
FuncionCopia16K     equ Copia16K-CodigoEnRAM+8000h

FHandle             db 0
BackupSP            dw 0
