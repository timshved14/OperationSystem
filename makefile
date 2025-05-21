CC = gcc
CFLAGS = -Wall -Wextra -pthread
TARGETS = factorial parallel_factorial

all: $(TARGETS)

factorial: main.c fact1.c
	$(CC) $(CFLAGS) $^ -o $@

parallel_factorial: parallel_factorial.c fact1.c
	$(CC) $(CFLAGS) $^ -o $@

clean:
	rm -f $(TARGETS)

.PHONY: all clean
