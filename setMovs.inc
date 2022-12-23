;Author: Mohammed Taher
;Setting avaliable moves of pieces (Rook, Bioshop, Queen) 
;(1) need testing
;(2) TODO: if piece of same color then last patch was last availMove
;------------------------------------------------

callDrawSquare macro cellNumber
pusha

    mov ax, cellNumber
    mov ah,0
    mov bl,8
    idiv bl
    mov bx,ax
    drawSquareOnCell 04h,bl,bh

popa
endm callDrawSquare



;****************************************************************************************************************************
;****************************************************************************************************************************
;**************************************************   Rook Moves    *********************************************************
;****************************************************************************************************************************
;****************************************************************************************************************************

rookMoves MACRO  row, column
    LOCAL checkRight, lastRight,preLeft, checkLeft,lastLeft,preTop,checkTop,lastTop,preBottom,checkBottom,lastBottom,rt
pusha

;------------------------- TESTING
drawSquareOnCell 03h,row,column
; callDrawSquare bx
; --------------------------

; intialize indexes

    mov bl,column
    mov bh,0
    mov si,bx ;store column number in si
    mov bl,row ;store row number in bl

;******************************************
;***************** Right Cells ************
;******************************************

    inc si
checkRight: ;right columns
        cmp si,08h
        jz preLeft
            mov cl,8
            mov al,row
            imul cl 
            mov bx,ax ;bx = bl(row number)*8
            add bx,si ;bx = bl(row number)*8 +si(column number)
; -------------------------- TESTING (delete)
; drawSquareOnCell 04h,row,column
; callDrawSquare bx
; --------------------------

        mov al,grid[bx]
        cmp al,00
        jnz lastRight
        mov availMoves[bx],0ffh
        callDrawSquare bx
        inc si ;go to right boxes
        jmp checkRight
        lastRight:
        ; ; Disable friendly fire... "NOT WORKING"
        ;     ;check same team?
        ;     ;get away piece code
        ;         mov dl,grid[bx] 
        ;         push bx 
        ;     ;get attacker piece code
        ;     ;reset bx
        ;         mov bl,column
        ;         mov bh,0
        ;         mov si,bx ;store column number in si
        ;         mov bl,row ;store row number in bl
        ;         mov cl,8
        ;         mov al,row
        ;         imul cl 
        ;         mov bx,ax ;bx = bl(row number)*8
        ;         add bx,si ;bx = bl(row number)*8 +si(column number)
        ;         mov dh,grid[bx]
        ;         pop bx
        ;     ;is same Color? "dl:away piece / dh:home piece" ;NOTES: dh is correct,dl is correct
        ;         ; ERORR FROM HERE
        ;         ; and dh,10d
        ;         ; cmp dh,00
        ;         ; ERORR TO HERE
        ;         ; jz preLeft
        ; ; Friendly fire is disabled
        mov availMoves[bx],0ffh
        callDrawSquare bx



preLeft:
;reset indexes
    mov bl,column
    mov bh,0
    mov si,bx ;store column number in si
    mov bl,row ;store row number in bl

;****************************************
;***************** left Cells ***********
;****************************************

    dec si
checkLeft: ;right columns
        cmp si,0ffffh
        jz preTop
            mov cl,8
            mov al,row
            imul cl 
            mov bx,ax ;bx = bl(row number)*8
            add bx,si ;bx = bl(row number)*8 +si(column number)
; -------------------------- TESTING (delete)
; drawSquareOnCell 04h,row,column
callDrawSquare bx
; --------------------------
        mov al,grid[bx]
        cmp al,00
        jnz lastLeft
        mov availMoves[bx],0ffh
        callDrawSquare bx
        dec si ;go to right boxes
        jmp checkLeft
        lastLeft:
        mov availMoves[bx],0ffh
        callDrawSquare bx

preTop:
;reset indexes
    mov bl,column
    mov bh,0
    mov si,bx
    mov bl,row

;*************************************
;***************** Top Cells *********
;*************************************

    dec bx
    checkTop:
         cmp bx,0ffffh
        jz preBottom
        mov cl,8
        mov al,bl
        imul cl
        push bx
        mov bx,ax
        add bx,si
        mov al,grid[bx]
        cmp al,00
        jnz lastTop
        mov availMoves[bx],0ffh
        callDrawSquare bx
        pop bx

        dec bx ;go to top boxes
        jmp checkTop
        lastTop:
        mov availMoves[bx],0ffh
        callDrawSquare bx

preBottom:
; reset indexes
    mov bl,column
    mov bh,0
    mov si,bx
    mov bl,row

