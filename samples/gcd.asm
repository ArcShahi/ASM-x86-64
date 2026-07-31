; Create .obj file with it and pass it to linker  or create a dll and link.

default rel
segment .text
  
global gcd 
; Eucledain GCD Implementation
; gcd(a=rcx, b=rdx)
gcd:
  
  ; Jump early if any paramter is 0 
  xor eax,eax 
  test rcx,rcx
  je .end
  test rdx,rdx
  je .end 
  
  mov rax,rcx  ; rax=a 
.loop:
    mov r8,rdx 
    cqo         ; Sign extend RAX->RDX ( so we can divide fucking huge numbers)
    idiv r8     ; RAX = RDX:RAX / R8  , RDX = RDX:RAX % R8 
    mov rax,r8  ; a,b are swapped 
    test rdx,rdx 
    jne .loop   ; continue till b!=0 

;  rax = rax < 0  ? abs(rax) : rax 
   test rax, rax 
   jns .end
   neg rax     ; rax = 0 - rax 
  
.end:
    ret


