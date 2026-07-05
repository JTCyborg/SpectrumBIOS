;=========================================================
;
; SBIOS
; FUZIX Loader
;
;=========================================================

FUZIX_LOAD_ADDR     EQU #C000

;---------------------------------------------------------
; Entry
;---------------------------------------------------------

FUZIX_Load

        call Loader_PrintBanner

        call Loader_MountFS
        jr c,.mount_error

        call Loader_OpenKernel
        jr c,.kernel_error

        call Loader_LoadKernel
        jr c,.read_error

        call Loader_LoadInitrd

        call Loader_PrepareBootInfo

        call Loader_StartKernel

        ret

.mount_error

        ld hl,TxtMountError
        call BIOS_PrintString
        ret

.kernel_error

        ld hl,TxtKernelError
        call BIOS_PrintString
        ret

.read_error

        ld hl,TxtReadError
        call BIOS_PrintString
        ret

;---------------------------------------------------------
; Banner
;---------------------------------------------------------

Loader_PrintBanner

        ld hl,TxtBanner
        call BIOS_PrintString

        ret

;---------------------------------------------------------
; Mount FAT16
;---------------------------------------------------------

Loader_MountFS

        ld a,FS_FAT16

        call VFS_Mount

        ret

;---------------------------------------------------------
; Open Kernel
;---------------------------------------------------------

Loader_OpenKernel

        ld hl,KernelName

        call VFS_Open

        ret

;---------------------------------------------------------
; Load Kernel
;---------------------------------------------------------

Loader_LoadKernel

        ld hl,FUZIX_LOAD_ADDR

        call VFS_LoadFile

        ret

;---------------------------------------------------------
; Optional initrd
;---------------------------------------------------------

Loader_LoadInitrd

        ld hl,InitrdName

        call VFS_Open

        ret c

        ld hl,#A000

        call VFS_LoadFile

        ret

;---------------------------------------------------------
; BootInfo
;---------------------------------------------------------

Loader_PrepareBootInfo

        ld hl,BOOTINFO

        ld (BootInfoPointer),hl

        ret

;---------------------------------------------------------
; Jump to kernel
;---------------------------------------------------------

Loader_StartKernel

        ld hl,BOOTINFO

        ld ix,hl

        jp FUZIX_LOAD_ADDR

;---------------------------------------------------------
; Variables
;---------------------------------------------------------

BootInfoPointer

        dw 0

;---------------------------------------------------------
; Names
;---------------------------------------------------------

KernelName

db "FUZIX   BIN",0

InitrdName

db "INITRD  IMG",0

;---------------------------------------------------------
; Messages
;---------------------------------------------------------

TxtBanner

db 13,10
db "Loading FUZIX...",13,10,0

TxtMountError

db "Cannot mount FAT16",13,10,0

TxtKernelError

db "FUZIX.BIN not found",13,10,0

TxtReadError

db "Kernel read error",13,10,0