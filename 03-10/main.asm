%include "io.inc"

section .bss
    n   resd 1
    x   resd 1
    y   resd 1
    num resd 1
    den resd 1
    g   resd 1
    tmp resd 1

section .text
global CMAIN

; -------------------------------------------------
; gcd(a, b)
; вход:
;   eax = a
;   ebx = b
; выход:
;   eax = gcd(a, b)
; -------------------------------------------------
gcd:
.gcd_loop:
    cmp ebx, 0
    je .gcd_done

    xor edx, edx
    div ebx          ; eax = a / b, edx = a % b

    mov eax, ebx     ; a = b
    mov ebx, edx     ; b = remainder
    jmp .gcd_loop

.gcd_done:
    ret

; -------------------------------------------------
; solve
; -------------------------------------------------
CMAIN:
    ; read n
    GET_UDEC 4, [n]

    ; num = 0
    mov dword [num], 0

    ; den = 1
    mov dword [den], 1

    ; ecx = n
    mov ecx, [n]

.for_loop:
    cmp ecx, 0
    je .done

    ; read x, y
    GET_UDEC 4, [x]
    GET_UDEC 4, [y]

    ; ---------------------------------------------
    ; num = num * y + x * den
    ; ---------------------------------------------

    ; tmp = num * y
    mov eax, [num]
    mul dword [y]        ; edx:eax = num * y
    mov [tmp], eax       ; берём младшие 32 бита

    ; eax = x * den
    mov eax, [x]
    mul dword [den]      ; edx:eax = x * den

    ; eax = tmp + x * den
    add eax, [tmp]
    mov [num], eax

    ; ---------------------------------------------
    ; den = den * y
    ; ---------------------------------------------
    mov eax, [den]
    mul dword [y]
    mov [den], eax

    ; ---------------------------------------------
    ; g = gcd(num, den)
    ; ---------------------------------------------
    mov eax, [num]
    mov ebx, [den]
    call gcd
    mov [g], eax

    ; ---------------------------------------------
    ; num = num / g
    ; ---------------------------------------------
    mov eax, [num]
    xor edx, edx
    div dword [g]
    mov [num], eax

    ; ---------------------------------------------
    ; den = den / g
    ; ---------------------------------------------
    mov eax, [den]
    xor edx, edx
    div dword [g]
    mov [den], eax

    dec ecx
    jmp .for_loop

.done:
    PRINT_UDEC 4, [num]
    PRINT_CHAR ' '
    PRINT_UDEC 4, [den]
    NEWLINE

    xor eax, eax
    ret