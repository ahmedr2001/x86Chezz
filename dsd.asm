;Author:Mohammed Taher
;Defining username screen
;---------------------------
include mymacros.inc

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

;-----------------------------------------------------------------------
; to draw image on board using row and column
drawImageOnBoard MACRO image, imageWidth, imageHeight, row, column
    drawImage image, imageWidth, imageHeight, 80+row*20, column*20
ENDM drawImageOnBoard
;----------------------------------------------------------------------

drawImage MACRO image, imageWidth, imageHeight, x, y
LOCAL drawLoop
        LEA BX , image ; BL contains index at the current drawn pixel
	
    MOV CX,x
    MOV DX,y
    MOV AH,0ch
	
; Drawing loop
    drawLoop:
        MOV AL,[BX]
        INT 10h 
        INC CX
        INC BX
        CMP CX,imageWidth+x
    JNE drawLoop 
        
        MOV CX , x
        INC DX
        CMP DX , imageHeight+y
    JNE drawLoop
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

mainScreen MACRO hello, exclamation, name1, messageTemp, mes1, mes2, mes3, keypressed, image1, image1Width, image1Height, ism, boardWidth, boardHeight, greyCell, whiteCell
    
      
     mov ax, 0003h
     int 10h
     notificationBar hello, exclamation, name1, messageTemp                                              
     ;mov ah,1
;     int 21h        
;     
     

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
    ; Press any key to exit
    MOV AH , 0
    INT 16h
    
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
; include resZahran.inc
.model small
.386
.stack 64
.data

grid                                    db      12,13,14,15,16,14,13,12
                                        db      11,11,11,11,11,11,11,11
                                        db      00,00,00,00,00,00,00,00
                                        db      00,00,00,00,00,00,00,00
                                        db      00,00,00,00,00,00,00,00
                                        db      00,00,00,00,00,00,00,00
                                        db      01,01,01,01,01,01,01,01
                                        db      02,03,04,05,06,04,03,02

whiteCell                                          db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh

                                          db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh

                                          db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh

                                          db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh

                                          db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        
greyCell                                db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h                                                                                                                                                                                                        
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db      16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        
;Size: 20 x 20 
arrow_right                             db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,0ffh,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,36h,36h,36h,36h,36h,36h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

;Size: 20 x 20 
black_bishop                            db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,12h,12h,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,12h,12h,12h,12h,12h,12h,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh
                                        db    0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h

;Size: 20 x 20 
black_king                              db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh

;Size: 20 x 20 
black_knight                            db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,12h,12h,12h,12h,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh

;Size: 20 x 20 
black_pawn                              db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh

;Size: 20 x 20 
black_queen                             db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,12h,12h,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh

;Size: 20 x 20 
black_rock                              db    0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,12h,12h,12h,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh,0ffh,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,12h,0ffh

;Size: 20 x 20 
white_bishop                            db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0fh,0fh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh
                                        db    0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh

;Size: 20 x 20 
white_king                              db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh

;Size: 20 x 20 
white_knight                            db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh

;Size: 20 x 20 
white_pawn                              db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh

;Size: 20 x 20 
white_queen                             db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0fh,0fh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh

;Size: 20 x 20 
white_rock                              db    0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0ffh,0ffh,0ffh
                                        db    0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh,0ffh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0ffh




ism                                    db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,18h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,17h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h
                                        db    15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,1bh,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,16h,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,17h,19h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,1bh,07h,16h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,16h,19h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                                        db    07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,18h,07h,07h,19h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,17h,16h,16h,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,17h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,19h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h
                                        db    15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,17h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,1bh,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,17h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,17h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,16h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,16h,17h,15h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh
                                        db    07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,18h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,17h,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,17h,16h,16h,16h,16h,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,17h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,18h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h
                                        db    15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,15h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,19h,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,17h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,17h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,17h,16h,19h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                                        db    07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,18h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,17h,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,1eh,19h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,19h,16h,17h,16h,16h,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,15h,16h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1bh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,16h,16h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,15h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1dh,16h,15h,16h,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,18h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,07h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1ch,0fh,0fh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h
                                        db    1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,07h,17h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,19h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h
                                        db    15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,16h,07h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1bh,16h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,1bh,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,19h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,15h,18h,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch,1ch
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1ch,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh
                                        db    16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,1bh,1eh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,19h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1eh,17h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,15h,1dh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,1ch,15h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,07h,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh,0fh








    hello db "Hello, $"
    exclamation db "!$"
    enterName db 'Please enter your name:','$'
    pressEnter db 'Press Enter Key to continue','$'
    name1 db 30,?,30 dup('$') ;First byte is the size, second byte is the number of characters from the keyboard
    chIn db 'a'
    keypressed db ?   
    mes1 db "To Start Chatting Press 1$"
    mes2 db "To Start The Game Press 2$"
    mes3 db "To End The Program Press ESC$"
    messageF1 db " - You pressed F1$"
    messageF2 db " - You pressed F2$"
    messageTemp db ' - Temporary notification bar for now. Happy Hacking!$'
    boardWidth equ 160
    boardHeight equ 160
.code 

        
main proc far
    mov ax,@DATA
    mov ds,ax     

    usernameScreen enterName, pressEnter
    ;Go to Main screen
    ;TODO: go to main screen    

      
    mainScreen hello, exclamation, name1, messageTemp, mes1, mes2, mes3, keypressed, white_bishop, 20, 20, ism, boardWidth, boardHeight, greyCell, whiteCell


   


        mov ah,04ch
        int 21h
main    ENDP  




getName proc
            
            mov ch,0
            mov cl,0
            jmp getCh
            
    endByEnter:
            mov ah,0
            int 16h 
            jmp endGetName
            
    consumeBuffer:
            mov ah,0
            int 16h        
        
    getCh: ;read 1 ch
            mov ah,1
            int 16h   
            jnz validation
            jz getCh
     
            
    validation:
            cmp cl,0
            jz isLetter
            cmp ah,1ch
            jz endByEnter
            jmp echoIt
    
    isLetter:
            cmp al,65
            jl consumeBuffer
            cmp al,90
            jl echoIt
            cmp al,97
            jl consumeBuffer
            cmp al,122
            jg consumeBuffer
            ;Valid then echo        
    
    echoIt:
        mov ah,2
        mov dl,al
        int 21h
        inc cl
        ;store in data
        mov si,cx
        mov Name1[si+1],al
        cmp cl,15 ;no more ch needed
        jl consumeBuffer
    
    lastButton:   ;if name reached size limit
        call waitEnter
    
    endGetName:   ;store in data
        mov Name1[1],cl
            
    ret     
    endp getName

waitEnter proc
            
    jmp getButton
    popButton:
    ;pop the button (called after any input) 
        mov ah,0
        int 16h    
    ;Get Enter key
    getButton:    
        mov ah,1
        int 16h
        jnz Enter ;if user entered button it will jmp
        jmp getButton ;no button entered try again
    
    Enter:
        cmp ah,1ch
        jnz popButton ; if button is not Enter, repeat 
        ;button is Enter
        ;pop it from buffer       
        mov ah,0
        int 16h  
        
    ret     
    endp waitEnter 

end main   