;*************************************
;***************** Bottom Cells *********
;*************************************

    inc bx
    checkBottom:
        cmp bx,08h
        jz rt
        mov cl,8
        mov al,bl
        imul cl
        push bx
        mov bx,ax
        add bx,si
        mov al,grid[bx]
        cmp al,00
        jnz lastBottom
        mov availMoves[bx],0ffh
        callDrawSquare bx
        pop bx

        inc bx ;go to top boxes
        jmp checkBottom
        lastBottom:
        mov availMoves[bx],0ffh
        callDrawSquare bx


    rt:

popa
ENDM rookMoves


;****************************************************************************************************************************
;****************************************************************************************************************************
;**************************************************   Bishop Moves    *******************************************************
;****************************************************************************************************************************
;****************************************************************************************************************************

bishopMoves MACRO row, column
    local checkBR,lastBR,checkTL,lastTL,checkTR,lastTR,checkBL,lastBL,precheckTL,precheckTR,precheckBL,rt

PUSHA

; ------------------------- TESTING
drawSquareOnCell 03h,row,column
; callDrawSquare bx
; --------------------------
    
; intialize indexes
    mov bl,column
    mov bh,0
    mov si,bx
    mov bl,row
    
;**********************************************
;***************** 4 o'clock Cells ************
;**********************************************

    inc bx
    inc si
    checkBR: ;bottom right
        cmp bx,08h
        jz precheckTL
        cmp si,08h
        jz precheckTL
        mov cl,8
        mov al,bl
        imul cl
        push bx
        mov bx,ax
        add bx,si
        mov al,grid[bx]
        cmp al,00
        jnz lastBR
        mov availMoves[bx],0ffh
        callDrawSquare bx
        pop bx
        inc bx
        inc si
        jmp checkBR
        lastBR:
        callDrawSquare bx
        mov availMoves[bx],0ffh


precheckTL:
    ;reset indexes
    mov bl,column
    mov bh,0
    mov si,bx
    mov bl,row


;***********************************************
;***************** 10 o'clock Cells ************
;***********************************************

    dec bx
    dec si
    checkTL: ;top left
        cmp bx,0ffffh
        jz precheckTR
        cmp si,0ffffh
        jz precheckTR
        mov cl,8
        mov al,bl
        imul cl
        push bx
        mov bx,ax
        add bx,si
        mov al,grid[bx]
        cmp al,00
        jnz lastTL
        mov availMoves[bx],0ffh
        callDrawSquare bx
        pop bx
        dec bx
        dec si
        jmp checkTL
        lastTL:
        mov availMoves[bx],0ffh
        callDrawSquare bx


precheckTR:
    ;reset indexes
    mov bl,column
    mov bh,0
    mov si,bx
    mov bl,row

;**********************************************
;***************** 2 o'clock Cells ************
;**********************************************

    dec bx
    inc si
    checkTR: ;top right
        cmp bx,0ffffh
        jz precheckBL
        cmp si,08h
        jz precheckBL
        mov cl,8
        mov al,bl
        imul cl
        push bx
        mov bx,ax
        add bx,si
        mov al,grid[bx]
        cmp al,00
        jnz lastTR
        mov availMoves[bx],0ffh
        callDrawSquare bx
        pop bx
        dec bx
        inc si
        jmp checkTR
        lastTR:
        mov availMoves[bx],0ffh
        callDrawSquare bx

precheckBL:
    ;reset indexes
    mov bl,column
    mov bh,0
    mov si,bx
    mov bl,row

;**********************************************
;***************** 8 o'clock Cells ************
;**********************************************

    inc bx
    dec si
    checkBL: ;bottom left
        cmp bx,08h
        jz rt
        cmp si,0ffffh
        jz rt
        mov cl,8
        mov al,bl
        imul cl
        push bx
        mov bx,ax
        add bx,si
        mov al,grid[bx]
        cmp al,00
        jnz lastBL
        mov availMoves[bx],0ffh
        callDrawSquare bx
        pop bx
        inc bx
        dec si
        jmp checkBL
        lastBL:
        mov availMoves[bx],0ffh
        callDrawSquare bx

    rt:                
popa 
ENDM bishopMoves


;****************************************************************************************************************************
;****************************************************************************************************************************
;**************************************************   Queen Moves    ********************************************************
;****************************************************************************************************************************
;****************************************************************************************************************************

queenMoves MACRO row, column
        ; pusha ;no need to it as you push in rook and bishop and queen doesn't change rigisters (for optimization)
    
        bishopMoves row,column
        rookMoves row,column
        ; popa
ENDM queenMoves

;------------------------------------------------
