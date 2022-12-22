;Author: Mohammed Taher
;Setting avaliable moves of pieces (Rook, Bioshop, Queen) 
;(1) need testing
;(2) TODO: if piece of same color then last patch was last availMove
;------------------------------------------------

callDrawSquare macro cellNumber

; mov ax,cellNumber

; mov ah,0ah
; add al,'0'
; int 10h

mov ax, cellNumber
mov cl,8
idiv cl

drawSquareOnCell 04h,ah,al

endm callDrawSquare


rookMoves MACRO availMoves ,grid, row, column
    LOCAL checkRight, lastRight, checkLeft,lastLeft,checkTop,lastTop,checkBottom,lastBottom,leave


;------------------------- TESTING
drawSquareOnCell 03h,row,column
; callDrawSquare bx
; --------------------------

; intialize indexes

    mov bl,column
    mov bh,0
    mov si,bx ;store column number in si
    mov bl,row ;store row number in bl


    inc si
checkRight: ;right columns
        cmp si,08h
        jz checkLeft
            mov cl,8
            mov al,bl
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
        mov availMoves[bx],0ffh
        callDrawSquare bx

;reset indexes
mov bl,column
mov bh,0
mov si,bx
    mov bl,row

    dec si
    checkLeft: ;left columns
;         cmp si,0ffh
;         jz checkTop
;         mov cl,8
; mov al,bl
; imul cl
; mov bx,ax
; add bx,si
;         mov al,grid[bx]
;         cmp al,00
;         jnz lastLeft
;         mov availMoves[bx],0ffh
;         callDrawSquare bx

;         dec si ;go to left boxes
;         jmp checkLeft
;         lastLeft:
;         mov availMoves[bx],0ffh
;         callDrawSquare bx


; ;reset indexes
; mov bl,column
; mov bh,0
; mov si,bx
;     mov bl,row

;     inc bx
;     checkTop:
;         cmp bx,08h
;         jz checkBottom
;         mov cl,8
; mov al,bl
; imul cl
; mov bx,ax
; add bx,si
;         mov al,grid[bx]
;         cmp al,00
;         jnz lastTop
;         mov availMoves[bx],0ffh
;         callDrawSquare bx

;         inc bx ;go to top boxes
;         jmp checkTop
;         lastTop:
;         mov availMoves[bx],0ffh
;         callDrawSquare bx


; ;reset indexes
; mov bl,column
; mov bh,0
; mov si,bx
;     mov bl,row

;     dec bx
;     checkBottom:
;         cmp bx,0ffh
;         jz leave
;         mov cl,8
; mov al,bl
; imul cl
; mov bx,ax
; add bx,si
;         mov al,grid[bx]
;         cmp al,00
;         jnz lastBottom
;         mov availMoves[bx],0ffh
;         callDrawSquare bx

;         dec bx ;go to bottom boxes
;         jmp checkBottom
;         lastBottom:
;         mov availMoves[bx],0ffh
;         callDrawSquare bx


;     leave:

ENDM rookMoves

;-----------------------------------------------

bishopMoves MACRO availMoves ,grid, row, column
    local checkBR,lastBR,checkTL,lastTL,checkTR,lastTR,checkBL,lastBL
    
; intialize indexes
mov bl,column
mov bh,0
mov si,bx
    mov bl,row
    
    inc bx
    inc si
    checkBR: ;bottom right
        cmp bx,08h
        jz checkTL
        cmp si,08h
        jz checkTL
        mov cl,8
    mov al,bl
    imul cl
mov bx,ax
add bx,si
        mov al,grid[bx]
        cmp al,00
        jnz,lastBR
        mov availMoves[bx],0ffh
        inc bx
        inc si
        jmp checkBR
        lastBR:
        mov availMoves[bx],0ffh

;reset indexes
mov bl,column
mov bh,0
mov si,bx
    mov bl,row

    dec bx
    dec si
    checkTL: ;top left
        cmp bx,0ffh
        jz checkTR
        cmp si,0ffh
        jz checkTR
        mov ax,grid[bx]
        cmp ax,00
        jnz,lastTL
        mov availMoves[bx],0ffh
        dec bx
        dec si
        jmp checkTL
        lastTL:
        mov availMoves[bx],0ffh

;reset indexes
mov bl,column
mov bh,0
mov si,bx
    mov bl,row

    dec bx
    inc si
    checkTR: ;top right
        cmp bx,0ffh
        jz checkBL
        cmp si,08h
        jz checkBL
        mov ax,grid[bx]
        cmp ax,00
        jnz,lastTR
        mov availMoves[bx],0ffh
        dec bx
        inc si
        jmp checkTR
        lastTR:
        mov availMoves[bx],0ffh

;reset indexes
mov bl,column
mov bh,0
mov si,bx
    mov bl,row

    inc bx
    dec si
    checkBL: ;bottom left
        cmp bx,08h
        jz leave
        cmp si,0ffh
        jz leave
        mov ax,grid[bx]
        cmp ax,00
        jnz,lastBL
        mov availMoves[bx],0ffh
        inc bx
        dec si
        jmp checkBL
        lastBL:
        mov availMoves[bx],0ffh

    leave:                
    
ENDM bishopMoves

;------------------------------------------------

queenMoves MACRO availMoves ,grid, row, column
    
        rookMoves availMoves,grid,row,column
        bishopMoves availMoves,grid,row,column

ENDM queenMoves

;------------------------------------------------
