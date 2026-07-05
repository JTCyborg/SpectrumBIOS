;=========================================================
;
; SBIOS
; Virtual File System
;
;=========================================================

;---------------------------------------------------------
; VFS_Init
;---------------------------------------------------------

VFS_Init

        xor a

        ld (VFS_CurrentFS),a
        ld (VFS_LastError),a

        ret

;---------------------------------------------------------
; Mount filesystem
;
; A = FS type
;---------------------------------------------------------

VFS_Mount

        ld (VFS_CurrentFS),a

        cp FS_FAT16
        jp z,FAT16_Init

        cp FS_EXT2
        jp z,EXT2_Init

        ld a,VFS_ERR_UNKNOWN_FS
        ld (VFS_LastError),a

        ret

;---------------------------------------------------------
; Open
;
; HL -> filename
;---------------------------------------------------------

VFS_Open

        ld a,(VFS_CurrentFS)

        cp FS_FAT16
        jp z,FAT16_Open

        cp FS_EXT2
        jp z,EXT2_Open

        ret

;---------------------------------------------------------

VFS_Close

        ld a,(VFS_CurrentFS)

        cp FS_FAT16
        jp z,FAT16_Close

        cp FS_EXT2
        jp z,EXT2_Close

        ret

;---------------------------------------------------------

VFS_Read

        ld a,(VFS_CurrentFS)

        cp FS_FAT16
        jp z,FAT16_Read

        cp FS_EXT2
        jp z,EXT2_Read

        ret

;---------------------------------------------------------

VFS_Write

        ld a,(VFS_CurrentFS)

        cp FS_FAT16
        jp z,FAT16_Write

        cp FS_EXT2
        jp z,EXT2_Write

        ret

;---------------------------------------------------------

VFS_Seek

        ld a,(VFS_CurrentFS)

        cp FS_FAT16
        jp z,FAT16_Seek

        cp FS_EXT2
        jp z,EXT2_Seek

        ret

;---------------------------------------------------------

VFS_Find

        ld a,(VFS_CurrentFS)

        cp FS_FAT16
        jp z,FAT16_Find

        cp FS_EXT2
        jp z,EXT2_Find

        ret

;---------------------------------------------------------

VFS_LoadFile

        ld a,(VFS_CurrentFS)

        cp FS_FAT16
        jp z,FAT16_LoadFile

        cp FS_EXT2
        jp z,EXT2_LoadFile

        ret

;---------------------------------------------------------

VFS_Unmount

        xor a

        ld (VFS_CurrentFS),a

        ret

;---------------------------------------------------------
; Variables
;---------------------------------------------------------

VFS_CurrentFS

        db 0

VFS_LastError

        db 0

;---------------------------------------------------------
; Filesystems
;---------------------------------------------------------

FS_NONE         EQU 0
FS_FAT16        EQU 1
FS_EXT2         EQU 2

;---------------------------------------------------------
; Errors
;---------------------------------------------------------

VFS_ERR_OK          EQU 0
VFS_ERR_NOTFOUND    EQU 1
VFS_ERR_READ        EQU 2
VFS_ERR_WRITE       EQU 3
VFS_ERR_UNKNOWN_FS  EQU 4