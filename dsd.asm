;Author:Mohammed Taher
;Defining username screen
;---------------------------
include mymacros.inc
;include setMovs.inc


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
eraseImage MACRO row, column, greyCell, whiteCell
LOCAL eraseGrey, eraseWhite, rt
    mov al, row
    mov ah, column
    add ah, al
    and ah, 1
    JZ eraseWhite
    JNZ eraseGrey

    eraseGrey:
    drawImageOnBoard greyCell, 20, 20, row, column
    jmp rt

    eraseWhite: 
    drawImageOnBoard whiteCell, 20, 20, row, column
    jmp rt

rt:
ENDM eraseImage

;;;;;;;;;;;;;;;;;;;;;;
drawSquareOnCell MACRO color, row, column
LOCAL drawHorizontalLines
LOCAL drawVerticalLines,fhl
pusha
mov al,20
mov bl,row
imul bl
mov dx,ax

mov al,20
mov bl,column
imul bl
add ax,80
mov cx,ax

; MOV CX,80+column*20
; mov dx,row*20

;initialize color and draw pixel command
MOV AH,0ch
mov al,color


mov bx,cx
add bx,19
drawHorizontalLines:
cmp cx,bx
je fhl
int 10h
add dx,19
int 10h
sub dx,19 
inc cx
jmp drawHorizontalLines

fhl:
mov bx,dx
add bx,19
drawVerticalLines:
int 10h 
sub cx,19
int 10h
add cx,19
inc dx
cmp dx,bx
jne drawVerticalLines
popa

ENDM drawSquareOnCell
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;-----------------------------------------------------------------------
; to draw image on board using row and column
drawImageOnBoard MACRO image, imageWidth, imageHeight, row, column
    pusha
    mov ah,0
    mov al, row
    mov bl, 20
    imul bl
    add ax, 80
    mov bx, ax
    mov x, bx
    mov ah,0
    mov al, column
    mov bl, 20
    imul bl
    mov cx, ax
    mov y, cx
    drawImage image, imageWidth, imageHeight, x, y
    popa
ENDM drawImageOnBoard
;----------------------------------------------------------------------

;--------------------------------------------------------------------------
drawEncodingOnBoard MACRO code, row, column
    LOCAL cmp2, cmp3, cmp4, cmp5, cmp6, cmp11, cmp12, cmp13, cmp14, cmp15, cmp16, rt
    pusha

    mov ah, code

    cmp ah, 1
    jnz cmp2
    drawImageOnBoard white_pawn, 20, 20, row, column
    jmp rt

    cmp2:
    cmp ah, 2
    jnz cmp3
    drawImageOnBoard white_rock, 20, 20, row, column
    jmp rt

    cmp3:
    cmp ah, 3
    jnz cmp4
    drawImageOnBoard white_knight, 20, 20, row, column
    jmp rt

    cmp4:
    cmp ah, 4
    jnz cmp5
    drawImageOnBoard white_bishop, 20, 20, row, column
    jmp rt

    cmp5:
    cmp ah, 5
    jnz cmp6
    drawImageOnBoard white_queen, 20, 20, row, column
    jmp rt

    cmp6:
    cmp ah, 6
    jnz cmp11
    drawImageOnBoard white_king, 20, 20, row, column
    jmp rt

    cmp11:
    cmp ah, 11
    jnz cmp12
    drawImageOnBoard black_pawn, 20, 20, row, column
    jmp rt

    cmp12:
    cmp ah, 12
    jnz cmp13
    drawImageOnBoard black_rock, 20, 20, row, column
    jmp rt

    cmp13:
    cmp ah, 13
    jnz cmp14
    drawImageOnBoard black_knight, 20, 20, row, column
    jmp rt

    cmp14:
    cmp ah, 14
    jnz cmp15
    drawImageOnBoard black_bishop, 20, 20, row, column
    jmp rt

    cmp15:
    cmp ah, 15
    jnz cmp16
    drawImageOnBoard black_queen, 20, 20, row, column
    jmp rt

    cmp16:
    cmp ah, 16
    jnz rt
    drawImageOnBoard black_king, 20, 20, row, column
    
    rt:
    popa
ENDM drawEncodingOnBoard  
;----------------------------------------------------------------------------  

drawImage MACRO image, imageWidth, imageHeight, x, y
LOCAL drawLoop
LOCAL nodraw
pusha
        LEA BX , image ; BL contains index at the current drawn pixel
    MOV CX,x
    MOV DX,y
    MOV AH,0ch
	
; Drawing loop
    drawLoop:
        mov ah, 0ch
        MOV AL,[BX]
        cmp AL,0ffh
        je nodraw
        ; cmp AL,0fh
        ; je nodraw
        INT 10h 
        nodraw:
        mov ax, x
        add ax, imageWidth
        INC CX
        INC BX
        CMP CX,ax
    JNE drawLoop 
        mov ax, y
        add ax, imageHeight
        MOV CX , x
        INC DX
        CMP DX , ax
    JNE drawLoop
    popa
ENDM drawImage

usernameScreen MACRO entername, pressEnter
    mov ax,0003h
            int 10h  
    ;cursor on position x = 2 and y = 2         
        mov ah,2
        mov dl,02h
        mov dh,02h
        int 10h  
        
    ;displays the prompt "Please enter your name:"
        mov ah, 9	
        mov dx, offset enterName
        int 21h
        
    ;cursor on position x = 6 and y = 4         
        mov ah,2
        mov dl,06h
        mov dh,04h				
        int 10h

    ;gets a response from the keyboard
    call getName
    
    ;cursor on position x = 2 and y = 20    
        mov ah,2          
        mov dl,02h		
        mov dh,14h      
        int 10h
                    
    ;Display "Press Enter Key to continue"
        mov dx, offset pressEnter
        mov ah, 9h
        int 21h

    ;Wait for enter key
    call waitEnter
endm usernameScreen

checkEmptyCell MACRO 
local notempty
pusha

mov bl,8
mov al,currRow
imul bl
add al,currColumn

mov bx,ax

mov cl,grid[bx]

mov isEmptyCell,0

cmp cl,0
jnz notempty
mov isEmptyCell,1

notempty:
popa

ENDM checkEmptyCell

getAvailForSelectedPiece MACRO
    local rt
    pusha

mov bl,8
mov al,currRow
imul bl
add al,currColumn
mov bx,ax

mov cl,grid[bx]

;test
;  mov ax, 0003h
;      int 10h

; mov ah,0ah
; mov al,cl
; add al,'0'
; int 10h

;check rock
cmp cl,2
jne blackrock
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
call rookMoves 
jmp rt
blackrock:
cmp cl,12
jne whitebishop
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
call rookMoves 
jmp rt
whitebishop:
cmp cl,4
jne blackbishop
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
call bishopMoves 
jmp rt
blackbishop:
cmp cl,14
jne whitequeen
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
call bishopMoves 
jmp rt
whitequeen:
cmp cl,5
jne blackqueen
push ax
mov al,currRow

mov ah,currColumn
mov row,al
mov col,ah
pop ax
call queenMoves 
jmp rt
blackqueen:
cmp cl,15
jne whitepawn
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
call queenMoves 
jmp rt
whitepawn:
cmp cl,1
jne blackpawn
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
 call HighlightAvailableForWPawnToEat 
 call HighlightAvailableForWPawnTwo 
jmp rt
blackpawn:
cmp cl,11
jne king1
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
 call HighlightAvailableForBPawnToEat 
 call HighlightAvailableForBPawnTwo 
jmp rt
; movePiece 1, currRow, currColumn, currRow,currColumn, grid, cooldown, winMessageP1, winMessageP2
king1:
cmp cl,6 
jne king2
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
call HighlightAvailableForWKing 
jmp rt
king2:
cmp cl,16
jne whiteknight
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
call HighlightAvailableForBKing 
jmp rt
whiteknight:
cmp cl,3
jne blackknight
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
 call HighlightAvailableForWKnight 
jmp rt
blackknight:
cmp cl,13
jne rt
push ax
mov al,currRow
mov ah,currColumn
mov row,al
mov col,ah
pop ax
call HighlightAvailableForBKnight 
jmp rt
rt:
;;;;;;;;;;con
popa
ENDM getAvailForSelectedPiece

callAppropriateMove macro
pusha

checkAvailable
cmp isAvailableCell,0
je notmoved


mov al,selectedRow
mov bl,8
imul bl
add al,selectedCol
mov bx,ax
mov al,grid[bx]

cmp al,1
jne check2
movePiece 1, selectedRow, selectedCol,currRow, currColumn, grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check2:
cmp al,2
jne check3
movePiece 2, selectedRow, selectedCol, currRow,currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check3:
cmp al,3
jne check4
movePiece 3, selectedRow, selectedCol,  currRow,currColumn, grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check4:
cmp al,4
jne check5
movePiece 4, selectedRow, selectedCol, currRow,currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check5:
cmp al,5
jne check6
movePiece 5, selectedRow, selectedCol,  currRow,currColumn, grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check6:
cmp al,6
jne check7
movePiece 6, selectedRow, selectedCol, currRow,currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check7:
cmp al,7
jne check8
movePiece 7, selectedRow, selectedCol,currRow, currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check8:
cmp al,8
jne check9
movePiece 8, selectedRow, selectedCol,  currRow,currColumn, grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check9:
cmp al,9
jne check10
movePiece 9, selectedRow, selectedCol, currRow,currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check10:
cmp al,10
jne check11
movePiece 10, selectedRow, selectedCol, currRow,currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check11:
cmp al,11
jne check12
movePiece 11, selectedRow, selectedCol, currRow,currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check12:
cmp al,12
jne check13
movePiece 12, selectedRow, selectedCol, currRow,currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check13:
cmp al,13
jne check14
movePiece 13, selectedRow, selectedCol,currRow, currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check14:
cmp al,14
jne check15
movePiece 14, selectedRow, selectedCol,currRow, currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check15:
cmp al,15
jne check16
movePiece 15, selectedRow, selectedCol,currRow, currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en
check16:
cmp al,16
jne en
movePiece 16, selectedRow, selectedCol,currRow, currColumn,  grid, cooldown, winMessageP1, winMessageP2
mov hasmoved,1
jmp en

