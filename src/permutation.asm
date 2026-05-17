; Permutation : P(n,k) : Number of ways to select 'k' objects from the set of 'n' elements in order
; Falling factorial :  n! / (n-k)! = n(n-1)(n-2)...(n-k+1)  

default rel

extern _CRT_INIT,printf,scanf
global main

segment .data
  msg db 0xA,"P(n,k): ",0
  fmt db "%d %d",0
  ans db "Ans : %lld",0xA,0xA,0 


segment .text
  
; ecx = n , edx = k 
permuation:
  
  mov r8d,ecx 
  sub r8d,edx 
  mov rax, 1 

.loop:
  imul rax,rcx 
  dec  ecx 
  cmp  ecx,r8d
  jg .loop    ; till (n-k+1) 

ret

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
  call permuation

  mov rdx,rax 
  lea rcx,[ans]
  call printf 

  xor eax,eax 
  add rsp,0x28
  ret 
