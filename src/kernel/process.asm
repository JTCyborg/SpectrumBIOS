;=========================================================
;
; SBIOS
; Process Manager
;
;=========================================================

MAX_PROCESSES      EQU 8

PROC_FREE          EQU 0
PROC_READY         EQU 1
PROC_RUNNING       EQU 2
PROC_SLEEP         EQU 3
PROC_ZOMBIE        EQU 4

;---------------------------------------------------------
; Process Descriptor
;---------------------------------------------------------

PROC_PID           EQU 0
PROC_STATE         EQU 1
PROC_PRIORITY      EQU 2
PROC_BANK          EQU 3
PROC_SP            EQU 4
PROC_PC            EQU 6
PROC_STACK         EQU 8
PROC_STACKSIZE     EQU 10
PROC_FLAGS         EQU 12

PROCESS_SIZE       EQU 16

;---------------------------------------------------------
; Variables
;---------------------------------------------------------

NextPID

        db 1

ProcessCount

        db 0

CurrentPID

        db 0

;---------------------------------------------------------
; Process Table
;---------------------------------------------------------

ProcessTable

        defs PROCESS_SIZE*MAX_PROCESSES

;=========================================================
; Init
;=========================================================

Process_Init

        xor a

        ld (ProcessCount),a
        ld (CurrentPID),a

        ld hl,ProcessTable
        ld de,ProcessTable+1
        ld bc,(PROCESS_SIZE*MAX_PROCESSES)-1

        ld (hl),0
        ldir

        ret

;=========================================================
; Create Process
;
; HL = Entry Point
; DE = Stack
; BC = Stack Size
;=========================================================

Process_Create

        ld a,(ProcessCount)

        cp MAX_PROCESSES
        ret nc

        push hl
        push de
        push bc

        ld hl,ProcessTable

        ld b,a

.next

        ld a,b
        or a
        jr z,.found

        ld de,PROCESS_SIZE

        add hl,de

        djnz .next

.found

        pop bc
        pop de
        pop af

        ld a,(NextPID)
        ld (hl),a

        inc a
        ld (NextPID),a

        inc hl

        ld (hl),PROC_READY

        inc hl

        ld (hl),1

        inc hl

        xor a
        ld (hl),a

        inc hl

        ld (hl),e
        inc hl
        ld (hl),d

        inc hl

        pop de

        ld (hl),e
        inc hl
        ld (hl),d

        inc hl

        pop de

        ld (hl),e
        inc hl
        ld (hl),d

        ld a,(ProcessCount)
        inc a
        ld (ProcessCount),a

        ret

;=========================================================
; Destroy
;=========================================================

Process_Destroy

        ret

;=========================================================
; Find PID
;=========================================================

Process_FindPID

        ld hl,ProcessTable

        ld b,MAX_PROCESSES

.loop

        ld c,(hl)

        ld a,c

        cp d

        ret z

        ld de,PROCESS_SIZE

        add hl,de

        djnz .loop

        xor a

        ret

;=========================================================
; Current
;=========================================================

Process_Current

        ld a,(CurrentPID)

        ret

;=========================================================
; Switch
;=========================================================

Process_Switch

        call Scheduler_NextTask

        ret

;=========================================================
; Sleep
;=========================================================

Process_Sleep

        ret

;=========================================================
; Wake
;=========================================================

Process_Wake

        ret

;=========================================================
; Kill
;=========================================================

Process_Kill

        ret

;=========================================================
; Exit
;=========================================================

Process_Exit

        call Process_Destroy

        call Scheduler_Yield

        ret