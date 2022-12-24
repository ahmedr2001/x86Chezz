checkEmptyCell2 MACRO 
local notempty
pusha
mov bl,8
mov al,currRow2
imul bl
add al,currColumn2
mov bx,ax
mov cl,grid[bx]
mov isEmptyCell2,0
cmp cl,0
jnz notempty
mov isEmptyCell2,1
notempty:
popa
ENDM checkEmptyCell2
resetavailmoves2 macro
local lo,freset,skip
push bx
push ax
mov bx,0
lo:
cmp bx,64d
je freset
mov al,availMoves2[bx]
cmp al,00
je skip
mov availMoves2[bx],00
removeHighlightFromCellnumber bx
skip:
inc bx
jmp lo
freset:
pop ax
pop bx
endm resetavailmoves2
callAppropriateMove2 macro
pusha
checkAvailable2
cmp isAvailableCell2,0
je notmoved
mov al,selectedRow2
mov bl,8
imul bl
add al,selectedCol2
mov bx,ax
mov al,grid[bx]
cmp al,1
jne check2
movePiece 1, selectedRow2, selectedCol2,currRow2, currColumn2, grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check2:
cmp al,2
jne check3
movePiece 2, selectedRow2, selectedCol2, currRow2,currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check3:
cmp al,3
jne check4
movePiece 3, selectedRow2, selectedCol2,  currRow2,currColumn2, grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check4:
cmp al,4
jne check5
movePiece 4, selectedRow2, selectedCol2, currRow2,currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check5:
cmp al,5
jne check6
movePiece 5, selectedRow2, selectedCol2,  currRow2,currColumn2, grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check6:
cmp al,6
jne check7
movePiece 6, selectedRow2, selectedCol2, currRow2,currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check7:
cmp al,7
jne check8
movePiece 7, selectedRow2, selectedCol2,currRow2, currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check8:
cmp al,8
jne check9
movePiece 8, selectedRow2, selectedCol2,  currRow2,currColumn2, grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check9:
cmp al,9
jne check10
movePiece 9, selectedRow2, selectedCol2, currRow2,currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check10:
cmp al,10
jne check11
movePiece 10, selectedRow2, selectedCol2, currRow2,currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check11:
cmp al,11
jne check12
movePiece 11, selectedRow2, selectedCol2, currRow2,currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check12:
cmp al,12
jne check13
movePiece 12, selectedRow2, selectedCol2, currRow2,currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check13:
cmp al,13
jne check14
movePiece 13, selectedRow2, selectedCol2,currRow2, currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check14:
cmp al,14
jne check15
movePiece 14, selectedRow2, selectedCol2,currRow2, currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check15:
cmp al,15
jne check16
movePiece 15, selectedRow2, selectedCol2,currRow2, currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
check16:
cmp al,16
jne en
movePiece 16, selectedRow2, selectedCol2,currRow2, currColumn2,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved2,1
jmp en
notmoved:
mov hasmoved2,0
en:
popa
endm callAppropriateMove2
checkSelected2 macro row,column
local skip
pusha
mov isSelectedCell2,0
mov cl,row
cmp cl,selectedRow2
jnz skip
mov cl,selectedCol2
cmp cl,column
jnz skip
mov isSelectedCell2,1
skip:
popa
endm checkSelected2
checkAvailable2 macro
local end
pusha
mov isAvailableCell2,0
mov al,currRow2
mov ah,0
mov bl,8
imul bl
mov bx,ax
add bl,currColumn2
mov al,availMoves2[bx]
cmp al,0ffh
jne end
mov isAvailableCell2,1
end:
popa
endm checkAvailable2
eraseHighlight2 macro 
local removeh,end,checks
pusha
checkAvailable2
cmp isAvailableCell2,0
jz checks
drawSquareOnCell 04h,currRow2,currColumn2
jmp end
checks:
checkSelected2 currRow2,currColumn2
cmp isSelectedCell2,0
jz removeh
drawSquareOnCell 03h,currRow2,currColumn2
jmp end
removeh:
drawSquareOnCell 07h,currRow2,currColumn2
end:
popa
endm eraseHighlight2
navigateAfterSelect2 macro 
LOCAL checkkey,up,down,left,right,consumebuffer,sel,skipnavd,skipnavu,skip,skipErase,skipnavl,skipnavr,escape2,ennav
checkkey:
mov ah,1
int 16h
jnz up
jz checkkey
up:
cmp ah,48h
jnz down
cmp currRow2,0
je skipnavu
eraseHighlight2
dec currRow2
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavu:
jmp consumebuffer
down:
cmp ah,50h
jnz left
cmp currRow2,7
je skipnavd
eraseHighlight2
inc currRow2
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavd:
jmp consumebuffer
left:
cmp ah,4bh
jnz right
cmp currColumn2,0
je skipnavl
eraseHighlight2
dec currColumn2
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavl:
jmp consumebuffer
right:
cmp ah,4dh
jnz sel
cmp currColumn2,7
je skipnavr
eraseHighlight2
inc currColumn2
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavr:
jmp consumebuffer
sel:
cmp al,2fh
jnz escape2
callAppropriateMove2
cmp hasmoved2,0
je noreset
drawSquareOnCell 07h,selectedRow2,selectedCol2
mov selectedRow2,0ffh
mov selectedCol2,0ffh
resetavailmoves2
jmp ennav
noreset:
jmp consumebuffer
escape2:
cmp al,2eh
jnz consumebuffer
drawSquareOnCell 07,selectedRow2,selectedCol2
mov selectedRow2,0ffh
mov selectedCol2,0ffh
;Reset availMoves and Remove Highlights
resetavailmoves2
drawSquareOnCell 0eh,currRow2,currColumn2
jmp ennav
consumebuffer:
mov ah,0
int 16h
jmp checkkey
ennav:
endm navigateAfterSelect2