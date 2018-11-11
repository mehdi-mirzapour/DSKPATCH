dosseg
.model small
.stack
.286

.data
 public sector_offset
  sector_offset   dw 0

  public current_sector_no,disk_drive_no
  current_sector_no  dw 0
  disk_drive_no   dw 0

  public lines_before_sector,header_line_no
  public header_part_1,header_part_2

  lines_before_sector   db  2
  header_line_no        db  0
  header_part_1           db  'Disk ',0
  header_part_2           db  '        Sector ',0
   public prompt_line_no,editor_prompt
   prompt_line_no  db 21
   editor_prompt   db 'Press function key, or enter '
                   db ' character or hex byte:',0
  .data?
      public sector
      sector db 8192 dup (?)

    .code
      extrn clear_screen:proc,read_sector:proc
      extrn init_sec_disp:proc,write_header:proc
      extrn write_prompt_line:proc,dispatcher:proc

    disk_patch  proc
       mov ax,dgroup
       mov ds,ax

       call clear_screen
       call write_header
       call read_sector
       call init_sec_disp
       lea dx,editor_prompt
       call write_prompt_line
       call dispatcher

       mov ah,4ch
       int 21h
    disk_patch  endp

    end disk_patch


