;Authors:
;CHESS GAME
;---------------------------
;--------------------------------
; Macro to move cursor to certain position
; Takes position as parameter
moveCursor MACRO position
    pusha    
    mov ah, 2
    mov dx, position
    int 10h             ; use interrupt 10/2, dx contains position
    popa
ENDM moveCursor
;----------------------------------

;--------------------------------------
; Macro to print string
; Takes message as parameter
printString MACRO message
    mov ah, 9
    mov dx, offset message
    int 21h
ENDM printString 
;--------------------------------------   

;----------------------------------
; Macro to print given char given number of times
; with given colors
; Takes char, count, back color front color
printCharColorTimes MACRO char, count, backfront
    mov ah, 9
    mov bh, 0
    mov al, char
    mov cx, count
    mov bl, backfront
    int 10h                 ; interrupt 10/9
ENDM printCharColorTimes    
;----------------------------------

;----------------------------------
; Macro to draw notification bar
; Takes nothing so far
notificationBar MACRO hello, exclamation, name1, messageTemp
    moveCursor 1700h        ; move the cursor to row 22 column 0
    
    printCharColorTimes '-', 80, 0fh  ; Print '-' with white foreground black background 80 times (whole screen width)
    
    moveCursor 1800h

    printString hello
    printString name1+2
    printString exclamation
    printString messageTemp
; CHECK: 
;     mov ah,0ch
;     mov al,0
;     int 21h
;     mov ah, 1
;     int 16h
;     jz CHECK
;     cmp ah, 3bh
;     je PRINTMESSAGEF1
;     cmp ah, 3ch
;     je PRINTMESSAGEF2
;     jmp CHECK

; PRINTMESSAGEF1:
;     moveCursor 1800h
;     printCharColorTimes ' ', 80, 0fh
;     moveCursor 1800h
;     mov ah, 9
;     mov dx, offset messageF1
;     int 21h
;     jmp CHECK

; PRINTMESSAGEF2:
;     moveCursor 1800h
;     printCharColorTimes ' ', 80, 0fh
;     moveCursor 1800h
;     mov ah, 9
;     mov dx, offset messageF2
;     int 21h
;     jmp CHECK
ENDM notificationBar
;-----------------------------------
; extrn ism:byte

callDrawSquare macro cellNumber,color
pusha

    mov ax, cellNumber
    mov ah,0
    mov bl,8
    idiv bl
    mov bx,ax
    drawSquareOnCell color,bl,bh

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

checkEmptyCell MACRO r,c
local notempty
pusha
mov bl,8
mov al,r
imul bl
add al,c
mov bx,ax
mov cl,grid[bx]
mov isEmptyCell,0
cmp cl,0
jnz notempty
mov isEmptyCell,1
notempty:
popa
ENDM checkEmptyCell

callAppropriateMove macro player,sr,sc,cr,cc
local en,notmoved,check2,check3,check4,check5,check6,check7,check8,check9,check10,check11,check12,check13,check14,check15,check16,p2,startm
local enm,p22,enm3,p23,enm4,p24,enm5,enm6,enm7,enm8,enm9,enm10,enm11,enm12,enm13,enm14,enm15,enm16,enm17,p25,p26,p27,p28,p29,p210,p211,p212,p213,p214,p215,p216,p217
pusha
mov cl,player

cmp cl,1
jne p2
checkAvailable
cmp isAvailableCell,0
je notmoved
jmp startm

p2:
cmp cl,2
jne notmoved
; mov al,'0'
; mov ah,0ah
; int 10h
checkAvailable2
cmp isAvailableCell2,0
je notmoved

startm:

mov al,sr
mov bl,8
imul bl
add al,sc
mov bx,ax
mov al,grid[bx]

