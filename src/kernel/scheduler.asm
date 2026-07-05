;=========================================================
;
; SBIOS
; Task Scheduler
;
;=========================================================

MAX_TASKS       EQU 8

TASK_FREE       EQU 0
TASK_READY      EQU 1
TASK_RUNNING    EQU 2
TASK_SLEEP      EQU 3
TASK_WAIT       EQU 4

;---------------------------------------------------------
; Task Structure
;---------------------------------------------------------

TASK_SP         EQU 0
TASK_PC         EQU 2
TASK_STATE      EQU 4
TASK_PRIORITY   EQU 5
TASK_FLAGS      EQU 6
TASK_BANK       EQU 7
TASK_SIZE       EQU 8

;---------------------------------------------------------
; Variables
;---------------------------------------------------------

SchedulerEnabled

        db 0

CurrentTask

        db 0

TaskCount

        db 0

;---------------------------------------------------------
; Task Table
;---------------------------------------------------------

TaskTable

        defs TASK_SIZE*MAX_TASKS

;---------------------------------------------------------
; Init
;---------------------------------------------------------

Scheduler_Init

        xor a

        ld (CurrentTask),a
        ld (TaskCount),a
        ld (SchedulerEnabled),a

        ld hl,TaskTable
        ld de,TaskTable+1
        ld bc,(TASK_SIZE*MAX_TASKS)-1

        ld (hl),0
        ldir

        ret

;---------------------------------------------------------
; Enable
;---------------------------------------------------------

Scheduler_Enable

        ld a,1
        ld (SchedulerEnabled),a

        ret

;---------------------------------------------------------
; Disable
;---------------------------------------------------------

Scheduler_Disable

        xor a
        ld (SchedulerEnabled),a

        ret

;---------------------------------------------------------
; Tick
;---------------------------------------------------------

Scheduler_Tick

        ld a,(SchedulerEnabled)

        or a
        ret z

        call Scheduler_NextTask

        ret

;---------------------------------------------------------
; Next Task
;---------------------------------------------------------

Scheduler_NextTask

        ld a,(CurrentTask)

.next

        inc a

        cp MAX_TASKS
        jr c,.check

        xor a

.check

        ld hl,TaskTable

        ld e,a
        ld d,0

        ld bc,TASK_SIZE

.loop

        or a
        jr z,.done

        add hl,bc

        dec e
        jr .loop

.done

        ld de,TASK_STATE

        add hl,de

        ld b,(hl)

        ld a,b

        cp TASK_READY
        jr nz,.next

        ld a,e
        ld (CurrentTask),a

        ret

;---------------------------------------------------------
; Add Task
;
; HL = Entry
; SP = Stack
;---------------------------------------------------------

Scheduler_AddTask

        ld a,(TaskCount)

        cp MAX_TASKS
        ret nc

        ld e,a
        ld d,0

        ld hl,TaskTable

        ld bc,TASK_SIZE

.add

        ld a,e
        or a
        jr z,.store

        add hl,bc

        dec e

        jr .add

.store

        push hl

        ld de,TASK_PC

        add hl,de

        ex de,hl

        pop hl

        ld (hl),e
        inc hl
        ld (hl),d

        inc hl
        inc hl

        ld (hl),TASK_READY

        ld a,(TaskCount)
        inc a
        ld (TaskCount),a

        ret

;---------------------------------------------------------
; Remove Task
;---------------------------------------------------------

Scheduler_RemoveTask

        ret

;---------------------------------------------------------
; Yield
;---------------------------------------------------------

Scheduler_Yield

        call Scheduler_NextTask

        ret

;---------------------------------------------------------
; Sleep
;---------------------------------------------------------

Scheduler_Sleep

        ret

;---------------------------------------------------------
; Wake
;---------------------------------------------------------

Scheduler_Wake

        ret

;---------------------------------------------------------
; IRQ Entry
;---------------------------------------------------------

Scheduler_IRQ

        push af
        push bc
        push de
        push hl
        push ix
        push iy

        call Scheduler_Tick

        pop iy
        pop ix
        pop hl
        pop de
        pop bc
        pop af

        ret