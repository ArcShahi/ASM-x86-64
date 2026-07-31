; Program to rotate a 3D vector clockwise using Rotation matrix
; TODO : Optimization by saving common multiples

default rel

%include "utils.mac"

extern _CRT_INIT,cos,sin 
global rotate
export rotate

segment .text

; Vec3& Calculate xmm0=[Cos(alpha),Cos(beta),Cos(gamma),_]
CosABC:
  push rbp 
  sub rsp,0x30 
  vmovdqa oword[rsp],xmm6 

  mov rbp,rcx                        ; rbp=&Vec3 
  vmovss xmm0,[rbp]
  call cos 
  vinsertps xmm6,xmm6,xmm0,0x00      ; xmm6[0]=cos(alpha)

  vmovss xmm0,[rbp+0x04] 
  call cos 
  vinsertps xmm6,xmm6,xmm0,0x10      ; xmm6[1]=cos(beta)

  vmovss xmm0,[rbp+0x08]
  call cos 
  vinsertps xmm6,xmm6,xmm0,0x20      ; xmm6[2]=cos(gamma) 
  
  vmovaps xmm0,xmm6  
  vmovdqa xmm6,oword[rsp]
  add rsp,0x30
  pop rbp 
  ret 


SinABC:
  push rbp 
  sub rsp,0x30 
  vmovdqa oword[rsp],xmm6 

  mov rbp,rcx                        ; rbp=&Vec3 
  vmovss xmm0,[rbp]
  call sin 
  vinsertps xmm6,xmm6,xmm0,0x00      ; xmm6[0]=sin(alpha)

  vmovss xmm0,[rbp+0x04] 
  call sin  
  vinsertps xmm6,xmm6,xmm0,0x10      ; xmm6[1]=sin(beta)

  vmovss xmm0,[rbp+0x08]
  call sin 
  vinsertps xmm6,xmm6,xmm0,0x20      ; xmm6[2]=sin(gamma) 
  
  vmovaps xmm0,xmm6                  ; xmm0=[alpha,beta,gamm,_]
  vmovdqa xmm6,oword[rsp]
  add rsp,0x30
  pop rbp 
  ret 


; Tait-Bryan angles in radians: (gamma,beta,alpha) around (z,y,x)
; void rotate(Vec3& dest, Vec3& v, Vec3& angles)
rotate:

