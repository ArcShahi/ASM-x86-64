; ... And the journey starts
default rel

extern _CRT_INIT,printf
global main

segment .data
  msg db 0xA,"Hello ASM x86-64 ;)",0xA,0XA,0 ; 0XA = \n; 0 = NULL

segment .text


main:
  sub rsp,0x28
  call _CRT_INIT

  lea rcx,[msg]
  call printf

  xor eax,eax
  add rsp,0x28
  ret 
