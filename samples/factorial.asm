; Program to calculate factorial of a number
default rel

extern _CRT_INIT,printf,scanf 
global main

segment .data
msg db "Gimme num: ",0xA,0
fmt db "%d",0
ans db "Factorial : %d",0xA,0

segment .text

; factorial(int n);
factorial:
  mov eax,1 
  
.loop:
   imul eax,ecx
   lea ecx,[ecx-1] 
   cmp ecx,1 
   jne .loop

   ret

main:
  
  sub rsp,0x28
  
  lea rcx,[msg]
  call printf

  lea rcx,[fmt]
  lea rdx,[rsp+0x24] ; local var 4 Byte( singned int)
  call scanf

  mov rcx,[rsp+0x24]
  call factorial

  mov edx,eax
  lea rcx,[ans]
  call printf

  xor eax,eax 
  add rsp,0x28
  ret
