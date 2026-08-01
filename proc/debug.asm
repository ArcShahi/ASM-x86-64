 
default rel

extern _CRT_INIT,printf
extern splitmix64
global main 

segment .data
  ans db "RAND = %llu ",0xA,0

segment .text

main:
  sub rsp,0x28 
  call _CRT_INIT

  mov rcx,69430 ; Seed 
  call splitmix64

  lea rcx,[ans]
  mov rdx,rax 
  call printf 

  xor eax,eax 
  add rsp,0x28 
  ret 