notmoved:
mov hasmoved,0

en:
popa
endm callAppropriateMove


checkSelected macro row,column
local skip
pusha
mov isSelectedCell,0

mov cl,row
cmp cl,selectedRow
jnz skip
mov cl,selectedCol
cmp cl,column
jnz skip
mov isSelectedCell,1

skip:
popa
endm checkSelected

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

checkAvailable macro
local end
pusha
mov isAvailableCell,0


mov al,currRow
mov ah,0
mov bl,8
imul bl
mov bx,ax
add bl,currColumn

mov al,availMoves[bx]


cmp al,0ffh
jne end
mov isAvailableCell,1

end:

popa
endm checkAvailable

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

eraseHighlight macro 
local removeh,end,checks
pusha

checkAvailable
cmp isAvailableCell,0
jz checks
drawSquareOnCell 04h,currRow,currColumn
jmp end

checks:

checkSelected currRow,currColumn
cmp isSelectedCell,0
jz removeh
drawSquareOnCell 03h,currRow,currColumn
jmp end

removeh:
drawSquareOnCell 07h,currRow,currColumn

end:
popa
endm eraseHighlight

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


removeHighlightFromCellnumber macro cellNumber
pusha

    mov ax, cellNumber
    mov ah,0
    mov bl,8
    idiv bl
    mov bx,ax
    drawSquareOnCell 07h,bl,bh

popa
endm removeHighlightFromCellnumber

resetavailmoves macro
local lo,freset,skip

push bx
push ax

mov bx,0

lo:
cmp bx,64d
je freset
mov al,availMoves[bx]
cmp al,0
je skip
mov availMoves[bx],00
removeHighlightFromCellnumber bx
skip:
inc bx
jmp lo
freset:

pop ax
pop bx
endm resetavailmoves

initializeGrid macro
push bx

mov grid[0], 12
mov cooldown[0], 0000
mov availMoves[0], 00
mov grid[1], 13
mov cooldown[1], 0000
mov availMoves[1], 00
mov grid[2], 14
mov cooldown[2], 0000
mov availMoves[2], 00
mov grid[3], 15
mov cooldown[3], 0000
mov availMoves[3], 00
mov grid[4], 16
mov cooldown[4], 0000
mov availMoves[4], 00
mov grid[5], 14
mov cooldown[5], 0000
mov availMoves[5], 00
mov grid[6], 13
mov cooldown[6], 0000
mov availMoves[6], 00
mov grid[7], 12
mov cooldown[7], 0000
mov availMoves[7], 00

mov bx,8

inirow2:
mov grid[bx],11
mov cooldown[bx], 0000
mov availMoves[bx], 00
inc bx
cmp bx,16
jne inirow2

inizeros:
mov grid[bx],0
mov cooldown[bx], 0000
mov availMoves[bx], 00
inc bx
cmp bx,48
jne inizeros

inirow7:
mov grid[bx],1
mov cooldown[bx], 0000
mov availMoves[bx], 00
inc bx
cmp bx,56
jne inirow7


mov grid[56],02
mov cooldown[56], 0000
mov availMoves[56], 00
mov grid[57],03
mov cooldown[57], 0000
mov availMoves[57], 00
mov grid[58],04
mov cooldown[58], 0000
mov availMoves[58], 00
mov grid[59],05
mov cooldown[59], 0000
mov availMoves[59], 00
mov grid[60],06
mov cooldown[60], 0000
mov availMoves[60], 00
mov grid[61],04
mov cooldown[61], 0000
mov availMoves[61], 00
mov grid[62],03
mov cooldown[62], 0000
mov availMoves[62], 00
mov grid[63],02
mov cooldown[63], 0000
mov availMoves[63], 00



pop bx
endm initializeGrid

mainScreen MACRO hello, exclamation, name1, messageTemp, mes1, mes2, mes3, keypressed, image1, image1Width, image1Height, ism, boardWidth, boardHeight, greyCell, whiteCell, grid, cooldown, winMessageP1, winMessageP2
    
      
     mov ax, 0003h
     int 10h
     notificationBar hello, exclamation, name1, messageTemp                                              
     ;mov ah,1
;     int 21h        
;     
     
enterms:
     mov ah,5
     mov al,0
     int 10h
            
     ;set cursor position       
     mov ah,2
     mov dh,4  ;row
     mov dl,25
     mov bh,0
     int 10h
     
     ;display string
     mov ah,9
     mov dx,offset mes1
     int 21h    
     
     
     ;set cursor position       
     mov ah,2
     mov dh,6  ;row
     mov dl,25
     mov bh,0
     int 10h

     ;display string     
     mov ah,9
     mov dx,offset mes2
     int 21h  
     
     
     
     
     ;set cursor position       
     mov ah,2
     mov dh,8  ;row
     mov dl,25
     mov bh,0
     int 10h
     ;display string     
     mov ah,9
     mov dx,offset mes3
     int 21h     
             
    notificationBar hello, exclamation, name1, messageTemp
            
     ;checks if kay pressed and check which key       
     checkkey:
     mov ah,1
     int 16h   
     jnz f1
     jz checkkey
    
    
    
     f1: 
     cmp al,31h
     jnz f2
     ;code here for entring chatting mode
     mov keypressed,al

     ;to consume the buffer
     jmp consumebufferms


     f2:
     cmp al,32h
     jnz escape
     ;code here for entring game mode
     MOV AH, 0
    MOV AL, 13h
    INT 10h
	
    ; CALL OpenFile
    ; CALL ReadData
	
    drawImage ism, boardWidth, boardHeight, 160-boardWidth/2, 0
    ; drawImageOnBoard image1, image1Width, image1Height, 4, 4
    ; eraseImage 4, 4, greyCell, whiteCell


;;;;;;;initializing pieces on board
     mov al,0
    ;loop to draw every type of the pieces
     drawpiecess:
     cmp al,6
     je finishpieces

     cmp al,0
     je drawrocks

     cmp al,1
     je drawknights

     cmp al,2
     je drawbishops

     cmp al,3
     je drawkings

     cmp al,4
     je drawqueens

     cmp al,5
     je drawpawns


    drawrocks:
    push ax
    drawImageOnBoard white_rock,20 , 20,7,7
    drawImageOnBoard white_rock,20 , 20,0,7
    drawImageOnBoard black_rock,20 , 20,0,0
    drawImageOnBoard black_rock,20 , 20,7,0
    pop ax
    inc al
    jmp drawpiecess

    drawknights:
    push ax
    drawImageOnBoard white_knight,20 , 20,6,7
    drawImageOnBoard white_knight,20 , 20,1,7
    drawImageOnBoard black_knight,20 , 20,1,0
    drawImageOnBoard black_knight,20 , 20,6,0
    pop ax
    inc al
    jmp drawpiecess


    drawbishops:
    push ax
    drawImageOnBoard white_bishop,20 , 20,5,7
    drawImageOnBoard white_bishop,20 , 20,2,7
    drawImageOnBoard black_bishop,20 , 20,2,0
    drawImageOnBoard black_bishop,20 , 20,5,0
    pop ax
    inc al
    jmp drawpiecess


    drawkings:
    push ax
    drawImageOnBoard white_king,20 , 20,3,7
    drawImageOnBoard black_king,20 , 20,3,0
    pop ax
    inc al
    jmp drawpiecess

    drawqueens:
    push ax
    drawImageOnBoard white_queen,20 , 20,4,7
    drawImageOnBoard black_queen,20 , 20,4,0
    pop ax
    inc al
    jmp drawpiecess

    drawpawns:
    ; mov ah,0
    ; drawwhitepawns:
    ; cmp ah,8
    ; je step2

    ; finishpieces1:

    ; push ax

;;;;;;;;;;;; Can We call the macro with ah or al?;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; when you have answer for this uncomment drawpawn loop code;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; YES WE CAN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!;;;;;;;;;;;;;;;;;;;






    ; drawImageOnBoard white_pawn ,20,20,ah,6
    ; drawImageOnBoard white_pawn ,20,20,ah,6
    ; drawImageOnBoard white_pawn ,20,20,ah,6
    ; drawImageOnBoard white_pawn ,20,20,ah,6
    ; drawImageOnBoard white_pawn ,20,20,ah,6
    ; drawImageOnBoard white_pawn ,20,20,ah,6
    ; drawImageOnBoard white_pawn ,20,20,ah,6
    ; drawImageOnBoard white_pawn ,20,20,ah,6


    drawImageOnBoard white_pawn ,20,20,0,6
    drawImageOnBoard white_pawn ,20,20,1,6
    drawImageOnBoard white_pawn ,20,20,2,6
    drawImageOnBoard white_pawn ,20,20,3,6
    drawImageOnBoard white_pawn ,20,20,4,6
    drawImageOnBoard white_pawn ,20,20,5,6
    drawImageOnBoard white_pawn ,20,20,6,6
    drawImageOnBoard white_pawn ,20,20,7,6

    ; pop ax
    ; inc ah
    ; jmp drawwhitepawns

    ; step2:
    ;  mov ah,0

    ; drawblackpawns:
    ;  cmp ah,8
    ;  je finishpieces
    ;  push ax

    ; drawImageOnBoard black_pawn,20,20,ah,1
    ; drawImageOnBoard black_pawn ,20,20,ah,1
    ; drawImageOnBoard black_pawn ,20,20,ah,1
    ; drawImageOnBoard black_pawn ,20,20,ah,1
    ; drawImageOnBoard black_pawn ,20,20,ah,1
    ; drawImageOnBoard black_pawn ,20,20,ah,1
    ; drawImageOnBoard black_pawn ,20,20,ah,1
    ; drawImageOnBoard black_pawn ,20,20,ah,1


    drawImageOnBoard black_pawn ,20,20,0,1
    drawImageOnBoard black_pawn ,20,20,1,1
    drawImageOnBoard black_pawn ,20,20,2,1
    drawImageOnBoard black_pawn ,20,20,3,1
    drawImageOnBoard black_pawn ,20,20,4,1
    drawImageOnBoard black_pawn ,20,20,5,1
    drawImageOnBoard black_pawn ,20,20,6,1
    drawImageOnBoard black_pawn ,20,20,7,1
    ; pop ax

    ; inc ah
    ; jmp drawblackpawns
    ; 

    
    finishpieces:
    
    initializeGrid

    drawSquareOnCell 0eh,currRow,currColumn

    drawSquareOnCell 0eh,currRow2,currColumn2

