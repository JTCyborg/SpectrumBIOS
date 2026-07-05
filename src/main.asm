DEVICE ZXSPECTRUM128

        INCLUDE "inc/bios.inc"

        INCLUDE "bios/reset.asm"
        INCLUDE "bios/vectors.asm"
        INCLUDE "bios/init.asm"
        INCLUDE "bios/post.asm"
        INCLUDE "bios/api.asm"

        INCLUDE "drivers/console.asm"
        INCLUDE "drivers/video.asm"
        INCLUDE "drivers/keyboard.asm"
        INCLUDE "drivers/memory.asm"
        INCLUDE "drivers/ide.asm"

        INCLUDE "bios/setup.asm"
        INCLUDE "bios/boot.asm"
