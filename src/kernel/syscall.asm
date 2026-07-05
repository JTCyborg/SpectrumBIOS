;=========================================================
;
; SBIOS
; System Call Dispatcher
;
;=========================================================

SYSCALL_COUNT      EQU 32

;---------------------------------------------------------
; Entry
;
; A = syscall number
;
;---------------------------------------------------------

SysCall

        cp SYSCALL_COUNT
        jr c,.dispatch

        scf
        ret

.dispatch

        add a,a

        ld hl,SysCallTable

        ld e,a
        ld d,0

        add hl,de

        ld e,(hl)
        inc hl
        ld d,(hl)

        ex de,hl

        jp (hl)

;=========================================================
; System Call Table
;=========================================================

SysCallTable

        dw SYS_Exit
        dw SYS_Print
        dw SYS_PutChar
        dw SYS_GetChar
        dw SYS_Open
        dw SYS_Close
        dw SYS_Read
        dw SYS_Write

        dw SYS_Seek
        dw SYS_Tell
        dw SYS_Create
        dw SYS_Delete

        dw SYS_Malloc
        dw SYS_Free
        dw SYS_GetTick
        dw SYS_Delay

        dw SYS_CreateTask
        dw SYS_KillTask
        dw SYS_Yield
        dw SYS_GetPID

        dw SYS_LoadModule
        dw SYS_Exec
        dw SYS_Mount
        dw SYS_Unmount

        dw SYS_IOCTL
        dw SYS_Reset
        dw SYS_Reboot
        dw SYS_Shutdown

        dw SYS_Reserved28
        dw SYS_Reserved29
        dw SYS_Reserved30
        dw SYS_Reserved31

;=========================================================
; Console
;=========================================================

SYS_Print

        jp CONSOLE_PrintString

SYS_PutChar

        jp CONSOLE_PutChar

SYS_GetChar

        jp KEYBOARD_Read

;=========================================================
; File System
;=========================================================

SYS_Open

        jp VFS_Open

SYS_Close

        jp VFS_Close

SYS_Read

        jp VFS_Read

SYS_Write

        jp VFS_Write

SYS_Seek

        jp VFS_Seek

SYS_Tell

        ret

SYS_Create

        ret

SYS_Delete

        ret

;=========================================================
; Memory
;=========================================================

SYS_Malloc

        jp Memory_Alloc

SYS_Free

        jp Memory_Free

;=========================================================
; Time
;=========================================================

SYS_GetTick

        ld hl,(BDA_TICKS)

        ret

SYS_Delay

.delay

        halt

        dec bc

        ld a,b
        or c

        jr nz,.delay

        ret

;=========================================================
; Tasks
;=========================================================

SYS_CreateTask

        jp Process_Create

SYS_KillTask

        jp Process_Kill

SYS_Yield

        jp Scheduler_Yield

SYS_GetPID

        jp Process_Current

;=========================================================
; Loader
;=========================================================

SYS_LoadModule

        ret

SYS_Exec

        ret

;=========================================================
; File System
;=========================================================

SYS_Mount

        jp VFS_Mount

SYS_Unmount

        jp VFS_Unmount

;=========================================================
; IOCTL
;=========================================================

SYS_IOCTL

        ret

;=========================================================
; System
;=========================================================

SYS_Reset

        jp Reset

SYS_Reboot

        jp Reset

SYS_Shutdown

.stop

        halt
        jr .stop

SYS_Exit

        jp Process_Exit

;=========================================================
; Reserved
;=========================================================

SYS_Reserved28

        ret

SYS_Reserved29

        ret

SYS_Reserved30

        ret

SYS_Reserved31

        ret