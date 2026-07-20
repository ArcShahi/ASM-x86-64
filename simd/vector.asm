; SIMD Vector operations : Add , Scale , Dot , cross 
; AVX with VEX.128 encoding version
; AVX cuts us some slacking... the memory for load and operations  don't need to be 16B or 32B aligned 
; But I'm still making struct aligned (16B) 

; Vector from C++ perspective : else get ready for chaos
; struct alignas(16) Vec3{float x{},y{},z{}};  The compiler will add 4B padding
; struct alignas(16) Vec4{float x{},y{},z{},w{}}; 

default rel

%include "vector.inc"

segment .text

; void add(Vec3& dest,Ve3& u,Vec3& v) 
Vec3_add:
 vmovaps xmm0,[rdx]
 vmovaps xmm1,[r8]
 vaddps xmm0,xmm0,xmm1 
 vmovaps [rcx],xmm0 
 ret 

; void add(Vec4& dest, Vec4& u,Vec4& v)
Vec4_add:
  vmovaps xmm0,[rdx]
  vaddps xmm0,xmm0,[r8] 
  vmovaps [rcx],xmm0 
  ret 

 ; void scale(Vec3& dest, Vec3& u,float scale)
Vec3_scale:
  vmovups xmm0,[rcx]
  vbroadcastss xmm1,xmm1 
  vmulps xmm0,xmm0,xmm1
  vmovaps [rcx],xmm0 
  ret

; void scale(Vec4& dest, Vec4& u,float scale)
Vec4_scale:
  vmovaps xmm0,[rcx]
  vbroadcastss xmm1,xmm1 
  vmulps xmm0,xmm0,xmm1
  vmovaps [rcx],xmm0 
  ret 

; float dot(Vec3& u,Vec3& v)
Vec3_dot:
  vmovaps xmm0,[rcx]
  vmovaps xmm1,[rdx]
  vdpps xmm0,xmm0,xmm1,0x71   ; 0b0111_0001 , Dot product of 3 lanes and store result in xmm0's lane 0 
  ret 

; float dot(Vec4& u,Vec4& v)
Vec4_dot:
  vmovaps xmm0,[rcx]
  vdpps xmm0,xmm0,[rdx],0xF1  ; 0b1111_0001 ; Dot product all lanes and store result in xmm0's lane 0 
  ret 
  
; void cross(Vec3& dest,Vec3& u,Vec3& v)
cross_product:
  vmovaps xmm1,[rdx]        
  vmovaps xmm2,[r8]

  vshufps xmm1,xmm1,xmm1,0x52 ; 0b0101_0010 ; xmm1={z,x,y,y} 
  vshufps xmm2,xmm2,xmm2,0x09 ; 0b0000_1001 ; xmm2={y,z,x,x}
  vmulps  xmm0,xmm1,xmm2      ; xmm0{UzVy,UxVz,UyVx,UyVx}

  vshufps xmm1,xmm1,xmm1,0x52 ; same mask : rotate right xmm1={y,z,x,x}
  vshufps xmm2,xmm2,xmm2,0x09 ; same mask : rotate left  xmm2={z,x,y,y}
  vfmsub231ps xmm0,xmm1,xmm2  ; xmm0 = xmm1*xmm2 - xmm0 : Cross product 
  vmovaps [rcx],xmm0 
  ret 

 ; void reflect(Vec3& ref,Vec3& V,Vec3& N)
 ; ref = V - 2(V ⋅N)N
 Vec3_reflect:
  vmovaps xmm1,[rdx]
  vdpps xmm0,xmm1,[r8],0xF1  ; xmm0=dp :  0b1111_0001 : dot(V,N) in lane 0 
  vaddss xmm0,xmm0,xmm0       ; dp*dp 
  vbroadcastss xmm0,xmm0      ; [2dp | 2dp | 2dp | 2dp]
  vmulps xmm0,xmm0,[r8]       ; Scaling the normal by 2DP
  vsubps xmm0,xmm1,xmm0       ; Subtracting from V 
  vmovaps [rcx],xmm0          ; write the result back
  ret 
  

; void refract(rcx=Vec3& dest,rdx=Vec3& I,r8=Vec3& N,xmm3=float eta)
; T = nI-(n(dot(I,N)+sqrt(k))N 
  Vec3_refract:
    vmovaps xmm2,[rdx]        ; xmm2 = Incident ray (I)
    mov eax,0x3f800000        ; IEEE-754 ecoding for : 1.0 
    vmovd xmm1,eax            ; xmm1 = 1.0 
    
    vdpps xmm0,xmm2,[r8],0xF1    ; xmm0 = dot(I,N) : 0b1111_0001 in lane 0 
    vmulss xmm5,xmm0,xmm0        ; xmm5 = dp^2 
    vsubss xmm5,xmm1,xmm5        ; xmm5 = 1 - dp^2 
    vmulss xmm4,xmm3,xmm3        ; xmm4 : eta^2 
    vmulss xmm5,xmm5,xmm4        
    vsubss xmm5,xmm1,xmm5        ; xmm5 = k 
    
    vxorps xmm4,xmm4,xmm4 
    vcomiss xmm5,xmm4
    jb .tir

   ; calculate refraction if : 0 < k
   vbroadcastss xmm3,xmm3        ; xmm3= [eta|eta|eta|eta]
   vmulps xmm2,xmm3,xmm2         ; xmm2= eta*I
   vsqrtss xmm5,xmm5,xmm5        ; xmm5= sqrt(k)
   vmulss xmm0,xmm3,xmm0         ; xmm0= eta*dot(I,N) 
   vaddss xmm0,xmm0,xmm5   
   vbroadcastss xmm0,xmm0 
   vmulps xmm0,xmm0,[r8] 
   vsubps xmm0,xmm2,xmm0 
   vmovaps [rcx],xmm0  
   ret 

  .tir:
    vxorps xmm0,xmm0,xmm0
    vmovaps [rcx],xmm0 
    ret 


; void normalize(Vec3& dest,Vec3& V)
Vec3_normalize:
  vmovaps xmm0,[rdx] 
  vdpps xmm1,xmm0,xmm0,0xF1      ; dot(V,V)=||V||^2 

  vxorps xmm2,xmm2,xmm2 
  vcomiss xmm1,xmm2 
  je .zero

  vrsqrtss xmm1,xmm1,xmm1   ; 1 / mag 
  vbroadcastss xmm1,xmm1 
  vmulps xmm2,xmm0,xmm1     ; Normalize if len != 0 

.zero:
  vmovaps [rcx],xmm2 
  ret 
