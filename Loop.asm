; build: nasm -f win64 Loop.asm -o Loop.obj
;        gcc  -mconsole Loop.obj -o Loop.exe
default rel
extern printf
global main

section .data
fmt db "i = %lld", 10, 0

section .text
main:
    sub     rsp, 40

    mov     rbx, 5          ; i = 5
.loop:
    cmp     rbx, 0
    jle     .done

    ; printf("i = %lld\n", i)
    lea     rcx, [rel fmt]
    mov     rdx, rbx
    mov     [rsp+0], rcx
    mov     [rsp+8], rdx
    xor     eax, eax
    call    printf

    dec     rbx
    jmp     .loop

.done:
    add     rsp, 40
    xor     eax, eax
    ret
