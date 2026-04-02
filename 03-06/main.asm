%include "io.inc"

section .bss
    n       resd 1
    k       resd 1
    x       resd 1
    ans     resd 1
    arr     resd 1000

section .text
global CMAIN

; -------------------------------------------------
; significant_zeros(x)
; cdecl:
;   аргумент x лежит по [ebp + 8]
; результат:
;   eax = количество значащих нулей
; -------------------------------------------------
significant_zeros:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]      ; eax = x
    xor ebx, ebx            ; ebx = count = 0

    ; if x == 0 return 0
    cmp eax, 0
    je .finish

.loop:
    test eax, 1
    jnz .next

    inc ebx

.next:
    shr eax, 1
    cmp eax, 0
    jne .loop

.finish:
    mov eax, ebx
    mov esp, ebp
    pop ebp
    ret

; -------------------------------------------------
; CMAIN
; -------------------------------------------------
CMAIN:
    GET_UDEC 4, [n]

    ; читаем массив
    xor ecx, ecx
.read_loop:
    cmp ecx, [n]
    jae .read_k

    GET_UDEC 4, [arr + ecx*4]
    inc ecx
    jmp .read_loop

.read_k:
    GET_UDEC 4, [k]

    mov dword [ans], 0

    xor ecx, ecx
.check_loop:
    cmp ecx, [n]
    jae .print_answer

    push dword [arr + ecx*4]
    call significant_zeros
    add esp, 4

    cmp eax, [k]
    jne .next_item

    inc dword [ans]

.next_item:
    inc ecx
    jmp .check_loop

.print_answer:
    PRINT_UDEC 4, [ans]
    NEWLINE

    xor eax, eax
    ret
