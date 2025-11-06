; build: nasm -f win64 SummingArray.asm -o SummingArray.obj
;        gcc  -mconsole SummingArray.obj -o SummingArray.exe
default rel
extern printf
global main

section .data
fmt     db "sum(array) = %lld", 10, 0
arr     dq 3, 5, 7, 9, 11
arr_len dq 5

section .text
main:
    sub     rsp, 40                  ; 32B shadow + 8B align

    xor     rax, rax                 ; sum = 0  (RAX accumulates)
    xor     rdi, rdi                 ; idx = 0
    mov     rcx, [rel arr_len]       ; rcx = length (5)

    lea     rsi, [rel arr]           ; rsi = &arr[0]  (base address for indexing)

.for:
    cmp     rdi, rcx
    jge     .done

    mov     r8, [rsi + rdi*8]        ; load arr[idx] (each element is 8 bytes)
    add     rax, r8                  ; sum += arr[idx]
    inc     rdi
    jmp     .for

.done:
    ; printf("sum(array) = %lld\n", sum)
    lea     rcx, [rel fmt]
    mov     rdx, rax
    mov     [rsp+0], rcx             ; variadic robustness: home args
    mov     [rsp+8], rdx
    xor     eax, eax                 ; no XMM args
    call    printf

    add     rsp, 40
    xor     eax, eax
    ret
