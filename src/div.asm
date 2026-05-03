; Example of unsigned division
default rel

extern _CRT_INIT,printf,scanf 
global main 

segment .data
  msg db "(x/y) : ",0
  fmt db "%d%d",0
  ans db"Ans: %d ",0xA,0

segment .text

; ecx=x edx=y -> eax= x/y 
quotient:
   mov eax,ecx ; move dividend in eax , cuz implied operand is RDX:RAX 
   mov ecx,edx ; save divisor 
   xor edx,edx ; zero extend EAX->EDX 
   div rcx     ; EDX:EAX / ECX 
   ret         ; eax = Quotient 


main:
  sub rsp,0x28
  call _CRT_INIT

  lea rcx,[msg]
  call printf

  lea rcx,[fmt]
  lea rdx,[rsp+0x24]
  lea r8 ,[rsp+0x20]
  call scanf 

  mov ecx,dword[rsp+0x24]
  mov edx,dword[rsp+0x20]
  call quotient 
  
  lea rcx,[ans]
  mov edx,eax 
  call printf

  xor eax,eax
  add rsp,0x28
  ret


  
