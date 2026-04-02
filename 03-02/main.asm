%include "io.inc"

section .bss
    x   resd 1

section .text
global CMAIN

; -------------------------------------------------
; f(x)
; cdecl:
;   аргумент x лежит по [ebp + 8]
; результат:
;   eax = F(x)
; -------------------------------------------------
f:
    push ebp
    mov ebp, esp

    ; eax = x
    mov eax, [ebp + 8]

    ; if x == 0 return 0
    cmp eax, 0
    jne .work

    xor eax, eax
    jmp .done

.work:
    ; делим x на 3
    ; после div:
    ; eax = x / 3
    ; edx = x % 3
    xor edx, edx
    mov ecx, 3
    div ecx

    ; сохраним остаток (x % 3)
    push edx

    ; рекурсивный вызов f(x / 3)
    push eax
    call f
    add esp, 4

    ; достаём остаток обратно
    pop edx

    ; если остаток == 1, прибавляем 1
    cmp edx, 1
    jne .done

    inc eax

.done:
    mov esp, ebp
    pop ebp
    ret

; -------------------------------------------------
; CMAIN
; -------------------------------------------------
CMAIN:
    GET_UDEC 4, [x]

    push dword [x]
    call f
    add esp, 4

    PRINT_UDEC 4, eax
    NEWLINE

    xor eax, eax
    ret