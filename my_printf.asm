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

        xor rax, rax
        mov al, [fstr]
        inc fstr

        cmp rax, '%'
        je .printprocent
            call [jmp_table + (rax - 'b') * 8]
        jmp .endifprocent
        .printprocent:
            mov dl, '%'
            call putc
        .endifprocent:
        
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

jmp_table:
    dq print_b
    dq print_c
    dq print_d
    times('o' - 'd' - 1) dq print_default
    dq print_o
    times('s' - 'o' - 1) dq print_default
    dq print_s
    times('x' - 's' - 1) dq print_default
    dq print_x

print_d:
    mov rbx, 10

    xor rcx, rcx

    mov rax, [farg]
    add farg, 8

    test eax, eax
    jg .no_negative
        mov dl, '-'
        call putc
        neg eax
    .no_negative:

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
        call putc
        dec rcx
        cmp rcx, 0
        jne .print_num_loop

    ret

print_b:
    xor rcx, rcx

    mov rax, [farg]
    add farg, 8

    test eax, eax
    jg .no_negative
        mov dl, '-'
        call putc
        neg eax
    .no_negative:

    .get_num_loop:
        mov rdx, rax
        and rdx, 1
        shr rax, 1
        
        add rdx, '0'

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

print_o:
    xor rcx, rcx

    mov rax, [farg]
    add farg, 8

    test eax, eax
    jg .no_negative
        mov dl, '-'
        call putc
        neg eax
    .no_negative:

    .get_num_loop:
        mov rdx, rax
        and rdx, 7
        shr rax, 3
        
        add rdx, '0'

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

print_x:
    xor rcx, rcx

    mov rax, [farg]
    add farg, 8

    test eax, eax
    jg .no_negative
        mov dl, '-'
        call putc
        neg eax
    .no_negative:

    .get_num_loop:
        mov rdx, rax
        and rdx, 15
        shr rax, 4
        
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
    mov rdx, [farg]
    add farg, 8

    call putc

    ret

print_s:
    mov rbx, [farg]
    add farg, 8
    
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

print_default:
    ret

section .data
buffer db 1024 dup(0)

section .note.GNU-stack noalloc noexec nowrite progbits