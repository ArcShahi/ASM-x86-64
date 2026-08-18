; Rotate Vector3 clockwise using Rotation matrix
; TODO : Look for optimization opportunities


default rel

%include "utils.mac"

extern _CRT_INIT,cosf,sinf 
global vec3_rotate
export vec3_rotate

segment .text


; (rcx=&angles) , return into xmmm0

_cosf_cba:
  push rbp 
  sub rsp,0x30 
  vmovdqa oword[rsp],xmm6 

  mov rbp,rcx                        ; rbp= &Vec3 
  vmovss xmm0,[rbp]
  call cosf 
  vinsertps xmm6,xmm6,xmm0,0x00      ; xmm6[0]= cos(c)

  vmovss xmm0,[rbp+0x04] 
  call cosf 
  vinsertps xmm6,xmm6,xmm0,0x10      ; xmm6[1]= cos(b)

  vmovss xmm0,[rbp+0x08]
  call cosf 
  vinsertps xmm6,xmm6,xmm0,0x20      ; xmm6[2]= cos(a) 
  
  vmovaps xmm0,xmm6  
  vmovdqa xmm6,oword[rsp]
  add rsp,0x30
  pop rbp 
  ret 


_sinf_cba:
  push rbp 
  sub rsp,0x30 
  vmovdqa oword[rsp+0x20],xmm6 

  mov rbp,rcx                        ; rbp= &Vec3 
  vmovss xmm0,[rbp]
  call sinf 
  vinsertps xmm6,xmm6,xmm0,0x00      ; xmm6[0]= sin(c)

  vmovss xmm0,[rbp+0x04] 
  call sinf  
  vinsertps xmm6,xmm6,xmm0,0x10      ; xmm6[1]= sin(b)

  vmovss xmm0,[rbp+0x08]
  call sinf 
  vinsertps xmm6,xmm6,xmm0,0x20      ; xmm6[2]= sin(a) 
 
  vmovaps xmm0,xmm6 
  vmovdqa xmm6,oword[rsp]
  add rsp,0x30
  pop rbp 
  ret 


; Tait-Brian angles in radians :(gamma,beta,alpha) around x,y,z
; void rotate([rcx]=Vec3* dest,[rdx]=Vec3* v,[r8]=Vec3* angles)
vec3_rotate:
  ; Saving volatile registers in shadow space
  mov [rsp+0x08],rcx
  mov [rsp+0x10],rdx
  mov [rsp+0x18],r8 

  push rbp
  sub rsp,0x50                           ; 80B = 32B shadow + 40B local + 8 Padding 

  mov rbp,r8                             ; rbp=&angles 
  mov rcx,r8    
  call _cosf_cba 
  vmovdqa oword[rsp+0x20],xmm0           ; Offset After shadow : stk[32B-43B]=cos[c,b,a]
  
  mov rcx,rbp 
  call _sinf_cba
  vmovdqu oword[rsp+0x2C],xmm0           ; stk [44B-55B] = sin[c,b,a]

  vmovd xmm0,dword[rsp+0x20]             ; xmm0= cos(c)
  vmulss xmm0,xmm0,dword[rsp+0x28]       
  vmovd [rsp+0x38],xmm0                  ; rsp+56 = cos(c)cos(a)

  vmovd xmm1,dword[rsp+0x30]             ; xmm1=sin(b) 
  vmulss xmm0,xmm1,dword[rsp+0x34]
  vmovd [rsp+0x3C],xmm0                  ; rsp+60= sin(b)sin(a)

  vmovd xmm0,dword[rsp+0x28]             ; xmm0=cos(a)
  vmulss xmm0,xmm0,xmm1                  ; xmm0=cos(a)*sin(b)
  vmovd [rsp+0x40],xmm0                  ; rsp+64 = cos(a)*sin(b)


  ; Create Rotation Matrix 

  ; IHat 
  vmovd xmm0,dword[rsp+0x28]            ; xmm0=cos(a)
  vmulss xmm0,xmm0,dword[rsp+0x24]      ; xmm0=cos(a)*cos(b)
  vmovd xmm1,dword[rsp+0x34]            ; xmm1=sin(a)
  vmulss xmm1,xmm1,dword[rsp+0x24]      ; xmm1=cos(b)sin(a)
  vpxor xmm2,xmm2,xmm2                  ; xmm2=0 
  vsubss xmm2,xmm2,[rsp+0x30]           ; xmm2= -sin(b)

  vinsertps xmm0,xmm0,xmm1,0x10         ; xmm0[1]=I.y
  vinsertps xmm0,xmm0,xmm2,0x20         ; xmm0[2]=I.z 


