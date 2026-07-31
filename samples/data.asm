; mov vs lea 
default rel

extern _CRT_INIT,printf
global main 

segment .data
  x dq 69 ; 'x' is just some label for mem address
  fmt   db "%p %d %p",0

segment .text

main:
  sub rsp, 0x28    ; 32B shadow space (required on Windows x64) + 8B Padding + 8B retaddr = 48B 
  call _CRT_INIT

  lea rcx,[fmt]
  mov rdx, x     ; loads address of x ; rdx=&x
  mov r8 ,[x]    ; loads value at 'x' : r8 = *x
  lea r9 , [x]   ; loads address of x : r9 = &x
  call printf

  xor rcx,rcx
  add rsp,0x28
  ret 
