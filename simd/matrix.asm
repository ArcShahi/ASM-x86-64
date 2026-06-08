; AVX Matrix Operations 

; General Matrix from C++ perspective struct matMxN { std::array<vecN,M> value;};
; Not aligned to 32 B for YMM


default rel

global mat4x4_scale,mat4x4_add

export mat4x4_scale 
export mat4x4_add 

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

; void mat4x4_add(mat4x4& dest,mat4x4& a,mat4x4& b);
; [rcx]=[rdx]+[r8]
mat4x4_add:
  vmovups ymm1,[rdx]
  vaddps ymm0,ymm1,[r8]
  vmovups [rcx],ymm0 

  vmovups ymm1,[rdx+0x20]
  vaddps  ymm0,ymm1,[r8+0x20]
  vmovups [rcx+0x20],ymm0 

  ret 

; void __(mat4x1& dest,mat4x4& a,mat4x1& b)
; the 4x1 matrix or 1x4 matrix is just vec4 , just the representation changes
; [rcx]=[rdx]*[r8]
mat4x4_mul_mat4x1:
 ; [row0 do vec]
 ; [row1 dot vec...]


