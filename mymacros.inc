;--------------------------------
; Macro to move cursor to certain position
; Takes position as parameter
moveCursor MACRO position    
    mov ah, 2
    mov dx, position
    int 10h             ; use interrupt 10/2, dx contains position
ENDM moveCursor
;----------------------------------

;--------------------------------------
; Macro to print string
; Takes message as parameter
printString MACRO message
    mov ah, 9
    mov dx, offset messageF1
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
notificationBar MACRO messageF1, messageF2
    moveCursor 1700h        ; move the cursor to row 22 column 0
    
    printCharColorTimes '-', 80, 0fh  ; Print '-' with white foreground black background 80 times (whole screen width)
    
    moveCursor 1800h

CHECK: 
    mov ah,0ch
    mov al,0
    int 21h
    mov ah, 1
    int 16h
    jz CHECK
    cmp ah, 3bh
    je PRINTMESSAGEF1
    cmp ah, 3ch
    je PRINTMESSAGEF2
    jmp CHECK

PRINTMESSAGEF1:
    moveCursor 1800h
    printCharColorTimes ' ', 80, 0fh
    moveCursor 1800h
    mov ah, 9
    mov dx, offset messageF1
    int 21h
    jmp CHECK

PRINTMESSAGEF2:
    moveCursor 1800h
    printCharColorTimes ' ', 80, 0fh
    moveCursor 1800h
    mov ah, 9
    mov dx, offset messageF2
    int 21h
    jmp CHECK
ENDM notificationBar
;-----------------------------------