; Example of unsigned division
default rel

segment .data
  ans db"QUOT: %lld",0xA,0

segment .text

extern _CRT_INIT,printf
global main


quotient:

   push rbx
   mov rax,rcx
   mov rbx,rdx
   xor rdx,rdx
   div rbx
  
   pop rbx
   ret 


main:
  sub rsp,0x28
  call _CRT_INIT


  mov rcx,0x45
  mov rdx,0x10
  call quotient 
  
  lea rcx,[ans]
  mov rdx,rax
  call printf

  xor rax,rax
  add rsp,0x28
  ret


  
