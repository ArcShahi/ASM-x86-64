
default rel

extern _CRT_INIT,__acrt_iob_func,printf,fgets
global main 

segment .data
  prompt db "Gimme str: ",0xA,0
  omsg db "COUNT: %d ",0xA,0

segment .bss
 buff resb 0x40 ; Reserve 64 Bytes


segment .text

strlen:
    
  xor eax,eax

.LOOP:
  cmp byte[rcx+rax],0  ; check for null char
  jz .END
  inc eax
  jmp .LOOP ; keep iterating

.END:
  dec eax
  ret

main:

  sub rsp,0x28 ; Shadow space 32 Bytes + 8 Bytes Padding + Pvs return Address = % 16 Stack Alignment 
  call _CRT_INIT

  lea rcx,[prompt]
  call printf

  ; fgets(buff,size,FILE*) : can FAIL !!
  mov ecx,0 ; stdin
  call __acrt_iob_func ; returns address of stdin in 'rax'

  ; fgets(buff,size,FILE*)
  lea rcx,[buff] ; buff
  mov rdx,0x40 ; size
  mov r8, rax ; copy value at mem address named 'stdin' , which hold FILE*
  call fgets

  ; call our function
  lea rcx,[buff]
  call strlen

  lea rcx,[omsg] 
  mov rdx,rax ; copy count 
  call printf

  xor eax,eax
  add rsp,0x28 
  ret 



