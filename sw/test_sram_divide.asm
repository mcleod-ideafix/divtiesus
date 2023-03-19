; Test DivIDE RAM

; DivIDE control register
; -----------------------
;
; xxxx xxxx 1110 0011, 0E3h, 227 - divIDE Control Register (Write Only)
;
; This register is write only. All bits are reset to '0' after each power-on.
; Unimplemented bits, marked 'X', should be written as zero for future
; compatibility divIDEs with more than 32K RAM.
;
;     7        6     5  4  3  2   1       0
; [ CONMEM , MAPRAM, X, X, X, X, BANK1, BANK0 ]
;
; BANK1 and BANK0 select which 8 KB bank is paged in at 2000h-3FFFh when divIDE
; memory is paged in. Bits 2 to 5 are reserved for accessing up to 512 KB of
; memory.

                        org 32768

Start                   proc
                        di
                        ld hl,4000h
                        ld de,4001h
                        ld bc,6143
                        ld (hl),l
                        ldir
                        inc hl
                        inc de
                        ld (hl),56
                        ld bc,767
                        ldir

                        ld hl,4000h
                        ld (ScrPos),hl
                        ld hl,MsgCopyRight
                        ld c,56
BucMsg                  ld a,(hl)
                        or a
                        jr z,FinPrintMsg
                        call PrintCharAndAttr
                        inc hl
                        jr BucMsg

FinPrintMsg             ld hl,4020h
                        ld (ScrPos),hl

                        ld b,15
BucFillSRAM             call FillSRAM
                        dec b
                        jp p,BucFillSRAM

                        ld b,0
BucCheckSRAM            call CheckSRAM
                        call PrintCheck
                        inc b
                        ld a,b
                        cp 16
                        jr nz,BucCheckSRAM

                        call CheckROM

                        xor a
                        out (227),a      ;CONMEM=0
                        ei
                        ret
                        endp


FillSRAM                proc
                        ld a,b
                        and 31          ;MAPRAM=0
                        or 128          ;CONMEM=1
                        out (227),a     ;DivIDE Control Register
                        ld a,b
                        ld hl,2000h
                        ld de,2001h
                        ld bc,1FFFh
                        ld (hl),a
                        ldir
                        ld b,a
                        ret
                        endp


CheckSRAM               proc
                        ld a,b
                        and 31          ;MAPRAM=0
                        or 128          ;CONMEM=1
                        out (227),a     ;DivIDE Control Register

                        ld hl,2000h
SigueCheck              ld a,(hl)
                        ld e,b
                        cp e
                        jr nz,NotOK
                        ld a,(hl)
                        cpl
                        ld (hl),a
                        ld a,b
                        cpl
                        ld e,a
                        ld a,(hl)
                        cp e
                        jr nz,NotOK
                        inc hl
                        ld a,h
                        cp 40h
                        jr nz,SigueCheck
                        ld a,(2000h)
                        or a
                        ret
NotOK                   scf
                        ret
                        endp


CheckROM                proc
                        ld a,128
                        out (227),a     ;CONMEM=1
                        ld d,0
                        ld hl,0
                        ld bc,40960    ;aprovecho y la copio a 40960
BucSumaROMDivIDE        ld a,(hl)
                        ld (bc),a
                        xor d
                        ld d,a
                        inc hl
                        inc bc
                        ld a,h
                        cp 20h
                        jr nz,BucSumaROMDivIDE

                        xor a
                        out (227),a     ;CONMEM=0
                        ld e,0
                        ld hl,0
BucSumaROMSistema       ld a,(hl)
                        xor e
                        ld e,a
                        inc hl
                        ld a,h
                        cp 20h
                        jr nz,BucSumaROMSistema

                        ld a,d
                        cp e
                        jr z,ErrorROM
PrintChecksums          or a
                        ld a,d
                        call PrintCheck
                        or a
                        ld a,e
                        call PrintCheck
                        ret
ErrorROM                scf
                        ld a,d
                        call PrintCheck
                        scf
                        ld a,e
                        call PrintCheck
                        ret
                        endp


PrintCheck              proc
                        ld c,11010111b  ;FLASH 1; BRIGHT 1: PAPRT 2: INK 7
                        jr c,NotChAttr
                        ld c,01100000b  ;BRIGHT 1: PAPRT 4: INK 0
NotChAttr               push af
                        xor a
                        out (227),a     ;ROM again, for taking chars
                        pop af
                        push af
                        sra a
                        sra a
                        sra a
                        sra a
                        call PrintNibble
                        pop af
                        call PrintNibble
;                        ld a,e
;                        ld c,01111001b
;                        push af
;                        sra a
;                        sra a
;                        sra a
;                        sra a
;                        call PrintNibble
;                        pop af
;                        call PrintNibble
                        ret
                        endp


PrintNibble             proc
                        and 0Fh
                        cp 10
                        jr c,Number
                        add a,55
PrintAndExit            call PrintCharAndAttr
                        ret
Number                  add a,48
                        jr PrintAndExit
                        endp


PrintCharAndAttr        proc
                        push bc
                        push de
                        push hl
                        ld h,0
                        ld l,a
                        add hl,hl
                        add hl,hl
                        add hl,hl
                        ex de,hl
                        ld hl,(23606)
                        add hl,de
                        ld de,(ScrPos)
                        ld b,8
BucPrtChar              ld a,(hl)
                        ld (de),a
                        inc hl
                        inc d
                        djnz BucPrtChar
                        ld de,(ScrPos)
                        ld a,18h
                        or d
                        ld d,a
                        ex de,hl
                        ld (hl),c
                        ld hl,(ScrPos)
                        inc hl
                        ld (ScrPos),hl
                        pop hl
                        pop de
                        pop bc
                        ret
                        endp
                           ;01234567890123456789012345678901
MsgCopyRight            db "DivMMC SRAM test McLeod/IdeaFix",0

ScrPos                  dw 4000h

                        end Start
