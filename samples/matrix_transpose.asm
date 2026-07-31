; Tranpose of Matrix
; Create .obj and pass it to linker , when using this symbol in other src files.

default rel

%include "utils.mac"

global transpose

segment .text

; void tranpose(matNxM* dest,matMxN* A,int M,int N)
transpose:
  multipush rbx,rbp,rsi,rdi
 
 xor eax,eax 
.loop_row:
  xor ebx,ebx
  .loop_clm:
   ; src byte offset = (i*N+j)
    mov esi,ebx
    imul esi,r8d
    add esi,ebx 

    ; dest byte offset = (j*M+i)
    mov edi,ebx
    imul edi,r8d 
    add edi,eax 

    mov ebp,[rdx+rsi*4] ; ebp = A[i][j]
    mov [rcx+rdi*4],ebp ; T[j][i]=ebp 

    inc ebx 
    cmp ebx,r9d 
    jb .loop_clm
  
  inc eax
  cmp eax,r8d
  jb .loop_row 
    
  multipop rbx,rbp,rsi,rdi
  ret 

