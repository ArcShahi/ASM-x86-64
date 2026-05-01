; Function for LCM. Will have to create .obj file or DLL and pass it to linker. 
default rel
extern gcd,lcm 

segment .text

; lcm(a,b)=|ab|/gcd(a,b)
lcm :
  sub rsp,0x28

  mov [rsp],rcx
  mov [rsp+0x08],rdx

  imul rcx,rdx
  mov [rsp+0x20] ,rcx; 

  mov rcx,[rsp]
  mov rdx,[rsp+0x08]
  call gcd

  mov r8,rax         ; rax=gcd 
  mov rax,[rsp+0x20] ; |ab| fetch it back
  cqo 
  idiv r8            ; |ab|/gcd(a,b)


  add rsp,0x28       
  ret

  


