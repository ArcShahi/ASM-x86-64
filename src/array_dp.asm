default rel

global array_dp
export array_dp

segment .text

; float array_dp(float* A,float* B,int N)
array_dp:

  ; calculate loop iteration 
  mov r9d,r8d 
  and r8d,7   ; r8d=  N % 8 
  and r9d,-8  ; r9d = N / 8

  vxorps ymm0,ymm0,ymm0 
  xor eax,eax ; counter 

.loop:
  vmovups ymm1,[rcx+rax*4]
  vfmadd231ps ymm0,ymm1,[rdx+rax*4]
  add eax,8 ;  8 elements forward
  cmp eax,r9d 
  jl .loop
  
  vhaddps ymm0,ymm0,ymm0;
  vhaddps ymm0,ymm0,ymm0   ; yes.. we've to do it twice for proper dot product
  vextractf128 xmm1,ymm0,1 ; Pull the upper 128 bit in xmm1 
  vaddps xmm0,xmm0,xmm1    ; current dot 

 ; Check if any remaining elements
 test r8d,r8d 
 jz .done

  ; Handle remaining  
.loop2:
  vmovss xmm1,[rcx+rax*4]
  vfmadd231ss xmm0,xmm1,[rdx+rax*4] ; xmm0 = xmm1 * mem128 + xmm0 
  inc eax 
  cmp eax,r8d 
  jl .loop2 

.done:
 ret 
  