;;;;;;;;;;;;;end of initializing pieces on board;;;;;;;;;;;;

; ###################################################

; Testing Moves "TAHER"

; rookMoves 4,4 ;Error
; CORNERS
; rookMoves 0,0 ;Error
; rookMoves 0,7 ;Error
; rookMoves 7,0 ;Works
; rookMoves 7,7 ;Works
; Lines
; rookMoves 0,4 ;Error
; rookMoves 7,4 ;Error -> solved
; rookMoves 4,0 ;Works
; rookMoves 4,7 ;Works

; bishopMoves 4,4
; CORNERS
; bishopMoves 0,0 ;Works
; bishopMoves 0,7 ;Works
; bishopMoves 7,0 ;Works
; bishopMoves 7,7 ;Error -> solved
; Lines
; bishopMoves 0,4 ;Works
; bishopMoves 7,4 ;Works
; bishopMoves 4,0 ;Works
; bishopMoves 4,7 ;Error -> solved

; queenMoves 4,4
; CORNERS
; queenMoves 0,0 ;Works
; queenMoves 0,7 ;Works
; queenMoves 7,0 ;Works
; queenMoves 7,7 ;Error -> solved
; Lines
; queenMoves 0,4 ;Works
; queenMoves 7,4 ;Works
; queenMoves 4,0 ;Works
; queenMoves 4,7 ;Error -> solved

; Inf Loop Bug -> Solved
; push ax
; mov al,4
; mov ah,1
; mov row,al
; mov col,ah
; pop ax
; call queenMoves 

;#####################################################

;;use color 07h to erase highlight

; ;;highlight current cell
; drawSquareOnCell 0eh,currRow,currColumn
; ; movePiece 1, currRow, currColumn, currColumn, currRow, grid, cooldown, winMessageP1, winMessageP2
; ; mov cx, 0fh
; ; mov dx, 4240h
; ; mov ah, 86h
; ; int 15h
; ; mov ah, 86h
; ; int 15h
; ; mov ah, 86h
; ; int 15h
; ; movePiece 1, currColumn, currRow, currRow, currColumn, grid, cooldown, winMessageP1, winMessageP2
; ; HighlightAvailableForKing 5, 4
; ; HighlightAvailableForKnight 1,4
; ; HighlightAvailableForPawnTwo 1,7

;gm
checkkeygm:
mov ah,1
int 16h
jnz w
jz checkkeygm

w:
cmp al,77h
jnz arrowup

;navigate up
cmp currRow,0
je skipnavu

eraseHighlight


; drawSquareOnCell 07h,currRow,currColumn
dec currRow
drawSquareOnCell 0eh,currRow,currColumn
skipnavu:



jmp consumebuffergm

arrowup:
cmp ah,48h
jne s

;navigate up
cmp currRow2,0
je skipnavu2

eraseHighlight2
dec currRow2
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavu2:



jmp consumebuffergm

s:
cmp al,73h
jnz arrowdown

;navigate down


cmp currRow,7
je skipnavd


eraseHighlight

inc currRow
drawSquareOnCell 0eh,currRow,currColumn
skipnavd:
jmp consumebuffergm

arrowdown:
cmp ah,50h
jne a

cmp currRow2,7
je skipnavd2


eraseHighlight2

inc currRow2
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavd2:
jmp consumebuffergm




a:
cmp al,61h
jnz arrowleft 

;navigate laft
cmp currColumn,0
je skipnavl

; drawSquareOnCell 07h,currRow,currColumn

eraseHighlight

dec currColumn
drawSquareOnCell 0eh,currRow,currColumn
skipnavl:

jmp consumebuffergm

arrowleft:
cmp ah,4bh
jne d

cmp currColumn2,0
je skipnavl2

; drawSquareOnCell 07h,currRow,currColumn

eraseHighlight2

dec currColumn2
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavl2:

jmp consumebuffergm

d:
cmp al,64h
jnz arrowright

;navigate right

cmp currColumn,7
je skipnavr

eraseHighlight

inc currColumn
drawSquareOnCell 0eh,currRow,currColumn
skipnavr:

jmp consumebuffergm

arrowright:
cmp ah,4dh
jne preq

cmp currColumn2,7
je skipnavr2

eraseHighlight2

inc currColumn2
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavr2:

jmp consumebuffergm

preq:
cmp checkq,0
je q
jne q2

q:
cmp al,71h
jnz exitgame

;select
checkEmptyCell

cmp isEmptyCell,0
jne preventSelection

mov cl,currColumn
mov selectedCol,cl
mov cl,currRow
mov selectedRow,cl
drawSquareOnCell 03h,currRow,currColumn

getAvailForSelectedPiece

;;;;;check available moves for the piece and draw them

; mov ah,0
; int 16h
; navigateAfterSelect
mov checkq,1


mov keypressed,al

preventSelection:

; mov checkq,1
jmp consumebuffergm

q2:
cmp al,71h
jne esc2
;first remove highlight from selected cell then move the piece at seleted cell to curr cell if available
;and remove the highlight of available moves
;then jump to consumebuffergm
callAppropriateMove

cmp hasmoved,0
je noreset
drawSquareOnCell 07h,selectedRow,selectedCol
mov selectedRow,0ffh
mov selectedCol,0ffh
resetavailmoves

mov checkq,0
noreset:
jmp consumebuffergm


exitgame:
cmp al,1bh
jnz consumebuffergm

;exitgame

mov keypressed,al
;consume buffet then go to main screen

; gameWon:

mov ah,0
int 16h

 mov ax, 0003h
     int 10h

jmp enterms


jmp consumebuffergm

esc2:
cmp al,1bh
jnz consumebuffer


; mov keypressed,al

drawSquareOnCell 07,selectedRow,selectedCol
mov selectedRow,0ffh
mov selectedCol,0ffh


;Reset availMoves and Remove Highlights
resetavailmoves

drawSquareOnCell 0eh,currRow,currColumn
mov checkq,0
jmp consumebuffergm

consumebuffergm:
mov ah,0
int 16h
jmp checkkeygm



    ; Press any key to exit
    ; MOV AH , 0
    ; INT 16h
    
    ; call CloseFile
    
    ;Change to Text MODE
    
     mov keypressed,al

     ;to consume the buffer
     jmp consumebufferms



     escape:
     MOV AH,0          
     push ax
    MOV AL,03h
    INT 10h 
    pop ax
     cmp al,1bh  
     jnz consumebufferms
     ;code here
     mov keypressed,al
     ;
     ;terminate the program
     mov ah, 4ch
     int 21h

    ;to consume the buffer
     jmp consumebufferms   
      
                     
     consumebufferms:
     mov ah,0
     int 16h
     jmp checkkey

endm mainScreen  

;------------------------------------------------------------
movePiece MACRO code, fromRow, fromColumn, toRow, toColumn, grid, cooldown, winMessageP1, winMessageP2
    local noMove, gameWon1, gameWon2
    pusha
    mov ah,00h
    int 1ah
    mov ah, 0
    mov al, fromRow
    mov bl, 8
    imul bl
    add al, fromColumn
    mov bx, ax
    ; lea di, cooldown
    mov ax, cooldown[bx]
    sub dx, ax
    cmp dx, 50
    ; jl noMove

    eraseImage fromColumn, fromRow, greyCell, whiteCell
    ; lea si, grid
    mov al, fromRow
    mov bl, 8
    imul bl
    add al, fromColumn
    mov bx, ax
    mov grid[bx], 0
    eraseImage toColumn, toRow, greyCell, whiteCell
    drawEncodingOnBoard code, toColumn, toRow
    ; lea si, grid
    mov al, toRow
    mov bl, 8
    imul bl
    add al, toColumn
    mov bx, ax
    mov ah, grid[bx]
    cmp ah, 6
    jz gameWon2
    cmp ah, 16
    jz gameWon1
    mov grid[bx], code
    mov ah,00h
    int 1ah
    ; lea di, cooldown
    mov al, toRow
    mov bl, 8
    imul bl
    add al, toColumn
    mov bx, ax
    mov cooldown[bx], dx
    jmp noMove
gameWon1:
    moveCursor 1800h
    mov dx, offset winMessageP1
    mov ah, 09h
    int 21h
    mov cx, 0fh
    mov dx, 4240h
    mov ah, 86h
    int 15h
    mov ah,0
int 16h

 mov ax, 0003h
     int 10h
    jmp enterms
    jmp noMove
gameWon2:
    mov dx, offset winMessageP2
    mov ah, 09
    int 21h
    mov cx, 0fh
    mov dx, 4240h
    mov ah, 86h
    int 15h
    mov ah,0
int 16h

 mov ax, 0003h
     int 10h
    jmp enterms
noMove:
    popa
ENDM movePiece
;-------------------------------------------------------------- 

