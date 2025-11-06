; build: nasm -f win64 AddTwoNumbersWithVars.asm -o AddTwoNumbersWithVars.obj
;        gcc  -mconsole AddTwoNumbersWithVars.obj -o AddTwoNumbersWithVars.exe
default rel
extern _gcvt_s
extern puts
global main

section .data
a       dq  1.4576655
b       dq  30.0
buf     times 64 db 0

section .text
main:
    sub     rsp, 40

    ; XMM0 = a + b
    movsd   xmm0, [rel a]
    addsd   xmm0, [rel b]

    ; _gcvt_s(buf, 64, (double)xmm0, 6)
    lea     rcx, [rel buf]         ; buf
    mov     rdx, 64                 ; size
    ; third arg is double → XMM2 (because RCX,RDX used)
    movapd  xmm2, xmm0
    mov     r9d, 6                  ; digits
    call    _gcvt_s

    lea     rcx, [rel buf]         ; puts(buf)
    call    puts

    add     rsp, 40
    xor     eax, eax
    ret
