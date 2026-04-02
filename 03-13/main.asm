%include "io.inc"

section .bss
    n       resd 1
    k       resd 1
    m       resd 1
    mask    resd 1
    ansx    resd 1

section .text
global CMAIN

; -------------------------------------------------
; placements_count(n, k)
; cdecl:
;   [ebp+8]  = n
;   [ebp+12] = k
; результат:
;   eax = P(n, k) = n * (n-1) * ... * (n-k+1)
; -------------------------------------------------
placements_count:
    push ebp
    mov ebp, esp

    push ebx
    push ecx
    push edx

    mov eax, 1              ; ans = 1
    mov ebx, [ebp + 8]      ; n
    mov ecx, [ebp + 12]     ; k
    xor edx, edx            ; i = 0

.loop:
    cmp edx, ecx
    jae .done

    ; ans *= (n - i)
    push eax                ; сохранили ans
    mov eax, ebx
    sub eax, edx            ; eax = n - i
    mov ecx, eax            ; ecx = n - i
    pop eax                 ; eax = ans
    imul eax, ecx           ; eax = ans * (n - i)

    inc edx
    mov ecx, [ebp + 12]     ; восстановили k
    jmp .loop

.done:
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
    GET_UDEC 4, [n]
    GET_UDEC 4, [k]
    GET_UDEC 4, [m]

    mov dword [mask], 0

    xor edi, edi            ; pos = 0

.pos_loop:
    mov eax, [k]
    cmp edi, eax
    jae .finish

    mov esi, 1              ; x = 1

.x_loop:
    mov eax, [n]
    cmp esi, eax
    ja .finish              ; сюда не должны попадать по условию

    ; if ((mask >> x) & 1) == 1 -> continue
    mov eax, [mask]
    mov ecx, esi
    shr eax, cl
    and eax, 1
    cmp eax, 1
    je .next_x

    ; cnt = placements_count(n - pos - 1, k - pos - 1)

    ; arg2 = k - pos - 1
    mov eax, [k]
    sub eax, edi
    dec eax
    push eax

    ; arg1 = n - pos - 1
    mov eax, [n]
    sub eax, edi
    dec eax
    push eax

    call placements_count
    add esp, 8              ; eax = cnt

    ; if (m > cnt) m -= cnt
    mov ebx, [m]
    cmp ebx, eax
    jbe .take_x

    sub ebx, eax
    mov [m], ebx
    jmp .next_x

.take_x:
    ; mask |= (1 << x)
    mov eax, 1
    mov ecx, esi
    shl eax, cl
    or [mask], eax

    mov [ansx], esi
    PRINT_UDEC 4, [ansx]

    ; печатаем пробел после каждого, кроме последнего
    mov eax, edi
    inc eax
    cmp eax, [k]
    je .after_print

    PRINT_CHAR ' '

.after_print:
    inc edi                 ; pos++
    jmp .pos_loop

.next_x:
    inc esi
    jmp .x_loop

.finish:
    NEWLINE
    xor eax, eax
    ret

section .note.GNU-stack noalloc noexec nowrite progbits