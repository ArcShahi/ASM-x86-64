; AVX2 Matrix Operations 
; NOT aligned to 32B for YMM

default rel

; Pass  -i<include\> flag to NASM to look for search dir outside src tree 
%include "utils.mac"
%include "matrix.inc" 

segment .text

;/////////////////////////////////////////////////////////////////////////////
;                                  Matrix3x3                                /
;////////////////////////////////////////////////////////////////////////////

; void add([rcx]=Mat3x3* dest, [rdx]=Mat3x3* M1, [r8]=Mat3x3* M2);

mat3x3_add:
  vmovups ymm1,[rdx]
  vaddps ymm0,ymm1,[r8]     ; Add first 2 rows 
  vmovups [rcx],ymm0 

  vmovups xmm1,[rdx+0x20]
  vaddps xmm0,xmm1,[rd+0x20]
  vmovups [rcx+0x20],xmm0
  ret

   
; void mul_Mat3x3([rcx]=Mat3x3* dest,[rdx]=Mat3x3* A,[r8]=Mat3x3* B);
; ASSUMING : Either A or B is Transposed -> dest= A*B^(-1) or dest= A^(-1)*B 
; Unrolled Loop 

mat3x3_mul_mat3x3:
  
  ; Load r0,r1 of B then r2 
  vmovups ymm1,[r8]           ; ymm0[127:0]= B's r0
  vmovups xmm2,[r8+0x20]      ; r2 

 ; A's r0 * B
  vmovups xmm0,[rdx]      ; Load only one row from A 
  vextractf128 xmm4,ymm1,0x01 ; xmm4[127:0]=ymm1[255:128] = B's r1 
  
  vdpps xmm3,xmm0,xmm1,0xF1   ; xmm3[0]= xmm0 dot xmm1 = A's r0 dot B's r0 
  vdpps xmm4,xmm0,xmm4,0xF1   ; xmm4[0]= xmm0 dot xmm4 = A's r0 dot B's r1 
  vddps xmm5,xmm0,xmm2,0xF1   ; xmm4[0]= xmm0 dot xmm2 = A's r0 dot B's r2

  ; Pack the results back to xmm0 
  vinsertps xmm0,xmm0,xmm3,0x00 ; xmm0[0]=xmm3[0]
  vinsertps xmm0,xmm0,xmm4,0x10 ; xmm0[1]=xmm4[0]
  vinsertps xmm0,xmm0,xmm5,0x20 ; xmm0[2]=xmm5[0]
  vmovups [rcx],xmm0          

 ; A's r1 * B
  vmovups xmm0,[rdx+0x10]       ;  Load only one row from A 
  vextractf128 xmm4,ymm1,0x01 ; xmm4[127:0]=ymm1[255:128] = B's r1 
  
  vdpps xmm3,xmm0,xmm1,0xF1   ; xmm3[0]= xmm0 dot xmm1 = A's r1 dot B's r0 
  vdpps xmm4,xmm0,xmm4,0xF1   ; xmm4[0]= xmm0 dot xmm4 = A's r1 dot B's r1 
  vddps xmm5,xmm0,xmm2,0xF1   ; xmm4[0]= xmm0 dot xmm2 = A's r1 dot B's r2

  ; Pack the results back to xmm0 
  vinsertps xmm0,xmm0,xmm3,0x00 ; xmm0[0]=xmm3[0]
  vinsertps xmm0,xmm0,xmm4,0x10 ; xmm0[1]=xmm4[0]
  vinsertps xmm0,xmm0,xmm5,0x20 ; xmm0[2]=xmm5[0]
  vmovups [rcx+0x10],xmm0          

 ; A's r2 * B
  vmovups xmm0,[rdx+0x20]       ;  Load only one row from A 
  vextractf128 xmm4,ymm1,0x01 ; xmm4[127:0]=ymm1[255:128] = B's r1 
  
  vdpps xmm3,xmm0,xmm1,0xF1   ; xmm3[0]= xmm0 dot xmm1 = A's r2 dot B's r0 
  vdpps xmm4,xmm0,xmm4,0xF1   ; xmm4[0]= xmm0 dot xmm4 = A's r2 dot B's r1 
  vddps xmm5,xmm0,xmm2,0xF1   ; xmm4[0]= xmm0 dot xmm2 = A's r2 dot B's r2

  ; Pack the results back to xmm0 
  vinsertps xmm0,xmm0,xmm3,0x00 ; xmm0[0]=xmm3[0]
  vinsertps xmm0,xmm0,xmm4,0x10 ; xmm0[1]=xmm4[0]
  vinsertps xmm0,xmm0,xmm5,0x20 ; xmm0[2]=xmm5[0]
  vmovups [rcx+0x20],xmm0
  ret 


; void mul_vec3([rcx]=Vec3* dest,[rdx]=Mat3x3* M,[r8]=Vec3* v);
; dest = Mv

mat3x3_mul_vec3:
  vmovups ymm1,[rdx]      ; load 2 rows from M : r0 , r1 
  vmovups xmm2,[rdx+0x20] ; load last row : r2 
  vmovaps xmm3,[r8]       ; Loading entire Vec3 or Mat3x1 at once 

  vdpps xmm0,xmm1,xmm3,0xF1     ; xmm0[31:0]=[r0 dot v]
  vextractf128 xmm4,ymm1,0x01   ; pull r1 from ymm1[255:128] to xmm4 
  vdpps xmm0,xmm4,xmm3,0xF2     ; xmm0[63:32]=[r1 dot v]
  vdpps xmm0,xmm2,xmm3,0xF4     ; xmm0[95:64]=[r2 dot v]
  vmovups [rcx],xmm0            ; Write back result 
  ret 

