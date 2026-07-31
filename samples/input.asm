default rel

extern _CRT_INIT,printf,scanf
global main

section .data
  prompt db "Hello, Enter something!", 0xD, 0xA, 0
  fmt   db "%d",0
  output db "Did you type: %d >_<",0


section .text

main:

; Stack misaligned after the call to main , return address of caller of main pushed 
  sub rsp,0x28 ; 32B Shadow space + 8B retaddrs + 8B padding = 48B aligned to 16B boundary.
  call _CRT_INIT

  lea rcx, [prompt]
  call printf         

  lea rcx, [fmt]
  lea rdx, [rsp+0x28] ; 
  call scanf

  mov edx, [rsp+0x28]      
  lea rcx, [output]
  call printf

  xor eax,eax          
  add rsp,0x28
  ret 

; RCX    RDX      R8      R9     CC      LOCAL
; [0..7][8..15][16..23][24..31][32..39][40..48]
; ^rsp points AT TOP