; JHat
  vmovd xmm1,dword[rsp+0x2C]                ; xmm1=sin(c)
  vmulss xmm1,xmm1,dword[rsp+0x40]          ; xmm1; cos(a)sin(b)sin(c)

  vmovd xmm2,dword[rsp+0x20]                ; xmm2=cos(c)
  vmulss xmm2,xmm2,dword[rsp+0x34]          ; xmm2=sin(a)cos(c)
  vsubss xmm1,xmm1,xmm2                     ; xmm1[0]=j.x

  vmovd xmm2,dword[rsp+0x2C]                ; xmm2=sin(c)
  vmulss xmm2,xmm2,dword[rsp+0x3C]          ; xmm2=sin(a)sin(b)sin(c)

  vmovd xmm3,dword[rsp+0x20]                ; xmm3=cos(c)
  vmulss xmm3,xmm3,dword[rsp+0x28]          ; xmm3=cos(a)cos(c)

  vaddss xmm2,xmm2,xmm3                     ; xmm2=J.y 
  vmovd xmm3,dword[rsp+0x24]                ; xmm3=cos(b)
  vmulss xmm3,xmm3,dword[rsp+0x2C]          ; xmm3=J.z 

  vinsertps xmm1,xmm1,xmm2,0x10             ; xmm1[1]=J.y
  vinsertps xmm1,xmm1,xmm3,0x20             ; xmm1[2]=J.z 

; K Hat

  vmovd xmm2,dword[rsp+0x20]                ;xmm2=cos(c)
  vmulss xmm2,xmm2,dword[rsp+0x40]          ;xmm2=cos(a)sin(b)cos(c)

  vmovd xmm3,dword[rsp+0x2C]                ;xmm2=sin(c)
  vmulss xmm3,xmm3,dword[rsp+0x34]          ;xmm3=sin(a)sin(c)
  vaddss xmm2,xmm2,xmm3                     ;xmm2[0]=K.x 

  vmovd xmm3,dword[rsp+0x20]                
  vmulss xmm3,xmm3,dword[rsp+0x3C]          ;xmm3=sin(a)sin(b)cos(c)

  vmovd xmm4,dword[rsp+0x28]                ;xmm4=cos(a)
  vmulss xmm4,xmm4,dword[rsp+0x2C]          ;xmm4=cos(a)sin(c)
  vsubss xmm3,xmm3,xmm4                     ;xmm3[0]=K.y 

  vmovd xmm4,dword[rsp+0x24]               ; xmm4=cos(b)
  vmulss xmm4,xmm4,dword[rsp+0x20]         ; xmm4=cos(b)cos(c)

  vinsertps xmm2,xmm2,xmm3,0x10            ; xmm2[1]=K_y
  vinsertps xmm2,xmm2,xmm4,0x20            ; xmm2[2]=K_z 
  

 ; Restore addresses 
 mov rcx,[rsp+0x60]
 mov rdx,[rsp+0x68]
 mov r8,[rsp+0x70]

 vmovaps xmm4,[rdx]               ; Load entire vector 

 vdpps xmm0,xmm0,xmm4,0xF1        ; xmm0[0]=(I dot v)
 vdpps xmm1,xmm1,xmm4,0xF1        ; xmm1[0]=(J dot v)
 vdpps xmm2,xmm2,xmm4,0xF1        ; xmm2[0]=(K dot v) 

 vinsertps xmm0,xmm0,xmm1,0x10   ; xmm0[1]=xmm1[0]
 vinsertps xmm0,xmm0,xmm2,0x20   ; xmm0[2]=xmm2[0]
 vmovaps [rcx],xmm0              ; write back result

 add rsp,0x50 
 pop rbp
 ret 
