;Author:Mohammed Taher
;Defining username screen
;---------------------------
.model small
.stack 64
.data
    enterName db 'Please enter your name:','$'
    pressEnter db 'Press Enter Key to continue','$'
    name1 db 30,?,30 dup('$') ;First byte is the size, second byte is the number of characters from the keyboard
    chIn db 'a'
.code 

        
main proc far             
    mov ax,@data
    mov ds,ax     
             
;cursor on position x = 2 and y = 2         
    mov ah,2
    mov dl,02d
	mov dh,02d
    int 10h  
    
;displays the prompt "Please enter your name:"
    mov ah, 9	
    mov dx, offset enterName
    int 21h
    
;cursor on position x = 6 and y = 4         
    mov ah,2
    mov dl,06d
	mov dh,04d				
    int 10h

;gets a response from the keyboard
   call getName
   
;cursor on position x = 2 and y = 20    
    mov ah,2          
    mov dl,02d		
	MOV dh,20d      
    int 10h
                 
;Display "Press Enter Key to continue"
    mov dx, offset pressEnter
    mov ah, 9
    int 21h

;Wait for enter key
call waitEnter

;Go to Main screen
    ;TODO: go to main screen                                  

        HLT
MAIN    ENDP  




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

   