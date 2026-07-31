default rel

extern _CRT_INIT,printf,scanf
global main 

segment .data
  prompt db "Hello, Gimme 2 nums: ",0xD,0xa,0
  fmt db "%lld%lld",0
  output db "Summed: %d >_<",0xD,0xA,0


segment .text

sum:
  lea rax,[rcx+rdx]  
  ret

main:
  
  sub rsp,0x38      ; 32B Shadow + 16B Local + 8B Padding + 8B retaddr pushed = 64B % 16==0 Aligned 
  call _CRT_INIT
   
  lea rcx,[prompt]
  call printf

  lea rcx,[fmt]
  lea rdx,[rsp+0x30]
  lea r8 ,[rsp+0x28] ; Using 8B for INT 
  call scanf

  mov rcx,[rsp+0x30]
  mov rdx,[rsp+0x28]
  call sum

  mov rdx,rax
  lea rcx,[output]
  call printf

  xor ecx,ecx
  add rsp,0x38 
  ret 



; RCX    RDX      R8      R9     CC     LOCAL  LOCAL
; [0..7][8..15][16..23][24..31][32..39][40..47][48-55]
; ^rsp points AT TOP

