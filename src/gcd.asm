; Create .obj file with it and pass it to linker  or create a dll and link.

default rel

segment .text
  
  global gcd 
; Eucledain GCD Implementation
gcd:
    ; ecx = X, edx = Y
    test ecx, ecx
    jz .end
    test edx, edx
    jz .end
    mov r8d, edx        ; save Y in r8d

.while:
    xor edx, edx        ; clear edx for idiv
    mov eax, ecx        ; eax = X
    cqo
    idiv r8d            ; eax = X / Y, edx = X % Y

    mov ecx, r8d        ; X = Y
    mov r8d, edx        ; Y = remainder

    test r8d, r8d       ; if remainder != 0, continue
    jnz .while

    ; rem == 0, GCD is in ecx
    mov eax, ecx
.end:
    ret


