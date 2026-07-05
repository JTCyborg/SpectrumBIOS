;=========================================================
;
; SpectrumUnix Kernel
;
;=========================================================

Kernel_Start

        di

        call Memory_Init
        call Scheduler_Init
        call Process_Init
        call VFS_Init

        call Console_Init

        call Kernel_Banner

        call Shell_Start

.loop

        halt

        call Scheduler_Tick

        jr .loop

;---------------------------------------------------------

Kernel_Banner

        ld hl,TxtKernel

        call CONSOLE_PrintString

        ret

;---------------------------------------------------------

TxtKernel

db 13,10
db "SpectrumUnix Kernel v0.0.1",13,10
db "(C) 2026",13,10
db 13,10,0