cmp al,1
jne check2
movePiece 1, sr, sc,cr, cc, grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p22
mov hasmoved,1
jmp enm
p22:
mov hasmoved2,1
enm:
jmp en
check2:
cmp al,2
jne check3
movePiece 2, sr, sc, cr,cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p23
mov hasmoved,1
jmp enm3
p23:
mov hasmoved2,1
enm3:
jmp en
check3:
cmp al,3
jne check4
movePiece 3, sr, sc,  cr,cc, grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p24
mov hasmoved,1
jmp enm4
p24:
mov hasmoved2,1
enm4:
jmp en
check4:
cmp al,4
jne check5
movePiece 4, sr, sc, cr,cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p25
mov hasmoved,1
jmp enm5
p25:
mov hasmoved2,1
enm5:
jmp en
check5:
cmp al,5
jne check6
movePiece 5, sr, sc,  cr,cc, grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p26
mov hasmoved,1
jmp enm6
p26:
mov hasmoved2,1
enm6:
jmp en
check6:
cmp al,6
jne check7
movePiece 6, sr, sc, cr,cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p27
mov hasmoved,1
jmp enm7
p27:
mov hasmoved2,1
enm7:
jmp en
check7:
cmp al,7
jne check8
movePiece 7, sr, sc,cr, cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p28
mov hasmoved,1
jmp enm8
p28:
mov hasmoved2,1
enm8:
jmp en
check8:
cmp al,8
jne check9
movePiece 8, sr, sc,  cr,cc, grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p29
mov hasmoved,1
jmp enm9
p29:
mov hasmoved2,1
enm9:
jmp en
check9:
cmp al,9
jne check10
movePiece 9, sr, sc, cr,cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p210
mov hasmoved,1
jmp enm10
p210:
mov hasmoved2,1
enm10:
jmp en
check10:
cmp al,10
jne check11
movePiece 10, sr, sc, cr,cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p211
mov hasmoved,1
jmp enm11
p211:
mov hasmoved2,1
enm11:
jmp en
check11:
cmp al,11
jne check12
movePiece 11, sr, sc, cr,cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p212
mov hasmoved,1
jmp enm12
p212:
mov hasmoved2,1
enm12:
jmp en
check12:
cmp al,12
jne check13
movePiece 12, sr, sc, cr,cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p213
mov hasmoved,1
jmp enm13
p213:
mov hasmoved2,1
enm13:
jmp en
check13:
cmp al,13
jne check14
movePiece 13, sr, sc,cr, cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p214
mov hasmoved,1
jmp enm14
p214:
mov hasmoved2,1
enm14:
jmp en
check14:
cmp al,14
jne check15
movePiece 14, sr, sc,cr, cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p215
mov hasmoved,1
jmp enm15
p215:
mov hasmoved2,1
enm15:
jmp en
check15:
cmp al,15
jne check16
movePiece 15, sr, sc,cr, cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p216
mov hasmoved,1
jmp enm16
p216:
mov hasmoved2,1
enm16:
jmp en
check16:
cmp al,16
jne en
movePiece 16, sr, sc,cr, cc,  grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
cmp cl,1
jne p217
mov hasmoved,1
jmp enm17
p217:
mov hasmoved2,1
enm17:
jmp en

notmoved:
cmp cl,1
jne nm2
mov hasmoved,0
jmp en
nm2:
mov hasmoved2,0

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
local checks,checks2,removeh,removeh2,end,checkp2
pusha

checkAvailable
cmp isAvailableCell,0
jz checks
drawSquareOnCell 04h,currRow,currColumn
jmp checkp2

checks:
checkSelected currRow,currColumn
cmp isSelectedCell,0
jz removeh
drawSquareOnCell 03h,currRow,currColumn
jmp checkp2

removeh:
drawSquareOnCell 07h,currRow,currColumn


checkp2:

checkAvailable2
cmp isAvailableCell2,0
jz checks2
drawSquareOnCell 04h,currRow2,currColumn2
jmp end

checks2:
checkSelected2 currRow2,currColumn2
cmp isSelectedCell2,0
jz removeh2
drawSquareOnCell 03h,currRow2,currColumn2
jmp end

removeh2:
drawSquareOnCell 07h,currRow2,currColumn2

end:
popa
endm eraseHighlight


resetavailmoves macro
local lo,freset,skip
pusha
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
callDrawSquare   bx,07h
skip:
inc bx
jmp lo
freset:

pop ax
pop bx
popa
endm resetavailmoves

resetavailmoves2 macro
local lo,freset,skip
pusha
push bx
push ax
mov bx,0

lo:
cmp bx,64d
je freset
mov al,availMoves2[bx]
cmp al,0
je skip
mov availMoves2[bx],00
callDrawSquare   bx,07h
skip:
inc bx
jmp lo
freset:

