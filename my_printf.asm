section .text

global my_printf

my_printf:
    ; считаем длину строки и кладем ее в rdx
    xor rdx, rdx
    .cnt_loop:
        cmp byte [rdi + rdx], 0
        je .end_cnt_loop
        inc rdx
        jmp .cnt_loop
    .end_cnt_loop:

    ; Вызов write
    mov rax, 1
    mov rsi, rdi
    mov rdi, 1
    syscall

    ret

section .note.GNU-stack noalloc noexec nowrite progbits