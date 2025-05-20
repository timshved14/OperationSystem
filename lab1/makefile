# Компилятор
CC = gcc

# Флаги компиляции
CFLAGS = -Wall -Wextra

# Имя исполняемого файла
TARGET = program

# Исходные файлы (.c)
SRC = main.c fact1.c

# Объектные файлы (.o)
OBJ = $(SRC:.c=.o)

# Заголовочные файлы
DEPS = factorial.h

# Основная цель
all: $(TARGET)

# Сборка исполняемого файла
$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

# Правило для компиляции .c в .o
%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c $< -o $@

# Очистка
clean:
	rm -f $(OBJ) $(TARGET)

# Указание, что цели all и clean - фиктивные
.PHONY: all clean