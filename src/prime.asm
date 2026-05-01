; Test if a number is prime
default rel

extern _CRT_INIT,printf,scanf 
global main 

segment .data
  msg  db "Number: ",0
  fmt  db "%lld",0   ; Read very large number
  ans0 db "NOT PRIME",0xA,0 
  ans1 db "PRIME",0xA,0

segment .text

isPrime:
  
  cmp rcx,1
  jle .L0 
  cmp rcx,2
  je .L1
  test al,1 ; if even 
  je .L0   ; je check ZF flag which was set cuz even & 1 = 0 , so it'll jump if number is even 

  mov r8,3 
; Initial test 
 mov rax,r8
 imul rax,r8 
 cmp rax ,rcx 
 jg .L0 

.loop:
  mov rax,rcx 
  cqo 
  idiv r8 
  test rdx,rdx 
  je .L0     ; if rdx = ( N % i ) == 0 then factor found so not prime 
  add r8,2   
  mov rax,r8 
  imul rax,r8  ; i*i 
  cmp rax,rcx  ; cmp(i*i-rcx)
  jle .loop 


; prime 
.L1:
  mov al,1
  ret 
; NOT prime 
.L0: 
  xor al,al 
  ret


main:
  sub rsp,0x28
  call _CRT_INIT
  
  lea rcx,[msg]
  call printf 

  lea rcx,[fmt]
  lea rdx,[rsp+0x20]
  call scanf 

  mov rcx,[rsp+0x20]
  call isPrime

  lea rcx ,[ans0] 
  lea  r8 ,[ans1]

  test al,al 
  cmovnz rcx,r8 ; if prime then 
  call printf 
 

  xor eax,eax 
  add rsp,0x28 
  ret 

