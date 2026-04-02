%include "io.inc"

%define MOD 2011

section .bss
    k   resd 1
    n   resd 1
    a   resd 1
    y   resd 1

section .text
global CMAIN

; -------------------------------------------------
; reverse_in_base(x, k)
; вход:
;   eax = x
;   ebx = k
; выход:
;   eax = число, полученное разворотом записи x
;         в системе счисления по основанию k
;
; портит:
;   ecx, edx, esi
; -------------------------------------------------
reverse_in_base:
    xor ecx, ecx              ; ecx = rev = 0

.rev_loop:
    cmp eax, 0
    je .rev_done

    xor edx, edx
    div ebx                   ; eax = x / k, edx = digit

    mov esi, eax              ; сохранили x / k
    push edx                  ; сохранили digit

    mov eax, ecx
    mul ebx                   ; eax = rev * k
    pop edx                   ; восстановили digit

    add eax, edx              ; eax = rev * k + digit
    mov ecx, eax              ; rev = eax

    mov eax, esi              ; x = x / k
    jmp .rev_loop

.rev_done:
    mov eax, ecx
    ret

; -------------------------------------------------
; CMAIN
; -------------------------------------------------
CMAIN:
    ; читаем k, n, a
    GET_UDEC 4, [k]
    GET_UDEC 4, [n]
    GET_UDEC 4, [a]

    ; y = a % MOD
    mov eax, [a]
    xor edx, edx
    mov ebx, MOD
    div ebx
    mov [y], edx

    ; for i in 0..n-1
    mov ecx, [n]

.main_loop:
    cmp ecx, 0
    je .print_answer

    ; t = y * y
    ; здесь t < 2011^2 = 4044121, так что влезает в 32 бита
    mov eax, [y]
    mov ebx, eax
    mul ebx                   ; edx:eax = y * y

    ; reverse_in_base(t, k)
    mov ebx, [k]
    push ecx                  ; reverse_in_base портит ecx
    call reverse_in_base
    pop ecx

    ; y = rev % MOD
    xor edx, edx
    mov ebx, MOD
    div ebx
    mov [y], edx

    dec ecx
    jmp .main_loop

.print_answer:
    PRINT_UDEC 4, [y]
    NEWLINE

    xor eax, eax
    ret
