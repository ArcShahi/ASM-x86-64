; SIMD Vector operations : Add , Scale , Dot , cross 
; AVX with VEX.128 encoding version
; AVX cuts us some slacking... the memory for load and operations  don't need to be 16B or 32B aligned 

; Vector from C++ perspective : struct Vec3{float x{},y{},z{}}; struct Vec4{float x{},y{},z{},w{}}; 

default rel

global Vec3_add,Vec4_add,Vec3_scale,Vec4_scale,Vec3_dot,Vec4_dot

export Vec3_add
export Vec3_scale
export Vec4_scale
export Vec3_dot
export Vec4_dot


segment .text

; Vec3 add(Ve3& u,Vec3& v)
Vec3_add:
 vmovups xmm0,[rdx]
 vmovups xmm1,[r8]
 vaddps xmm0,xmm0,xmm1 
 vmovups [rcx],xmm0 
 ret 

; It's already 16B Aligned
; Vec4 add(Vec4& u,Vec4& v)
Vec4_add:
  vmovaps xmm0,[rdx]
  vaddps xmm0,xmm0,[r8] 
  vmovaps [rcx],xmm0 
  ret 

 ;Vec3 scale(Vec3& u,float scale)
Vec3_scale:
  vmovups xmm0,[rcx]
  vbroadcastss xmm1,xmm1 
  vmulps xmm0,xmm0,xmm1
  ret

; Vec4 scale(Vec4& u,float scale)
Vec4_scale:
  vmovaps xmm0,[rcx]
  vbroadcastss xmm1,xmm1 
  vmulps xmm0,xmm0,xmm1
  ret 

; float dot(Vec3& u,Vec3& v)
Vec3_dot:
  vmovups xmm0,[rcx]
  vmovups xmm1,[rdx]
  vdpps xmm0,xmm0,xmm1,0x71 ; 0b0111_0001 , Dot product of 3 lanes and store result in xmm0's lane 0 
  ret 

; float dot(Vec4& u,Vec4& v)
Vec4_dot:
  vmovaps xmm0,[rcx]
  vdpps xmm0,xmm0,[rdx],0xF1  ; 0b1111_0001 ; Dot product all lanes and store result in xmm0's lane 0 
  ret 
  
; Vec3 cross(Vec3& dest,Vec3& u,Vec3& v)
cross_product:
  vmovups xmm1,[rdx]        
  vmovups xmm2,[r8]

  vshufps xmm1,xmm1,xmm1,0x52 ; 0b0101_0010 ; xmm1={z,x,y,y} 
  vshufps xmm2,xmm2,xmm2,0x09 ; 0b0000_1001 ; xmm2={y,z,x,x}
  vmulps  xmm0,xmm1,xmm2      ; xmm0{UzVy,UxVz,UyVx,UyVx}

  vshufps xmm1,xmm1,xmm1,0x52 ; same mask : rotate right xmm1={y,z,x,x}
  vshufps xmm2,xmm2,xmm2,0x09 ; same mask : rotate left  xmm2={z,x,y,y}
  vfmsub231 xmm0,xmm1,xmm2    ; xmm0 = xmm1*xmm2 - xmm0 : Cross product 
  vmovups [rcx],xmm0 
  ret 
