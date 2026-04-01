%include "io.inc"

%define BASE 1000000000
%define BIG_D0   0
%define BIG_D1   4
%define BIG_D2   8
%define BIG_D3   12
%define BIG_SIZE 16
%define BIG_BYTES 20

section .bss
    a   resd 1
    b   resd 1
    c   resd 1

    ; result Big
    res resb BIG_BYTES

section .text
global CMAIN

; -------------------------------------------------
; add32(a, b)
; вход:
;   eax = a
;   ebx = b
; выход:
;   eax = sum
;   edx = carry (0 или 1)
; -------------------------------------------------
add32:
    add eax, ebx
    xor edx, edx
    jnc .done
    mov edx, 1
.done:
    ret

; -------------------------------------------------
; mul_big_by_u32(big, num)
;
; вход:
;   esi -> Big
;   eax = num
;
; меняет Big на месте:
;   big = big * num
;
; портит:
;   eax, ebx, ecx, edx, edi
; -------------------------------------------------
mul_big_by_u32:
    mov edi, eax        ; edi = num
    xor ebx, ebx        ; carry = 0
    xor ecx, ecx        ; i = 0

.loop:
    ; while i < big.size or carry > 0
    mov eax, [esi + BIG_SIZE]
    cmp ecx, eax
    jb .work
    cmp ebx, 0
    je .done

.work:
    ; if i == big.size:
    ;     big.d[i] = 0
    ;     big.size += 1
    mov eax, [esi + BIG_SIZE]
    cmp ecx, eax
    jne .have_block

    mov dword [esi + ecx*4], 0
    inc dword [esi + BIG_SIZE]

.have_block:
    ; 1) prod = big.d[i] * num
    ;    EDX:EAX = big.d[i] * num
    mov eax, [esi + ecx*4]
    mul edi

    ; 2) cur = prod + carry
    add eax, ebx
    adc edx, 0

    ; 3) делим cur на BASE
    ;    quotient -> eax = new_carry
    ;    remainder -> edx = rem
    mov ebx, BASE
    div ebx

    ; rem -> big.d[i]
    mov [esi + ecx*4], edx

    ; new_carry -> ebx
    mov ebx, eax

    inc ecx
    jmp .loop

.done:
    ret

; -------------------------------------------------
; solve(a, b, c, &res)
;
; вход:
;   eax = a
;   ebx = b
;   ecx = c
;   esi -> Big result
;
; после возврата:
;   result лежит в структуре Big по адресу esi
;
; портит:
;   eax, ebx, ecx, edx, edi
; -------------------------------------------------
solve:
    ; обнуляем result
    mov dword [esi + BIG_D0], 0
    mov dword [esi + BIG_D1], 0
    mov dword [esi + BIG_D2], 0
    mov dword [esi + BIG_D3], 0
    mov dword [esi + BIG_SIZE], 1

    ; result = a
    mov [esi + BIG_D0], eax

    ; сохраним b и c
    push ebx
    push ecx

    ; result *= b
    mov eax, [esp + 4]      ; b
    call mul_big_by_u32

    ; result *= c
    mov eax, [esp + 0]      ; c
    call mul_big_by_u32

    add esp, 8
    ret

; -------------------------------------------------
; print_big(esi -> Big)
; -------------------------------------------------
print_big:
    push eax
    push ebx
    push ecx
    push edx
    push edi

    mov ecx, [esi + BIG_SIZE]
    dec ecx

    ; старший блок
    mov eax, [esi + ecx*4]
    PRINT_UDEC 4, eax

    dec ecx

.next:
    cmp ecx, -1
    je .done

    mov eax, [esi + ecx*4]
    mov edi, eax          ; сохранили число

    mov ebx, 100000000    ; 10^8

.pad:
    cmp ebx, 0
    je .print

    xor edx, edx
    mov eax, edi
    div ebx

    test eax, eax
    jne .skip_zero

    ; печатаем '0'
    push edx
    mov edx, '0'
    PRINT_CHAR edx
    pop edx

.skip_zero:
    mov eax, ebx
    mov edx, 0
    mov ebx, 10
    div ebx
    mov ebx, eax

    jmp .pad

.print:
    mov eax, edi
    PRINT_UDEC 4, eax

    dec ecx
    jmp .next

.done:
    NEWLINE

    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
    
; -------------------------------------------------
; demo CMAIN
; читает a, b, c
; вызывает solve
; результат остаётся в res:
;   res.d[0..3], res.size
; -------------------------------------------------
CMAIN:
    GET_UDEC 4, [a]
    GET_UDEC 4, [b]
    GET_UDEC 4, [c]

    mov eax, [a]
    mov ebx, [b]
    mov ecx, [c]
    mov esi, res
    call solve

    mov esi, res
    call print_big
    
    xor eax, eax
    ret
