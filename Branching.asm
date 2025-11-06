; build: nasm -f win64 Branching.asm -o Branching.obj
;        gcc  -mconsole Branching.obj -o Branching.exe
default rel
extern printf
global main

section .data
fmt db "if/else picked: %lld", 10, 0

section .text
main:
    sub     rsp, 40

    mov     rcx, 2         ; x
    mov     rdx, 17         ; y
    mov     rax, rcx        ; assume pick x
    cmp     rcx, rdx
    jge     .picked         ; if (x >= y) keep rax = x
    mov     rax, rdx        ; else rax = y
.picked:

    ; printf(fmt, rdx)
    lea     rcx, [rel fmt]
    mov     rdx, rax
    ; mov     [rsp+0], rcx
    ; mov     [rsp+8], rdx
    ; xor     eax, eax
    call    printf

    add     rsp, 40
    xor     eax, eax
    ret
