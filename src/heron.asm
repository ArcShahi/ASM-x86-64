; Heron's formula for Triangle's area
default rel

extern _CRT_INIT,prinf,scanf
global main

segment .data
  
  msg db "Type sides(a,b,c): ",0xA,0
  fmt db "%f %f %f",0
  ans db "Area: %f",0xA,0
  two dd 0.5 

segment .text
  
; area(xmm0a,xmm1=b,xmm2=c) 
area:

  xorps xmm3,xmm3 
  addss xmm3,xmm2 
  addss xmm3,xmm1
  addss xmm3,xmm0 
  mulss xmm3,[two] ; S = ( a + b + c ) / 2 

  movss xmm4,xmm3 
  subss xmm4,xmm0 ; (s-a)
  movss xmm5,xmm3 
  subss xmm5,xmm1 ; (s-b)
  mulss xmm4,xmm5 ; (s-a)(s-b)
  movss xmm5,xmm3
  subss xmm5,xmm2 ; (s-c) 
  mulss xmm4,xmm5 ; (s-a)(s-b)(s-c) 
  mulss xmm3,xmm4 

  sqrtss xmm0,xmm3 ; sqrt(fuckall) 

  ret 

main:
 sub rsp,0x38 ; 56B : 32 B shadow space + 12B Local + 8B ret add + 12B Padding for Alignment 
 call _CRT_INIT

 lea rcx,[msg]
 call printf

 lea rcx,[fmt]
 lea rdx,[rsp+0x34] ; &a 
 lea r8, [rsp+0x30] ; &b 
 lea r9, [rsp+0x2C] ; &c 
 call scanf

 movss xmm0,dword[rsp+0x34]
 movss xmm1,dword[rsp+0x30]
 movss xmm2,dword[rsp+0x2C]
 call area 

 ; convert single scaler to single double 
 cvtss2sd xmm1,xmm0    ; printf %f is for double precision, not single precision wtf ?!
 movq rdx,xmm1         ; printf is varargs function : so must mirror values in integer reg
 lea rcx,[ans]
 call printf

 xor eax,eax 
 add rsp,0x38 
 ret 
