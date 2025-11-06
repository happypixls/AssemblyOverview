; build: nasm -f win64 AllocateArray.asm -o AllocateArray.obj
;        gcc  -mconsole AllocateArray.obj -o AllocateArray.exe
default rel
extern printf
global main

section .data
fmt     db "sum = %lld", 10, 0
len     dq 5

section .bss
arr     resq 8                      ; reserve space for up to 8 qwords (8 elements)

section .text
main:
    sub     rsp, 40

    ; --- "add elements to the array" (store values) ---
    lea     rsi, [rel arr]         ; rsi = &arr[0]
    mov     qword [rsi + 0*8], 10  ; arr[0] = 10
    mov     qword [rsi + 1*8], 20  ; arr[1] = 20
    mov     qword [rsi + 2*8], 30  ; arr[2] = 30
    mov     qword [rsi + 3*8], 40  ; arr[3] = 40
    mov     qword [rsi + 4*8], 50  ; arr[4] = 50
    ; (we set 5 elements; len=5)

    ; --- sum first 'len' elements ---
    xor     rax, rax               ; sum = 0
    xor     rdi, rdi               ; i = 0
    mov     rcx, [rel len]         ; rcx = length (5)

.for:
    cmp     rdi, rcx
    jge     .done
    add     rax, [rsi + rdi*8]     ; sum += arr[i]
    inc     rdi
    jmp     .for

.done:
    ; printf("sum = %lld\n", sum)
    lea     rcx, [rel fmt]
    mov     rdx, rax
    ; mov     [rsp+0], rcx
    ; mov     [rsp+8], rdx
    ; xor     eax, eax
    call    printf

    add     rsp, 40
    xor     eax, eax
    ret