pop ax
pop bx
popa
endm resetavailmoves2

initializeGrid macro
push bx

mov grid[0], 12
mov cooldown[0], 0000
mov availMoves[0], 00
mov availMoves2[0], 00
mov grid[1], 13
mov cooldown[1], 0000
mov availMoves[1], 00
mov availMoves2[1], 00
mov grid[2], 14
mov cooldown[2], 0000
mov availMoves[2], 00
mov availMoves2[2], 00
mov grid[3], 15
mov cooldown[3], 0000
mov availMoves[3], 00
mov availMoves2[3], 00
mov grid[4], 16
mov cooldown[4], 0000
mov availMoves[4], 00
mov availMoves2[4], 00
mov grid[5], 14
mov cooldown[5], 0000
mov availMoves[5], 00
mov availMoves2[5], 00
mov grid[6], 13
mov cooldown[6], 0000
mov availMoves[6], 00
mov availMoves2[6], 00
mov grid[7], 12
mov cooldown[7], 0000
mov availMoves[7], 00
mov availMoves2[7], 00

mov bx,8

inirow2:
mov grid[bx],11
mov cooldown[bx], 0000
mov availMoves[bx], 00
mov availMoves2[bx], 00
inc bx
cmp bx,16
jne inirow2

inizeros:
mov grid[bx],0
mov cooldown[bx], 0000
mov availMoves[bx], 00
mov availMoves2[bx], 00
inc bx
cmp bx,48
jne inizeros

inirow7:
mov grid[bx],1
mov cooldown[bx], 0000
mov availMoves[bx], 00
mov availMoves2[bx], 00
inc bx
cmp bx,56
jne inirow7


mov grid[56],02
mov cooldown[56], 0000
mov availMoves[56], 00
mov availMoves2[56], 00
mov grid[57],03
mov cooldown[57], 0000
mov availMoves[57], 00
mov availMoves2[57], 00
mov grid[58],04
mov cooldown[58], 0000
mov availMoves[58], 00
mov availMoves2[58], 00
mov grid[59],05
mov cooldown[59], 0000
mov availMoves[59], 00
mov availMoves2[59], 00
mov grid[60],06
mov cooldown[60], 0000
mov availMoves[60], 00
mov availMoves2[60], 00
mov grid[61],04
mov cooldown[61], 0000
mov availMoves[61], 00
mov availMoves2[61], 00
mov grid[62],03
mov cooldown[62], 0000
mov availMoves[62], 00
mov availMoves2[62], 00
mov grid[63],02
mov cooldown[63], 0000
mov availMoves[63], 00
mov availMoves2[63], 00

pop bx
endm initializeGrid

mainScreen MACRO hello, exclamation, name1, messageTemp, mes1, mes2, mes3, keypressed, image1, image1Width, image1Height, ism, boardWidth, boardHeight, greyCell, whiteCell, grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2

      
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
    drawImageOnBoard white_king,20 , 20,4,7
    drawImageOnBoard black_king,20 , 20,4,0
    pop ax
    inc al
    jmp drawpiecess

    drawqueens:
    push ax
    drawImageOnBoard white_queen,20 , 20,3,7
    drawImageOnBoard black_queen,20 , 20,3,0
    pop ax
    inc al
    jmp drawpiecess

    drawpawns:
    

    drawImageOnBoard white_pawn ,20,20,0,6
    drawImageOnBoard white_pawn ,20,20,1,6
    drawImageOnBoard white_pawn ,20,20,2,6
    drawImageOnBoard white_pawn ,20,20,3,6
    drawImageOnBoard white_pawn ,20,20,4,6
    drawImageOnBoard white_pawn ,20,20,5,6
    drawImageOnBoard white_pawn ,20,20,6,6
    drawImageOnBoard white_pawn ,20,20,7,6

    
    drawImageOnBoard black_pawn ,20,20,0,1
    drawImageOnBoard black_pawn ,20,20,1,1
    drawImageOnBoard black_pawn ,20,20,2,1
    drawImageOnBoard black_pawn ,20,20,3,1
    drawImageOnBoard black_pawn ,20,20,4,1
    drawImageOnBoard black_pawn ,20,20,5,1
    drawImageOnBoard black_pawn ,20,20,6,1
    drawImageOnBoard black_pawn ,20,20,7,1

    
    finishpieces:
    
    initializeGrid

    drawSquareOnCell 0eh,currRow,currColumn

    drawSquareOnCell 0eh,currRow2,currColumn2

