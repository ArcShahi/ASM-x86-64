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
  
  vmovups ymm1,[rdx]              ; load 2 rows : r0 r1 
  vmovaps xmm2,[r8]               ; Entire vec4 or mat4x1 loaded at once

  vdpps xmm0,xmm1,xmm2,0xF1       ; xmm0 [31:0]  = [r0 dot v]
  
  vperm2f128 ymm1,ymm1,ymm1,0x01  ; Swapped: r0 <-> r1 
  vdpps xmm0,xmm1,xmm2,0xF2       ; xmm0 [63:32] = [r1 dot v]

  vmovups ymm1,[rdx+0x20]         ; Load next 2 rows : r2 , r3 
  vdpps xmm0,xmm1,xmm2,0xF4       ; xmm0 [95:64] = [r2 dot v]

  vperm2f128 ymm1,ymm1,ymm1,0x01  ; Swppaed : r2 <-> r3 
  vdpps xmm0,xmm1,xmm2,0xF8       ; xmm0 [127:96] = [r3 dot v]

  ret 


