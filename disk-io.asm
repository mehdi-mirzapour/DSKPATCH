 .model small
 .data
   extrn sector:byte
   extrn disk_drive_no:byte
   extrn current_sector_no:word

   public  read_sector

  .code
  read_sector      proc
     push ax
     push bx
     push cx
     push dx

     mov al,disk_drive_no
     mov cx,1
     mov dx,current_sector_no
     lea bx,sector
     int 25h
     popf

     pop dx
     pop cx
     pop bx
     pop ax
     ret
  read_sector      endp

   public previous_sector
    extrn init_sec_disp:proc,write_header:proc
    extrn write_prompt_line:proc
    .data
     extrn current_sector_no:word,editor_prompt:byte
    .code
     previous_sector   proc
      push ax
      push dx
      mov ax,current_sector_no
      or ax,ax
      jz dds
      dec ax
      mov current_sector_no,ax
      call write_header
      call read_sector
      call init_sec_disp
      lea dx,editor_prompt
      call write_prompt_line
  dds:
      pop dx
      pop ax
      ret
    previous_sector      endp


   public next_sector
    extrn init_sec_disp:proc,write_header:proc
    extrn write_prompt_line:proc
    .data
     extrn current_sector_no:word,editor_prompt:byte
    .code
     next_sector   proc
      push ax
      push dx
      mov ax,current_sector_no
      inc ax
      mov current_sector_no,ax
      call write_header
      call read_sector
      call init_sec_disp
      lea dx,editor_prompt
      call write_prompt_line
      pop dx
      pop ax
       ret
    next_sector      endp


  end
