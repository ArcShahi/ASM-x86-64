; Program to rotate a 3D vector using Rotation matrix
; TODO : Look for optimization opportunities
; NOT : TESTED 

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

  mov rbp,rcx                        ; rbp= &Vec3 
  vmovss xmm0,[rbp]
  call cos 
  vinsertps xmm6,xmm6,xmm0,0x00      ; xmm6[0]= cos(alpha)

  vmovss xmm0,[rbp+0x04] 
  call cos 
  vinsertps xmm6,xmm6,xmm0,0x10      ; xmm6[1]= cos(beta)

  vmovss xmm0,[rbp+0x08]
  call cos 
  vinsertps xmm6,xmm6,xmm0,0x20      ; xmm6[2] = cos(gamma) 
  
  vmovaps xmm0,xmm6  
  vmovdqa xmm6,oword[rsp]
  add rsp,0x30
  pop rbp 
  ret 


SinABC:
  push rbp 
  sub rsp,0x30 
  vmovdqa oword[rsp],xmm6 

  mov rbp,rcx                        ; rbp= &Vec3 
  vmovss xmm0,[rbp]
  call sin 
  vinsertps xmm6,xmm6,xmm0,0x00      ; xmm6[0]= cos(alpha)

  vmovss xmm0,[rbp+0x04] 
  call sin  
  vinsertps xmm6,xmm6,xmm0,0x10      ; xmm6[1]= cos(beta)

  vmovss xmm0,[rbp+0x08]
  call sin 
  vinsertps xmm6,xmm6,xmm0,0x20      ; xmm6[2] = cos(gamma) 
 
  vmovaps xmm0,xmm6 
  vmovdqa xmm6,oword[rsp]
  add rsp,0x30
  pop rbp 
  ret 



; Tait-Brian angles in radians :(gamma,beta,alpha) around (z,y,x)
; void rotate(Vec3& dest,Vec3& v,Vec3& angles)
rotate:
  ; Saving volatile registers in shadow space
  mov [rsp+0x08],rcx
  mov [rsp+0x10],rdx
  mov [rsp+0x18],r8 

  push rbp
  sub rsp,0x70                    ; Shadow space 32B + 32 B for xmm5,xmm6 + 48B for local variables
  vmovdqa oword[rsp+0x20],xmm5    ; Save xmm5 
  vmovdqa oword[rsp+0x30],xmm6    ; Save xmm6 

  mov rbp,r8                      ; rbp=&angles 
  mov rcx,rbp   
  call SinABC 
  vmovdqa oword[rsp+0x34],xmm0         ; stk[0x34-0x40] =[Sa,Sb,Sc,_]

  mov rcx,rbp 
  call CosABC 
  vmovdqa oword[rsp+0x44],xmm0    ; stk[0x44-0x4c] =[Ca,Cb,Cc,_] 

  ; Restore args 
  mov rcx,[rsp+0x78]            ; Offset ; 112B 
  mov rdx,[rsp+0x80]
  mov r8, [rsp+0x88]

  vmovd xmm0,[rsp+0x34]            ; xmm0=Cos(a)
  vmulss xmm1,xmm0,[rsp+0x48]       ; Cos(a)* Sin(a) 
  vmovd [rsp+0x50],xmm1            ; stk[rsp+0x50]= Con(a)*Sin(a)
  vmulss xmm0,xmm0,[rsp+0x40]           ; Cos(a)*Cos(c)
  vmovd [rsp+0x58],xmm0            ; stk[rsp+0x58]= Cos(a)*Cos(c) 

  vmovss xmm0,[rsp+0x44]           ; xmm0= Sin(a) 
  vmulss xmm0,xmm0,[rsp+0x48]           ; xmm0=Sin(a)*Sin(b)
  vmovd [rsp+0x54],xmm0            ; stk[rsp+0x54]= Sin(a)*Sin(b) 


 mov eax,0xbf800000            ; -1.0f in IEEE-754 
 vmovd xmm1,eax               

 ; I Hat : X Axis

 vmovss xmm0,[rsp+0x34]    
 vmulss xmm0,xmm0,[rsp+0x38]        ; xmm0= cos(a)*cos(b) 
 vmovd [rsp+0x5C],xmm0              ; stk@ 0x5c=I_x 

 vmovss xmm0,[rsp+0x44]             ; xmm0= sin(a) 
 vmulss xmm0,xmm0,[rsp+0x38]        ; xmm0= sin(a)*cos(b) 
 vmovd [rsp+0x60],xmm0              ; stk@ 0x60=I_y
 vmulss xmm0,xmm1,[rsp+0x48]        ; xmm0= -sin(b) 
 vmovd [rsp+0x64],xmm0              ; stk@ 0x64=I_z

 xor eax,eax 
 mov [rsp+0x68],eax                ; I_w=0 

 vbroadcastss xmm0,[rdx]      ; xmm0=[Vx,Vx,Vx,Vx]
 vmulps xmm0,xmm1,[rsp+0x5C]       ; xmm0= Iv  

