.model small
.data
keypressed db ?   
mes1 db "To Start Chatting Press 1$"
mes2 db "To Start The Game Press 2$"
mes3 db "To End The Program Press ESC$"

.code
main proc
     
     mov ax,@data
     mov ds,ax
    
     mov ax, 0003h
     int 10h
     ;mov ah,1
;     int 21h        
;     

     mov ah,5
     mov al,1
     int 10h
            
     ;set cursor position       
     mov ah,2
     mov dh,4  ;row
     mov dl,25
     mov bh,1
     int 10h
     
     ;display string
     mov ah,9
     mov dx,offset mes1
     int 21h    
     
     
     ;set cursor position       
     mov ah,2
     mov dh,6  ;row
     mov dl,25
     mov bh,1
     int 10h

     ;display string     
     mov ah,9
     mov dx,offset mes2
     int 21h  
     
     
     
     
     ;set cursor position       
     mov ah,2
     mov dh,8  ;row
     mov dl,25
     mov bh,1
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
     jmp consumebuffer


     f2:
     cmp al,32h
     jnz escape
     ;code here for entring game mode
     mov keypressed,al

     ;to consume the buffer
     jmp consumebuffer


     escape:
     cmp al,1bh  
     jnz consumebuffer
     ;code here
     mov keypressed,al
     ;
     ;terminate the program
     mov ah, 4ch
     int 21h

    ;to consume the buffer
     jmp consumebuffer   
      
                     
     consumebuffer:  
     mov ah,0
     int 16h
     jmp checkkey

                      

    
main endp
end main
