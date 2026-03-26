%include "io.inc"

section .bss
    x resd 1

section .text
global CMAIN

CMAIN:
    GET_UDEC 4, [x]
    PRINT_UDEC 4, [x]
    NEWLINE

    xor eax, eax
    ret
