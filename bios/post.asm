;=========================================================
;
; SBIOS
; POST
;
;=========================================================

;---------------------------------------------------------
; BIOS POST
;---------------------------------------------------------

BIOS_POST:

        call POST_Clear

        call POST_Banner

        call POST_CPU

        call POST_RAM

        call POST_ROM

        call POST_VIDEO

        call POST_KEYBOARD

        call POST_AY

        call POST_RTC

        call POST_IDE

        call POST_BOOT

        ret

;---------------------------------------------------------
; Clear
;---------------------------------------------------------

POST_Clear

        call VIDEO_Clear

        ret

;---------------------------------------------------------
; Banner
;---------------------------------------------------------

POST_Banner

        ld hl,TxtBanner
        call BIOS_PrintString

        ret

;---------------------------------------------------------
; CPU
;---------------------------------------------------------

POST_CPU

        ld hl,TxtCPU
        call BIOS_PrintString

        ; здесь позже будет реальный тест

        ret

;---------------------------------------------------------
; RAM
;---------------------------------------------------------

POST_RAM

        ld hl,TxtRAM
        call BIOS_PrintString

        ; здесь позже полный Memory Test

        ret

;---------------------------------------------------------
; ROM
;---------------------------------------------------------

POST_ROM

        ld hl,TxtROM
        call BIOS_PrintString

        ; CRC ROM

        ret

;---------------------------------------------------------
; VIDEO
;---------------------------------------------------------

POST_VIDEO

        ld hl,TxtVIDEO
        call BIOS_PrintString

        ret

;---------------------------------------------------------
; KEYBOARD
;---------------------------------------------------------

POST_KEYBOARD

        ld hl,TxtKEYBOARD
        call BIOS_PrintString

        ret

;---------------------------------------------------------
; AY
;---------------------------------------------------------

POST_AY

        ld hl,TxtAY
        call BIOS_PrintString

        ret

;---------------------------------------------------------
; RTC
;---------------------------------------------------------

POST_RTC

        ld hl,TxtRTC
        call BIOS_PrintString

        ret

;---------------------------------------------------------
; IDE
;---------------------------------------------------------

POST_IDE

        ld hl,TxtIDE
        call BIOS_PrintString

        ; Identify Device будет позже

        ret

;---------------------------------------------------------
; BOOT
;---------------------------------------------------------

POST_BOOT

        ld hl,TxtBOOT
        call BIOS_PrintString

        ret

;=========================================================
; Strings
;=========================================================

TxtBanner

db 13,10
db "Spectrum SBIOS v0.0.1",13,10
db "Pentagon 1024",13,10
db "(C) 2026",13,10
db 13,10,0

TxtCPU

db "[ OK ] CPU",13,10,0

TxtRAM

db "[ OK ] RAM",13,10,0

TxtROM

db "[ OK ] ROM",13,10,0

TxtVIDEO

db "[ OK ] VIDEO",13,10,0

TxtKEYBOARD

db "[ OK ] KEYBOARD",13,10,0

TxtAY

db "[ OK ] AY-3-8912",13,10,0

TxtRTC

db "[ OK ] RTC",13,10,0

TxtIDE

db "[ OK ] NEMO IDE",13,10,0

TxtBOOT

db 13,10
db "Starting Boot Manager...",13,10,0