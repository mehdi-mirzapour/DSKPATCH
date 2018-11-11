.model small

.code

.data
  extrn sector:byte
  extrn sector_offset:word
  extrn phantom_cursor_x:byte
  extrn phantom_cursor_y:byte

  .code

  write_to_memory    proc
    push ax
    push bx
    push cx
    mov bx,sector_offset
    mov al,phantom_cursor_y
    xor ah,ah
    mov cl,4
    shl ax,cl
    add bx,ax
    mov al,phantom_cursor_x
    xor ah,ah
    add bx,ax
    mov sector[bx],dl
    pop cx
    pop bx
    pop ax
    ret
    write_to_memory  endp

    public edit_byte
      extrn save_real_cursor:proc,restore_real_cursor:proc
      extrn mov_to_hex_position:proc,mov_to_ascii_position:proc
      extrn write_phantom:proc,write_prompt_line:proc
      extrn cursor_right:proc,write_hex:proc,write_char:proc
    .data
     extrn editor_prompt:byte
    .code
     edit_byte     proc
      push  dx
      call save_real_cursor
      call mov_to_hex_position
      call cursor_right
      call write_hex
      call mov_to_ascii_position
      call write_char
      call restore_real_cursor
      call write_phantom
      call write_to_memory
      lea dx,editor_prompt
      call write_prompt_line
      pop dx
      ret
     edit_byte      endp

         end
