%include "io.inc"

section .text
global CMAIN

; -------------------------------------------------
; print_reversed()
; читает одно число
; если это 0 -> return
; иначе рекурсивно вызывает себя
; потом печатает это число
; -------------------------------------------------
print_reversed:
    push ebp
    mov ebp, esp
    sub esp, 4          ; локальная переменная x на стеке

    ; read x
    GET_DEC 4, [ebp - 4]

    ; if x == 0 return
    cmp dword [ebp - 4], 0
    je .done

    ; рекурсивный вызов
    call print_reversed

    ; печатаем текущее число после возврата
    PRINT_DEC 4, [ebp - 4]
    PRINT_CHAR ' '

.done:
    mov esp, ebp
    pop ebp
    ret

; -------------------------------------------------
; CMAIN
; -------------------------------------------------
CMAIN:
    call print_reversed
    NEWLINE

    xor eax, eax
    ret