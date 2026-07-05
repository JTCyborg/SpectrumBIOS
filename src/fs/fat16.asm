;=========================================================
;
; SBIOS
; FAT16 Driver
;
;=========================================================

;---------------------------------------------------------
; Constants
;---------------------------------------------------------

BPB_BYTES_PER_SECTOR     EQU 11
BPB_SECTORS_PER_CLUSTER  EQU 13
BPB_RESERVED_SECTORS     EQU 14
BPB_NUM_FATS             EQU 16
BPB_ROOT_ENTRIES         EQU 17
BPB_SECTORS_PER_FAT      EQU 22

;---------------------------------------------------------
; Variables
;---------------------------------------------------------

FAT16_BytesPerSector

        dw 512

FAT16_SectorsPerCluster

        db 1

FAT16_ReservedSectors

        dw 1

FAT16_NumberOfFATs

        db 2

FAT16_RootEntries

        dw 512

FAT16_SectorsPerFAT

        dw 0

FAT16_FAT_LBA

        dw 0

FAT16_ROOT_LBA

        dw 0

FAT16_DATA_LBA

        dw 0

;---------------------------------------------------------
; Init
;---------------------------------------------------------

FAT16_Init

        ld hl,FAT_Buffer

        ld bc,0
        ld de,0

        call IDE_ReadSector

        call FAT16_ParseBPB

        ret

;---------------------------------------------------------
; Parse BPB
;---------------------------------------------------------

FAT16_ParseBPB

        ld hl,FAT_Buffer

        ld de,FAT16_BytesPerSector

        ld bc,2

        ldir

        ld a,(FAT_Buffer+BPB_SECTORS_PER_CLUSTER)
        ld (FAT16_SectorsPerCluster),a

        ld hl,(FAT_Buffer+BPB_RESERVED_SECTORS)
        ld (FAT16_ReservedSectors),hl

        ld a,(FAT_Buffer+BPB_NUM_FATS)
        ld (FAT16_NumberOfFATs),a

        ld hl,(FAT_Buffer+BPB_ROOT_ENTRIES)
        ld (FAT16_RootEntries),hl

        ld hl,(FAT_Buffer+BPB_SECTORS_PER_FAT)
        ld (FAT16_SectorsPerFAT),hl

        call FAT16_CalcLayout

        ret

;---------------------------------------------------------
; Calculate layout
;---------------------------------------------------------

FAT16_CalcLayout

        ld hl,(FAT16_ReservedSectors)
        ld (FAT16_FAT_LBA),hl

        ld a,(FAT16_NumberOfFATs)

        ld hl,(FAT16_SectorsPerFAT)

.loop

        or a
        jr z,.done

        add hl,hl

        dec a
        jr .loop

.done

        ld de,(FAT16_FAT_LBA)

        add hl,de

        ld (FAT16_ROOT_LBA),hl

        ld de,32

        ld hl,(FAT16_RootEntries)

        srl h
        rr l

        srl h
        rr l

        srl h
        rr l

        srl h
        rr l

        add hl,(FAT16_ROOT_LBA)

        ld (FAT16_DATA_LBA),hl

        ret

;---------------------------------------------------------
; Open
;---------------------------------------------------------

FAT16_Open

        call FAT16_Find

        ret

;---------------------------------------------------------

FAT16_Close

        ret

;---------------------------------------------------------

FAT16_Read

        ret

;---------------------------------------------------------

FAT16_Write

        ret

;---------------------------------------------------------

FAT16_Seek

        ret

;---------------------------------------------------------
; Find File
;---------------------------------------------------------

FAT16_Find

        ld hl,RootDirectory

        ret

;---------------------------------------------------------
; Load File
;---------------------------------------------------------

FAT16_LoadFile

        call FAT16_Open

        call FAT16_Read

        ret

;---------------------------------------------------------
; Read Cluster
;---------------------------------------------------------

FAT16_ReadCluster

        ret

;---------------------------------------------------------
; Next Cluster
;---------------------------------------------------------

FAT16_NextCluster

        ret

;---------------------------------------------------------
; Root Directory
;---------------------------------------------------------

RootDirectory

        defs 16384

;---------------------------------------------------------
; FAT Buffer
;---------------------------------------------------------

FAT_Buffer

        defs 512