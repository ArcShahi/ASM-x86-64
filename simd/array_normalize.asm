; Normalize N Dimensional vec
default rel

global array_norm

; void __(rcx=*arr,rdx=N)
; float arr[]
array_norm:
  
  ; Cacluate iteration
  mov r8d,edx
  and edx,7     ; edx = N % 8
  and r8d,-8    ; r8d= (N/8)*8  , Vectorize element count 

  vxorps ymm0,ymm0,ymm0 
  xor eax,eax   ; i 

; Calculate sum of square of components
.loop:
  vmovups ymm1,[rcx+rax*4]   ; load 8 elements  
  vfmadd231ps ymm0,ymm1,ymm1 ; ymm0+= ymm1 * ymm1 
  add eax,8 
  cmp eax,r8d 
  jb .loop 

  ; Reduce partial sume : High lane 
  vhaddps ymm0,ymm0,ymm0 
  vhaddps ymm0,ymm0,ymm0 
  vextractf128 xmm1,ymm0,0x01
  vaddss xmm0,xmm0,xmm1 
  
  test edx,edx
  jz .normalize 

  lea r9,[rcx+r8*4] ; load address after Vectorize 
  xor eax, eax 
.loop2:
  vmovss xmm1,[r9+rax*4]
  vfmadd231ss xmm0,xmm1,xmm1 
  inc eax
  cmp eax,edx
  jb .loop2 

.normalize
 ; xmm0 =  (V_0)^2 + (V_1)^2 + (V_2)^2 + ... + (V_n)^2
 vxorps xmm1,xmm1,xmm1  
 vcomiss xmm0,xmm1
 je .done 
 vrsqrtss xmm0,xmm0,xmm0  ; xmm0 = 1 / mag 
 vbroadcastss ymm0,xmm0 

 xor eax,eax 
.loop3:
  vmovups ymm1,[rcx+rax*4]
  vmulps ymm1,ymm0,ymm1   
  vmovups [rcx+rax*4],ymm1 
  add eax,0x08            
  cmp eax,r8d 
  jb .loop3 

  test edx,edx 
  jz .done 

; Normaize remaining
 lea r9,[rcx+r8*4]
 xor eax,eax 
.loop4:
  vmovss xmm1,[r9+rax*4]
  vmulss xmm1,xmm0,xmm1 
  vmovss [r9+rax*4],xmm1 
  inc eax 
  cmp eax,edx
  jb .loop4

.done:
  ret 
