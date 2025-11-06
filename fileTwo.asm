; build: nasm -f win64 fileTwo.asm -o fileTwo.obj
;        gcc  -mconsole fileOne.obj fileTwo.obj -o Combined.exe
default rel
extern addTwoDoubles
extern _gcvt_s
extern puts
global main

section .data
a     dq __float64__(2.4576655)
b     dq __float64__(30.0)
buf   times 64 db 0

section .text
main:
    sub     rsp, 40                    ; 32 shadow + 8 align (Win64 rule)

    ; call the function in the other file
    movsd   xmm0, [rel a]              ; arg1 (a)  -> XMM0
    movsd   xmm1, [rel b]              ; arg2 (b)  -> XMM1
    call    addTwoDoubles              ; result    -> XMM0

    ; convert result to text and print (no varargs)
    lea     rcx, [rel buf]             ; _gcvt_s(buf, 64, XMM0, 6)
    mov     edx, 64
    movapd  xmm2, xmm0                 ; 3rd arg (double) goes in XMM2
    mov     r9d, 6
    call    _gcvt_s

    lea     rcx, [rel buf]
    call    puts

    add     rsp, 40
    xor     eax, eax
    ret
