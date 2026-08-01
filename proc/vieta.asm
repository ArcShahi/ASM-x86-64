; Implementation of Vieta's formuls for finding coefficients of quadratic given 2 roots 

default rel

extern _CRT_INIT,printf,scanf 
global main

segment .data
  msg db "Gimme roots (r1,r2): ",0
  fmt db "%lf %lf",0 
  ans db "Coefficients : a = 1 , b = %g , c = %g",0xA,0xA,0 
  neg1 dq -1.00

segment .bss
  b resq 1
  c resq 1 

segment .text 

; xmm0=r1 , xmm1=r2 
coefficients:
  
  ; Assuming a=1 , for simplicity 
  ; Sum of roots : r1 + r2  = -b / a 
  ; b = -a(r1+r2)
  vaddsd xmm2,xmm0,xmm1 
  vmulsd xmm2,xmm2,[neg1]
  vmovsd qword[b],xmm2 

  ;Product of roots : r1r2 = c / a 
  ;c = a(r1r2)
  vmulsd xmm2,xmm0,xmm1 
  vmovsd qword[c],xmm0  
  ret 

main:
  sub rsp,0x38 ; 56B : 32B Shadow + 16B Local + 8B Padding; + 8B retaddr = 64B 
  call _CRT_INIT

  lea rcx,[msg]
  call printf

  lea rcx,[fmt]
  lea rdx,[rsp+0x30]
  lea r8,[rsp+0x28]
  call scanf

  vmovsd xmm0,qword[rsp+0x30]
  vmovsd xmm1,qword[rsp+0x28]
  call coefficients 

  lea rcx,[ans]
  vmovsd xmm1,[b]
  vmovsd xmm2,[c]
  mov rdx,[b]
  mov r8, [c]
  call printf 

  xor eax,eax 
  add rsp,0x38
  ret 
