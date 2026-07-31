; Project Euler : 5 
; Assembler with : neko .\pe5.asm -LinkerArgs ".\out\obj\lcm.obj", ".\out\obj\gcd.obj"

default rel

extern _CRT_INIT,printf,lcm 
global main 

segment .data
    fmt db "ANS: %lld", 0xA, 0

segment .text
   
min_multiple:
    sub rsp, 0x38         
    mov r10, rcx            ; N
    mov qword [rsp+0x30], 1 ; result  = 1
    mov qword [rsp+0x28], 2 ; counter = 2

.loop:
    mov rcx, [rsp+0x30]
    mov rdx, [rsp+0x28]
    call lcm
    mov [rsp+0x30], rax     ; result = lcm(result, counter)
    inc qword [rsp+0x28]
    cmp [rsp+0x28], r10
    jle .loop

    mov rax, [rsp+0x30]
    add rsp, 0x38
    ret

main:
    sub rsp, 0x28
    call _CRT_INIT

    mov rcx, 20
    call min_multiple

    lea rcx, [fmt]
    mov rdx, rax
    call printf

    xor eax,eax 
    add rsp, 0x28
    ret

