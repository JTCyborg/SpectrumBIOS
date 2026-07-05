;=========================================================
;
; SBIOS
; Memory Manager
;
; Pentagon 1024 (1MB)
;
;=========================================================

PAGE_SIZE       EQU 16384
TOTAL_PAGES     EQU 64

PAGE_FREE       EQU 0
PAGE_USED       EQU 1
PAGE_ROM        EQU 2
PAGE_RESERVED   EQU 3

;---------------------------------------------------------
; Variables
;---------------------------------------------------------

Memory_TotalPages

        db TOTAL_PAGES

Memory_FreePages

        db TOTAL_PAGES

Memory_LastError

        db 0

;---------------------------------------------------------
; Page Bitmap
;---------------------------------------------------------

MemoryMap

        defs TOTAL_PAGES

;---------------------------------------------------------
; Init
;---------------------------------------------------------

Memory_Init

        ld hl,MemoryMap
        ld de,MemoryMap+1
        ld bc,TOTAL_PAGES-1

        xor a

        ld (hl),PAGE_FREE

        ldir

        ; ROM

        ld a,PAGE_ROM
        ld (MemoryMap+0),a

        ; Reserve first RAM page

        ld a,PAGE_RESERVED
        ld (MemoryMap+1),a

        ld a,TOTAL_PAGES-2
        ld (Memory_FreePages),a

        ret

;---------------------------------------------------------
; Allocate one page
;
; Return:
; A = page
; Carry=1 error
;---------------------------------------------------------

Memory_Alloc

        ld hl,MemoryMap

        ld b,TOTAL_PAGES

        xor a

.loop

        cp b
        jr z,.fail

        ld d,a

        ld e,0

        add hl,de

        ld e,(hl)

        ld a,e

        cp PAGE_FREE

        jr z,.found

        ld a,d
        inc a

        ld hl,MemoryMap

        jr .loop

.found

        ld (hl),PAGE_USED

        ld a,(Memory_FreePages)
        dec a
        ld (Memory_FreePages),a

        ld a,d

        or a

        ret

.fail

        scf

        ld a,1
        ld (Memory_LastError),a

        ret

;---------------------------------------------------------
; Free Page
;
; A = page
;---------------------------------------------------------

Memory_Free

        cp TOTAL_PAGES
        ret nc

        ld hl,MemoryMap

        ld e,a
        ld d,0

        add hl,de

        ld (hl),PAGE_FREE

        ld a,(Memory_FreePages)
        inc a
        ld (Memory_FreePages),a

        ret

;---------------------------------------------------------
; Allocate N Pages
;
; B = pages
;---------------------------------------------------------

Memory_AllocBlock

        ; TODO

        ret

;---------------------------------------------------------
; Free Block
;---------------------------------------------------------

Memory_FreeBlock

        ; TODO

        ret

;---------------------------------------------------------
; Get Page State
;
; A = page
;
; Return A=state
;---------------------------------------------------------

Memory_GetState

        cp TOTAL_PAGES
        jr nc,.bad

        ld hl,MemoryMap

        ld e,a
        ld d,0

        add hl,de

        ld a,(hl)

        ret

.bad

        xor a

        ret

;---------------------------------------------------------
; Set Page State
;
; A = page
; C = state
;---------------------------------------------------------

Memory_SetState

        cp TOTAL_PAGES
        ret nc

        ld hl,MemoryMap

        ld e,a
        ld d,0

        add hl,de

        ld (hl),c

        ret

;---------------------------------------------------------
; Get Free Pages
;---------------------------------------------------------

Memory_GetFree

        ld a,(Memory_FreePages)

        ret

;---------------------------------------------------------
; Clear Page
;
; A = page
;---------------------------------------------------------

Memory_ClearPage

        ; TODO:
        ; page -> bank
        ; map bank
        ; clear 16K

        ret

;---------------------------------------------------------
; Copy Page
;---------------------------------------------------------

Memory_CopyPage

        ; TODO

        ret

;---------------------------------------------------------
; Map Bank
;
; A = bank
;---------------------------------------------------------

Memory_MapBank

        ; Pentagon 1024 paging
        ; TODO

        ret