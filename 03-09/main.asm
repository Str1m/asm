%include "io.inc"

section .bss
    k       resd 1
    cnt     resd 1
    cur     resd 1

section .text
global CMAIN

; -------------------------------------------------
; is_deficient(x)
; cdecl:
;   аргумент x лежит по [ebp + 8]
; результат:
;   eax = 1, если число недостаточное
;   eax = 0, иначе
;
; идея:
;   считаем сумму собственных делителей числа x
;   если сумма < x, то число недостаточное
; -------------------------------------------------
is_deficient:
    push ebp
    mov ebp, esp

    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov esi, [ebp + 8]      ; esi = x

    ; для x = 1 сумма собственных делителей = 0
    ; 0 < 1, значит число недостаточное
    cmp esi, 1
    jne .not_one

    mov eax, 1
    jmp .finish

.not_one:
    mov edi, 1              ; sum = 1
    mov ebx, 2              ; d = 2

.loop:
    ; пока d * d <= x
    mov eax, ebx
    mul ebx                 ; edx:eax = d * d
    cmp eax, esi
    ja .check_sum

    ; проверяем делимость x на d
    mov eax, esi
    xor edx, edx
    div ebx                 ; eax = x / d, edx = x % d

    cmp edx, 0
    jne .next_d

    ; d — делитель
    add edi, ebx

    ; q = x / d, если q != d, то тоже добавляем
    cmp eax, ebx
    je .next_d

    add edi, eax

.next_d:
    inc ebx
    jmp .loop

.check_sum:
    ; если sum < x -> deficient
    mov eax, 0
    cmp edi, esi
    jae .finish

    mov eax, 1

.finish:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; -------------------------------------------------
; CMAIN
; -------------------------------------------------
CMAIN:
    GET_UDEC 4, [k]

    mov dword [cnt], 0      ; сколько недостаточных нашли
    mov dword [cur], 0      ; текущее число

.search_loop:
    ; если уже нашли k чисел, текущее cur и есть ответ
    mov eax, [cnt]
    cmp eax, [k]
    je .print_answer

    ; cur += 1
    inc dword [cur]

    ; проверяем cur
    push dword [cur]
    call is_deficient
    add esp, 4

    cmp eax, 1
    jne .search_loop

    inc dword [cnt]
    jmp .search_loop

.print_answer:
    ; когда cnt == k, в cur уже лежит k-е недостаточное число
    PRINT_UDEC 4, [cur]
    NEWLINE

    xor eax, eax
    ret

section .note.GNU-stack noalloc noexec nowrite progbits
