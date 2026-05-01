; Project Euler 1: Find the sum of all the multiples of 3 or 5 in range (1,1000)
default rel

extern _CRT_INIT,printf,scanf 
global main 

segment .data
  ans db "ANS %d",0xA,0
  N   dd 999 

segment .text

SumMul:
  
   ; Number of Multipels in [1,n]
   ; rcx = k
   mov eax,[N]
   mov r8,rcx ; r8=k
   cqo        ; Sing extend rax->rdx 
   idiv r8    ; n / k  , t= rax 

   lea rcx,[rax+1] ; rcx=t+1 
   imul rax,rcx    ; rax=  t(t+1) 
   imul rax,r8     ; rax = kt(t+1)

   shr rax, 1      ; rax = kt(t+1) 2
   ret

; N(t u f) = N(t) + N(f) - N(t n f )
Union2:
    sub rsp, 0x28

    mov r10, rcx      ; save x
    mov r11, rdx      ; save y : CQO modifies rdx 

    ; r9 = tf
    mov r9, r10
    imul r9, r11

    call SumMul 
    push rax ; preserve N(t)

    mov rcx, r11
    call SumMul 
    push rax ; preserve N(f)

    mov rcx, r9
    call SumMul ; rax = N(tf)
    
    pop rdx ; rdx = N(f)
    pop r8  ; r8 =  N(t)
    add r8, rdx   ; N(t) + N(f)
    sub r8, rax   ; N(t) + N(f) - N(tf)
    mov rax, r8   

    add rsp, 0x28
    ret


main:
  
  sub rsp,0x28
  call _CRT_INIT

  mov ecx,3 
  mov edx,5
  call Union2 

  lea rcx,[ans]
  mov rdx,rax 
  call printf
 
  xor eax,eax 
  add rsp,0x28 
  ret 
  
