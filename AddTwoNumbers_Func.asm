; build: nasm -f win64 addTwoNumbers.asm -o addTwoNumbers.obj
;        gcc  -mconsole addTwoNumbers.obj -o addTwoNumbers.exe
default rel
extern _gcvt_s
extern puts
global main
global addTwoDoubles

section .data
a       dq  2.4576655
b       dq  30.0
buf     times 64 db 0

section .text

addTwoDoubles:
    addsd xmm0, xmm1
    ret

main:
    sub     rsp, 40

    ; XMM0 = a + b
    movsd   xmm0, [rel a]
    movsd   xmm1, [rel b]
    call    addTwoDoubles

    ; _gcvt_s(buf, 64, (double)xmm0, 6)
    lea     rcx, [rel buf]         ; buf
    mov     rdx, 64                 ; size

    ; third arg is double → XMM2 (because RCX,RDX used)
    movapd  xmm2, xmm0
    mov     r9d, 9                  ; digits
    call    _gcvt_s

    lea     rcx, [rel buf]         ; puts(buf)
    call    puts

    add     rsp, 40
    xor     eax, eax
    ret
