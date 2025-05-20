	.file	"factorial.c"	# Имя исходного файла
	.text	# Начало секции кода
	# Функция factorial(int n)
	.globl	factorial
	.def	factorial;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial	# Начало функции с обработкой SEH (Windows исключения)
factorial:
	# Пролог функции
	pushq	%rbx	# Сохраняем в стек регистр rbx
	.seh_pushreg	%rbx	# Информируем SEH о сохранении регистра
	subq	$32, %rsp	# Выделяем 32 байта на стеке
	.seh_stackalloc	32	# Информируем SEH о выделении стека
	.seh_endprologue	# Конец пролога SEH
	movl	%ecx, %ebx	# Сохраняем аргумент n (из RCX) в EBX
	movl	$1, %eax	# EAX = 1 (значение по умолчанию для возврата)
	cmpl	$1, %ecx	# Сравниваем n с 1
	jle	.L1	# Если n <= 1, переходим к L1
	# Рекурсивный вызов
	leal	-1(%rcx), %ecx	# Уменьшаем n на 1 (n-1)
	call	factorial	# Рекурсивный вызов factorial(n-1)
	imull	%ebx, %eax	# Умножаем результат (EAX) на исходное n (EBX)
.L1: 
	addq	$32, %rsp	# Освобождаем стек
	popq	%rbx	# Восстанавливаем RBX
	ret	# Возврат из функции
	.seh_endproc	# Конец функции для SEH
	# Функция main()
	.def	__main;	.scl	2;	.type	32;	.endef
	# Секция read-only данных
	.section .rdata,"dr"
.LC0:
	.ascii "%d\0"	# Строка формата для printf
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main	# Начало main с обработкой SEH
main:
	subq	$40, %rsp	# Выделяем 40 байт на стеке
	.seh_stackalloc	40	# Информируем SEH
	.seh_endprologue	# Конец пролога
	call	__main	# Инициализация среды выполнения 
	# Вызов factorial(7)
	movl	$7, %ecx	# Передаем аргумент n = 7 через ECX
	call	factorial	# Вызываем factorial(7)
	# Вывод результата
	movl	%eax, %edx	# Результат (EAX) -> второй аргумент printf (EDX)
	leaq	.LC0(%rip), %rcx	# строка формата "%d" (RCX)
	call	printf	# Вызов printf
	# Завершение программы
	movl	$0, %eax	# Возвращаем 0
	addq	$40, %rsp	# Восстанавливаем стек
	ret	# Выход из main
	.seh_endproc	# Конец функции для SEH
	# Дополнительная информация
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0"
	.def	printf;	.scl	2;	.type	32;	.endef