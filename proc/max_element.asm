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
  sub rsp,0x38       ; 56B : 32B Shadow + 12B local + 12 Padding 
  call _CRT_INIT


  lea rcx,[msg]
  call printf

  lea rcx,[fmt]
  lea rdx,qword[rsp+0x28]  ; passing the address of local variable 
  call scanf 

  ; Allocate Memory 
  movsxd rcx,dword[rsp+0x28]
  imul rcx,4                     ; len  * sizeof(int)
  call malloc                    ; Assuming it's a success 
  mov qword[rsp+0x20],rax        ; copy pointer of *arr 

  lea rcx,[msg2]
  call printf 

  xor esi,esi 
  mov rdi,qword[rsp+0x20]        ; load point to 0th 

.loop:
  cmp esi,dword [rsp+0x28] 
  jge .done            ; rax>=size 

  lea rcx,[fmt]        ; the pvs call to scanf fucks rcx 
  lea rdx,[rdi+rsi*4]  
  call scanf           ; varargs call : x64 ABI 

  inc esi
  jmp .loop 

.done:
   
   mov rcx,qword[rsp+0x20]       ; [arr] = *arr = allocated mem addr 
   mov edx,dword[rsp+0x28]       ; n
   call max_element 

   mov rdx,rax         ; catch the ans
   lea rcx,[ans]
   call printf 

  xor eax,eax 
  add rsp,0x38
  multipop rsi,rdi 
  ret