; include resZahran.inc
.model small
.386
.stack 64
.data

    winMessageP1     db  "Game ended! Player 1 wins!$"
    winMessageP2     db  "Game ended! Player 2 wins!$"

    x                dw  ?
    y                dw  ?

    grid             db  12,13,14,15,16,14,13,12                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;0-7
                     db  11,11,11,11,11,11,11,11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;9-15
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;16-23
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;24-31
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;32-39
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;40-47
                     db  01,01,01,01,01,01,01,01                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;48-55
                     db  02,03,04,05,06,04,03,02                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;56-64
   
    cooldown         dw  0000,0000,0000,0000,0000,0000,0000,0000
                     dw  0000,0000,0000,0000,0000,0000,0000,0000
                     dw  0000,0000,0000,0000,0000,0000,0000,0000
                     dw  0000,0000,0000,0000,0000,0000,0000,0000
                     dw  0000,0000,0000,0000,0000,0000,0000,0000
                     dw  0000,0000,0000,0000,0000,0000,0000,0000
                     dw  0000,0000,0000,0000,0000,0000,0000,0000
                     dw  0000,0000,0000,0000,0000,0000,0000,0000

    availMoves       db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;1
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;2
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;3
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;4
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;5
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;6
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;7
                     db  00,00,00,00,00,00,00,00
                     
    availMoves2      db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;1
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;2
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;3
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;4
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;5
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;6
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;7
                     db  00,00,00,00,00,00,00,00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               ;8



    whiteCell        db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh

                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh

                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh

                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh

                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        
    greyCell         db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        
    ;Size: 20 x 20
    arrow_right      db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,0ffh,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

    ;Size: 20 x 20
    black_bishop     db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0h,0h,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0h,0h,0h,0h,0h,0h,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh
                     db  0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h

    ;Size: 20 x 20
    black_king       db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh

    ;Size: 20 x 20
    black_knight     db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0h,0h,0h,0h,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh

    ;Size: 20 x 20
    black_pawn       db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh

    ;Size: 20 x 20
    black_queen      db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0h,0h,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh

    ;Size: 20 x 20
    black_rock       db  0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0h,0h,0h,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh,0ffh,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0h,0ffh

    ;Size: 20 x 20
    white_bishop     db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,01h,01h,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,01h,01h,01h,01h,01h,01h,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh
                     db  0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h

    ;Size: 20 x 20
    white_king       db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh

    ;Size: 20 x 20
    white_knight     db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,01h,01h,01h,01h,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh

    ;Size: 20 x 20
    white_pawn       db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh

    ;Size: 20 x 20
    white_queen      db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,01h,01h,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh

    ;Size: 20 x 20
    white_rock       db  0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01h,01h,01h,0ffh,0ffh,0ffh
                     db  0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh,0ffh,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,0ffh




    ism              db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,18h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,17h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h
                     db  15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,1bh,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,16h,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,17h,19h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,07h,16h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,16h,19h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                     db  07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,18h,07h,07h,19h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,17h,16h,16h,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,17h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,19h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h
                     db  15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,17h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,1bh,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,17h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,17h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,16h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,16h,17h,15h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh
                     db  07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,18h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,17h,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,17h,16h,16h,16h,16h,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,17h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,18h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h
                     db  15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,17h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,17h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,16h,19h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                     db  07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,17h,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,17h,16h,16h,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                     db  1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,17h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,19h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h
                     db  15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,1bh,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                     db  16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh


    currRow          db  7
    currColumn       db  0
    ;-------------------;
    currRow2         db  0
    currColumn2      db  0

    selectedRow      db  0ffh
    selectedCol      db  0ffh
    ;-------------------;
    selectedRow2     db  0ffh
    selectedCol2     db  0ffh

    isSelectedCell   db  0
    isEmptyCell      db  ?
    isAvailableCell  db  ?
    hasmoved         db  ?
    ;--------------------
    isSelectedCell2  db  0
    isEmptyCell2     db  ?
    isAvailableCell2 db  ?
    hasmoved2        db  ?

    selectedPiece    db  ?
    ;_--------------
    selectedPiece2   db  ?


    checkq           db  0
    ;---------------
    checkq2          db  0




    hello            db  "Hello, $"
    exclamation      db  "!$"
    enterName        db  'Please enter your name:','$'
    pressEnter       db  'Press Enter Key to continue','$'
    name1            db  30,?,30 dup('$')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ;First byte is the size, second byte is the number of characters from the keyboard
    chIn             db  'a'
    keypressed       db  ?
    mes1             db  "To Start Chatting Press 1$"
    mes2             db  "To Start The Game Press 2$"
    mes3             db  "To End The Program Press ESC$"
    messageF1        db  " - You pressed F1$"
    messageF2        db  " - You pressed F2$"
    messageTemp      db  ' - Temporary notification bar for now. Happy Hacking!$'
    boardWidth       equ 160
    boardHeight      equ 160
    row              db  ?
    col              db  ?
    IsmailRow        db  ?
    IsmailCol        db  ?
.code

        
main proc far
                                    mov              ax,@DATA
                                    mov              ds,ax
    ;    mov ah,0
    ;    mov al,13h
    ;    int 10h
              
                                    usernameScreen   enterName, pressEnter
    ;Go to Main screen
    ;TODO: go to main screen

      
                                    mainScreen       hello, exclamation, name1, messageTemp, mes1, mes2, mes3, keypressed, white_bishop, 20, 20, ism, boardWidth, boardHeight, greyCell, whiteCell, grid, cooldown, winMessageP1, winMessageP2

                                    mov              ah,04ch
                                    int              21h
main ENDP

rookMoves proc
                                    pusha
    ; ;------------------------- TESTING
    ;                                 drawSquareOnCell 03h,row,col
    ; ; callDrawSquare bx
    ; ; --------------------------

    ; intialize indexes

                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx                                                                                                                                                                                        ;store col number in si
                                    mov              bl,row                                                                                                                                                                                       ;store row number in bl

    ;******************************************
    ;***************** Right Cells ************
    ;******************************************

                                    inc              si
    checkRight:                                                                                                                                                                                                                                   ;right cols
                                    cmp              si,08h
                                    jz               preLeft
                                    mov              cl,8
                                    mov              al,row
                                    imul             cl
                                    mov              bx,ax                                                                                                                                                                                        ;bx = bl(row number)*8
                                    add              bx,si                                                                                                                                                                                        ;bx = bl(row number)*8 +si(col number)
    ; -------------------------- TESTING (delete)
    ; drawSquareOnCell 04h,row,col
    ; callDrawSquare bx
    ; --------------------------

                                    mov              al,grid[bx]
                                    cmp              al,00
                                    jnz              lastRight
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx
                                    inc              si                                                                                                                                                                                           ;go to right boxes
                                    jmp              checkRight
    lastRight:                      
    ; Disable friendly fire...
    ;check same team?
    ;get away piece code
                                    mov              dl,grid[bx]
                                    push             bx
    ;get attacker piece code
    ;reset bx
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx                                                                                                                                                                                        ;store col number in si
                                    mov              bl,row                                                                                                                                                                                       ;store row number in bl
                                    mov              cl,8
                                    mov              al,row
                                    imul             cl
                                    mov              bx,ax                                                                                                                                                                                        ;bx = bl(row number)*8
                                    add              bx,si                                                                                                                                                                                        ;bx = bl(row number)*8 +si(col number)
                                    mov              dh,grid[bx]
                                    pop              bx
    ;is same Color? "dl:away piece / dh:home piece"
                                    cmp              dh,10
                                    jl               whiteAttackerR                                                                                                                                                                               ;white Attacker
    ;black Attacker
                                    cmp              dl,10
                                    jg               preleft
                                    jmp              eatRight
    ;white Attacker
    whiteAttackerR:                 
                                    cmp              dl,10
                                    jl               preleft
    ; Friendly fire is disabled
    eatRight:                       
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx



    preLeft:                        
    ;reset indexes
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx                                                                                                                                                                                        ;store col number in si
                                    mov              bl,row                                                                                                                                                                                       ;store row number in bl

    ;****************************************
    ;***************** left Cells ***********
    ;****************************************

                                    dec              si
    checkLeft:                                                                                                                                                                                                                                    ;right cols
                                    cmp              si,0ffffh
                                    jz               preTop
                                    mov              cl,8
                                    mov              al,row
                                    imul             cl
                                    mov              bx,ax                                                                                                                                                                                        ;bx = bl(row number)*8
                                    add              bx,si                                                                                                                                                                                        ;bx = bl(row number)*8 +si(col number)
    ; -------------------------- TESTING (delete)
    ; drawSquareOnCell 04h,row,col
    ; callDrawSquare bx
    ; --------------------------
                                    mov              al,grid[bx]
                                    cmp              al,00
                                    jnz              lastLeft
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx
                                    dec              si                                                                                                                                                                                           ;go to right boxes
                                    jmp              checkLeft
    lastLeft:                       
    ; Disable friendly fire...
    ;check same team?
    ;get away piece code
                                    mov              dl,grid[bx]
                                    push             bx
    ;get attacker piece code
    ;reset bx
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx                                                                                                                                                                                        ;store col number in si
                                    mov              bl,row                                                                                                                                                                                       ;store row number in bl
                                    mov              cl,8
                                    mov              al,row
                                    imul             cl
                                    mov              bx,ax                                                                                                                                                                                        ;bx = bl(row number)*8
                                    add              bx,si                                                                                                                                                                                        ;bx = bl(row number)*8 +si(col number)
                                    mov              dh,grid[bx]
                                    pop              bx
    ;is same Color? "dl:away piece / dh:home piece"
                                    cmp              dh,10
                                    jl               whiteAttackerL                                                                                                                                                                               ;white Attacker
    ;black Attacker
                                    cmp              dl,10
                                    jg               preTop
                                    jmp              eatLeft
    ;white Attacker
    whiteAttackerL:                 
                                    cmp              dl,10
                                    jl               preTop
    ; Friendly fire is disabled
    eatLeft:                        
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx

    preTop:                         
    ;reset indexes
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx
                                    mov              bl,row

    ;*************************************
    ;***************** Top Cells *********
    ;*************************************

                                    dec              bx
    checkTop:                       
                                    cmp              bx,0ffffh
                                    jz               preBottom
                                    mov              cl,8
                                    mov              al,bl
                                    imul             cl
                                    push             bx
                                    mov              bx,ax
                                    add              bx,si
                                    mov              al,grid[bx]
                                    cmp              al,00
                                    jnz              lastTop
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx
                                    pop              bx

                                    dec              bx                                                                                                                                                                                           ;go to top boxes
                                    jmp              checkTop
    lastTop:                        
    ; Disable friendly fire...
    ;check same team?
    ;get away piece code
                                    pop              ax

                                    mov              dl,grid[bx]
                                    push             bx
    ;get attacker piece code
    ;reset bx
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx                                                                                                                                                                                        ;store col number in si
                                    mov              bl,row                                                                                                                                                                                       ;store row number in bl
                                    mov              cl,8
                                    mov              al,row
                                    imul             cl
                                    mov              bx,ax                                                                                                                                                                                        ;bx = bl(row number)*8
                                    add              bx,si                                                                                                                                                                                        ;bx = bl(row number)*8 +si(col number)
                                    mov              dh,grid[bx]
                                    pop              bx
    ;is same Color? "dl:away piece / dh:home piece"
                                    cmp              dh,10
                                    jl               whiteAttackerT                                                                                                                                                                               ;white Attacker
    ;black Attacker
                                    cmp              dl,10
                                    jg               preBottom
                                    jmp              eatTop
    ;white Attacker
    whiteAttackerT:                 
                                    cmp              dl,10
                                    jl               preBottom
    ; Friendly fire is disabled
    eatTop:                         
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx

    preBottom:                      
    ; reset indexes
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx
                                    mov              bl,row

    ;*************************************
    ;***************** Bottom Cells *********
    ;*************************************

                                    inc              bx
    checkBottom:                    
                                    cmp              bx,08h
                                    jz               rt91
                                    mov              cl,8
                                    mov              al,bl
                                    imul             cl
                                    push             bx
                                    mov              bx,ax
                                    add              bx,si
                                    mov              al,grid[bx]
                                    cmp              al,00
                                    jnz              lastBottom
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx
                                    pop              bx

                                    inc              bx                                                                                                                                                                                           ;go to top boxes
                                    jmp              checkBottom
    lastBottom:                     
    ; Disable friendly fire...
    ;check same team?
    ;get away piece code
                                    pop              ax
                                    mov              dl,grid[bx]
                                    push             bx
    ;get attacker piece code
    ;reset bx
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx                                                                                                                                                                                        ;store col number in si
                                    mov              bl,row                                                                                                                                                                                       ;store row number in bl
                                    mov              cl,8
                                    mov              al,row
                                    imul             cl
                                    mov              bx,ax                                                                                                                                                                                        ;bx = bl(row number)*8
                                    add              bx,si                                                                                                                                                                                        ;bx = bl(row number)*8 +si(col number)
                                    mov              dh,grid[bx]
                                    pop              bx
    ;is same Color? "dl:away piece / dh:home piece"
                                    cmp              dh,10
                                    jl               whiteAttackerB                                                                                                                                                                               ;white Attacker
    ;black Attacker
                                    cmp              dl,10
                                    jg               rt91
                                    jmp              eatBottom
    ;white Attacker
    whiteAttackerB:                 
                                    cmp              dl,10
                                    jl               rt91
    ; Friendly fire is disabled
    eatBottom:                      
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx


    rt91:                           

                                    popa
                                    ret
                                    ENDp             rookMoves

