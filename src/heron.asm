; Heron's formula for Triangle's area
default rel

extern _CRT_INIT,printf,scanf
global main

segment .data
  
  msg db "Type sides(a,b,c): ",0xA,0
  fmt db "%f %f %f",0
  ans db "Area: %g",0xA,0
  two dd 0.5 

segment .text
  
; area(xmm0a,xmm1=b,xmm2=c) 
area:

  vaddss xmm3,xmm1,xmm2   ;  xmm3= b + c 
  vaddss xmm3,xmm3,xmm0   
  vmulss xmm3,xmm3,[two]  ;  xmm3 -  s = ( a + b + c ) / 2  
  vsubss xmm4,xmm3,xmm0   ;  xmm4 = ( s - a )
  vsubss xmm0,xmm3,xmm1   ;  xmm0 = ( s - b ) 
  vsubss xmm1,xmm3,xmm2   ;  xmm1 = ( s - c ) 
  vmulss xmm0,xmm0,xmm4  
  vmulss xmm0,xmm0,xmm1   ;  xmm0 = (s-a)(s-b)(s-c)
  vmulss xmm0,xmm0,xmm3   
  vsqrtss xmm0,xmm0,xmm0  ; sqrt(all)
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

 vmovss xmm0,dword[rsp+0x34]
 vmovss xmm1,dword[rsp+0x30]
 vmovss xmm2,dword[rsp+0x2C]
 call area 

 ; convert single scaler to single double 
 vcvtss2sd xmm1,xmm1,xmm0     ; printf %f is for double precision, not single precision wtf ?!
 vmovq rdx,xmm1               ; printf is varargs function : so must mirror values in integer reg
 lea rcx,[ans]
 call printf

 xor eax,eax 
 add rsp,0x38 
 ret 
