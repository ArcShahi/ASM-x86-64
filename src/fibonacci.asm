; Prints fibonacci till Nth term

default rel

%include "utils.mac"

extern _CRT_INIT,printf,scanf
global main 

segment .data
  msg db "Nth term: ",0
  fmt db "%d",0
  ans db "%lld ",0
  ansl db "%d %d ",0

segment .text
  
fibonacci:
  multipush rsi,rdi,rbx,rbp 
  sub  rsp,0x28

  mov ebp,ecx ; save Nth term 
   
  mov rbx,0x00 ; 1st 
  mov rdi,0x01 ; 2nd 

; Print first 2 before looping 
  lea rcx,[ansl]
  mov rdx,rbx
  mov r8,rdi 
  call printf 

.loop:
  cmp ebp,2         ; cuz we did 2 before
  jle .done

  lea rsi,[rbx+rdi] ; Nth= N-1 + N-2 
  mov rbx,rdi       ; N-1 = N-2 
  mov rdi,rsi       ; N-2 = Nth 
  lea rcx,[ans]
  mov rdx,rsi 
  call printf 

  dec ebp
  jmp .loop 

.done:
  add rsp,0x28
  multipop rsi,rdi,rbx,rbp 
  ret 

main:
  sub rsp,0x28 
  call _CRT_INIT
  
  lea rcx,[msg]
  call printf 

  lea rcx,[fmt]
  lea rdx,[rsp+0x24]
  call scanf 

  mov ecx,dword[rsp+0x24]
  call fibonacci

  xor eax,eax 
  add rsp,0x28 
  ret 

