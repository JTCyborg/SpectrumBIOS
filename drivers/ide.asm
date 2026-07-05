;=========================================================
;
; SBIOS
; Nemo IDE Driver
;
; ATA PIO MODE
;
;=========================================================

        INCLUDE "inc/bios.inc"
        INCLUDE "inc/ports.inc"

;---------------------------------------------------------
; Variables
;---------------------------------------------------------

IDE_LastError

        db 0

;---------------------------------------------------------
; Init
;---------------------------------------------------------

IDE_Init

        call IDE_Reset
        call IDE_Detect

        ret

;---------------------------------------------------------
; Software Reset
;---------------------------------------------------------

IDE_Reset

        ld a,IDE_CMD_RESET
        out (IDE_COMMAND),a

        call IDE_WaitNotBusy

        ret

;---------------------------------------------------------
; Detect Drive
;---------------------------------------------------------

IDE_Detect

        ld a,#A0
        out (IDE_HEAD),a

        call IDE_WaitReady

        call IDE_Identify

        ret

;---------------------------------------------------------
; Identify Device
;---------------------------------------------------------

IDE_Identify

        call IDE_WaitNotBusy

        ld a,IDE_CMD_IDENTIFY
        out (IDE_COMMAND),a

        call IDE_WaitDRQ

        ld hl,IDE_Buffer

        ld bc,IDE_DATA

        ld de,256

.ReadWord

        in a,(c)
        ld (hl),a
        inc hl

        in a,(c)
        ld (hl),a
        inc hl

        dec de

        ld a,d
        or e

        jr nz,.ReadWord

        ret

;---------------------------------------------------------
; Read Sector
;
; LBA = DEBC
; HL = Buffer
;---------------------------------------------------------

IDE_ReadSector

        call IDE_SelectMaster

        ld a,1
        out (IDE_SECCNT),a

        ld a,c
        out (IDE_SECTOR),a

        ld a,b
        out (IDE_CYL_LOW),a

        ld a,e
        out (IDE_CYL_HIGH),a

        ld a,#E0
        or d
        out (IDE_HEAD),a

        ld a,IDE_CMD_READ
        out (IDE_COMMAND),a

        call IDE_WaitDRQ

        ld bc,IDE_DATA

        ld de,256

.ReadLoop

        in a,(c)
        ld (hl),a
        inc hl

        in a,(c)
        ld (hl),a
        inc hl

        dec de

        ld a,d
        or e

        jr nz,.ReadLoop

        ret

;---------------------------------------------------------
; Write Sector
;---------------------------------------------------------

IDE_WriteSector

        call IDE_SelectMaster

        ld a,1
        out (IDE_SECCNT),a

        ld a,c
        out (IDE_SECTOR),a

        ld a,b
        out (IDE_CYL_LOW),a

        ld a,e
        out (IDE_CYL_HIGH),a

        ld a,#E0
        or d
        out (IDE_HEAD),a

        ld a,IDE_CMD_WRITE
        out (IDE_COMMAND),a

        call IDE_WaitDRQ

        ld bc,IDE_DATA

        ld de,256

.WriteLoop

        ld a,(hl)
        out (c),a
        inc hl

        ld a,(hl)
        out (c),a
        inc hl

        dec de

        ld a,d
        or e

        jr nz,.WriteLoop

        ret

;---------------------------------------------------------
; Select Master
;---------------------------------------------------------

IDE_SelectMaster

        ld a,#E0
        out (IDE_HEAD),a

        ret

;---------------------------------------------------------
; Wait BSY=0
;---------------------------------------------------------

IDE_WaitNotBusy

        ld b,255

.Wait

        in a,(IDE_STATUS)

        and IDE_BSY

        ret z

        djnz .Wait

        ld a,1
        ld (IDE_LastError),a

        ret

;---------------------------------------------------------
; Wait DRDY
;---------------------------------------------------------

IDE_WaitReady

        ld b,255

.Wait

        in a,(IDE_STATUS)

        and IDE_DRDY

        jr nz,.Ready

        djnz .Wait

        ld a,2
        ld (IDE_LastError),a

.Ready

        ret

;---------------------------------------------------------
; Wait DRQ
;---------------------------------------------------------

IDE_WaitDRQ

        ld b,255

.Wait

        in a,(IDE_STATUS)

        and IDE_DRQ

        jr nz,.OK

        djnz .Wait

        ld a,3
        ld (IDE_LastError),a

.OK

        ret

;---------------------------------------------------------
; Flush
;---------------------------------------------------------

IDE_Flush

        ret

;---------------------------------------------------------
; Buffer
;---------------------------------------------------------

IDE_Buffer

        defs 512