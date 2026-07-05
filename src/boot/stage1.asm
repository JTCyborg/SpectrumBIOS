;=========================================================
;
; SBIOS
; Stage 1 Boot Loader
;
; HDD -> MBR -> Stage2
;
;=========================================================

STAGE2_LOAD_ADDR      EQU #8000

;---------------------------------------------------------
; Entry
;---------------------------------------------------------

Stage1_Start

        call IDE_Init
        jr c,.ide_error

        call Stage1_ReadMBR
        jr c,.disk_error

        call Stage1_ParseMBR
        jr c,.mbr_error

        call Stage1_LoadStage2
        jr c,.load_error

        jp STAGE2_LOAD_ADDR

.ide_error

        ld hl,TxtIDEError
        call BIOS_PrintString
        ret

.disk_error

        ld hl,TxtDiskError
        call BIOS_PrintString
        ret

.mbr_error

        ld hl,TxtMBRError
        call BIOS_PrintString
        ret

.load_error

        ld hl,TxtStage2Error
        call BIOS_PrintString
        ret

;---------------------------------------------------------
; Read MBR (LBA0)
;---------------------------------------------------------

Stage1_ReadMBR

        ld hl,MBR_Buffer

        ld bc,0
        ld de,0

        call IDE_ReadSector

        ret

;---------------------------------------------------------
; Parse MBR
;---------------------------------------------------------

Stage1_ParseMBR

        ld hl,MBR_Buffer+#1BE

        ld b,4

.next

        bit 7,(hl)
        jr nz,.active

        ld de,16
        add hl,de

        djnz .next

        scf
        ret

.active

        inc hl
        inc hl
        inc hl
        inc hl

        ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl

        ld c,(hl)
        inc hl

        ld b,(hl)

        ld (Stage2_LBA),bc
        ld (Stage2_LBA+2),de

        or a
        ret

;---------------------------------------------------------
; Load Stage2
;---------------------------------------------------------

Stage1_LoadStage2

        ld hl,STAGE2_LOAD_ADDR

        ld bc,(Stage2_LBA)
        ld de,(Stage2_LBA+2)

        call IDE_ReadSector

        ret

;---------------------------------------------------------
; Variables
;---------------------------------------------------------

Stage2_LBA

        dd 0

;---------------------------------------------------------
; Buffers
;---------------------------------------------------------

MBR_Buffer

        defs 512

;---------------------------------------------------------
; Messages
;---------------------------------------------------------

TxtIDEError

db 13,10
db "IDE initialization failed",13,10,0

TxtDiskError

db 13,10
db "Disk read error",13,10,0

TxtMBRError

db 13,10
db "No active partition",13,10,0

TxtStage2Error

db 13,10
db "Stage2 loading failed",13,10,0