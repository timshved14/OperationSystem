.file    "factorial.c"          ; Имя исходного файла
    .text                       ; Начало секции кода
    .p2align 4                  ; Выравнивание кода по 16-байтной границе
    .globl    factorial         ; Объявление factorial как глобального символа
    .def    factorial;    .scl    2;    .type    32;    .endef  ; Метаданные для отладки
    .seh_proc    factorial      ; Начало функции (SEH - Structured Exception Handling)
factorial:
    .seh_endprologue            ; Конец пролога функции
    movl    $1, %eax            ; Загружаем 1 в регистр eax (начальное значение результата)
    cmpl    $1, %ecx            ; Сравниваем входной аргумент (n) с 1
    jle    .L1                  ; Если n <= 1, переходим к возврату (базовый случай рекурсии)
    .p2align 4,,10              ; Оптимизация выравнивания для процессора
    .p2align 3
.L2:                            ; Начало цикла
    movl    %ecx, %edx          ; Копируем текущее n в edx
    subl    $1, %ecx            ; Уменьшаем n на 1 (n--)
    imull    %edx, %eax         ; Умножаем результат (eax) на текущее n (edx)
    cmpl    $1, %ecx            ; Сравниваем новое n с 1
    jne    .L2                  ; Если n != 1, продолжаем цикл
.L1:                            ; Метка возврата
    ret                         ; Возврат из функции (результат в eax)
    .seh_endproc                ; Конец функции (SEH)

    .def    __main;    .scl    2;    .type    32;    .endef  ; Метаданные для __main
    .section .rdata,"dr"        ; Начало секции read-only данных
.LC0:
    .ascii "%d\0"               ; Строка формата для printf
    .section    .text.startup,"x"  ; Начало секции кода запуска
    .p2align 4                  ; Выравнивание
    .globl    main              ; Объявление main как глобального символа
    .def    main;    .scl    2;    .type    32;    .endef  ; Метаданные для main
    .seh_proc    main           ; Начало функции main (SEH)
main:
    subq    $40, %rsp           ; Выделяем 40 байт в стеке
    .seh_stackalloc    40        ; Информация для SEH о выделении стека
    .seh_endprologue            ; Конец пролога
    call    __main              ; Вызов инициализации среды выполнения MinGW
    movl    $5040, %edx         ; Загружаем 5040 (7!) в edx (аргумент для printf)
    leaq    .LC0(%rip), %rcx    ; Загружаем адрес строки формата "%d" в rcx (1-й аргумент)
    call    printf              ; Вызываем printf("%d", 5040)
    xorl    %eax, %eax          ; Обнуляем eax (возвращаем 0)
    addq    $40, %rsp           ; Освобождаем стек
    ret                         ; Возврат из main
    .seh_endproc                ; Конец функции main (SEH)

    .ident    "GCC: (MinGW-W64 x86_64-ucrt-posix-seh, built by Brecht Sanders) 13.2.0"  ; Информация о компиляторе
    .def    printf;    .scl    2;    .type    32;    .endef  ; Метаданные для printf