;=========================================================
;
; SBIOS
; Serial Driver
;
; UART 16550 compatible (future)
;
;=========================================================

SERIAL_BASE         EQU #00EF

SERIAL_DATA         EQU SERIAL_BASE+0
SERIAL_IER          EQU SERIAL_BASE+1
SERIAL_IIR          EQU SERIAL_BASE+2
SERIAL_LCR          EQU SERIAL_BASE+3
SERIAL_MCR          EQU SERIAL_BASE+4
SERIAL_LSR          EQU SERIAL_BASE+5
SERIAL_MSR          EQU SERIAL_BASE+6

;---------------------------------------------------------
; Init
;---------------------------------------------------------

SERIAL_Init

        xor a
        ret

;---------------------------------------------------------
; PutChar
;
; A = character
;---------------------------------------------------------

SERIAL_PutChar

.wait

        in a,(SERIAL_LSR)

        bit 5,a
        jr z,.wait

        ld a,l

        out (SERIAL_DATA),a

        ret

;---------------------------------------------------------
; GetChar
;
; A = character
;---------------------------------------------------------

SERIAL_GetChar

.wait

        in a,(SERIAL_LSR)

        bit 0,a
        jr z,.wait

        in a,(SERIAL_DATA)

        ret

;---------------------------------------------------------
; Status
;---------------------------------------------------------

SERIAL_Status

        in a,(SERIAL_LSR)

        ret

;---------------------------------------------------------
; PrintString
;
; HL -> ASCIIZ
;---------------------------------------------------------

SERIAL_PrintString

.loop

        ld a,(hl)

        or a
        ret z

        push hl

        call SERIAL_PutChar

        pop hl

        inc hl

        jr .loop

;---------------------------------------------------------
; Print HEX8
;---------------------------------------------------------

SERIAL_PrintHex8

        push af

        rrca
        rrca
        rrca
        rrca

        call SERIAL_PrintNibble

        pop af

        call SERIAL_PrintNibble

        ret

;---------------------------------------------------------
; Print Nibble
;---------------------------------------------------------

SERIAL_PrintNibble

        and #0F

        add a,'0'

        cp '9'+1

        jr c,.ok

        add a,7

.ok

        call SERIAL_PutChar

        ret

;---------------------------------------------------------
; Print CRLF
;---------------------------------------------------------

SERIAL_CRLF

        ld a,13
        call SERIAL_PutChar

        ld a,10
        call SERIAL_PutChar

        ret