HighlightAvailableForWKing proc
    ;local  noAboveLeft, noAboveRight, noAbove, noBelowLeft, noBelowRight, noBelow, noRight, noLeft,noEnemyAbove,noEnemyAboveLeft,noEnemyAboveRight,noEnemyBelow,noEnemyBelowLeft,noEnemyBelowRight,noEnemyLeft,noEnemyRight,EmptyAbove,EmptyAboveLeft,EmptyAboveRight,EmptyBelow,EmptyBelowLeft,EmptyBelowRight,EmptyRight,EmptyLeft
    ;highlight 3 above it
                                    pusha
                                    mov              al,row
                                    mov              ah,0
                                    mov              bl,col
                                    mov              bh,0
                                    mov              cl,8
                                    lea              di,grid
                                    lea              si,availMoves
                                    mul              cl
                                    add              di,ax                                                                                                                                                                                        ;on current cell
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx

                                    cmp              row,1
                                    jl               noAbove11
                                    mov              al,row
                                    dec              al
                                    mov              IsmailRow,al
                                    sub              di,8                                                                                                                                                                                         ;above cell
                                    sub              si,8
                                    cmp              byte ptr [di],00h
                                    je               EmptyAbove11
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyAbove11
    EmptyAbove11:                   
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
    noEnemyAbove11:                 
                                    dec              di
                                    dec              si
                                    dec              bl
                                    cmp              col,1
                                    jl               noAboveLeft11
                                    cmp              byte ptr [di],00h
                                    je               EmptyAboveLeft11
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyAboveLeft11
    EmptyAboveLeft11:               
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
    noEnemyAboveLeft11:             
    noAboveLeft11:                  
                                    add              di,2
                                    add              si,2
                                    add              bl,2
                                    cmp              col,6
                                    jg               noAboveRight11
                                    cmp              byte ptr [di],00h
                                    je               EmptyAboveRight11
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyAboveRight11
    EmptyAboveRight11:              
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
    noEnemyAboveRight11:            
    noAboveRight11:                 
                                    dec              bl
                                    add              di,7                                                                                                                                                                                         ;back to current cell
                                    add              si,7
    noAbove11:                      

    ;highlight 3 below it

                                    cmp              row,6
                                    jg               noBelow11
                                    mov              al,row                                                                                                                                                                                       ;and bl => equal now col
                                    add              di,8                                                                                                                                                                                         ;below it
                                    add              si,8                                                                                                                                                                                         ;below it
                                    inc              al                                                                                                                                                                                           ;below it
                                    mov              IsmailRow,al
                                    cmp              byte ptr [di],00h
                                    je               EmptyBelow11
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyBelow11
    EmptyBelow11:                   
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
    noEnemyBelow11:                 
                                    cmp              col,1
                                    jl               noBelowLeft11
                                    dec              di
                                    dec              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyBelowLeft11
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyBelowLeft11
    EmptyBelowLeft11:               
                                    dec              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              bl
    noEnemyBelowLeft11:             
                                    inc              di
                                    inc              si
    noBelowLeft11:                  
                                    cmp              col,6
                                    jg               noBelowRight11
                                    inc              di
                                    inc              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyBelowRight11
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyBelowRight11
    EmptyBelowRight11:              
                                    inc              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    dec              bl
    noEnemyBelowRight11:            
                                    dec              di
                                    dec              si
    noBelowRight11:                 
                                    dec              al                                                                                                                                                                                           ;on cell and bl too
                                    sub              di,8
                                    sub              si,8
    noBelow11:                      

    ;di,si are on cell
                                    mov              al,row                                                                                                                                                                                       ;and bl => equal now col
                                    mov              IsmailRow,al
    ;highlight right
                                    cmp              col,6
                                    jg               noRight11
                                    inc              di
                                    inc              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyRight11
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyRight11
    EmptyRight11:                   
                                    inc              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    dec              bl
                                    mov              byte ptr [si],0ffh
    noEnemyRight11:                 
                                    dec              di                                                                                                                                                                                           ;on cell now
                                    dec              si                                                                                                                                                                                           ;too
    noRight11:                      

    ;highlight left
                                    cmp              col,1
                                    jl               noLeft11
                                    dec              di
                                    dec              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyLeft11
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyLeft11
    EmptyLeft11:                    
                                    dec              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
    noEnemyLeft11:                  
    noLeft11:                       
                                    popa
                                    ret
                                    endp             HighlightAvailableForWKing
    ;==;==
HighlightAvailableForBKing proc
    ;local  noAboveLeft, noAboveRight, noAbove, noBelowLeft, noBelowRight, noBelow, noRight, noLeft,noEnemyAbove,noEnemyAboveLeft,noEnemyAboveRight,noEnemyBelow,noEnemyBelowLeft,noEnemyBelowRight,noEnemyLeft,noEnemyRight,EmptyAbove,EmptyAboveLeft,EmptyAboveRight,EmptyBelow,EmptyBelowLeft,EmptyBelowRight,EmptyRight,EmptyLeft
                                    pusha
    ;highlight 3 above it
                                    mov              al,row
                                    mov              ah,0
                                    mov              bl,col
                                    mov              bh,0
                                    mov              cl,8
                                    lea              di,grid
                                    lea              si,availMoves
                                    mul              cl
                                    add              di,ax                                                                                                                                                                                        ;on current cell
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx

                                    cmp              row,1
                                    jl               noAbove2
                                    mov              al,row
                                    dec              al
                                    mov              IsmailRow,al
                                    sub              di,8                                                                                                                                                                                         ;above cell
                                    sub              si,8
                                    cmp              byte ptr [di],07h
                                    jl               EmptyAbove2
                                    jmp              noEnemyAbove2
    EmptyAbove2:                    
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
    noEnemyAbove2:                  
                                    dec              di
                                    dec              si
                                    dec              bl
                                    cmp              col,1
                                    jl               noAboveLeft2
                                    cmp              byte ptr [di],07h
                                    jl               EmptyAboveLeft2
                                    jmp              noEnemyAboveLeft2
    EmptyAboveLeft2:                
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
    noEnemyAboveLeft2:              
    noAboveLeft2:                   
                                    add              di,2
                                    add              si,2
                                    add              bl,2
                                    cmp              col,6
                                    jg               noAboveRight2
                                    cmp              byte ptr [di],07h
                                    jl               EmptyAboveRight2
                                    jmp              noEnemyAboveRight2
    EmptyAboveRight2:               
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
    noEnemyAboveRight2:             
    noAboveRight2:                  
                                    dec              bl
                                    add              di,7                                                                                                                                                                                         ;back to current cell
                                    add              si,7
    noAbove2:                       

    ;highlight 3 below it

                                    cmp              row,6
                                    jg               noBelow2
                                    mov              al,row                                                                                                                                                                                       ;and bl => equal now col
                                    add              di,8                                                                                                                                                                                         ;below it
                                    add              si,8                                                                                                                                                                                         ;below it
                                    inc              al                                                                                                                                                                                           ;below it
                                    mov              IsmailRow,al
                                    cmp              byte ptr [di],07h
                                    jl               EmptyBelow2
                                    jmp              noEnemyBelow2
    EmptyBelow2:                    
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
    noEnemyBelow2:                  
                                    cmp              col,1
                                    jl               noBelowLeft2
                                    dec              di
                                    dec              si
                                    cmp              byte ptr [di],07h
                                    jl               EmptyBelowLeft2
                                    jmp              noEnemyBelowLeft2
    EmptyBelowLeft2:                
                                    dec              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              bl
    noEnemyBelowLeft2:              
                                    inc              di
                                    inc              si
    noBelowLeft2:                   
                                    cmp              col,6
                                    jg               noBelowRight2
                                    inc              di
                                    inc              si
                                    cmp              byte ptr [di],07h
                                    jl               EmptyBelowRight2
                                    jmp              noEnemyBelowRight2
    EmptyBelowRight2:               
                                    inc              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    dec              bl
    noEnemyBelowRight2:             
                                    dec              di
                                    dec              si
    noBelowRight2:                  
                                    dec              al                                                                                                                                                                                           ;on cell and bl too
                                    sub              di,8
                                    sub              si,8
    noBelow2:                       

    ;di,si are on cell
                                    mov              al,row                                                                                                                                                                                       ;and bl => equal now col
                                    mov              IsmailRow,al
    ;highlight right
                                    cmp              col,6
                                    jg               noRight2
                                    inc              di
                                    inc              si
                                    cmp              byte ptr [di],07h
                                    jl               EmptyRight2
                                    jmp              noEnemyRight2
    EmptyRight2:                    
                                    inc              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    dec              bl
                                    mov              byte ptr [si],0ffh
    noEnemyRight2:                  
                                    dec              di                                                                                                                                                                                           ;on cell now
                                    dec              si                                                                                                                                                                                           ;too
    noRight2:                       

    ;highlight left
                                    cmp              col,1
                                    jl               noLeft2
                                    dec              di
                                    dec              si
                                    cmp              byte ptr [di],07h
                                    jl               EmptyLeft2
                                    jmp              noEnemyLeft2
    EmptyLeft2:                     
                                    dec              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              bl
    noEnemyLeft2:                   
                                    inc              di
                                    inc              si
    noLeft2:                        
                                    popa
                                    ret
                                    endp             HighlightAvailableForBKing

    ;=========================================================
