 .286
 .model small
;--------------------------------------------------
; Graphic charachters for border of sector
;--------------------------------------------------
vertical_bar     equ   0bah
horizental_bar   equ   0cdh
upper_left       equ   0c9h
upper_right      equ   0bbh
lower_left       equ   0c8h
lower_right      equ   0bch
top_t_bar        equ   0cbh
bottom_t_bar     equ   0cah
top_tick         equ   0d1h
bottom_tick      equ   0cfh


 .data?
       extrn sector:byte

 .data
 top_line_pattern      label byte
        db ' ',7
        db upper_left,1
        db horizental_bar,12
        db top_tick,1
        db horizental_bar,11
        db top_tick,1
        db horizental_bar,11
        db top_tick,1
        db horizental_bar,12
        db top_t_bar,1
        db horizental_bar,18
        db upper_right,1
        db 0

 bottom_line_pattern   label byte
        db ' ',7
        db lower_left,1
        db horizental_bar,12
        db bottom_tick,1
        db horizental_bar,11
        db bottom_tick,1
        db horizental_bar,11
        db bottom_tick,1
        db horizental_bar,12
        db bottom_t_bar,1
        db horizental_bar,18
        db lower_right,1
        db 0


 .code
      public disp_half_sector
      extrn  send_crlf:proc
      ;Entery  DS:DX
      ;
      disp_half_sector       proc

           push cx
           push dx
           xor dx,dx
           mov cx,16
half_sector:
           call disp_line
           call send_crlf
           add dx,16
           loop half_sector
           pop dx
           pop cx
           ret 
      disp_half_sector      endp




     public disp_line
     extrn write_hex:proc
     extrn write_char:proc
     extrn write_char_n_times:proc
     
 ;writes 16 cell of ram
 ;
      disp_line   proc
            push bx
            push cx
            push dx
            
            xor bx,bx
            add bx,dx
            push bx
            ;;;;;;
            mov dl,' '
            mov cx,3
            call  write_char_n_times
            mov cx,16
            cmp bx,100h
            jb write_one
            mov dl,'1'
  write_one:
            call write_char
            mov dl,bl
            call write_hex

            mov dl,' '
            call write_char
            mov dl,vertical_bar
            call write_char
            mov dl,' '
            call write_char
            

  hex_loop:
           mov dl,sector[bx]
           call write_hex
           mov dl,' '
           call write_char
           inc bx
           loop hex_loop

           mov dl,vertical_bar
           call write_char

           mov dl,' '
           call write_char
           mov cx,16
           pop bx
ascii_loop:
           mov dl,sector[bx]
           call write_char
           inc bx
           loop ascii_loop

           mov dl,' '
           call write_char
           mov dl,vertical_bar
           call write_char
           pop dx
           pop cx
           pop bx
           ret
           
    disp_line    endp

      public init_sec_disp
       extrn write_pattern:proc,send_crlf:proc
       extrn goto_xy:proc,write_phantom:proc
       .data
         extrn lines_before_sector:byte
         extrn sector_offset:word
      .code 
      init_sec_disp   proc
         push dx
         xor dl,dl
         mov dh,lines_before_sector
         mov dh,2
         call goto_xy
         call write_top_hex_numbers
         lea dx,top_line_pattern
         call write_pattern
         call send_crlf
         xor dx,dx
         mov sector_offset,dx
         call disp_half_sector
         lea dx,bottom_line_pattern
         call write_pattern
         call write_phantom
         pop dx
         ret
  init_sec_disp   endp 
 extrn write_char_n_times:proc,write_hex:proc,write_char:proc
 extrn write_hex_digit:proc,send_crlf:proc
 ; write_top_hex_numbers
 write_top_hex_numbers       proc
       push cx
       push dx
       mov dl,' '
       mov cx,9
       call write_char_n_times
       xor dh,dh

hex_number_loop:
       mov dl,dh
       call write_hex
       mov dl,' '
       call write_char
       inc dh
       cmp dh,10h
       jb hex_number_loop

       mov dl,' '
       mov cx,2
       call write_char_n_times
       xor dl,dl
hex_digit_loop:
       call write_hex_digit
       inc dl
       cmp dl,10h
       jb hex_digit_loop
       call send_crlf
       pop dx
       pop cx
       ret
write_top_hex_numbers       endp

     public write_header
     .data
          extrn header_line_no:byte
          extrn header_part_1:byte
          extrn header_part_2:byte
          extrn disk_drive_no:byte
          extrn current_sector_no:word
     .code
        extrn write_string:proc,write_decimal:proc
        extrn goto_xy:proc,clear_to_end_of_line:proc

        write_header     proc
          push dx
          xor dl,dl
          mov dh,header_line_no
          call goto_xy
          lea dx,header_part_1
          call write_string
          mov dl,disk_drive_no
          add dl,'A'
          call write_char
          lea dx,header_part_2
          call write_string
          mov dx,current_sector_no
          call write_decimal
          call clear_to_end_of_line
          pop dx
          ret
        write_header     endp

     end 

       
