; Function for LCM. Will have to create .obj file or DLL and pass it to Linker. 
; If a program uses LCM , It'll have to pass both : lcm.obj , gcd.obj to Linker Args 
; using my script : neko .\test.asm -LinkerArgs "..\out\obj\gcd.obj","..\out\obj\lcm.obj"
; The linker will take those obj files and create : test.exe 


default rel
extern gcd,lcm 

segment .text

; lcm(a,b)=|ab|/gcd(a,b)
lcm :

  ; Save paramters in shadow space ; offset 8B ( cuz caller's return addr was pushed )
  mov [rsp+0x08], rcx ; save a 
  mov [rsp+0x10], rdx ; save b 
  push rbx 
  sub rsp,0x20 ; Shadow space : 32B ; Stack is unaligned by 8B 

  imul rcx,rdx
  mov rbx,rcx  ; rbx=ab (cuz we're gonna call gcd and it will fuck the rcx )

  ; Fetch a,b original value; Now at offset of 40B
  mov rcx,[rsp+0x30]
  mov rdx,[rsp+0x38]
  call gcd

  mov rcx,rax         ; rcx=gcd(a,b) 
  mov rax,rbx         ; rax= |ab| 
  cqo                 ; Sign extend RAX->RDX 
  idiv rcx            ; |ab|/gcd(a,b)

  add rsp,0x20      
  pop rbx 
  ret

  


