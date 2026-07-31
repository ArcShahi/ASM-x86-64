bits 64
default rel

extern _CRT_INIT,printf,scanf
global main 

segment .data
  prompt db "Hi, Gimme 2 nums: ",0XD,0XA,0
  fmt db"%d%d"
  output db "After Swap: %d <-> %d ",0XD,0XA,0


segment .text

; swap ints 
swap:
  mov eax,dword[rcx] ;  rax =*rcx
  mov r8d,dword[rdx] ;  r8 = *rdx
  mov dword[rcx],r8d ; *rcx= r8
  mov dword[rdx],eax;  *rdx = rax 
  ret

main:
  sub rsp,0x28 ; 40B = 32B Shadow + 8B local; + 8B ret addrs = 48B . STACK ALIGNED

  lea rcx ,[prompt]
  call printf

  lea rcx,[fmt]
  lea rdx,[rsp+0x24]
  lea r8, [rsp+0x20] ; using 'int' (4B)
  call scanf

  lea rcx,[rsp+0x24]
  lea rdx,[rsp+0x20]
  call swap
 
  lea rcx,[output]
  mov rdx,[rsp+0x24]
  mov r8 ,[rsp+0x20] 
  call printf

  xor eax,eax 
  add rsp,0x28 
  ret 
