; check if a point is on / inside  a circle
default rel

extern _CRT_INIT,printf,scanf
global main 

segment .data
  msg db "Gimme Point(x,y): ",0xA,0
  msg1 db "Gimme Circle(a,b,r):",0xA,0
  fmt db "%f%f",0
  fmt1 db "%f%f%f",0
  ans0 db "Point NOT inside  or on circle",0xA,0 
  ans1 db "Point's inside or on circle",0xA,0 


segment .text 
 
; in_circle(xmm0=x,xmm1=y,xmm2=a,xmm3=b,xmm4=r) : custom calling convention
; (x-a)^2 + (y-b)^2 <= r^2
in_circle:
    xor eax, eax

    vsubss xmm0,xmm0, xmm2        
    vmulss xmm0,xmm0, xmm0        ; (x-a)^2
    vsubss xmm1,xmm1, xmm3        
    vmulss xmm1,xmm1, xmm1        ; (y-b)^2
    vaddss xmm0,xmm0, xmm1        ; lhs 
    vmulss xmm4, xmm4,xmm4        ; r^2
    vcomiss xmm0, xmm4            ; lhs <= r^2 ?
    setbe al 
    ret

main:
  sub rsp,0x38; 56B : (32B Shadow + 20B Local + 4B Padding) +  8B ret addr = 64 % 16==0 Aligned
  call _CRT_INIT 

  lea rcx,[msg]
  call printf 

  lea rcx,[fmt]
  lea rdx,[rsp+0x34] ; x  
  lea r8 ,[rsp+0x30] ; y 
  call scanf 

  lea rcx,[msg1]
  call printf 

  lea rcx,[fmt1]
  lea rdx,[rsp+0x2C] ; a 
  lea r8 ,[rsp+0x28] ; b 
  lea r9 ,[rsp+0x24] ; r 
  call scanf 

  ; mov float value 
  vmovss xmm0,dword[rsp+0x34] 
  vmovss xmm1,dword[rsp+0x30]
  vmovss xmm2,dword[rsp+0x2C]
  vmovss xmm3,dword[rsp+0x28]
  vmovss xmm4,dword[rsp+0x24]
  call in_circle

  lea rcx,[ans1]
  lea rdx,[ans0]
  test al,al    ; if zero then not in/on cirlce
  cmovz rcx,rdx ; Load correct msg when in circle 
  call printf 

  xor eax,eax 
  add rsp,0x38
  ret 
