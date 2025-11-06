; build: nasm -f win64 fileOne.asm -o fileOne.obj
;        gcc  -mconsole fileOne.obj fileTwo.obj -o Combined.exe

default rel
global addTwoDoubles

section .text
addTwoDoubles:
    addsd   xmm0, xmm1
    ret