HighlightAvailableForWKnight proc
    ;local noAbove,noBelow,noRight,noLeft,noLeftAbove,noRightAbove,noLeftbelow,noRightbelow,noEnemyAboveLeft,noEnemyAboveRight,noBelowLeft,noEnemyBelowRight,noEnemyDownLeft,noEnemyDownright,noEnemyUpLeft,noEnemyUpright,EmptyAboveLeft,EmptyAboveRight,EmptyBelowLeft,EmptyBelowRight,EmptyDownLeft,EmptyDownRight,EmptyUpLeft,EmptyUpRight,noUpLeft,noDownLeft,noDownRight,noUpRight,noEnemyBelowLeft
                                    pusha
                                    mov              al,row
                                    mov              ah,0
                                    mov              bl,col
                                    mov              bh,0
                                    mov              cl,8
                                    lea              di,grid
                                    lea              si,availMoves

    ;highlight above
                                    cmp              row,2
                                    jl               noAbove1
                                    sub              al,2                                                                                                                                                                                         ;above 2 steps
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx
                                    mov              al,row
                                    sub              al,2
                                    mov              IsmailRow,al
                                    cmp              col,1
                                    jl               noLeftAbove1
                                    dec              di
                                    dec              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyAboveLeft1
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyAboveLeft1
    EmptyAboveLeft1:                
                                    dec              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              bl
    noEnemyAboveLeft1:              
                                    inc              di
                                    inc              si
    noLeftAbove1:                   
                                    cmp              col,6
                                    jg               noRightAbove1
                                    inc              di
                                    inc              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyAboveRight1
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyAboveRight1
    EmptyAboveRight1:               
                                    inc              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    dec              bl
    noEnemyAboveRight1:             
                                    dec              di
                                    dec              si
    noRightAbove1:                  
    noAbove1:                       
    ;highlight below

                                    cmp              row,5
                                    jg               noBelow1
                                    lea              di,grid
                                    lea              si,availMoves
                                    mov              al,row                                                                                                                                                                                       ;on cell and bl too
                                    add              al,2                                                                                                                                                                                         ;below 2 steps
                                    mov              IsmailRow,al
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx
                                    cmp              col,1
                                    jl               noLeftBelow1
                                    dec              di
                                    dec              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyBelowLeft1
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyBelowLeft1
    EmptyBelowLeft1:                
                                    dec              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              bl
    noEnemyBelowLeft1:              
                                    inc              di
                                    inc              si
    noLeftBelow1:                   

                                    cmp              col,6
                                    jg               noRightBelow1
                                    inc              di
                                    inc              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyBelowRight1
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyBelowRight1
    EmptyBelowRight1:               
                                    inc              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    dec              bl
    noEnemyBelowRight1:             
                                    dec              di
                                    dec              si
    noRightBelow1:                  
    noBelow1:                       
    ;highlight right

                                    cmp              col,5
                                    jg               noRight
                                    lea              di,grid
                                    lea              si,availMoves
                                    mov              al,row                                                                                                                                                                                       ;on cell and bl too
                                    add              bl,2                                                                                                                                                                                         ;right 2 steps
                                    mov              IsmailCol,bl
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx
                                    mov              al,row
                                    cmp              row,1
                                    jl               noUpRight1
                                    sub              di,8
                                    sub              si,8
                                    cmp              byte ptr [di],00h
                                    je               EmptyUpRight1
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyUpright1
    EmptyUpRight1:                  
                                    dec              al
                                    mov              IsmailRow,al
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              al
    noEnemyUpright1:                
                                    add              di,8
                                    add              si,8
    noUpRight1:                     
                                    cmp              row,6
                                    jg               noDownRight1
                                    add              di,8
                                    add              si,8
                                    cmp              byte ptr [di],00h
                                    je               EmptyDownRight1
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyDownright1
    EmptyDownRight1:                
                                    inc              al
                                    mov              IsmailRow,al
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    dec              al
    noEnemyDownright1:              
    noDownRight1:                   
                                    sub              bl,2
    noRight1:                       
    ;highlight left

                                    cmp              col,2
                                    jl               noLeft1
                                    lea              di,grid
                                    lea              si,availMoves
                                    mov              al,row                                                                                                                                                                                       ;on cell and bl too
                                    sub              bl,2                                                                                                                                                                                         ;left 2 steps
                                    mov              IsmailCol,bl
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx
                                    mov              al,row
                                    cmp              row,1
                                    jl               noUpLeft1
                                    sub              di,8
                                    sub              si,8
                                    cmp              byte ptr [di],00h
                                    je               EmptyUpLeft1
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyUpLeft1
    EmptyUpLeft1:                   
                                    dec              al
                                    mov              IsmailRow,al
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              al
    noEnemyUpLeft1:                 
                                    add              di,8
                                    add              si,8
    noUpLeft1:                      
                                    cmp              row,6
                                    jg               noDownLeft1
                                    add              di,8
                                    add              si,8
                                    cmp              byte ptr [di],00h
                                    je               EmptyDownLeft1
                                    cmp              byte ptr [di],07h
                                    jl               noEnemyDownLeft1
    EmptyDownLeft1:                 
                                    inc              al
                                    mov              IsmailRow,al
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    dec              al
    noEnemyDownLeft1:               
                                    sub              di,8
                                    sub              si,8
    noDownLeft1:                    
    noLeft1:                        
                                    popa
                                    ret
                                    endp             HighlightAvailableForWKnight
    ;==;==
HighlightAvailableForBKnight proc
    ;local noAbove,noBelow,noRight,noLeft,noLeftAbove,noRightAbove,noLeftbelow,noRightbelow,noEnemyAboveLeft,noEnemyAboveRight,noBelowLeft,noEnemyBelowRight,noEnemyDownLeft,noEnemyDownright,noEnemyUpLeft,noEnemyUpright,EmptyAboveLeft,EmptyAboveRight,EmptyBelowLeft,EmptyBelowRight,EmptyDownLeft,EmptyDownRight,EmptyUpLeft,EmptyUpRight,noUpLeft,noDownLeft,noDownRight,noUpRight,noEnemyBelowLeft
                                    pusha
                                    mov              al,row
                                    mov              ah,0
                                    mov              bl,col
                                    mov              bh,0
                                    mov              cl,8
                                    lea              di,grid
                                    lea              si,availMoves

    ;highlight above
                                    cmp              row,2
                                    jl               noAbove
                                    sub              al,2                                                                                                                                                                                         ;above 2 steps
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx
                                    mov              al,row
                                    sub              al,2
                                    mov              IsmailRow,al
                                    cmp              col,1
                                    jl               noLeftAbove
                                    dec              di
                                    dec              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyAboveLeft
                                    cmp              byte ptr [di],07h
                                    jg               noEnemyAboveLeft
    EmptyAboveLeft:                 
                                    dec              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              bl
    noEnemyAboveLeft:               
                                    inc              di
                                    inc              si
    noLeftAbove:                    
                                    cmp              col,6
                                    jg               noRightAbove
                                    inc              di
                                    inc              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyAboveRight
                                    cmp              byte ptr [di],07h
                                    jg               noEnemyAboveRight
    EmptyAboveRight:                
                                    inc              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    dec              bl
    noEnemyAboveRight:              
                                    dec              di
                                    dec              si
    noRightAbove:                   
    noAbove:                        
    ;highlight below

                                    cmp              row,5
                                    jg               noBelow
                                    lea              di,grid
                                    lea              si,availMoves
                                    mov              al,row                                                                                                                                                                                       ;on cell and bl too
                                    add              al,2                                                                                                                                                                                         ;below 2 steps
                                    mov              IsmailRow,al
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx
                                    cmp              col,1
                                    jl               noLeftBelow
                                    dec              di
                                    dec              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyBelowLeft
                                    cmp              byte ptr [di],07h
                                    jg               noEnemyBelowLeft
    EmptyBelowLeft:                 
                                    dec              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              bl
    noEnemyBelowLeft:               
                                    inc              di
                                    inc              si
    noLeftBelow:                    

                                    cmp              col,6
                                    jg               noRightBelow
                                    inc              di
                                    inc              si
                                    cmp              byte ptr [di],00h
                                    je               EmptyBelowRight
                                    cmp              byte ptr [di],07h
                                    jg               noEnemyBelowRight
    EmptyBelowRight:                
                                    inc              bl
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    dec              bl
    noEnemyBelowRight:              
                                    dec              di
                                    dec              si
    noRightBelow:                   
    noBelow:                        
    ;highlight right

                                    cmp              col,5
                                    jg               noRight
                                    lea              di,grid
                                    lea              si,availMoves
                                    mov              al,row                                                                                                                                                                                       ;on cell and bl too
                                    add              bl,2                                                                                                                                                                                         ;right 2 steps
                                    mov              IsmailCol,bl
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx
                                    mov              al,row
                                    cmp              row,1
                                    jl               noUpRight
                                    sub              di,8
                                    sub              si,8
                                    cmp              byte ptr [di],00h
                                    je               EmptyUpRight
                                    cmp              byte ptr [di],07h
                                    jg               noEnemyUpright
    EmptyUpRight:                   
                                    dec              al
                                    mov              IsmailRow,al
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              al
    noEnemyUpright:                 
                                    add              di,8
                                    add              si,8
    noUpRight:                      
                                    cmp              row,6
                                    jg               noDownRight
                                    add              di,8
                                    add              si,8
                                    cmp              byte ptr [di],00h
                                    je               EmptyDownRight
                                    cmp              byte ptr [di],07h
                                    jg               noEnemyDownright
    EmptyDownRight:                 
                                    inc              al
                                    mov              IsmailRow,al
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    dec              al
    noEnemyDownright:               
    noDownRight:                    
                                    sub              bl,2
    noRight:                        
    ;highlight left

                                    cmp              col,2
                                    jl               noLeft
                                    lea              di,grid
                                    lea              si,availMoves
                                    mov              al,row                                                                                                                                                                                       ;on cell and bl too
                                    sub              bl,2                                                                                                                                                                                         ;left 2 steps
                                    mov              IsmailCol,bl
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx
                                    mov              al,row
                                    cmp              row,1
                                    jl               noUpLeft
                                    sub              di,8
                                    sub              si,8
                                    cmp              byte ptr [di],00h
                                    je               EmptyUpLeft
                                    cmp              byte ptr [di],07h
                                    jg               noEnemyUpLeft
    EmptyUpLeft:                    
                                    dec              al
                                    mov              IsmailRow,al
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    inc              al
    noEnemyUpLeft:                  
                                    add              di,8
                                    add              si,8
    noUpLeft:                       
                                    cmp              row,6
                                    jg               noDownLeft
                                    add              di,8
                                    add              si,8
                                    cmp              byte ptr [di],00h
                                    je               EmptyDownLeft
                                    cmp              byte ptr [di],07h
                                    jg               noEnemyDownLeft
    EmptyDownLeft:                  
                                    inc              al
                                    mov              IsmailRow,al
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh
                                    dec              al
    noEnemyDownLeft:                
                                    sub              di,8
                                    sub              si,8
    noDownLeft:                     
    noLeft:                         
                                    popa
                                    ret
                                    endp             HighlightAvailableForBKnight

    ; ;===============================================================

    ;;for two computers
