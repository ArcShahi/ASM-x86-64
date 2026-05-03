; Function for LCM. Will have to create .obj file or DLL and pass it to linker. 
default rel
extern gcd,lcm 

segment .text

; lcm(a,b)=|ab|/gcd(a,b)
lcm :
  ; Save paramters in shadow space
  mov [rsp+0x08], rcx ; save a 
  mov [rsp+0x0f], rdx ; save b 

  sub rsp,0x20 ; Shadow space : 32B ; Stack is unaligned by 8B 

  imul rcx,rdx
  push rcx    ; ab on stack(cuz we're gonna call gcd and it may fuck the rcx ) , stack aligned now

  ; Fetch a,b original value 
  mov rcx,[rsp+0x08]
  mov rdx,[rsp+0x0f]
  call gcd

  mov rcx,rax         ; rcx=gcd 
  pop rax             ; rax= |ab| 
  cqo                 ; Sign extend RCX->RDX 
  idiv r8             ; |ab|/gcd(a,b)

  add rsp,0x20       
  ret

  


