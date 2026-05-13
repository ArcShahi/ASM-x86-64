; Quadractic equation solver using quadratic formula 

default rel

extern _CRT_INIT,printf,scanf
global main

segment .data
  msg db "Coefficient (a,b,c): ",0
  fmt db "%lf %lf %lf",0
  ans0 db "2 Real solutions: x1 = %g , x2 = %g",0xA,0xA,0 
  ans1 db "Double solution : x1 = x2 = %g",0xA,0xA,0 
  ans2 db "2 Complex solutions : x1 = x2 = ( %g +- %gi )", 0xA,0xA, 0

  neg4 dq -4.0
  neg1 dq -1.0

segment .text

; xmm0=a,xmm1=b,xmm2=c 
find_roots:
  sub rsp,0x28 

  vmulsd xmm3,xmm0,xmm2 
  vmulsd  xmm3,xmm3,[neg4]     ; xmm3= -4ac 
  vmulsd  xmm2,xmm1,xmm1       ; xmm2 = b^2 
  vaddsd  xmm3,xmm3,xmm2       ; xmm3= descriminant = b^2 +(-4ac) 
  vsqrtsd xmm2,xmm2,xmm3       ; xmm2= sqrt(d) 
  
  vmulsd xmm1,xmm1,[neg1]      ; xmm1 = -b
  vaddsd xmm0,xmm0,xmm0        ; xmm0 = 2a
  vxorpd xmm4,xmm4,xmm4  
  vcomisd xmm3,xmm4            ; compare descriminant with 0 
  jb .LCR
  jg .LRR

  ; Double Solution , 1 Real root 
  vdivsd xmm1,xmm1,xmm0         ; x1=x2= -b/2a 
  lea rcx,[ans1]
  vmovq rdx,xmm1                ; Mirror in GP reg , cuz printf and x64 ABI is weird 
  call printf 
  jmp .done

 ; 2 Real solution 
.LRR:
  vmovapd xmm4,xmm1             ; xmm4 = -b  
  vaddsd xmm1,xmm1,xmm2 
  vdivsd xmm1,xmm1,xmm0         ; xmm1= x1 =  (-b+sqrt(d))/ 2a )
  vsubsd xmm2,xmm4,xmm2
  vdivsd xmm2,xmm2,xmm0         ; xmm2 = x2 = (-b-sqrt(d) / 2a ) 
  
  lea rcx,[ans0]
  vmovq rdx,xmm1 
  vmovq r8,xmm2                 ; mirroring 
  call printf  
  jmp .done 

 ; 2 Complex Solution 
.LCR:
  vmovapd xmm4,xmm1              ; xmm4=-b
  vdivsd xmm1,xmm1,xmm0          ; xmm1 = real part = -b/2a 
  vmulsd xmm2,xmm3,[neg1]        ; 'd' is -ive here, so making it positive 
  vsqrtsd xmm2,xmm2,xmm2         ; xmm2 = sqrt(|d|)
  vdivsd xmm2,xmm2,xmm0          ; xmm2 = ur gf part = sqrt(|d|)/ 2a 
  
  lea   rcx,[ans2]
  vmovq rdx,xmm1  
  vmovq r8 ,xmm2                  ; Mirroring 
  call printf 


.done:
  xor eax,eax 
  add rsp,0x28 
  ret 

main: 
  sub rsp,0x38 ; 56B : 32B shadow + 24B Local and 8B caller ret addr = 64B % 16== 0 Aligned 
  call _CRT_INIT

  lea rcx,[msg]
  call printf 

  lea rcx,[fmt]
  lea rdx,[rsp+0x30] ; &a (8B for locals)
  lea r8, [rsp+0x28] ; &b 
  lea r9, [rsp+0x20] ; &c 
  call scanf 

  ; Pass values 
  vmovsd xmm0,qword[rsp+0x30]
  vmovsd xmm1,qword[rsp+0x28]
  vmovsd xmm2,qword[rsp+0x20]
  call find_roots


  xor eax,eax 
  add rsp,0x38
  ret 

; This is one of the worst things I've ever done...
; -Shahi