;;;;;;;;;;;;;end of initializing pieces on board;;;;;;;;;;;;


;#####################################################


;gm
checkkeygm:
lea si, buf
mov ah,00
int 1ah
mov ax, dx
call number2string
mov dx, 0000h
mov bx, 0
mov ah, 2
int 10h
mov ah,9
mov dx, offset buf
int 21h
mov ah,1
int 16h
jnz w
jz checkkeygm

w:
; push ax
; pop ax

cmp al,77h
jnz arrowup

;navigate up
cmp currRow,0
je skipnavu

eraseHighlight


; drawSquareOnCell 07h,currRow,currColumn
dec currRow
drawSquareOnCell 0eh,currRow,currColumn
drawSquareOnCell 0eh,currRow2,currColumn2

skipnavu:



jmp consumebuffergm

arrowup:
cmp ah,48h
jne s

;navigate up
cmp currRow2,0
je skipnavu2

eraseHighlight
dec currRow2
drawSquareOnCell 0eh,currRow,currColumn
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavu2:

jmp consumebuffergm

s:
cmp al,73h
jnz arrowdown

cmp currRow,7
je skipnavd


eraseHighlight

inc currRow
drawSquareOnCell 0eh,currRow,currColumn
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavd:
jmp consumebuffergm

arrowdown:
cmp ah,50h
jne a

cmp currRow2,7
je skipnavd2


eraseHighlight

inc currRow2
drawSquareOnCell 0eh,currRow,currColumn
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavd2:
jmp consumebuffergm


a:
cmp al,61h
jnz arrowleft 

cmp currColumn,0
je skipnavl

eraseHighlight

dec currColumn
drawSquareOnCell 0eh,currRow,currColumn
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavl:
jmp consumebuffergm

arrowleft:
cmp ah,4bh
jne d

cmp currColumn2,0
je skipnavl2

eraseHighlight

dec currColumn2
drawSquareOnCell 0eh,currRow,currColumn
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavl2:
jmp consumebuffergm

d:
cmp al,64h
jnz arrowright

cmp currColumn,7
je skipnavr

eraseHighlight

inc currColumn
drawSquareOnCell 0eh,currRow,currColumn
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavr:
jmp consumebuffergm

arrowright:
cmp ah,4dh
jne preq
cmp currColumn2,7
je skipnavr2
eraseHighlight
inc currColumn2

drawSquareOnCell 0eh,currRow,currColumn
drawSquareOnCell 0eh,currRow2,currColumn2
skipnavr2:

jmp consumebuffergm

preq:
cmp checkq,0
je q
jne q2

st:
jmp enterms

q:
cmp al,71h
jnz exitgame

;select
checkEmptyCell currRow,currColumn

cmp isEmptyCell,0
jne preventSelection

mov cl,currColumn
mov selectedCol,cl
mov cl,currRow
mov selectedRow,cl
drawSquareOnCell 03h,currRow,currColumn

getAvailForSelectedPiece currRow,currColumn,1

;;;;;check available moves for the piece and draw them

mov checkq,1

preventSelection:

jmp consumebuffergm


q2:
cmp al,71h
jne esc2

; callAppropriateMove 1,selectedRow,selectedCol,currRow,currColumn

; cmp hasmoved,0
; je noreset
; drawSquareOnCell 07h,selectedRow,selectedCol
; mov selectedRow,0ffh
; mov selectedCol,0ffh
; resetavailmoves

; mov checkq,0
; noreset:
jmp consumebuffergm

esc2:
cmp al,1bh
jnz presel2


; mov keypressed,al

drawSquareOnCell 07,selectedRow,selectedCol
mov selectedRow,0ffh
mov selectedCol,0ffh


;Reset availMoves and Remove Highlights
resetavailmoves

drawSquareOnCell 0eh,currRow,currColumn
mov checkq,0
jmp consumebuffergm

