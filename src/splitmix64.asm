default rel
global splitmix64

segment .text
; rcx=seed 
splitmix64:
  
  mov rax,rcx
  mov rcx,0x9e3779b97f4a7c15
  add rax,rcx                ; rax  = z = seed + n1 

  mov rcx,rax                ; rcx = z' 
  shr rcx,0x1E               ; rcx = z' =  z >> 30
  xor rax,rcx 
  mov rcx,0xbf58476d1ce4e5b9 
  mul rcx                    ; rax = z = ( z ^ z')  * n2 

  mov rcx,rax 
  shr rcx,0x1B               ;  z' = z' >> 27 
  xor rax,rcx 
  mov rcx,0x94d049bb133111eb 
  mul rcx                    ; rax = z = ( z ^ z' ) * n3

  mov rcx,rax 
  shr rcx,0x1F               ; z' = z >> 31 
  xor rax,rcx                ; z =  z ^ z' 
  ret 
  



