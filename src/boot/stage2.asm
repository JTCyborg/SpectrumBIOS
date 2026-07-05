;=========================================================
;
; SBIOS
; Stage2 Loader
;
;=========================================================

KERNEL_LOAD_ADDR    EQU #C000

Stage2_Start

        call VFS_Init

        ld a,FS_FAT16
        call VFS_Mount

        ld hl,KernelName
        call VFS_Open
        jr c,.error

        ld hl,KERNEL_LOAD_ADDR
        call VFS_LoadFile
        jr c,.error

        jp KERNEL_LOAD_ADDR

.error

        ld hl,TxtError
        call BIOS_PrintString

.halt

        halt
        jr .halt

;---------------------------------------------------------

KernelName

db "KERNEL  BIN",0

;---------------------------------------------------------

TxtError

db 13,10
db "Kernel not found",13,10
db 0