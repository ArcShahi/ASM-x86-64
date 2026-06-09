default rel

%include "include/utils.mac"

extern _CRT_INIT,printf,scanf,malloc
global main


segment .data
  msg  db "Specify arr size: ",0
  msg2 db "Elements in Ascending order...",0xA,0 
  msg3 db "Value to search: ",0
  ans0 db "NOT FOUND",0xA,0xA,0
  ans1 db "FOUND @ : %d ",0xA,0xA,0 
  fmt  db "%d",0 

segment .bss
  buffer resq 1
  size   resd 1 


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
  cmovg edx,r9d          ; high = mid -1 
  cmovl edi,r11d         ; low = mid + 1 

  cmp edi,edx       
  jle .loop 


.exit:
   pop rdi
   ret 


main:
  multipush rsi,rdi 
  sub rsp,0x28 
  call _CRT_INIT
  
  lea rcx,[msg]
  call printf 

  lea rcx,[fmt]
  lea rdx,[size] ; size of array 
  call scanf  

  ; Allocate Memory 
  movsxd rcx,dword[size]
  shl rcx, 2       ; rcx * 4 , Using int 
  call malloc     
  mov [buffer],rax ; copy pointer to array
  
  lea rcx,[msg2]
  call printf 

  xor esi,esi
  mov rdi,[buffer] ; ptr to start of mem addr

.loop:
  cmp esi,dword[size]
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
  lea rdx,[rsp+0x24] ; (int) value to search 
  call scanf 

  mov rcx,[buffer]   ; arr*
  mov edx,dword[size]; size
  mov r8d,[rsp+0x24] ; vale 
  call binary_serach


  mov edx,eax         ; copy ret val
  lea rcx,[ans0] 
  lea rax,[ans1]
  cmp edx, -1 
  cmovne rcx,rax      ; If value FOUND
  call printf


  multipop rsi,rdi 
  add rsp,0x28
  ret 