presel2:
cmp checkq2,0
je sel2
jne sel22

sel2:
cmp al,2fh
jne exitgame2
checkEmptyCell currRow2,currColumn2
cmp isEmptyCell,0
jne preventSelection2
mov cl,currColumn2
mov selectedCol2,cl
mov cl,currRow2
mov selectedRow2,cl
drawSquareOnCell 03h,currRow2,currColumn2

getAvailForSelectedPiece currRow2,currColumn2,2
mov checkq2,1
preventSelection2:
jmp consumebuffergm

sel22:
cmp al,2fh
jne esc22

; mov al,'0'
; mov ah,0ah
; int 10h

callAppropriateMove 2,selectedRow2,selectedCol2,currRow2,currColumn2
; 
cmp hasmoved2,0
je noreset2
drawSquareOnCell 07h,selectedRow2,selectedCol2
mov selectedRow2,0ffh
mov selectedCol2,0ffh
resetavailmoves2
; 
mov checkq2,0
noreset2:

jmp consumebuffergm

esc22:
cmp al,2eh
jnz consumebuffergm



drawSquareOnCell 07,selectedRow2,selectedCol2
mov selectedRow2,0ffh
mov selectedCol2,0ffh


resetavailmoves2

drawSquareOnCell 0eh,currRow2,currColumn2
mov checkq2,0
jmp consumebuffergm

exitgame2:
cmp al,2eh
jne consumebuffergm

mov ah,0
int 16h

 mov ax, 0003h
     int 10h

jmp st
; jmp consumebuffergm
exitgame:
cmp al,1bh
jnz presel2

;consume buffet then go to main screen

mov ah,0
int 16h

 mov ax, 0003h
     int 10h

jmp st


jmp consumebuffergm


consumebuffergm:
mov ah,0
int 16h
jmp checkkeygm

    
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
movePiece MACRO code, fromRow, fromColumn, toRow, toColumn, grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2
    local noMove, gameWon1, gameWon2, notWin, checkGameWon
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
    jl noMove

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
    cmp ah, 0
    je notWin 
    push ax
    push bx
    mov dx, 1800h
    mov bx, 0
    mov ah, 2
    int 10h
    mov dx, offset eatWP
    mov ah, 9
    int 21h
    pop bx
    pop ax
checkGameWon:    
    cmp ah, 6
    jz gameWon2
    cmp ah, 16
    jz gameWon1
notWin:    
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
    resetavailmoves2
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
    jmp st
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
    jmp st
noMove:
    popa
ENDM movePiece

getAvailForSelectedPiece MACRO r,c,player
    local rt,blackrock,whitebishop,blackbishop,whitequeen,blackqueen,king1,king2,whitepawn,blackpawn,blackknight,whiteknight,preking,prepawn,preknight
    pusha

mov bl,8
mov al,r
imul bl
add al,c
mov bx,ax

mov cl,grid[bx]

;check rock
cmp cl,2
jne blackrock
push ax
push bx
mov al,r
mov ah,c
mov bl,player
mov row,al
mov col,ah
mov PNO,bl
pop bx
pop ax
call rookMoves 
jmp rt
blackrock:
cmp cl,12
jne whitebishop
push ax
push bx
mov al,r
mov ah,c
mov bl,player
mov row,al
mov col,ah
mov PNO,bl
pop bx
pop ax
call rookMoves 
jmp rt
whitebishop:
cmp cl,4
jne blackbishop
push ax
push bx
mov al,r
mov ah,c
mov bl,player
mov row,al
mov col,ah
mov PNO,bl
pop bx
pop ax
call bishopMoves 
jmp rt
blackbishop:
cmp cl,14
jne whitequeen
push ax
push bx
mov al,r
mov ah,c
mov bl,player
mov row,al
mov col,ah
mov PNO,bl
pop bx
pop ax
call bishopMoves 
jmp rt
whitequeen:
cmp cl,5
jne blackqueen
push ax
push bx
mov al,r
mov ah,c
mov bl,player
mov row,al
mov col,ah
mov PNO,bl
pop bx
pop ax
call queenMoves 
jmp rt
blackqueen:
cmp cl,15
jne prepawn
push ax
push bx
mov al,r
mov ah,c
mov bl,player
mov row,al
mov col,ah
mov PNO,bl
pop bx
pop ax
call queenMoves 
jmp rt

