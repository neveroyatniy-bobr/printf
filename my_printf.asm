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

        ;обработка числа, если число
        call print_n

        ;обработка символа, если символ
        call print_c

        ;обработка строки, если строка
        call print_s
        
        jmp .loop

        .no_format:

        mov dl, [fstr]
        mov [buffer + buffer_ptr], dl
        inc fstr
        inc buffer_ptr
        
        jmp .loop
    .endloop:
    
    ;дописываю остаток буффера
    call print_buffer

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
        
        cmp rdx, 10
        jl .digit
            add rdx, 'a' - 10
            jmp .end_digit_if
        .digit:
            add rdx, '0'
        .end_digit_if:

        push rdx
        inc rcx

        cmp rax, 0
        jne .get_num_loop
    
    .print_num_loop:
        pop rdx
        call putc
        dec rcx
        cmp rcx, 0
        jne .print_num_loop

    ret

print_c:
    cmp byte [fstr], 'c'
    je .char
        ret
    .char:
    inc fstr

    mov rdx, [farg]
    add farg, 8

    call putc

    ret

print_s:
    cmp byte [fstr], 's'
    je .str
        ret
    .str:
    inc fstr

    mov rbx, [farg]
    
    xor rdx, rdx
    .loop_str:
        cmp byte [rbx], 0
        je .end_loop_str

        mov dl, [rbx]
        inc rbx

        call putc

        jmp .loop_str
    .end_loop_str:

    ret

putc:
    cmp buffer_ptr, 1023
    jne .no_buffer_limit
        call print_buffer
    .no_buffer_limit:

    mov [buffer + buffer_ptr], dl
    inc buffer_ptr

    ret

print_buffer:
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, buffer_ptr
    syscall

    ret

section .data
buffer db 1024 dup(0)

section .note.GNU-stack noalloc noexec nowrite progbits