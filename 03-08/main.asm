%include "io.inc"

section .bss
    n   resd 1
    k   resd 1
    x   resd 1
    ans resd 1

section .text
global CMAIN

; -------------------------------------------------
; sum_digits(x, k)
; вход:
;   eax = x
;   ebx = k
; выход:
;   eax = сумма цифр x в системе счисления по основанию k
;
; портит:
;   ecx, edx
; -------------------------------------------------
sum_digits:
    xor ecx, ecx              ; s = 0

.sum_loop:
    cmp eax, 0
    je .done

    xor edx, edx
    div ebx                   ; eax = x / k, edx = x % k
    add ecx, edx              ; s += digit
    jmp .sum_loop

.done:
    mov eax, ecx
    ret

; -------------------------------------------------
; CMAIN
; -------------------------------------------------
CMAIN:
    ; read n, k
    GET_UDEC 4, [n]
    GET_UDEC 4, [k]

    ; x = n
    mov eax, [n]
    mov [x], eax

    ; ans = 0
    mov dword [ans], 0

.main_loop:
    ; ans += x
    mov eax, [ans]
    add eax, [x]
    mov [ans], eax

    ; если sum_digits(x, k) == x,
    ; то это последнее число, его нужно учесть ещё раз
    mov eax, [x]
    mov ebx, [k]
    call sum_digits

    cmp eax, [x]
    je .add_last_and_finish

    ; иначе продолжаем процесс
    mov [x], eax
    jmp .main_loop

.add_last_and_finish:
    ; последнее число записывается ещё раз
    mov eax, [ans]
    add eax, [x]
    mov [ans], eax

.finish:
    PRINT_UDEC 4, [ans]
    NEWLINE

    xor eax, eax
    ret

section .note.GNU-stack noalloc noexec nowrite progbits