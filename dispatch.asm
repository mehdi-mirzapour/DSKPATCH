.model small
.code
  extrn next_sector:proc
  extrn previous_sector:proc
  extrn phantom_up:proc,phantom_down:proc
  extrn phantom_left:proc,phantom_right:proc
.data

 dispatch_table   label byte
                   
                  db 61
                  dw offset _text:previous_sector
                  db 62
                  dw offset _text:next_sector
                  db 72
                  dw offset _text:phantom_up
                  db 80
                  dw offset _text:phantom_down
                  db 75
                  dw offset _text:phantom_left
                  db 77
                  dw offset _text:phantom_right
                  db 0

 .code

   public dispatcher
   extrn read_byte:proc,edit_byte:proc

   dispatcher      proc
       push ax
       push bx
       push dx
 dispatch_loop:
       call read_byte
       or ah,ah

       js dispatch_loop
       jnz special_key
       mov dl,al
       call edit_byte
       jmp dispatch_loop
 special_key:
       cmp al,68
       je end_dispatch
       lea bx,dispatch_table
 special_loop:
        cmp byte ptr[bx],0
        je not_in_table
        cmp al,[bx]
        je dispatch
        add bx,3
        jmp special_loop
  dispatch:
         inc bx
         call word ptr [bx]
         jmp dispatch_loop
  not_in_table:
          jmp dispatch_loop
  end_dispatch:
         pop dx
         pop bx
         pop ax
         ret
dispatcher      endp

 end



