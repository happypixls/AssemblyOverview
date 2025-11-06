; build: nasm -f win64 addTwoNumbers_UserInput.asm -o addTwoNumbers_UserInput.obj
;        gcc  -mconsole addTwoNumbers_UserInput.obj -o addTwoNumbers_UserInput.exe
default rel
extern scanf
extern _gcvt_s
extern puts
global main
global addTwoDoubles

section .data
; prompts & formats
promptA db "Enter a (double): ", 0
promptB db "Enter b (double): ", 0
fmtIn   db "%lf", 0               ; scanf format for double (reads into double*)
fmtOut  db "sum = ", 0

; storage
a   dq 0
b   dq 0
buf times 64 db 0                  ; output buffer for _gcvt_s

section .text
; double addTwoDoubles(double a, double b)  -- XMM0+XMM1 -> XMM0
addTwoDoubles:
    addsd   xmm0, xmm1
    ret

main:
    ; One-time stack prep for all our calls:
    ; 32B shadow + 8B to get 16B alignment at each call site
    sub     rsp, 40

    ; --- read a ---
    lea     rcx, [rel promptA]
    call    puts                   ; puts(promptA)
    lea     rcx, [rel fmtIn]       ; RCX = "%lf"
    lea     rdx, [rel a]           ; RDX = &a  (double*)
    xor     eax, eax               ; scanf is variadic, but we pass NO XMM args
    call    scanf

    ; --- read b ---
    lea     rcx, [rel promptB]
    call    puts                   ; puts(promptB)
    lea     rcx, [rel fmtIn]
    lea     rdx, [rel b]
    xor     eax, eax
    call    scanf

    ; --- sum = addTwoDoubles(a, b) ---
    movsd   xmm0, [rel a]          ; arg1 (a) -> XMM0
    movsd   xmm1, [rel b]          ; arg2 (b) -> XMM1
    call    addTwoDoubles                  ; result in XMM0

    ; --- convert and print: "sum = <value>" ---
    lea     rcx, [rel fmtOut]
    call    puts                   ; print "sum = "

    ; _gcvt_s(buf, 64, (double)XMM0, 6)
    lea     rcx, [rel buf]         ; buf
    mov     edx, 64                ; size
    movapd  xmm2, xmm0             ; value (next FP arg register slot)
    mov     r9d, 6                 ; digits
    call    _gcvt_s

    lea     rcx, [rel buf]
    call    puts                   ; prints the number + newline

    add     rsp, 40
    xor     eax, eax
    ret
