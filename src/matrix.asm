; AVX Matrix Operations 

; General Matrix from C++ perspective struct matMxN { std::array<vecN,M> value;};
; Not aligned to 32 B for YMM


default rel

global mat4x4_scale

export mat4x4_scale 

segment .text

;void mat4x4_scale(mat4x4& dest, float f,mat4x4& a)
; [rcx]=xmm1*[r8]
mat4x4_scale:
  
  vbroadcastss ymm1,xmm1 
  vmulps ymm0,ymm1,[r8]
  vmovups [rcx],ymm0

  vmulps ymm0,ymm1,[r8+0x20]
  vmovups [rcx+0x20],ymm0 
  ret 


;mat4x4_mul_mat4x4:

