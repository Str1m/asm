%include "io.inc"

section .text
global CMAIN

; -------------------------------------------------
; solve_rec(pos)
; pos передаётся через стек (cdecl)
; -------------------------------------------------
solve_rec:
    push ebp
    mov ebp, esp
    sub esp, 4              ; локальная переменная x = [ebp - 4]

    ; eax = pos
    mov eax, [ebp + 8]

    ; читаем x
    GET_DEC 4, [ebp - 4]

    ; if x == 0 return
    cmp dword [ebp - 4], 0
    je .done

    ; проверка: pos % 2
    test eax, 1
    jz .even_case

    ; ---- нечётная позиция ----
    PRINT_DEC 4, [ebp - 4]
    PRINT_CHAR ' '

.even_case:
    ; рекурсивный вызов solve_rec(pos + 1)
    mov eax, [ebp + 8]
    inc eax
    push eax
    call solve_rec
    add esp, 4

    ; если pos чётная → печатаем после
    mov eax, [ebp + 8]
    test eax, 1
    jnz .done

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
    push 1                  ; начальная позиция = 1
    call solve_rec
    add esp, 4

    NEWLINE

    xor eax, eax
    ret
