%include "io.inc"

section .bss
    n resd 1
    k resd 1
    x resd 1

section .text
global CMAIN

; eax = a
; ebx = k
; eax -> 1 если lucky, иначе 0
is_lucky:
    push ebp
    push esi
    push edi

    mov ebp, eax        ; сохранить исходное a
    mov esi, eax        ; b = a
    xor ecx, ecx        ; sum_all = 0
    xor edi, edi        ; cnt = 0

.count_loop:
    cmp esi, 0
    je .count_done

    mov eax, esi
    xor edx, edx
    div ebx

    add ecx, edx
    inc edi
    mov esi, eax
    jmp .count_loop

.count_done:
    cmp edi, 0
    jne .not_zero_case

    mov eax, 1
    jmp .finish

.not_zero_case:
    test edi, 1
    jz .right_half_start
    inc edi

.right_half_start:
    xor esi, esi        ; sum_right = 0
    mov eax, ebp        ; восстановить исходное a

.right_loop:
    cmp edi, 0
    je .check_result

    xor edx, edx
    div ebx

    add esi, edx
    sub edi, 2
    jmp .right_loop

.check_result:
    lea eax, [esi + esi]
    cmp eax, ecx
    jne .false_result

    mov eax, 1
    jmp .finish

.false_result:
    xor eax, eax

.finish:
    pop edi
    pop esi
    pop ebp
    ret

CMAIN:
    push ebx
    push esi
    push edi

    GET_UDEC 4, [n]
    GET_UDEC 4, [k]

    mov eax, [n]
    mov [x], eax

.main_loop:
    mov eax, [x]
    mov ebx, [k]
    call is_lucky

    cmp eax, 1
    je .done

    inc dword [x]
    jmp .main_loop

.done:
    PRINT_UDEC 4, [x]
    NEWLINE

    pop edi
    pop esi
    pop ebx

    xor eax, eax
    ret
