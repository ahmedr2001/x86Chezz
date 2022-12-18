;Author: Mohammed Taher
;Setting avaliable moves of pieces (Rook, Bioshop, Queen) 
;(1) need testing
;(2) TODO: if piece of same color then last patch was last availMove
;------------------------------------------------

rookMoves MACRO availMoves ,grid, row, column
    LOCAL checkRight, lastRight, checkLeft,lastLeft,checkTop,lastTop,checkDown,lastDown,leave

; intialize indexes
    mov bx,row
    mov si,column

    inc si
checkRight: ;right columns
        cmp si,08h
        jz checkLeft
        mov al,grid[bx][si]
        cmp al,00
        jnz lastRight
        mov availMoves[bx][si],0ffh
        inc si ;go to right boxes
        jmp checkRight
        lastRight:
        mov availMoves[bx][si],0ffh

;reset indexes
    mov bx,row
    mov si,column

    dec si
    checkLeft: ;left columns
        cmp si,0ffh
        jz checkTop
        mov al,grid[bx][si]
        cmp al,00
        jnz lastLeft
        mov availMoves[bx][si],0ffh
        dec si ;go to left boxes
        jmp checkLeft
        lastLeft:
        mov availMoves[bx][si],0ffh

;reset indexes
    mov bx,row
    mov si,column

    inc bx
    checkTop:
        cmp bx,08h
        jz checkBottom
        mov al,grid[bx][si]
        cmp al,00
        jnz lastTop
        mov availMoves[bx][si],0ffh
        inc bx ;go to top boxes
        jmp checkTop
        lastTop:
        mov availMoves[bx][si],0ffh

;reset indexes
    mov bx,row
    mov si,column

    dec bx
    checkBottom:
        cmp bx,0ffh
        jz leave
        mov al,grid[bx][si]
        cmp al,00
        jnz lastBottom
        mov availMoves[bx][si],0ffh
        dec bx ;go to bottom boxes
        jmp checkBottom
        lastBottom:
        mov availMoves[bx][si],0ffh

    leave:

ENDM rookMoves

;-----------------------------------------------

bishopMoves MACRO availMoves ,grid, row, column
    local checkBR,lastBR,checkTL,lastTL,checkTR,lastTR,checkBL,lastBL
    
; intialize indexes
    mov bx,row
    mov si,column
    
    inc bx
    inc si
    checkBR: ;bottom right
        cmp bx,08h
        jz checkTL
        cmp si,08h
        jz checkTL
        mov al,grid[bx][si]
        cmp al,00
        jnz,lastBR
        mov availMoves[bx][si],0ffh
        inc bx
        inc si
        jmp checkBR
        lastBR:
        mov availMoves[bx][si],0ffh

;reset indexes
    mov bx,row
    mov si,column

    dec bx
    dec si
    checkTL: ;top left
        cmp bx,0ffh
        jz checkTR
        cmp si,0ffh
        jz checkTR
        mov ax,grid[bx][si]
        cmp ax,00
        jnz,lastTL
        mov availMoves[bx][si],0ffh
        dec bx
        dec si
        jmp checkTL
        lastTL:
        mov availMoves[bx][si],0ffh

;reset indexes
    mov bx,row
    mov si,column

    dec bx
    inc si
    checkTR: ;top right
        cmp bx,0ffh
        jz checkBL
        cmp si,08h
        jz checkBL
        mov ax,grid[bx][si]
        cmp ax,00
        jnz,lastTR
        mov availMoves[bx][si],0ffh
        dec bx
        inc si
        jmp checkTR
        lastTR:
        mov availMoves[bx][si],0ffh

;reset indexes
    mov bx,row
    mov si,column

    inc bx
    dec si
    checkBL: ;bottom left
        cmp bx,08h
        jz leave
        cmp si,0ffh
        jz leave
        mov ax,grid[bx][si]
        cmp ax,00
        jnz,lastBL
        mov availMoves[bx][si],0ffh
        inc bx
        dec si
        jmp checkBL
        lastBL:
        mov availMoves[bx][si],0ffh

    leave:                
    
ENDM bishopMoves

;------------------------------------------------

queenMoves MACRO availMoves ,grid, row, column
    
        rookMoves availMoves,grid,row,column
        bishopMoves availMoves,grid,row,column

ENDM queenMoves

;------------------------------------------------
