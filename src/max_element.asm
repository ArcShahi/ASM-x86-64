; Function defintion of max_element 

default rel
%include "utils.mac"

extern _CRT_INIT,printf,scanf,malloc
global main

segment .data
 msg  db "Specify size of array: ",0xA,0
 msg2 db "Elements...",0xA,0
 fmt  db "%d",0
 ans  db "Largest in array: %d",0xA,0

segment .bss
  arr  resq 1
  len  resd 1

segment .text

; max_element (*arr,n)
max_element:
    movsxd rax, dword [rcx]       ; max = arr[0], only take 4B(32 Bits) value 
    mov    r8,  1

.loop:
    cmp    r8,  rdx
    jge    .done
    movsxd r9,  dword [rcx + r8*4]
    cmp    rax, r9
    cmovl  rax, r9
    inc    r8
    jmp    .loop

.done:
    ret

main:

  multipush rsi,rdi 
  sub rsp,0x28
  call _CRT_INIT


  lea rcx,[msg]
  call printf

  lea rcx,[fmt]
  lea rdx,[len] 
  call scanf 

  ; Allocate Memory 
  movsxd rcx,dword[len]
  imul rcx,4           ; len  * sizeof(int)
  call malloc          ; Assuming it's a success 
  mov [arr],rax        ; copy pointer of *arr 

  lea rcx,[msg2]
  call printf 

  xor esi,esi 
  mov rdi,[arr]        ; load point to 0th 

.loop:
  cmp esi,dword [len] 
  jge .done            ; rax>=size 

  lea rcx,[fmt]        ; the pvs call to scanf fucks rcx 
  lea rdx,[rdi+rsi*4]  
  call scanf           ; varargs call : x64 ABI 

  inc esi
  jmp .loop 

.done:
   
   mov rcx,[arr]       ; [arr] = *arr = allocated mem addr 
   mov edx,dword[len]  ; n
   call max_element 

   mov rdx,rax         ; catch the ans
   lea rcx,[ans]
   call printf 


  add rsp,0x28
  multipop rsi,rdi 
  xor eax,eax
  ret
