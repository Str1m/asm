%include "io.inc"

section .bss
    m    resd 1
    n    resd 1
    x    resd 1

section .data
    yes_str db "Yes", 0
    no_str  db "No", 0

section .text
global CMAIN

; -------------------------------------------------
; reverse_num(x)
; вход:
;   eax = x
; выход:
;   eax = reversed(x)
; портит:
;   ebx, ecx, edx, esi
; -------------------------------------------------
reverse_num:
    xor ecx, ecx          ; ecx = rev = 0
    mov ebx, 10

.rev_loop:
    cmp eax, 0
    je .rev_done

    xor edx, edx
    div ebx               ; eax = x / 10, edx = digit

    mov esi, eax          ; сохранили x / 10
    push edx              ; сохранили digit

    mov eax, ecx
    mul ebx               ; eax = rev * 10
    pop edx               ; восстановили digit

    add eax, edx          ; eax = rev * 10 + digit
    mov ecx, eax          ; rev = eax

    mov eax, esi          ; x = x / 10
    jmp .rev_loop

.rev_done:
    mov eax, ecx
    ret

; -------------------------------------------------
; is_palindrome(x)
; вход:
;   eax = x
; выход:
;   eax = 1, если palindrome
;   eax = 0, иначе
; портит:
;   ebx, ecx, edx, esi
; -------------------------------------------------
is_palindrome:
    push eax            ; сохранили исходное x
    call reverse_num
    pop edx             ; edx = исходное x

    cmp eax, edx
    jne .false_result

    mov eax, 1
    ret

.false_result:
    xor eax, eax
    ret

; -------------------------------------------------
; CMAIN
; -------------------------------------------------
CMAIN:
    GET_UDEC 4, [m]
    GET_UDEC 4, [n]

    ; x = m
    mov eax, [m]
    mov [x], eax

    ; делаем ровно n шагов
    mov ecx, [n]

.main_loop:
    cmp ecx, 0
    je .check_final

    push ecx
    mov eax, [x]
    call reverse_num
    pop ecx

    add [x], eax

    dec ecx
    jmp .main_loop

.check_final:
    mov eax, [x]
    call is_palindrome

    cmp eax, 1
    jne .print_no

    PRINT_STRING yes_str
    NEWLINE
    PRINT_UDEC 4, [x]
    NEWLINE
    xor eax, eax
    ret

.print_no:
    PRINT_STRING no_str
    NEWLINE
    xor eax, eax
    ret