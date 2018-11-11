.model small

.data
 real_cursor_x    db  0
 real_cursor_y    db  0
  public phantom_cursor_x,phantom_cursor_y  
 phantom_cursor_x   db  0
 phantom_cursor_y   db  0

 .code
     public mov_to_hex_position
     extrn  goto_xy:proc
 .data
    extrn lines_before_sector:byte
 .code

  mov_to_hex_position     proc
   push ax
   push cx
   push dx
   mov dh,lines_before_sector
   add dh,2
   add dh,phantom_cursor_y
   mov dl,8
   mov cl,3
   mov al,phantom_cursor_x
   mul cl
   add dl,al
   call goto_xy
   pop dx
   pop cx
   pop ax
   ret
   mov_to_hex_position    endp

   public mov_to_ascii_position     
       extrn goto_xy:proc
    .data
    extrn lines_before_sector:byte
    .code
    mov_to_ascii_position  proc
     push ax
     push dx
     mov dh,lines_before_sector
     add dh,2
     add dh,phantom_cursor_y
     mov dl,59
     add dl,phantom_cursor_x
     call goto_xy
     pop dx
     pop ax
     ret
    mov_to_ascii_position  endp

    public save_real_cursor
     save_real_cursor   proc
     push ax
     push bx
     push cx
     push dx
     mov ah,3
     xor bh,bh
     int 10h
     mov real_cursor_y,dl
     mov real_cursor_x,dh
     pop dx
     pop cx
     pop bx
     pop ax
     ret
     save_real_cursor    endp

     public restore_real_cursor
      extrn goto_xy:proc
     restore_real_cursor   proc
      push dx
      mov dl,real_cursor_y
      mov dh,real_cursor_x
      call goto_xy
      pop dx
      ret 
     restore_real_cursor   endp

     public write_phantom
      extrn write_attribute_n_times:proc

      write_phantom    proc
       push cx
       push dx
       call save_real_cursor
       call mov_to_hex_position
       mov cx,4
       mov dl,70h
       call write_attribute_n_times
       call mov_to_ascii_position
       mov cx,1
       call write_attribute_n_times
       call restore_real_cursor
       pop dx
       pop cx
       ret
      write_phantom   endp

      public erase_phantom
      extrn write_attribute_n_times:proc

      erase_phantom     proc
      push cx
      push dx
      call save_real_cursor
      call mov_to_hex_position
      mov cx,4
      mov dl,7
      call write_attribute_n_times
      call mov_to_ascii_position
      mov cx,1
      call write_attribute_n_times
      call restore_real_cursor
      pop dx
      pop cx
      ret
      erase_phantom  endp

      public phantom_up

      phantom_up   proc
        call erase_phantom
        dec phantom_cursor_y
        jns wasnt_at_top
        mov phantom_cursor_y,0
     wasnt_at_top:
        call write_phantom
        ret
      phantom_up  endp

      public phantom_down

      phantom_down   proc
        call erase_phantom
        inc phantom_cursor_y
        cmp phantom_cursor_y,16
        jb wasnt_at_bottom
        mov phantom_cursor_y,15
     wasnt_at_bottom:
        call write_phantom
        ret
      phantom_down  endp

      public phantom_left

      phantom_left   proc
        call erase_phantom
        dec phantom_cursor_x
        jns wasnt_at_left
        mov phantom_cursor_x,0
     wasnt_at_left:
        call write_phantom
        ret
      phantom_left  endp

       public phantom_right

      phantom_right   proc
        call erase_phantom
        inc phantom_cursor_x
        cmp phantom_cursor_x,16
        jb wasnt_at_right
        mov phantom_cursor_x,15
     wasnt_at_right:
        call write_phantom
        ret
      phantom_right  endp

      end

