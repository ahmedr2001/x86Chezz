include mymacros.inc

.model small
.stack 64
.data
messageF1 db 'You F1', '$'
messageF2 db 'You pressed F2', '$'
.code
main proc far
    mov ax, @DATA
    mov ds, ax

    mov ax, 0003
    int 10h

    notificationBar messageF1, messageF2
    mov ah, 04ch
    int 21h
main endp
    end main    