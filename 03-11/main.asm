%include "io.inc"

section .bss
    n   resd 1
    x   resd 1

section .data
    yes_str db "YES", 0
    no_str  db "NO", 0

section .text
global CMAIN

; -------------------------------------------------
; div3(x)
; cdecl:
;   аргумент x лежит по [ebp + 8]
; результат:
;   eax = 1, если x делится на 3
;   eax = 0, иначе
;
; без массивов и без инструкции div
; -------------------------------------------------
div3:
    push ebp
    mov ebp, esp
    push ebx

    mov eax, [ebp + 8]      ; x
    xor ecx, ecx            ; rem = 0
    mov ebx, 0x80000000     ; маска для старшего бита

.bit_loop:
    ; rem = rem * 2
    lea ecx, [ecx + ecx]

    ; если текущий бит равен 1, прибавляем 1
    test eax, ebx
    jz .after_bit
    inc ecx

.after_bit:
    ; rem %= 3
    cmp ecx, 3
    jb .next_bit
    sub ecx, 3

.next_bit:
    shr ebx, 1
    jnz .bit_loop

    ; если rem == 0 -> YES
    xor eax, eax
    cmp ecx, 0
    jne .done

    mov eax, 1

.done:
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; -------------------------------------------------
; CMAIN
; -------------------------------------------------
CMAIN:
    GET_UDEC 4, [n]

    mov ecx, [n]

.read_loop:
    cmp ecx, 0
    je .finish

    GET_UDEC 4, [x]

    push ecx                ; div3 портит ecx
    push dword [x]
    call div3
    add esp, 4
    pop ecx

    cmp eax, 1
    jne .print_no

    PRINT_STRING yes_str
    NEWLINE
    jmp .next_num

.print_no:
    PRINT_STRING no_str
    NEWLINE

.next_num:
    dec ecx
    jmp .read_loop

.finish:
    xor eax, eax
    ret

section .note.GNU-stack noalloc noexec nowrite progbits