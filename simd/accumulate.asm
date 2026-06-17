; Summation of array

default rel

global accumulate

segment .text

; auto accumulate(*arr,N)
accumulate:
  
  ; calculate iteration
  ; Assuming N>=8 
  mov r8d,edx
  and edx,7 ; edx=N%8 
  and r8d,-8 ; r8d=(N/8)*8, Vectorize element count

  vxorps ymm0,ymm0,ymm0 
  xor eax,eax  ; i 

.loop:
  vmovups ymm1,[rcx+rax*4] ; load 8 elements
  vhaddps ymm1,ymm1,ymm1 
  vhaddps ymm1,ymm1,ymm1 
  vextractf128 xmm0,ymm1,0x01 
  vaddss xmm0,xmm0,xmm1 
  add eax,0x08 
  cmp eax,r8d 
  jb .loop 

  test edx,edx 
  jz .done

  ; Add remaining
  lea r9,[rcx+r8*4] ; load address after vectorize 
  xor eax,eax 

.loop2:
  vmovss xmm1,[r9+rax*4]
  vaddss xmm0,xmm0,xmm1 
  inc eax
  cmp eax,edx 
  jb .loop2 

.done:
  ret 
