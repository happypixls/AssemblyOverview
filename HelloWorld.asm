; build: ./nasm -f win64 HelloWorld.asm -o hello.obj
;        gcc -mconsole hello.obj -o hello.exe

extern printf
global main

section .data
msg db "Hello, World!", 10, 0

section .text
main:
    ; Win64: need 32 bytes shadow space AND 16-byte alignment at call sites
    sub     rsp, 40           ; 32 shadow + 8 to fix alignment

    lea     rcx, [rel msg]    ; printf(const char*) in RCX
    xor     eax, eax          ; varargs ABI: AL = number of XMM regs used (0)
    call    printf

    add     rsp, 40
    xor     eax, eax          ; return 0
    ret