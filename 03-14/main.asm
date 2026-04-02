%include "io.inc"

%define MOD 2011

section .bss
    k       resd 1
    n       resd 1
    a       resd 1
    prev    resd 1
    cur     resd 1
    nextv   resd 1
    i       resd 1

section .text
global CMAIN

digits_in_base:
    cmp eax, 0
    jne .work
    mov eax, 1
    ret

.work:
    xor ecx, ecx
.dloop:
    xor edx, edx
    div ebx
    inc ecx
    cmp eax, 0
    jne .dloop
    mov eax, ecx
    ret

; eax = k, ecx = len -> eax = k^len mod MOD
pow_mod_small:
    push esi
    mov esi, eax              ; esi = k
    mov eax, 1

.ploop:
    cmp ecx, 0
    je .pdone

    mul esi
    mov ebx, MOD
    div ebx
    mov eax, edx

    dec ecx
    jmp .ploop

.pdone:
    pop esi
    ret

CMAIN:
    GET_UDEC 4, [k]
    GET_UDEC 4, [n]
    GET_UDEC 4, [a]

    ; prev = x0 = a % MOD
    mov eax, [a]
    xor edx, edx
    mov ebx, MOD
    div ebx
    mov [prev], edx

    cmp dword [n], 0
    jne .make_x1

    PRINT_UDEC 4, [prev]
    NEWLINE
    xor eax, eax
    ret

.make_x1:
    ; len(prev)
    mov eax, [prev]
    mov ebx, [k]
    call digits_in_base
    mov ecx, eax

    ; p = k^len mod MOD
    mov eax, [k]
    call pow_mod_small
    mov ebx, eax

    ; cur = x1
    mov eax, [prev]
    mul ebx
    add eax, [prev]
    adc edx, 0

    mov ebx, MOD
    div ebx
    mov [cur], edx

    cmp dword [n], 1
    jne .loop_init

    PRINT_UDEC 4, [cur]
    NEWLINE
    xor eax, eax
    ret

.loop_init:
    mov dword [i], 1

.main_loop:
    mov eax, [i]
    cmp eax, [n]
    jae .print_answer

    ; len(prev)
    mov eax, [prev]
    mov ebx, [k]
    call digits_in_base
    mov ecx, eax

    ; p = k^len mod MOD
    mov eax, [k]
    call pow_mod_small
    mov ebx, eax

    ; next = (cur * p + prev) % MOD
    mov eax, [cur]
    mul ebx
    add eax, [prev]
    adc edx, 0

    mov ebx, MOD
    div ebx
    mov [nextv], edx

    mov eax, [cur]
    mov [prev], eax

    mov eax, [nextv]
    mov [cur], eax

    inc dword [i]
    jmp .main_loop

.print_answer:
    PRINT_UDEC 4, [cur]
    NEWLINE

    xor eax, eax
    ret

section .note.GNU-stack noalloc noexec nowrite progbits