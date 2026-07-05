;=========================================================
;
; SBIOS
; Console Driver v1.0
;
;=========================================================

;---------------------------------------------------------
; Variables
;---------------------------------------------------------

CursorX         db 0
CursorY         db 0

;---------------------------------------------------------
; Clear Screen
;---------------------------------------------------------

CONSOLE_Clear:

        ld hl,#4000
        ld de,#4001
        ld bc,6143
        ld (hl),0
        ldir

        ld hl,#5800
        ld de,#5801
        ld bc,767
        ld (hl),7
        ldir

        xor a
        ld (CursorX),a
        ld (CursorY),a

        ret

;---------------------------------------------------------
; Home
;---------------------------------------------------------

CONSOLE_Home:

        xor a

        ld (CursorX),a
        ld (CursorY),a

        ret

;---------------------------------------------------------
; Print zero terminated string
;
; HL -> string
;---------------------------------------------------------

CONSOLE_PrintString:

.next

        ld a,(hl)

        or a

        ret z

        call CONSOLE_PutChar

        inc hl

        jr .next

;---------------------------------------------------------
; PutChar
;
; Пока только управление курсором.
; Рендер символов добавим после video.asm
;---------------------------------------------------------

CONSOLE_PutChar:

        cp 13
        jr z,.cr

        cp 10
        jr z,.lf

        ; временно индикация символа бордюром

        push bc

        ld b,a

        and 7

        out (PORT_FE),a

        ld a,b

        pop bc

        ld a,(CursorX)
        inc a
        cp 32
        jr c,.storex

        xor a

        ld (CursorX),a

        ld a,(CursorY)
        inc a
        ld (CursorY),a

        ret

.storex

        ld (CursorX),a

        ret

.cr

        xor a
        ld (CursorX),a

        ret

.lf

        ld a,(CursorY)
        inc a
        ld (CursorY),a

        ret

;---------------------------------------------------------
; Set Cursor
;
; B = X
; C = Y
;---------------------------------------------------------

CONSOLE_GotoXY:

        ld a,b
        ld (CursorX),a

        ld a,c
        ld (CursorY),a

        ret

;---------------------------------------------------------
; Get Cursor
;
; B = X
; C = Y
;---------------------------------------------------------

CONSOLE_GetXY:

        ld a,(CursorX)
        ld b,a

        ld a,(CursorY)
        ld c,a

        ret