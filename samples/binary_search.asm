; Binary search implementation
default rel

%include "utils.mac"

extern _CRT_INIT,printf,scanf,malloc
global main

segment .data
  msg  db "Specify arr size: ",0
  msg2 db "Elements in ascending order...",0xA,0 
  msg3 db "Value to search: ",0
  ans0 db "NOT FOUND",0xA,0xA,0
  ans1 db "FOUND @ : %d ",0xA,0xA,0 
  fmt  db "%d",0 

segment .text

; binary_serach(rcx=*arr,edx=size,r8d=value)
binary_serach:
  push rdi 
  mov eax,-1 ; 
  mov edi,0  ; low 
  dec edx    ; high

  cmp edi,edx
  jg .exit

.loop:
  mov r9d,edx 
  sub r9d,edi 
  shr r9d,1     
  add r9d,edi            ; mid = low + ( high - low ) / 2 

  mov r10d,[rcx+r9*4]    ; arr[mid]
  cmp r10d,r8d           ; arr[mid] vs value 

  cmove eax,r9d  
  je .exit 

  lea r11d,[r9d+1]         ; mid+1
  lea r9d, [r9d-1]         ; mid-1 
  cmovg edx,r9d            ; high = mid -1 
  cmovl edi,r11d           ; low = mid + 1 

  cmp edi,edx       
  jle .loop 

.exit:
   pop rdi
   ret 

main:
  multipush rsi,rdi 
  sub rsp,0x38 
  call _CRT_INIT
  
  lea rcx,[msg]
  call printf 

  lea rcx,[fmt]
  lea rdx,[rsp+0x28]      ; passing the address of stack 
  call scanf  

  ; Allocate Memory 
  movsxd rcx,dword[rsp+0x28]
  shl rcx, 2              ; rcx * 4 , Using int 
  call malloc     
  mov qword[rsp+0x20],rax ; copy pointer to array
  
  lea rcx,[msg2]
  call printf 

  xor esi,esi
  mov rdi,qword[rsp+0x20] ; ptr to start of mem addr

.loop:
  cmp esi,dword[rsp+0x28]
  jge .done

  lea rcx,[fmt]
  lea rdx,[rdi+rsi*4]
  call scanf         ; this call : fucks rcx,rdx 

  inc esi 
  jmp .loop

.done:
  lea rcx,[msg3]
  call printf

  lea rcx,[fmt]
  lea rdx,[rsp+0x2C] ; (int) value to search 
  call scanf 

  mov rcx,qword[rsp+0x20]   ; arr*
  mov edx,dword[rsp+0x28]   ; size
  mov r8d,dword[rsp+0x2C]   ; value
  call binary_serach

  mov edx,eax         ; copy ret val
  lea rcx,[ans0] 
  lea rax,[ans1]
  cmp edx, -1 
  cmovne rcx,rax      ; If value FOUND
  call printf

  multipop rsi,rdi 
  add rsp,0x38 
  xor eax,eax 
  ret 
