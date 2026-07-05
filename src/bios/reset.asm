;=========================================================
;
; SBIOS
; reset.asm
;
;=========================================================

        ORG     #0000

;---------------------------------------------------------
; RESET VECTOR
;---------------------------------------------------------

Reset:

        di

        im      1

        xor     a
        ld      i,a

        ld      sp,STACK_TOP

        jp      BIOS_Start

;---------------------------------------------------------
; BIOS ENTRY
;---------------------------------------------------------

BIOS_Start:

        call    BIOS_ClearBDA

        call    BIOS_InitCPU

        call    BIOS_InitMemory

        call    BIOS_InitVideo

        call    BIOS_InitKeyboard

        call    BIOS_InitTimer

        call    BIOS_InitRTC

        call    BIOS_InitIDE

        call    BIOS_POST

        call    BIOS_CheckSetupKey

        call    BIOS_BootManager

;---------------------------------------------------------
; Boot returned (error)
;---------------------------------------------------------

Boot_Return:

        ld      hl,MsgBootFailed

        call    BIOS_PrintString

.loop

        halt

        jr      .loop

;---------------------------------------------------------
; Strings
;---------------------------------------------------------

MsgBootFailed:

        db 13,10
        db "BOOT FAILURE",13,10
        db "System halted",13,10,0