; Save paramter's in caller's shadow space 
  mov [rsp+0x08],rcx                 
  mov [rsp+0x10],rdx                 
  mov [rsp+0x18],r8                  

  push rbp
  sub rsp,0x40                       ; shadow space 32B + xmm5,xmm6 32B + 8B RBP+ 8B ret address = 80B 
  vmovdqa oword[rsp+0x20],xmm5       ; save xmm5
  vmovdqa oword[rsp+0x30],xmm6       ; save xmm6

  mov rcx,[rsp+0x58]                 ; rcx=&angles
  call SinABC 
  vmovaps xmm5,xmm0                  ; xmm5=[Sa,Sb,Sc,_]

  mov rcx,[rsp+0x58]                 ; rcx=&angles
  call CosABC 
  vmovaps xmm6,xmm0                  ; xmm6=[Ca,Cb,Cc,_]

  mov rcx,[rsp+0x48]                 ; rcx=&dest
  mov rdx,[rsp+0x50]                 ; rdx=&v
  mov r8, [rsp+0x58]                 ; r8=&angles

  ; I Hat (x-axis row)
  vmovss xmm2,[xmm6+0x04]            ; xmm2=Cb
  vmulss xmm1,xmm2,[xmm6]            ; xmm1=Cb*Ca
  vmulss xmm2,xmm2,[xmm5]            ; xmm2=Cb*Sa
  vinsertps xmm1,xmm1,xmm2,0x10      ; xmm1[1]=Cb*Sa
  
  mov eax,0xbf800000                 ; -1.0 in IEEE-754
  vmovd xmm2,eax
  vmulss xmm2,xmm2,[xmm5+0x04]       ; xmm2=-Sb
  vinsertps xmm1,xmm1,xmm2,0x20      ; xmm1[2]=-Sb

  vbroadcastss xmm0,[rdx]            ; xmm0=[x,x,x,x]
  vmulps xmm1,xmm1,xmm0              ; xmm1=I*x

  ; J Hat (y-axis row)
  vmovss xmm0,[xmm5+0x08]            ; xmm0=Sc
  vmovss xmm2,[xmm5+0x04]            ; xmm2=Sb
  vmulss xmm2,xmm2,xmm0              ; xmm2=Sb*Sc
  vmovss xmm0,[xmm6]                 ; xmm0=Ca
  vmulss xmm2,xmm2,xmm0              ; xmm2=Ca*Sb*Sc

  vmovss xmm0,[xmm5]                 ; xmm0=Sa
  vmulss xmm3,xmm0,[xmm6+0x08]       ; xmm3=Sa*Cc
  vsubss xmm2,xmm2,xmm3              ; xmm2=J_x

  vmovss xmm0,[xmm5]                 ; xmm0=Sa
  vmulss xmm0,xmm0,[xmm5+0x04]       ; xmm0=Sa*Sb
  vmulss xmm0,xmm0,[xmm5+0x08]       ; xmm0=Sa*Sb*Sc

  vmovss xmm3,[xmm6]                 ; xmm3=Ca
  vmulss xmm3,xmm3,[xmm6+0x08]       ; xmm3=Ca*Cc
  vaddss xmm0,xmm0,xmm3              ; xmm0=Jy
  vinsertps xmm2,xmm2,xmm0,0x10      ; xmm2[1]=J_y

  vmovss xmm3,[xmm6+0x04]            ; xmm3=Cb
  vmulss xmm0,xmm3,[xmm5+0x08]       ; xmm0=Cb*Sc
  vinsertps xmm2,xmm2,xmm0,0x20      ; xmm2[2]=J_z

  vbroadcastss xmm0,[rdx+0x04]       ; xmm0=[y,y,y,y]
  vmulps xmm2,xmm2,xmm0              ; xmm2=J*y

  ; K Hat (z-axis row)
  vmovss xmm0,[xmm6]                 ; Ca
  vmulss xmm0,xmm0,[xmm5+0x04]       ; Ca*Sb
  vmulss xmm0,xmm0,[xmm6+0x08]       ; Ca*Sb*Cc

  vmovss xmm3,[xmm5]                 ; Sa
  vmulss xmm3,xmm3,[xmm5+0x08]       ; Sa*Sc

  vaddss xmm0,xmm0,xmm3              ; K_x

  vmovss xmm3,[xmm5]                 ; Sa
  vmulss xmm3,xmm3,[xmm5+0x04]       ; Sa*Sb
  vmulss xmm3,xmm3,[xmm6+0x08]       ; Sa*Sb*Cc

  vmovss xmm4,[xmm6]                 ; Ca
  vmulss xmm4,xmm4,[xmm5+0x08]       ; Ca*Sc

  vsubss xmm3,xmm3,xmm4              ; Ky
  vinsertps xmm0,xmm0,xmm3,0x10      ; xmm0[1]=K_y

  vmovss xmm3,[xmm6]                 ; Ca
  vmulss xmm3,xmm3,[xmm6+0x04]       ; Ca*Cb
  vinsertps xmm0,xmm0,xmm3,0x20      ; xmm0[2]=K_z

  vbroadcastss xmm3,[rdx+0x08]       ; xmm3=[z,z,z,z]
  vmulps xmm0,xmm0,xmm3              ; xmm0=K*z

  ; Transformed Vector :[ I*x + J*y + K*z ] = [x',y',z']
  vaddps xmm1,xmm1,xmm2              ; I*x + J*y
  vaddps xmm0,xmm0,xmm1              ; + K*z
  vmovaps [rcx],xmm0                

  vmovdqa xmm5,oword[rsp+0x20]       ; restroe xmm5
  vmovdqa xmm6,oword[rsp+0x30]       ; restroe xmm6
  add rsp,0x40 
  pop rbp 
  ret