HighlightAvailableForWPawnTwo proc
    ;local notFirstStepP2, endOfBoardP2, done,canNotMove1,canNotMove2,OK1,OK11,notFirstStepP22,OK2
    ;if first step (one or two)
                                    pusha
                                    mov              al,row
                                    mov              ah,0
                                    mov              bl,col
                                    mov              bh,0
                                    mov              cl,8
                                    lea              si,availMoves
                                    lea              di,grid
                                    cmp              ax,6
                                    JNE              notFirstStepP21
                                    sub              ax,1
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    cmp              byte ptr [di],00h
                                    je               OK121
                                    jmp              canNotMove1
    OK121:                          
                                    mov              al,row
                                    sub              al,1
                                    mov              IsmailRow,al
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mul              cl
                                    add              si,ax
                                    add              si,bx
                                    mov              byte ptr [si],0ffh
    notFirstStepP21:                
                                    mov              al,row
                                    cmp              al,6
                                    JNE              notFirstStepP221
                                    sub              ax,2
                                    sub              di,8
                                    cmp              byte ptr [di],00h
                                    je               OK1121
                                    jmp              canNotMove121
    OK1121:                         
                                    mov              IsmailRow,al
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    sub              si,8
                                    mov              byte ptr [si],0ffh
    canNotMove121:                  
                                    jmp              done121
    notFirstStepP221:               
    ;else
                                    cmp              ax,0
                                    je               endOfBoardP212
                                    sub              ax,1
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    cmp              byte ptr [di],00h
                                    je               OK212
                                    jmp              canNotMove212
    OK212:                          
                                    mov              al,row
                                    dec              al
                                    mov              IsmailRow,al
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mul              cl
                                    add              si,ax
                                    add              si,bx
                                    mov              byte ptr [si],0ffh
    canNotMove212:                  
    endOfBoardP212:                 
    done121:                        
                                    popa
                                    ret
                                    endp             HighlightAvailableForWPawnTwo
    ;===;===
HighlightAvailableForBPawnTwo proc
    ;local notFirstStepP2, endOfBoardP2, done,canNotMove1,canNotMove2,OK1,OK11,notFirstStepP22,OK2
    ;if first step (one or two)
                                    pusha
                                    mov              al,row
                                    mov              ah,0
                                    mov              bl,col
                                    mov              bh,0
                                    mov              cl,8
                                    lea              si,availMoves
                                    lea              di,grid
                                    cmp              ax,1
                                    JNE              notFirstStepP2
                                    add              ax,1
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    cmp              byte ptr [di],00h
                                    je               OK1
                                    jmp              canNotMove1
    OK1:                            
                                    mov              al,row
                                    add              al,1
                                    mov              IsmailRow,al
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mul              cl
                                    add              si,ax
                                    add              si,bx
                                    mov              byte ptr [si],0ffh
    notFirstStepP2:                 
                                    mov              al,row
                                    cmp              al,1
                                    JNE              notFirstStepP22
                                    add              ax,2
                                    add              di,8
                                    cmp              byte ptr [di],00h
                                    je               OK11
                                    jmp              canNotMove1
    OK11:                           
                                    mov              IsmailRow,al
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    add              si,8
                                    mov              byte ptr [si],0ffh
    canNotMove1:                    
                                    jmp              done
    notFirstStepP22:                
    ;else
                                    cmp              ax,7
                                    je               endOfBoardP2
                                    add              ax,1
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    cmp              byte ptr [di],00h
                                    je               OK2
                                    jmp              canNotMove2
    OK2:                            
                                    mov              al,row
                                    inc              al
                                    mov              IsmailRow,al
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mul              cl
                                    add              si,ax
                                    add              si,bx
                                    mov              byte ptr [si],0ffh
    canNotMove2:                    
    endOfBoardP2:                   
    done:                           
                                    popa
                                    ret
                                    endp             HighlightAvailableForBPawnTwo

    ;;;;===============================================================
    ;;need different color
HighlightAvailableForWPawnToEat proc
    ;local DoNotHighlightToEat1,DoNotHighlightToEat2,EndLeft,EndRight
                                    pusha
                                    mov              al,row
                                    mov              ah,0
                                    mov              bl,col
                                    mov              bh,0
                                    mov              cl,8
                                    lea              si,availMoves
                                    lea              di,grid
                                    mul              cl
                                    add              di,ax                                                                                                                                                                                        ;on cell
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx
                                    cmp              col,0
                                    je               EndLeft
                                    sub              di,9
                                    sub              si,9
                                    cmp              byte ptr [di],07h
                                    jl               DoNotHighlightToEat1
                                    mov              al,row
                                    dec              al
                                    dec              bl
                                    mov              IsmailRow,al
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h, IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh                                                                                                                                                                           ;;eat
                                    inc              bl
    DoNotHighlightToEat1:           
                                    add              di,9
                                    add              si,9
    EndLeft:                        
                                    cmp              col,7
                                    je               EndRight
                                    sub              di,7
                                    sub              si,7
                                    cmp              byte ptr [di],07h
                                    jl               DoNotHighlightToEat2
                                    mov              al,row
                                    dec              al
                                    inc              bl
                                    mov              IsmailRow,al
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh                                                                                                                                                                           ;;eat
                                    dec              bl
    DoNotHighlightToEat2:           
    EndRight:                       
                                    popa
                                    ret
                                    endp             HighlightAvailableForWPawnToEat

HighlightAvailableForBPawnToEat proc
    ;local DoNotHighlightToEat1,DoNotHighlightToEat2,EndLeft,EndRight
                                    pusha
                                    mov              al,row
                                    mov              ah,0
                                    mov              bl,col
                                    mov              bh,0
                                    mov              cl,8
                                    lea              si,availMoves
                                    lea              di,grid
                                    mul              cl
                                    add              di,ax                                                                                                                                                                                        ;on cell
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx
                                    cmp              col,0
                                    je               EndLeft21
                                    add              di,7
                                    add              si,7
                                    cmp              byte ptr [di],00h
                                    je               DoNotHighlightToEat121
                                    cmp              byte ptr [di],07h
                                    jg               DoNotHighlightToEat121
                                    mov              al,row
                                    inc              al
                                    dec              bl
                                    mov              IsmailRow,al
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h, IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh                                                                                                                                                                           ;;eat
                                    inc              bl
    DoNotHighlightToEat121:         
                                    sub              di,7
                                    sub              si,7
    EndLeft21:                      
                                    cmp              col,7
                                    je               EndRight21
                                    add              di,9
                                    add              si,9
                                    cmp              byte ptr [di],00h
                                    je               DoNotHighlightToEat221
                                    cmp              byte ptr [di],07h
                                    jg               DoNotHighlightToEat221
                                    mov              al,row
                                    inc              al
                                    inc              bl
                                    mov              IsmailRow,al
                                    mov              IsmailCol,bl
                                    drawSquareOnCell 04h,IsmailRow,IsmailCol
                                    mov              byte ptr [si],0ffh                                                                                                                                                                           ;;eat
                                    dec              bl
    DoNotHighlightToEat221:         
    EndRight21:                     
                                    popa
                                    ret
                                    endp             HighlightAvailableForBPawnToEat
    ;;;;;;===============================================================


