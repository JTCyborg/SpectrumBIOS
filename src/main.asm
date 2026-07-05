        DEVICE ZXSPECTRUM128

;=========================================================
; SBIOS
; Main build file
;=========================================================

        INCLUDE "inc/bios.inc"

;---------------------------------------------------------
; BIOS
;---------------------------------------------------------

        INCLUDE "bios/reset.asm"
        INCLUDE "bios/vectors.asm"
        INCLUDE "bios/init.asm"
        INCLUDE "bios/post.asm"
        INCLUDE "bios/api.asm"
        INCLUDE "bios/setup.asm"
        INCLUDE "bios/boot.asm"

;---------------------------------------------------------
; Drivers
;---------------------------------------------------------

        INCLUDE "drivers/console.asm"
        INCLUDE "drivers/video.asm"
        INCLUDE "drivers/keyboard.asm"
        INCLUDE "drivers/memory.asm"
        INCLUDE "drivers/ide.asm"

;---------------------------------------------------------
; End of ROM
;---------------------------------------------------------

ROM_End:

        DISPLAY "ROM size = ", /D, ROM_End

        ASSERT ROM_End <= #4000

        BLOCK #4000-ROM_End,#FF
