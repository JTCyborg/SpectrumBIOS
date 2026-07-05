;=========================================================
;
; SBIOS
; BIOS Setup
;
;=========================================================

;---------------------------------------------------------
; Entry
;---------------------------------------------------------

BIOS_Setup

        call VIDEO_Clear

        call SETUP_Draw

SetupLoop

        call KEYBOARD_Wait

        cp 27                  ; ESC
        jp z,SetupExit

        cp 13                  ; ENTER
        jr z,SetupEnter

        cp 'w'
        jr z,SetupUp

        cp 's'
        jr z,SetupDown

        cp 'W'
        jr z,SetupUp

        cp 'S'
        jr z,SetupDown

        jr SetupLoop

;---------------------------------------------------------

SetupExit

        ret

;---------------------------------------------------------

SetupEnter

        ld a,(SetupItem)

        cp 0
        jp z,SETUP_Main

        cp 1
        jp z,SETUP_Advanced

        cp 2
        jp z,SETUP_Boot

        cp 3
        jp z,SETUP_IDE

        cp 4
        jp z,SETUP_Devices

        cp 5
        jp z,SETUP_Diagnostics

        cp 6
        jp z,SETUP_Save

        cp 7
        jp z,SETUP_Exit

        jr SetupLoop

;---------------------------------------------------------

SetupUp

        ld a,(SetupItem)

        or a
        jr z,SetupLoop

        dec a

        ld (SetupItem),a

        call SETUP_Draw

        jr SetupLoop

;---------------------------------------------------------

SetupDown

        ld a,(SetupItem)

        cp 7
        jr z,SetupLoop

        inc a

        ld (SetupItem),a

        call SETUP_Draw

        jr SetupLoop

;---------------------------------------------------------

SETUP_Draw

        ld hl,TxtSetup

        call BIOS_PrintString

        ret

;---------------------------------------------------------

SETUP_Main

        ld hl,TxtMain

        call BIOS_PrintString

        jr SetupLoop

;---------------------------------------------------------

SETUP_Advanced

        ld hl,TxtAdvanced

        call BIOS_PrintString

        jr SetupLoop

;---------------------------------------------------------

SETUP_Boot

        ld hl,TxtBoot

        call BIOS_PrintString

        jr SetupLoop

;---------------------------------------------------------

SETUP_IDE

        ld hl,TxtIDE

        call BIOS_PrintString

        jr SetupLoop

;---------------------------------------------------------

SETUP_Devices

        ld hl,TxtDevices

        call BIOS_PrintString

        jr SetupLoop

;---------------------------------------------------------

SETUP_Diagnostics

        ld hl,TxtDiag

        call BIOS_PrintString

        jr SetupLoop

;---------------------------------------------------------

SETUP_Save

        ld hl,TxtSave

        call BIOS_PrintString

        ; позже запись CMOS/HDD

        jr SetupLoop

;---------------------------------------------------------

SETUP_Exit

        ret

;---------------------------------------------------------
; Variables
;---------------------------------------------------------

SetupItem

        db 0

;---------------------------------------------------------
; Strings
;---------------------------------------------------------

TxtSetup

db 13,10
db "================================",13,10
db "        SBIOS SETUP",13,10
db "================================",13,10
db "W/S  Move",13,10
db "ENTER Select",13,10
db "ESC Exit",13,10
db 13,10
db "MAIN",13,10
db "ADVANCED",13,10
db "BOOT",13,10
db "IDE",13,10
db "DEVICES",13,10
db "DIAGNOSTICS",13,10
db "SAVE",13,10
db "EXIT",13,10,0

TxtMain

db 13,10
db "MAIN PAGE",13,10
db "CPU........Z80",13,10
db "RAM........1024KB",13,10
db "ROM........16KB",13,10,0

TxtAdvanced

db 13,10
db "ADVANCED",13,10
db "Turbo........OFF",13,10
db "Shadow ROM...OFF",13,10,0

TxtBoot

db 13,10
db "BOOT",13,10
db "1 HDD",13,10
db "2 BASIC",13,10,0

TxtIDE

db 13,10
db "IDE",13,10
db "Primary Master",13,10
db "Auto Detect",13,10,0

TxtDevices

db 13,10
db "DEVICES",13,10
db "AY",13,10
db "RTC",13,10
db "Kempston",13,10,0

TxtDiag

db 13,10
db "Diagnostics",13,10
db "RAM Test",13,10
db "IDE Test",13,10
db "Keyboard Test",13,10,0

TxtSave

db 13,10
db "Settings saved.",13,10,0