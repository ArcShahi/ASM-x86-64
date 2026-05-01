;Project Euler 0 :Among the first 'n' thousand square numbers, what is the sum of all the odd squares?

bits 64
default rel

extern _CRT_INIT,printf,scanf
global main

segment .data
 ans db "ANS : %lld",0xA,0
 fmt db "%d",0

segment .bss
  n resd 1

segment .text

solve:
    sar rcx, 1              ; m = n/2 
    mov rax, rcx            ; rax = m
    lea rax, [rax+rax - 1]    ; 2m-1
    imul rax, rcx           ; m*(2m-1)
    lea rcx, [rcx+rcx + 1]    ; 2m+1
    imul rax, rcx           ; m*(2m-1)*(2m+1)
    cqo                     ; sign-extend rax into rdx:rax
    mov rcx, 3
    idiv rcx                ; rax = result / 3  
    ret

main:
  sub rsp,0x28
  call _CRT_INIT

  lea rcx,[fmt]
  lea rdx,[n]
  call scanf

  mov rcx,[n]
  call solve

  mov rdx,rax

  lea rcx,[ans]
  call printf

  xor eax,eax 
  add rsp,0x28
  ret

  

