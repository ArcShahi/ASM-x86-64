; Project Euler 6 : Find the difference between the sum of the squares of the first one hundred natural numbers and the square of the sum.
bits 64
default rel

segment .data
   ans db "Ans: %ld",0XA,0
   N   dd 0x64  

segment .text
  
  extern _CRT_INIT
  extern printf
  global main


sln:
  ; Sum of squares in ramng [1,100] = n(n+1)(2n+1)/6
  mov rcx,[N]
  inc rcx 
  imul rcx,[N]        ; rcx= n(n+1)
  mov rax,[N]         ; rax = n 
  lea rax,[rax+rax+1] ; rax = 2n+1
  imul rax,rcx        ; rax = n(n+1)(2n+1)

  cqo 
  mov ecx,0x6
  idiv rcx            ; rax = n(n+1)2(n+1)/6

 ; Square of numbers in range [1,100] = (n(n+1)/2)^2 

  mov rcx ,[N] 
  inc rcx 
  imul rcx,[N]        ; rcx = n(n+1)
  shr rcx , 1         ; rcx = n(n+1)/2 
  imul rcx,rcx        ; rcx = (n(n+1)/2)^2 

  ; The difference 
  sub rcx,rax         ; rcx-=rax 
  mov rax,rcx 
  ret


main:
  sub rsp,0x28 
  call _CRT_INIT

  call sln
  lea rcx,[ans]
  mov rdx,rax 
  call printf 

  add rsp,0x28
  xor eax,eax
  ret