bishopMoves proc
                                    PUSHA

    ; ; ------------------------- TESTING
    ;                                 drawSquareOnCell 03h,row,col
    ; ; callDrawSquare bx
    ; ; --------------------------
    
    ; intialize indexes
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx
                                    mov              bl,row
    
    ;**********************************************
    ;***************** 4 o'clock Cells ************
    ;**********************************************

                                    inc              bx
                                    inc              si
    checkBR:                                                                                                                                                                                                                                      ;bottom right
                                    cmp              bx,08h
                                    jz               precheckTL
                                    cmp              si,08h
                                    jz               precheckTL
                                    mov              cl,8
                                    mov              al,bl
                                    imul             cl
                                    push             bx
                                    mov              bx,ax
                                    add              bx,si
                                    mov              al,grid[bx]
                                    cmp              al,00
                                    jnz              lastBR
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx
                                    pop              bx
                                    inc              bx
                                    inc              si
                                    jmp              checkBR
    lastBR:                         
                                    pop              ax
    ; Disable friendly fire...
    ;check same team?
    ;get away piece code
                                    mov              dl,grid[bx]
                                    push             bx
    ;get attacker piece code
    ;reset bx
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx                                                                                                                                                                                        ;store col number in si
                                    mov              bl,row                                                                                                                                                                                       ;store row number in bl
                                    mov              cl,8
                                    mov              al,row
                                    imul             cl
                                    mov              bx,ax                                                                                                                                                                                        ;bx = bl(row number)*8
                                    add              bx,si                                                                                                                                                                                        ;bx = bl(row number)*8 +si(col number)
                                    mov              dh,grid[bx]
                                    pop              bx
    ;is same Color? "dl:away piece / dh:home piece"
                                    cmp              dh,10
                                    jl               whiteAttackerBR                                                                                                                                                                              ;white Attacker
    ;black Attacker
                                    cmp              dl,10
                                    jg               precheckTL
                                    jmp              eatBR
    ;white Attacker
    whiteAttackerBR:                
                                    cmp              dl,10
                                    jl               precheckTL
    ; Friendly fire is disabled
    eatBR:                          
                                    callDrawSquare   bx
                                    mov              availMoves[bx],0ffh


    precheckTL:                     
    ;reset indexes
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx
                                    mov              bl,row


    ;***********************************************
    ;***************** 10 o'clock Cells ************
    ;***********************************************

                                    dec              bx
                                    dec              si
    checkTL:                                                                                                                                                                                                                                      ;top left
                                    cmp              bx,0ffffh
                                    jz               precheckTR
                                    cmp              si,0ffffh
                                    jz               precheckTR
                                    mov              cl,8
                                    mov              al,bl
                                    imul             cl
                                    push             bx
                                    mov              bx,ax
                                    add              bx,si
                                    mov              al,grid[bx]
                                    cmp              al,00
                                    jnz              lastTL
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx
                                    pop              bx
                                    dec              bx
                                    dec              si
                                    jmp              checkTL
    lastTL:                         
                                    pop              ax
    ; Disable friendly fire...
    ;check same team?
    ;get away piece code
                                    mov              dl,grid[bx]
                                    push             bx
    ;get attacker piece code
    ;reset bx
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx                                                                                                                                                                                        ;store col number in si
                                    mov              bl,row                                                                                                                                                                                       ;store row number in bl
                                    mov              cl,8
                                    mov              al,row
                                    imul             cl
                                    mov              bx,ax                                                                                                                                                                                        ;bx = bl(row number)*8
                                    add              bx,si                                                                                                                                                                                        ;bx = bl(row number)*8 +si(col number)
                                    mov              dh,grid[bx]
                                    pop              bx
    ;is same Color? "dl:away piece / dh:home piece"
                                    cmp              dh,10
                                    jl               whiteAttackerTL                                                                                                                                                                              ;white Attacker
    ;black Attacker
                                    cmp              dl,10
                                    jg               precheckTR
                                    jmp              eatTL
    ;white Attacker
    whiteAttackerTL:                
                                    cmp              dl,10
                                    jl               precheckTR
    ; Friendly fire is disabled
    eatTL:                          
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx


    precheckTR:                     
    ;reset indexes
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx
                                    mov              bl,row

    ; ;**********************************************
    ; ;***************** 2 o'clock Cells ************
    ; ;**********************************************

                                    dec              bx
                                    inc              si
    checkTR:                                                                                                                                                                                                                                      ;top right
                                    cmp              bx,0ffffh
                                    jz               precheckBL
                                    cmp              si,08h
                                    jz               precheckBL
                                    mov              cl,8
                                    mov              al,bl
                                    imul             cl
                                    push             bx
                                    mov              bx,ax
                                    add              bx,si
                                    mov              al,grid[bx]
                                    cmp              al,00
                                    jnz              lastTR
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx
                                    pop              bx
                                    dec              bx
                                    inc              si
                                    jmp              checkTR
    lastTR:                         
                                    pop              ax
    ; Disable friendly fire...
    ;check same team?
    ;get away piece code
                                    mov              dl,grid[bx]
                                    push             bx
    ;get attacker piece code
    ;reset bx
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx                                                                                                                                                                                        ;store col number in si
                                    mov              bl,row                                                                                                                                                                                       ;store row number in bl
                                    mov              cl,8
                                    mov              al,row
                                    imul             cl
                                    mov              bx,ax                                                                                                                                                                                        ;bx = bl(row number)*8
                                    add              bx,si                                                                                                                                                                                        ;bx = bl(row number)*8 +si(col number)
                                    mov              dh,grid[bx]
                                    pop              bx
    ;is same Color? "dl:away piece / dh:home piece"
                                    cmp              dh,10
                                    jl               whiteAttackerTR                                                                                                                                                                              ;white Attacker
    ;black Attacker
                                    cmp              dl,10
                                    jg               precheckBL
                                    jmp              eatTR
    ;white Attacker
    whiteAttackerTR:                
                                    cmp              dl,10
                                    jl               precheckBL
    ; Friendly fire is disabled
    eatTR:                          
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx

    precheckBL:                     
    ;reset indexes
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx
                                    mov              bl,row

    ; ;**********************************************
    ; ;***************** 8 o'clock Cells ************
    ; ;**********************************************

                                    inc              bx
                                    dec              si
    checkBL:                                                                                                                                                                                                                                      ;bottom left
                                    cmp              bx,08h
                                    jz               rt1
                                    cmp              si,0ffffh
                                    jz               rt1
                                    mov              cl,8
                                    mov              al,bl
                                    imul             cl
                                    push             bx
                                    mov              bx,ax
                                    add              bx,si
                                    mov              al,grid[bx]
                                    cmp              al,00
                                    jnz              lastBL
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx
                                    pop              bx
                                    inc              bx
                                    dec              si
                                    jmp              checkBL
    lastBL:                         
                                    pop              ax
    ; Disable friendly fire...
    ;check same team?
    ;get away piece code
                                    mov              dl,grid[bx]
                                    push             bx
    ;get attacker piece code
    ;reset bx
                                    mov              bl,col
                                    mov              bh,0
                                    mov              si,bx                                                                                                                                                                                        ;store col number in si
                                    mov              bl,row                                                                                                                                                                                       ;store row number in bl
                                    mov              cl,8
                                    mov              al,row
                                    imul             cl
                                    mov              bx,ax                                                                                                                                                                                        ;bx = bl(row number)*8
                                    add              bx,si                                                                                                                                                                                        ;bx = bl(row number)*8 +si(col number)
                                    mov              dh,grid[bx]
                                    pop              bx
    ;is same Color? "dl:away piece / dh:home piece"
                                    cmp              dh,10
                                    jl               whiteAttackerBL                                                                                                                                                                              ;white Attacker
    ;black Attacker
                                    cmp              dl,10
                                    jg               rt1
                                    jmp              eatBL
    ;white Attacker
    whiteAttackerBL:                
                                    cmp              dl,10
                                    jl               rt1
    ; Friendly fire is disabled
    eatBL:                          
                                    mov              availMoves[bx],0ffh
                                    callDrawSquare   bx

    rt1:                            
                                    popa
                                    ret
                                    ENDp             bishopMoves

queenMoves proc
                                    pusha                                                                                                                                                                                                         ;no need to it as you push in rook and bishop and queen doesn't change rigisters (for optimization)
    
                                    call             bishopMoves
                                    call             rookMoves
      
                                    popa
                                    ret
                                    ENDp             queenMoves

    ;------------------------------------------------




getName proc
            
                                    mov              ch,0
                                    mov              cl,0
                                    jmp              getCh
            
    endByEnter:                     
                                    mov              ah,0
                                    int              16h
                                    jmp              endGetName
            
    consumeBuffer:                  
                                    mov              ah,0
                                    int              16h
        
    getCh:                                                                                                                                                                                                                                        ;read 1 ch
                                    mov              ah,1
                                    int              16h
                                    jnz              validation
                                    jz               getCh
     
            
    validation:                     
                                    cmp              cl,0
                                    jz               isLetter
                                    cmp              ah,1ch
                                    jz               endByEnter
                                    jmp              echoIt
    
    isLetter:                       
                                    cmp              al,65
                                    jl               consumeBuffer
                                    cmp              al,90
                                    jl               echoIt
                                    cmp              al,97
                                    jl               consumeBuffer
                                    cmp              al,122
                                    jg               consumeBuffer
    ;Valid then echo
    
    echoIt:                         
                                    mov              ah,2
                                    mov              dl,al
                                    int              21h
                                    inc              cl
    ;store in data
                                    mov              si,cx
                                    mov              Name1[si+1],al
                                    cmp              cl,15                                                                                                                                                                                        ;no more ch needed
                                    jl               consumeBuffer
    
    lastButton:                                                                                                                                                                                                                                   ;if name reached size limit
                                    call             waitEnter
    
    endGetName:                                                                                                                                                                                                                                   ;store in data
                                    mov              Name1[1],cl
            
                                    ret
                                    endp             getName

waitEnter proc
            
                                    jmp              getButton
    popButton:                      
    ;pop the button (called after any input)
                                    mov              ah,0
                                    int              16h
    ;Get Enter key
    getButton:                      
                                    mov              ah,1
                                    int              16h
                                    jnz              Enter                                                                                                                                                                                        ;if user entered button it will jmp
                                    jmp              getButton                                                                                                                                                                                    ;no button entered try again
    
    Enter:                          
                                    cmp              ah,1ch
                                    jnz              popButton                                                                                                                                                                                    ; if button is not Enter, repeat
    ;button is Enter
    ;pop it from buffer
                                    mov              ah,0
                                    int              16h
        
                                    ret
                                    endp             waitEnter
end main 