prepawn:
push ax
push bx
mov al,r
mov ah,c
mov bl,player
mov row,al
mov col,ah
mov PNO,bl
pop bx
pop ax
cmp PNO,1
je whitepawn
jne blackpawn

whitepawn:
cmp cl,1
jne preking
 call HighlightAvailableForWPawnToEat 
 call HighlightAvailableForWPawnTwo 
jmp rt
blackpawn:
cmp cl,11
jne preking
 call HighlightAvailableForBPawnToEat 
 call HighlightAvailableForBPawnTwo 
jmp rt

preking:
push ax
push bx
mov al,r
mov ah,c
mov bl,player
mov row,al
mov col,ah
mov PNO,bl
pop bx
pop ax
cmp PNO,1
je king1
jne king2

king1:
cmp cl,6 
jne preknight
call HighlightAvailableForWKing 
jmp rt
king2:
cmp cl,16
jne preknight
call HighlightAvailableForBKing 
jmp rt

preknight:
push ax
push bx
mov al,r
mov ah,c
mov bl,player
mov row,al
mov col,ah
mov PNO,bl
pop bx
pop ax
cmp PNO,1
je whiteknight
jne blackknight

whiteknight:
cmp cl,3
jne rt
call HighlightAvailableForWKnight 
jmp rt
blackknight:
cmp cl,13
jne rt
call HighlightAvailableForBKnight 
jmp rt
rt:
popa
ENDM getAvailForSelectedPiece
;-------------------------------------------------------------- 

