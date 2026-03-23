section .text

global my_printf

my_printf:
    ; Вызов write
    mov rax, 1
    mov rdx, rdi; исправить чтобы сама считала длину строки
    mov rdi, 1
    syscall

    ret

section .note.GNU-stack noalloc noexec nowrite progbits