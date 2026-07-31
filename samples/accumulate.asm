; Accumate array based on operation ( Sum, product )

default rel

%include "utils.mac"

extern _CRT_INIT,printf,scanf,malloc
global main

segment .data
  msg  db "Specify the size: ",0xA,0
  fmt  db "%d",0
  msg2 db  "Elements...",0xA,0
  ans  db "Accumulated : %d ",0xA,0

segment .bss
  buffer resq 1 
  size   resd 1 

segment .text
  
; accumulate(rcx=*arr,edx=n) ; todo  impl (*arr,n,op)
accumulate:

  xor eax,eax 

.loop:
  test edx,edx 
   jz .done
   dec edx ; n-1
   add eax,[rcx+rdx*4]
   jmp .loop

.done:
  ret

main:

  multipush rsi,rdi
  sub rsp,0x28
  call _CRT_INIT


  lea rcx,[msg]
  call printf

  lea rcx,[fmt]
  lea rdx,[size]
  call scanf

  ; Allocate Memory
  movsxd rcx,dword[size]
  imul rcx,4           ; size  * sizeof(int)
  call malloc          ; Assuming it's a success
  mov [buffer],rax     ; copy pointer of *arr

  lea rcx,[msg2]
  call printf

  xor esi,esi
  mov rdi,[buffer]     ; load pointer of starting mem addr 

.loop:
  cmp esi,dword [size]
  jge .done            ; rax>=size

  lea rcx,[fmt]        ; the pvs call to scanf fucks rcx
  lea rdx,[rdi+rsi*4]
  call scanf           ; varargs call : x64 ABI

  inc esi
  jmp .loop

.done:

   mov rcx,[buffer]       ; [arr] = *arr = allocated mem addr
   mov edx,dword[size]    ; n
   call accumulate

   lea rcx,[ans]
   mov rdx,rax 
   call printf

  
  add rsp,0x28
  multipop rsi,rdi
  xor eax,eax
  ret

 

