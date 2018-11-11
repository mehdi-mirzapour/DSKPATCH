
.model small
.code
      
      ; This procedure writes DL in bin
      ; Entry : DL         

      PUBLIC  write_bin

      write_bin  proc 
                push ax
                push bx
                push cx
                push dx
                mov bl,dl               
                mov ah,2
                mov cx,8
         wbl1:  
                mov dl,0
                rcl bl,1
                adc dl,'0'
                int 21h
                loop wbl1 
                pop dx 
                pop cx
                pop bx 
                pop ax
                ret
      write_bin  endp
  
      ; This procedure write DL in hex
      ; entry : DL

      PUBLIC write_hex

      write_hex proc
               push cx
               push dx
               mov dh,dl
               mov cx,4
               shr dl,cl
               call write_hex_digit
               mov dl,dh
               and dl,0fh
               call write_hex_digit
               pop dx
               pop cx
               ret
      write_hex endp


      ; Procedure for writing DL
      ; Entry : DL (4bit Only)

      public write_hex_digit

      write_hex_digit     proc
                   push dx
                   cmp dl,10
                   jae hex_letter
                   add dl,'0'
                   jmp write_digit
     hex_letter:
                   add dl,'A'-10
     write_digit:
                   call write_char
                   pop dx
                   ret
     write_hex_digit     endp




      ; Procedure for writing charachter
      ; Entery :DL 
      
      PUBLIC write_char
       extrn cursor_right:proc
      write_char proc
        push ax
        push bx
        push cx
        push dx

        mov ah,9
        mov bh,0
        mov cx,1
        mov al,dl
        mov bl,7
        int 10h
        call cursor_right
        pop dx
        pop cx
        pop bx
        pop ax
        ret
      write_char endp
                
     ;This procedure writes DX in decimal 
     ;Entry : DX

    PUBLIC write_decimal

    write_decimal   proc
         push ax
         push cx
         push dx
         push di

         mov ax,0
         mov cx,0
         mov di,10
         xchg dx,ax
  wdl1:  div di
         push dx
         mov dx,0
         inc cx
         and ax,0ffffh
         jnz wdl1
  wdl2:
         pop dx
         mov ah,2
         add dx,'0'
         int 21h
         loop wdl2
         
         pop di
         pop dx
         pop cx
         pop ax
         ret
    write_decimal  endp

    public write_char_n_times
    ; On entry : DL charchter     CX:Number
    ;
     write_char_n_times   proc  
     push cx
     n:
      call write_char
      loop n
      pop cx
      ret
    write_char_n_times  endp

    public write_pattern

    ;DS:DX

    write_pattern   proc
          push ax
          push cx
          push dx
          push si
          pushf
          cld
          mov si,dx
  pattern_loop:
          lodsb
          or al,al
          jz end_pattern
          mov dl,al
          lodsb
          mov cl,al
          xor ch,ch
          call write_char_n_times
          jmp pattern_loop
  end_pattern:
          popf
          pop si
          pop dx
          pop cx
          pop ax
          ret
   write_pattern  endp

    public write_string
     write_string    proc
         push ax
         push dx
         push si
         pushf
         cld
         mov si,dx
     strloop:
         lodsb
         or al,al
         jz endstr
         mov dl,al
         call write_char
         jmp strloop
     endstr:
         popf
         pop si
         pop dx
         pop ax
         ret
     write_string   endp

     public write_prompt_line
     extrn clear_to_end_of_line:proc
     extrn goto_xy:proc

     .data
       extrn prompt_line_no:byte
     .code
      write_prompt_line     proc
      push dx
      xor dl,dl
      mov dh,prompt_line_no
      call goto_xy
      pop dx
      call write_string
      call clear_to_end_of_line
      ret
      write_prompt_line     endp

     public write_attribute_n_times
      extrn cursor_right:proc
      write_attribute_n_times   proc
      push ax
      push bx
      push cx
      push dx
      mov bl,dl
      xor bh,bh
      mov dx,cx
      mov cx,1
 attr_loop:
      mov ah,8
      int 10h
      mov ah,9
      int 10h
      call cursor_right
      dec dx
      jnz attr_loop
      pop dx
      pop cx
      pop bx
      pop ax
      ret
   write_attribute_n_times    endp

  end