; J Hat : Y-Axis 

 vmovss xmm1,[rsp+0x4C]            ; xmm1=sin(c)
 vmulss xmm1,xmm1,[rsp+0x50]       ; xmm1=cos(a)*sin(b)*sin(c)
 vmovss xmm2,[rsp+0x44]            ; xmm2=sin(a) 
 vmulss xmm2,xmm2,[rsp+0x3C]       ; xmm2=sin(a)*cos(c)
 vsubss xmm1,xmm1,xmm2              
 vmovd [rsp+0x5C],xmm1             ; stk@ 0x5C = J_x 

 vmovss xmm1,[rsp+0x4C]            ; xmm1=sin(c) 
 vmulss xmm1,xmm1,[rsp+0x54]       ; xmm1= sin(a)*sin(b)*sin(c) 
 vaddss xmm1,xmm1,[rsp+0x58]       ; xmm1 = xmm1- cos(a)*cos(c) 
 vmovd [rsp+0x60],xmm1             ; stk@ 0x60 = J_y 

 vmovss xmm1,[rsp+0x38]          
 vmulss xmm1,xmm1,[rsp+0x4C]      ; xmm1=cos(b)*sin(c) 
 vmovd [rsp+0x64],xmm1            ; stk@ 0x64 = J_z 

 vbroadcastss xmm1,[rdx+0x04]     ; xmm1=[Vy,Vy,Vy,Vy]
 vmulps xmm1,xmm1,[rsp+0x5C]      ; xmm1= Jv 

; K Hat : Z Axis 

 vmovss xmm2,[rsp+0x4C]            ; xmm2=  sin(c) 
 vmulss xmm2,xmm2,[rsp+0x54]       ; xmm2 = cos(a)*sin(b)*cos(c)
 vmovss xmm3,[rsp+0x4C]            ; xmm3 = sin(c)
 vmulss xmm2,xmm2,[rsp+0x44]       ; xmm2= sin(a)*sin(c)
 vaddss xmm2,xmm2,xmm3             ; 
 vmovd [rsp+0x5C],xmm2             ; stk@ 0x5C = K_x 

 vmulss xmm2,xmm3,[rsp+0x34]       ; xmm2 = cos(a)*sin(c) 
 vmovss xmm3,[rsp+0x3C]            ; xmm3= cos(c) 
 vmulss xmm3,xmm3,[rsp+0x54]       ; xmm3= sin(a)*sin(b)*cos(c)
 vsubss xmm2,xmm3,xmm2             
 vmovd [rsp+0x60],xmm2             ; stk @0x5c= K_y

 vmovss xmm2,[rsp+0x3C]            ; xmm2 = cos(c) 
 vmulss xmm2,xmm2,[rsp+0x38]       ; xmm2= cos(b)*cos(c)
 vmovd [rsp+0x64],xmm2             ; stk @0x64 = K_z 

 vbroadcastss xmm2,[rdx+0x08]      ; xmm2=[Vz,Vz,Vz,Vz]
 vmulps xmm2,xmm2,[rsp+0x5C]       ; xmm2=Kv 

 ; Rotated Matrix 
 vaddps xmm1,xmm1,xmm2 
 vaddps xmm0,xmm0,xmm1  
 vmovaps [rcx],xmm0                

 ; Restore xmm 
 vmovdqa xmm5,[rsp+0x20]
 vmovdqa xmm6,[rsp+0x30]
 add rsp,0x70 
 pop rbp 
 ret 
