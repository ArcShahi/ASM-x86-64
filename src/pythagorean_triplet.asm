; Euclid's formula to generate pythagorean triplet 
; 3 numbers : a,b,c that satisfy : a^2 + b^2 = c^2 

default rel

extern _CRT_INIT,printf,scanf
global main

segment .data
  msg db "Gimme m,n ( m>n>0 ): ",0 
  fmt db "%f%f",0
  ans db "Triplet a= %g , b= %g , c= %g",0xA,0xA,0

  a dd 0.0
  b dd 0.0
  c dd 0.0 

segment .text 
; triplet(xmm0=m, xmm1=n)
gen_triplet:
   ucomiss xmm0,xmm1 
   jbe .exit        ; jump if below or equal 

   movss xmm2,xmm0 
   mulss xmm2,xmm1 ; mn 
   addss xmm2,xmm2 ; 2*mn 
   movss [b],xmm2  

   mulss xmm0,xmm0 ; m^2 
   mulss xmm1,xmm1 ; n^2 

   movss xmm2,xmm0 
   subss xmm2,xmm1 ; m^2 - n^2 
   movss [a],xmm2  

   addss xmm0,xmm1 ; m^2 + n^2 
   movss [c],xmm0 

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

  movss xmm0,dword[rsp+0x24] ; m 
  movss xmm1,dword[rsp+0x20] ; n 
  call  gen_triplet

  lea rcx,[ans]
  cvtss2sd xmm1,[a]    ; convert single preicsion to doulbe and copy to destination 
  movq rdx,xmm1        ; mirror ,  cuz printf is varargs function : Read x64 ABI 
  cvtss2sd xmm2,[b]
  movq r8,xmm2 
  cvtss2sd xmm3,[c]
  movq r9 , xmm3
  call printf 

  xor eax,eax
  add rsp,0x28 
  ret 
  
  

  ; We can also put that function in a loop and generate fuckton of triplet...