; include resZahran.inc
.model small
.386
.stack 64
.data

    eatWP db "Piece eaten$"
    seconds db ?         
    buf     db 6 dup (?)

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
    PNO              db  ?
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

      
                                    mainScreen       hello, exclamation, name1, messageTemp, mes1, mes2, mes3, keypressed, white_bishop, 20, 20, ism, boardWidth, boardHeight, greyCell, whiteCell, grid, cooldown, winMessageP1, winMessageP2, checkKing1Message, checkKing2Message, row, col, PNO, availMoves, availMoves2

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
                                    cmp              PNO,1
                                    jne              p2
                                    mov              availMoves[bx],0ffh
                                    jmp              e
    p2:                             
                                    mov              availMoves2[bx],0ffh
    e:                              
                                    callDrawSquare   bx,04h
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
                                    cmp              PNO,1
                                    jne              p22
                                    mov              availMoves[bx],0ffh
                                    jmp              e2
    p22:                            
                                    mov              availMoves2[bx],0ffh
    e2:                             
                                    callDrawSquare   bx,04h



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
                                    cmp              PNO,1
                                    jne              p23
                                    mov              availMoves[bx],0ffh
                                    jmp              e3
    p23:                            
                                    mov              availMoves2[bx],0ffh
    e3:                             
                                    callDrawSquare   bx,04h
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
                                    cmp              PNO,1
                                    jne              p24
                                    mov              availMoves[bx],0ffh
                                    jmp              e4
    p24:                            
                                    mov              availMoves2[bx],0ffh
    e4:                             
                                    callDrawSquare   bx,04h

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
                                    cmp              PNO,1
                                    jne              p25
                                    mov              availMoves[bx],0ffh
                                    jmp              e5
    p25:                            
                                    mov              availMoves2[bx],0ffh
    e5:                             
                                    callDrawSquare   bx,04h
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
                                    cmp              PNO,1
                                    jne              p26
                                    mov              availMoves[bx],0ffh
                                    jmp              e6
    p26:                            
                                    mov              availMoves2[bx],0ffh
    e6:                             
                                    callDrawSquare   bx,04h

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
                                    cmp              PNO,1
                                    jne              p27
                                    mov              availMoves[bx],0ffh
                                    jmp              e7
    p27:                            
                                    mov              availMoves2[bx],0ffh
    e7:                             
                                    callDrawSquare   bx,04h
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
                                    cmp              PNO,1
                                    jne              p28
                                    mov              availMoves[bx],0ffh
                                    jmp              e8
    p28:                            
                                    mov              availMoves2[bx],0ffh
    e8:                             
                                    callDrawSquare   bx,04h


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
                                    lea              si,availMoves2
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
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx

    ;highlight above
                                    cmp              row,2
                                    jl               noAbove1
                                    sub              di,16                                                                                                                                                                                        ;above
                                    sub              si,16
                                    mov              al,row
                                    sub              al,2                                                                                                                                                                                         ;above 2 steps
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
                                    add              di,16
                                    add              si,16
    noAbove1:                       
    ;highlight below

                                    cmp              row,5
                                    jg               noBelow1
                                    add              di,16
                                    add              si,16
                                    mov              al,row                                                                                                                                                                                       ;on cell and bl too
                                    add              al,2                                                                                                                                                                                         ;below 2 steps
                                    mov              IsmailRow,al
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
                                    sub              di,16
                                    sub              si,16
    noBelow1:                       
    ;highlight right

                                    cmp              col,5
                                    jg               noRight1
                                    add              di,2
                                    add              si,2                                                                                                                                                                                         ;on cell and bl too
                                    add              bl,2                                                                                                                                                                                         ;right 2 steps
                                    mov              IsmailCol,bl
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
                                    sub              di,8
                                    sub              si,8
    noDownRight1:                   
                                    sub              bl,2
                                    sub              di,2
                                    sub              si,2
    noRight1:                       
    ;highlight left

                                    cmp              col,2
                                    jl               noLeft1
                                    sub              di,2
                                    sub              si,2
    ;on cell and bl too
                                    sub              bl,2                                                                                                                                                                                         ;left 2 steps
                                    mov              IsmailCol,bl
                                   
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
                                    add              di,2
                                    add              si,2

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
                                    lea              si,availMoves2
                                    mul              cl
                                    add              di,ax
                                    add              di,bx
                                    add              si,ax
                                    add              si,bx

    ;highlight above
                                    cmp              row,2
                                    jl               noAbove
                                    sub              di,16
                                    sub              si,16
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
                                    add              di,16
                                    add              si,16
    noAbove:                        
    ;highlight below

                                    cmp              row,5
                                    jg               noBelow
                                    add              di,16
                                    add              si,16
                                    mov              al,row                                                                                                                                                                                       ;on cell and bl too
                                    add              al,2                                                                                                                                                                                         ;below 2 steps
                                    mov              IsmailRow,al
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
                                    sub              di,16
                                    sub              si,16
    noBelow:                        
    ;highlight right

                                    cmp              col,5
                                    jg               noRight
                                    add              di,2
                                    add              si,2                                                                                                                                                                                         ;on cell and bl too
                                    add              bl,2                                                                                                                                                                                         ;right 2 steps
                                    mov              IsmailCol,bl
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
                                    sub              di,8
                                    sub              si,8
    noDownRight:                    
                                    sub              bl,2
                                    sub              di,2
                                    sub              si,2
    noRight:                        
    ;highlight left

                                    cmp              col,2
                                    jl               noLeft
                                    sub              di,2
                                    sub              si,2                                                                                                                                                                                         ;on cell and bl too
                                    sub              bl,2                                                                                                                                                                                         ;left 2 steps
                                    mov              IsmailCol,bl
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
                                    cmp              row,0
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
                                    lea              si,availMoves2
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
                                    cmp              row,0
                                    jne              notGridEnd1
                                    jmp              gridEnd1
    notGridEnd1:                    
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
    gridEnd1:                       
                                    popa
                                    ret
                                    endp             HighlightAvailableForWPawnToEat

