; memcpy implementation
default rel

extern _CRT_INIT,printf,scanf
global main

segment .data
  src dd 69 
  ans db "SRC=%d ,DEST=%d ",0xA,0 

segment .bss 
  dest resd 1

segment .text
;memcpy(rcx=*dest,rdx=*src,r8=count)
memcpy:

 test r8,r8
 jz .done

 .loop:
    dec r8 
    mov al,byte[rdx+r8]
    mov byte[rcx+r8], al 
    test r8,r8
    jns .loop ; jumps if SF=0 , r8 >=0 

 .done:
    ret     
  
main:
  sub rsp,0x28 

  lea rcx,[dest]
  lea rdx,[src]
  mov r8, 4 
  call memcpy

  lea rcx,[ans]
  mov edx,[src]
  mov r8d,[dest]
  call printf

  add rsp,0x28
  ret 
