.model small

.code
   public read_byte

   read_byte     proc
       xor ah,ah
       int 16h
       or al,al
       jz extended_code
not_extended:
       xor  ah,ah
done_reading:
       ret
extended_code:
       mov al,ah
       mov ah,1
       jmp done_reading
  read_byte      endp

    end