HighlightAvailableForBPawnToEat proc
    ;local DoNotHighlightToEat1,DoNotHighlightToEat2,EndLeft,EndRight
                                    pusha
                                    cmp              row,7
                                    jne              notGridEnd2
                                    jmp              gridEnd2
    notGridEnd2:                    
                                    mov              al,row
                                    mov              ah,0
                                    mov              bl,col
                                    mov              bh,0
                                    mov              cl,8
                                    lea              si,availMoves2
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
    gridEnd2:                       
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
                                    cmp              PNO,1
                                    jne              p29
                                    mov              availMoves[bx],0ffh
                                    jmp              e9
    p29:                            
                                    mov              availMoves2[bx],0ffh
    e9:                             
                                    callDrawSquare   bx,04h
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
                                    callDrawSquare   bx,04h
                                    cmp              PNO,1
                                    jne              p210
                                    mov              availMoves[bx],0ffh
                                    jmp              e10
    p210:                           
                                    mov              availMoves2[bx],0ffh
    e10:                            


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
                                    cmp              PNO,1
                                    jne              p211
                                    mov              availMoves[bx],0ffh
                                    jmp              e11
    p211:                           
                                    mov              availMoves2[bx],0ffh
    e11:                            
                                    callDrawSquare   bx,04h
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
                                    cmp              PNO,1
                                    jne              p212
                                    mov              availMoves[bx],0ffh
                                    jmp              e12
    p212:                           
                                    mov              availMoves2[bx],0ffh
    e12:                            
                                    callDrawSquare   bx,04h


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
                                    cmp              PNO,1
                                    jne              p213
                                    mov              availMoves[bx],0ffh
                                    jmp              e13
    p213:                           
                                    mov              availMoves2[bx],0ffh
    e13:                            
                                    callDrawSquare   bx,04h
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
                                    cmp              PNO,1
                                    jne              p214
                                    mov              availMoves[bx],0ffh
                                    jmp              e14
    p214:                           
                                    mov              availMoves2[bx],0ffh
    e14:                            
                                    callDrawSquare   bx,04h

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
                                    cmp              PNO,1
                                    jne              p215
                                    mov              availMoves[bx],0ffh
                                    jmp              e15
    p215:                           
                                    mov              availMoves2[bx],0ffh
    e15:                            
                                    callDrawSquare   bx,04h
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
                                    cmp              PNO,1
                                    jne              p216
                                    mov              availMoves[bx],0ffh
                                    jmp              e16
    p216:                           
                                    mov              availMoves2[bx],0ffh
    e16:                            
                                    callDrawSquare   bx,04h

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

    ;------------------------------------------
    ;CONVERT A NUMBER IN STRING.
    ;ALGORITHM : EXTRACT DIGITS ONE BY ONE, STORE
    ;THEM IN STACK, THEN EXTRACT THEM IN REVERSE
    ;ORDER TO CONSTRUCT STRING (STR).
    ;PARAMETERS : AX = NUMBER TO CONVERT.
    ;             SI = POINTING WHERE TO STORE STRING.

number2string proc
    ;FILL BUF WITH DOLLARS.
                                    push             si
                                    call             dollars
                                    pop              si

                                    mov              bx, 10                                                                                                                                                                                       ;DIGITS ARE EXTRACTED DIVIDING BY 10.
                                    mov              cx, 0                                                                                                                                                                                        ;COUNTER FOR EXTRACTED DIGITS.
    cycle1:                         
                                    mov              dx, 0                                                                                                                                                                                        ;NECESSARY TO DIVIDE BY BX.
                                    div              bx                                                                                                                                                                                           ;DX:AX / 10 = AX:QUOTIENT DX:REMAINDER.
                                    push             dx                                                                                                                                                                                           ;PRESERVE DIGIT EXTRACTED FOR LATER.
                                    inc              cx                                                                                                                                                                                           ;INCREASE COUNTER FOR EVERY DIGIT EXTRACTED.
                                    cmp              ax, 0                                                                                                                                                                                        ;IF NUMBER IS
                                    jne              cycle1                                                                                                                                                                                       ;NOT ZERO, LOOP.
    ;NOW RETRIEVE PUSHED DIGITS.
    cycle2:                         
                                    pop              dx
                                    add              dl, 48                                                                                                                                                                                       ;CONVERT DIGIT TO CHARACTER.
                                    mov              [ si ], dl
                                    inc              si
                                    loop             cycle2

                                    ret
                                    endp

    ;------------------------------------------
    ;FILLS VARIABLE WITH '$'.
    ;USED BEFORE CONVERT NUMBERS TO STRING, BECAUSE
    ;THE STRING WILL BE DISPLAYED.
    ;PARAMETER : SI = POINTING TO STRING TO FILL.

dollars proc
                                    mov              cx, 6
    six_dollars:                    
                                    mov              bl, '$'
                                    mov              [ si ], bl
                                    inc              si
                                    loop             six_dollars

                                    ret
                                    endp

end main 