; void scale([rcx]=Mat3x3* dest,xmm1=float f,[r8]=Mat3x3 vec);
; dest = f*vec
          
mat3x3_scale:
  vbroadcastss ymm1,xmm1 
  vmulps ymm0,ymm1,[r8] 
  vmovups [rcx],ymm0

  vmulps xmm0,xmm1,[r8+0x20]    ; load last row 
  vmovups [rcx+0x20],xmm0       ; write to dest 
  ret 


;/////////////////////////////////////////////////////////////////////////////////
;                                Matrix4x4                                      /
;///////////////////////////////////////////////////////////////////////////////


; void mat4x4_add([rcx]=Mat4x4& dest,[rcx]=Mat4x4& a,[r8=Mat4x4& b);
; dest= a+b 

mat4x4_add:
  vmovups ymm1,[rdx]
  vaddps ymm0,ymm1,[r8]
  vmovups [rcx],ymm0 

  vmovups ymm1,[rdx+0x20]
  vaddps  ymm0,ymm1,[r8+0x20]
  vmovups [rcx+0x20],ymm0 
  ret


 ; void multiply([rcx]=Mat4x4* dest,[rdx]=Mat4x4* A,[r8]=Mat4x4* B)
 ; Assuming one of the matrices are Transposed 
mat4x4_mul_mat4x4:
 
  ; Pushing ymm6 on stack 
  sub rsp,0x20
  vmovups [rsp],ymm6 

  ; load r0,r1 of B then r2,r3
  vmovups ymm1,[r8]
  vmovups ymm2,[r8+0x20] 
  xor eax,eax  ; i 

.loop:
  vmovups xmm0,[rdx+rax] ; Load only 1 row from A 
  vextractf128 xmm4,ymm1,0x01 ; xmm4[127:0]=ymm1[255:128] = B r1 
  vextractf128 xmm6,ymm2,0x01 ; xmm6[127:0]=ymm2[255:128] = B r3

  vdpps xmm3,xmm0,xmm1,0xF1   ; xmm3[0]=xmm0 dot xmm1 = A row_i dot B r0 
  vdpps xmm4,xmm0,xmm4,0xF1   ; xmm4[0]=xmm0 dot xmm4 = A row_i dot B r1 

  vdpps xmm5,xmm0,xmm2,0xF1   ; xmm5[0]=xmm0 dot xmm2 = A row_i dot B r2 
  vdpps xmm6,xmm0,xmm6,0xF1   ; xmm6[0]=xmm0 dot xmm6 = A row_i dot B r3 

  ; pack the result back to xmm0 
  vinsertps xmm0,xmm0,xmm3,0x00  ; xmm0[0]=xmm3[0]
  vinsertps xmm0,xmm0,xmm4,0x10  ; xmm0[1]=xmm4[0]
  vinsertps xmm0,xmm0,xmm5,0x20  ; xmm0[2]=xmm5[0]
  vinsertps xmm0,xmm0,xmm6,0x30  ; xmm0[3]=xmm6[0] 
 
  vmovups [rcx+rax],xmm0 
  add eax,0x10 ; move 16B next row of A
  cmp eax,0x40 ; cmp with 64 B 
  jb .loop

  vmovups ymm6,[rsp]
  add rsp,0x20
  ret 

; void mul_vec4([rcx]=Vec4* dest,[rdx]=Mat4x4* M,[r8]=Vec4* v)
; the 4x1 matrix or 1x4 matrix is just Vec4 , just the representation changes

mat4x4_mul_vec4:
  
  vmovups ymm1,[rdx]              ; load 2 rows : r0 r1 
  vmovups ymm2,[rdx+0x20]         ; load r2,r3 
  vmovaps xmm3,[r8]               ; Entire vec4 or mat4x1 loaded at once

  vdpps xmm0,xmm1,xmm3,0xF1       ; xmm0 [31:0]  = [r0 dot v]
  vextractf128 xmm4,ymm1,0x01     ; pull r1 from ymm1[255:128] to xmm4
  vdpps xmm0,xmm4,xmm3,0xF2       ; xmm0 [63:32] = [r1 dot v]
  vdpps xmm0,xmm2,xmm3,0xF4       ; xmm0 [95:64] = [r2 dot v]

  vextractf128 xmm4,ymm2,0x01     ; pull r3 from ymm2[255:128] to xmm4 
  vdpps xmm0,xmm1,xmm2,0xF8       ; xmm0 [127:96] = [r3 dot v]
  vmovups [rcx],xmm0              ; Write back result 
  ret 


;void mat4x4_scale([rcx]=Mat4x4* dest, xmm1=float f,[r8]=Matt4x4* v)
; dest=f*v
mat4x4_scale:
  
  vbroadcastss ymm1,xmm1 
  vmulps ymm0,ymm1,[r8]
  vmovups [rcx],ymm0

  vmulps ymm0,ymm1,[r8+0x20]
  vmovups [rcx+0x20],ymm0 
  ret 
