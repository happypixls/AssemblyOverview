; build: nasm -f win64 MaxOfTwoInts.asm -o MaxOfTwoInts.obj
;        gcc  -mconsole MaxOfTwoInts.obj -o MaxOfTwoInts.exe

default rel
extern printf
global main
global max2i

section .data
fmt db "max(%lld, %lld) = %lld", 10, 0

section .text
; long long max2i(long long x, long long y)
; Win64: x in RCX, y in RDX, return in RAX
max2i:
    mov     rax, rcx        ; rax = x
    cmp     rdx, rax        ; compare y vs x
    cmovg   rax, rdx        ; if (y > x) rax = y
    ret

main:
    sub     rsp, 40         ; 32B shadow + 8B align

    mov     rcx, 10         ; arg1
    mov     rdx, 30         ; arg2
    call    max2i           ; RAX = max(10,30)

    ; printf(fmt, 10, 30, RAX)
    lea     rcx, [rel fmt]
    mov     rdx, 10
    mov     r8,  30
    mov     r9,  rax
    ; (variadic robustness) home RCX/RDX/R8/R9:
    mov     [rsp+0], rcx
    mov     [rsp+8], rdx
    mov     [rsp+16], r8
    mov     [rsp+24], r9
    xor     eax, eax        ; no XMM args
    call    printf

    add     rsp, 40
    xor     eax, eax
    ret
