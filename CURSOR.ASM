 CR equ 13
 LF equ 10
 .model small
 .286
 .code
     public send_crlf

     send_crlf     proc
       push  ax
       push  dx
       mov ah,2
       mov dl,CR
       int 21h
       mov dl,lf
       int 21h
       pop dx
       pop ax
       ret
     send_crlf    endp

       
     public clear_screen
      
     clear_screen   proc
       push ax
       push bx
       push cx
       push dx
       xor al,al
       xor cx,cx
       mov dh,24
       mov dl,79
       mov bh,7
       mov ah,6
       int 10h
       pop dx
       pop cx
       pop bx
       pop ax
       ret
    clear_screen    endp

     public goto_xy
       goto_xy   proc
            push ax
            push bx
            mov bh,0
            mov ah,2
            int 10h

            pop bx
            pop ax
            ret
       goto_xy  endp

       public cursor_right

       cursor_right     proc
           push ax
           push bx
           push cx
           push dx
           mov ah,3
           mov bh,0
           int 10h
           mov ah,2
           inc dl
           cmp dl,79
           jbe ok
           call send_crlf
           jmp done
           ok: int 10h
           done:
           pop dx
           pop cx
           pop bx
           pop ax
           ret
       cursor_right    endp

     public clear_to_end_of_line

     clear_to_end_of_line  proc
      pusha
      mov ah,3
      xor bh,bh
      int 10h
      mov ah,6
      xor al,al
      mov ch,dh
      mov cl,dl
      mov dl,79
      mov bh,7
      int 10h
      popa
      ret
      clear_to_end_of_line  endp
end

