; Euclid's formula to generate pythagorean triplet 
; 3 numbers : a,b,c that satisfy : a^2 + b^2 = c^2 

default rel

extern _CRT_INIT,printf,scanf
global main

segment .data
  msg db "Gimme m,n ( m > n > 0 ): ",0 
  fmt db "%f%f",0
  ans db "Triplet a = %g , b = %g , c = %g",0xA,0xA,0

  a dd 0.0
  b dd 0.0
  c dd 0.0 

segment .text 
; triplet(xmm0=m, xmm1=n)
gen_triplet:
   vcomiss xmm0,xmm1 
   jbe .exit        ; jump if below or equal 

   vmulss xmm2,xmm0,xmm1 
   vaddss xmm2,xmm2,xmm2 
   vmovss [b],xmm2       ; b = 2mn
   vmulss xmm0,xmm0,xmm0 ; m^2 
   vmulss xmm1,xmm1,xmm1 ; n^2 
   vsubss xmm2,xmm0,xmm1 
   vmovss [a],xmm2       ; a = m^2 - n^2
   vaddss xmm2,xmm0,xmm1 
   vmovss [c],xmm2       ; c = m^2 + n^2    

.exit:
  ret 

main:
  sub rsp,0x28 ; 40B + 8B (ret addr) % 16 == 0 , Aligned 
  call _CRT_INIT 

  lea rcx,[msg]
  call printf

  lea rcx,[fmt]
  lea rdx,[rsp+0x24] ; &m 
  lea r8 ,[rsp+0x20] ; &n 
  call scanf 

  vmovss xmm0,dword[rsp+0x24] ; m 
  vmovss xmm1,dword[rsp+0x20] ; n 
  call  gen_triplet

  lea rcx,[ans]
  vcvtss2sd xmm1,[a]    ; convert single preicsion to doulbe and copy to destination 
  vmovq rdx,xmm1        ; mirror ,  cuz printf is varargs function : Read x64 ABI 
  vcvtss2sd xmm2,[b]
  vmovq r8,xmm2 
  vcvtss2sd xmm3,[c]
  vmovq r9 ,xmm3
  call printf 

  xor eax,eax
  add rsp,0x28 
  ret 
  

  ; We can also put that function in a loop and generate fuckton of triplet...


