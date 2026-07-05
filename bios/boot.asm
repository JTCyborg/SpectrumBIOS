;=========================================================
;
; SBIOS
; Boot Manager
;
;=========================================================

;---------------------------------------------------------
; Entry
;---------------------------------------------------------

BIOS_BootManager

        call BOOT_ShowMenu

MainLoop

        call KEYBOARD_Wait

        cp '1'
        jp z,BOOT_IDE

        cp '2'
        jp z,BOOT_BASIC

        cp '3'
        jp z,BOOT_SETUP

        cp '4'
        jp z,BOOT_DIAG

        jr MainLoop

;---------------------------------------------------------
; Draw menu
;---------------------------------------------------------

BOOT_ShowMenu

        ld hl,TxtBootMenu
        call BIOS_PrintString

        ret

;---------------------------------------------------------
; Boot IDE
;---------------------------------------------------------

BOOT_IDE

        ld hl,TxtBootIDE
        call BIOS_PrintString

        call IDE_Reset

        call IDE_Detect

        call BOOT_ReadMBR

        call BOOT_LoadStage2

        ret

;---------------------------------------------------------
; Boot BASIC
;---------------------------------------------------------

BOOT_BASIC

        ld hl,TxtBasic
        call BIOS_PrintString

        jp 0

;---------------------------------------------------------
; Setup
;---------------------------------------------------------

BOOT_SETUP

        jp BIOS_Setup

;---------------------------------------------------------
; Diagnostics
;---------------------------------------------------------

BOOT_DIAG

        jp BIOS_Diagnostics

;---------------------------------------------------------
; Read MBR
;---------------------------------------------------------

BOOT_ReadMBR

        ld hl,MBR_Buffer

        xor a
        ld b,a
        ld c,a
        ld d,a
        ld e,a

        call IDE_ReadSector

        ret

;---------------------------------------------------------
; Load Stage2
;---------------------------------------------------------

BOOT_LoadStage2

        ld hl,TxtStage2
        call BIOS_PrintString

        ; здесь позже будет:
        ;
        ; Parse MBR
        ; Find Active Partition
        ; Read FAT16
        ; Find KERNEL.BIN
        ; Load Kernel

        ret

;---------------------------------------------------------
; Buffer
;---------------------------------------------------------

MBR_Buffer

        defs 512

;---------------------------------------------------------
; Strings
;---------------------------------------------------------

TxtBootMenu

db 13,10
db "Boot Manager",13,10
db "------------------------",13,10
db "1 Boot HDD",13,10
db "2 ROM BASIC",13,10
db "3 Setup",13,10
db "4 Diagnostics",13,10
db 13,10
db "Select:",0

TxtBootIDE

db 13,10
db "Booting HDD...",13,10,0

TxtBasic

db 13,10
db "Starting ROM BASIC...",13,10,0

TxtStage2

db 13,10
db "Loading Stage2...",13,10,0