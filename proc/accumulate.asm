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


segment .text
  
; accumulate(rcx=int* arr,rdx=int size);
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
  sub rsp,0x38
  call _CRT_INIT

  lea rcx,[msg]
  call printf

  lea rcx,[fmt]
  lea rdx,[rsp+0x28]   ; local int size; 
  call scanf

  ; Allocate Memory
  movsxd rcx,dword[rsp+0x28]
  imul rcx,4                  ; size  * sizeof(int)
  call malloc                 ; Assuming it's a success
  mov qword[rsp+0x20],rax     ; copy pointer of *buff 

  lea rcx,[msg2]
  call printf

  xor esi,esi
  mov rdi,qword[rsp+0x20]     ; load pointer of starting mem addr 

.loop:
  cmp esi,dword [rsp+0x28]
  jge .done            ; rax>=size

  lea rcx,[fmt]        ; the pvs call to scanf fucks rcx
  lea rdx,[rdi+rsi*4]
  call scanf           ; varargs call : x64 ABI

  inc esi
  jmp .loop

.done:

  mov rcx,qword[rsp+0x20]         ; [arr] = *arr = allocated mem addr
  mov edx,dword[rsp+0x28]         ; size
  call accumulate

  lea rcx,[ans]
  mov rdx,rax 
  call printf

  add rsp,0x38
  multipop rsi,rdi
  xor eax,eax
  ret

 

