section .text

global my_printf

my_printf:
    pop rax
    push r9
    push r8
    push rcx
    push rdx
    push rsi
    push rdi
    push rax

    ;r12 - указатель на текущее положение в буффере
    mov r12, 0
    %define buffer_ptr r12

    ;r13 - указатель на текщее положение форматной строки
    mov r13, rdi
    %define fstr r13

    ;r14 - указатель на текщую форматную переменную
    mov r14, rsp
    add r14, 16
    %define farg r14

    .loop:
        cmp byte [fstr], 0
        je .endloop

        cmp byte [fstr], '%'
        jne .no_format
        inc fstr

        ;парсинг числа, если число
        
        call print_n
        
        jmp .loop

        .no_format:

        mov dl, [fstr]
        mov [buffer + buffer_ptr], dl
        inc fstr
        inc buffer_ptr
        
        jmp .loop
    .endloop:
    
    ; Вызов write
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, buffer_ptr
    syscall

    pop rax
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop r8
    pop r9
    push rax

    ret

print_n:
    cmp byte [fstr], 'd'
    jne .no_d
        mov rbx, 10
        jmp .number
    .no_d:
    cmp byte [fstr], 'b'
    jne .no_b
        mov rbx, 2
        jmp .number
    .no_b:
    cmp byte [fstr], 'o'
    jne .no_o
        mov rbx, 8
        jmp .number
    .no_o:
    cmp byte [fstr], 'x'
    jne .no_x
        mov rbx, 16
        jmp .number
    .no_x:

    ret
    
    .number:

    inc fstr

    xor rcx, rcx
    mov rax, [farg]
    add farg, 8
    .get_num_loop:
        mov rdx, 0
        div rbx

        add rdx, '0'

        push rdx
        inc rcx

        cmp rax, 0
        jne .get_num_loop
    
    .print_num_loop:
        pop rdx
        mov [buffer + buffer_ptr], dl
        inc buffer_ptr
        dec rcx
        cmp rcx, 0
        jne .print_num_loop

    ret

section .data
buffer db 1024 dup(0)

section .note.GNU-stack noalloc noexec nowrite progbits