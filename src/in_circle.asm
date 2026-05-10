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

    subss xmm0, xmm2        
    mulss xmm0, xmm0        ; (x-a)^2
    subss xmm1, xmm3        
    mulss xmm1, xmm1        ; (y-b)^2
    addss xmm0, xmm1        ; lhs 
    mulss xmm4, xmm4        ; r^2
    ucomiss xmm0, xmm4      ; lhs <= r^2 ?
    setbe al

    ret

main:
  sub rsp,0x48; 72B : 40B Shadow + 20B Local + 12B Padding + 8B ret addr = 80B % 16==0 Aligned
  call _CRT_INIT 

  lea rcx,[msg]
  call printf 

  lea rcx,[fmt]
  lea rdx,[rsp+0x44] ; x  
  lea r8 ,[rsp+0x40] ; y 
  call scanf 

  lea rcx,[msg1]
  call printf 

  lea rcx,[fmt1]
  lea rdx,[rsp+0x3C] ; a 
  lea r8 ,[rsp+0x38] ; b 
  lea r9 ,[rsp+0x34] ; r 
  call scanf 

  ; mov float value 
  movss xmm4,dword[rsp+0x34] 
  movss xmm0,dword[rsp+0x44]
  movss xmm1,dword[rsp+0x40]
  movss xmm2,dword[rsp+0x38]
  movss xmm3,dword[rsp+0x34]
  call in_circle

  lea rcx,[ans1]
  lea rdx,[ans0]
  test al,al    ; if zero then not in/on cirlce
  cmovz rcx,rdx ; Load correct msg when in circle 
  call printf 

  xor eax,eax 
  add rsp,0x48
  ret 
