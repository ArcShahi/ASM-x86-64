; Combination - C(n,k) : Number of ways to select 'k' objects from set of 'n' elements
; n! / k!(n-k)!  = P(n,k) / k! = n(n-1)(n-2)...(n-k+1) / k! 
default rel

extern _CRT_INIT,printf,scanf
global main

segment .data
  msg db 0xA,"C(n,k): ",0
  fmt db "%d %d",0
  ans db "Ans : %lld",0xA,0xA,0 


segment .text 

combination:
   mov r8d,ecx 
   mov r9d,edx 

   ; calculate k! 
   mov rax, 1 
.loop:
  imul rax,r9
  dec r9d 
  cmp r9d, 1 
  jne .loop

  mov r9,rax  ; k! 

  ; calculate falling factorial
  sub r8d,edx 
  mov rax , 1 
.loop2:
  imul rax,rcx
  dec  ecx
  cmp ecx, r8d 
  jg .loop2 

  ; P(n,k) / k! 
  cqo 
  idiv r9 
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
  call combination

  mov rdx,rax 
  lea rcx,[ans]
  call printf 

  xor eax,eax 
  add rsp,0x28
  ret 
  



