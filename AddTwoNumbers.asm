; build: nasm -f win64 addTwoNumbers.asm -o addTwoNumbers.obj
;        gcc  -mconsole addTwoNumbers.obj -o addTwoNumbers.exe

section .data
fmt db "%lld", 10, 0     ; format string: 64-bit signed int + '\n'

extern printf
global main

section .text
main:
    sub     rsp, 40           ; 32 shadow + 8 to fix alignment

    mov     rax, 60
    mov     rdx, 30
    add     rdx, rax
    lea     rcx, [rel fmt]

    call    printf
    add     rsp, 40
    xor     eax, eax          ; return 0
    ret