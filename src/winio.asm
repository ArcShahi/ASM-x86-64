; Testing Win API 
; It's nowhere near usable yet

bits 64
default rel 

segment .text


extern GetStdHandle
extern ReadConsoleA
extern WriteConsoleA

global strlen
global println
global read_input


export strlen
export println
export read_input

strlen:
  xor eax,eax

 .loop:
  cmp byte[rcx+rax],0 ; if string empty
  jz .end
  inc eax
  jmp .loop

 .end:
  ret

;println(*buff)
println:
    push rsi 
    sub rsp,0x50 

    call strlen

    mov rsi,rcx ; copy buff mem addr
    mov r8d,eax  ; copy buff size to Write 

    ; STDOUT handle
    mov ecx,-11
    call GetStdHandle

    ; WriteConsole(handle,buffer,charsToWrite,charWritten,Reserved=NULL)
    mov rcx,rax ; STDOUT
    mov rdx,rsi ; buffer addr, r8d = chartToWrite
    lea r9,[rsp+0x48] ; chartWritten 
    mov [rsp+0x20],0 ; 5th arg on stack 
    call WriteConsoleA

    add rsp,0x50
    pop rsi
    ret 



;read_input(*buffer,size)
read_input:
  push rsi
  sub rsp,0x50 ; ret add + old_rsi + 40B Shadow + 16B Locals + 8B padding = 80 Bytes % 16 = Aligned

  mov rsi,rcx ; copy buffer mem address
  mov r8d,edx ; copy size 


  ; Get STDIN handle
  mov ecx,-10 
  call GetStdHandle ; returns STDIN handle in rax

  ; ReadConsoleA(handle,buffer,size,&Bytesread,NULL)
  mov rcx,rax 
  mov rdx,rsi
  ;r8d already has size
  lea r9,[rsp+0x48] ; tells how many bytes read 
  mov [rsp+0x20],0 ; 5th args on stack 0x32 , 0
  call ReadConsoleA

  ; Add null char
  mov eax,[r9]
  mov [rsi+rax],0 ; buff[size]

  add rsp,0x50 
  pop rsi
  ret 

