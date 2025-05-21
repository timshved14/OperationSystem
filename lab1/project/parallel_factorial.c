#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "factorial.h"

typedef struct {
    int input;
    int* result;
    pthread_mutex_t* mutex;
} ThreadData;

void* parallel_factorial(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    int res = factorial(data->input);
    
    pthread_mutex_lock(data->mutex);
    *(data->result) = res;
    pthread_mutex_unlock(data->mutex);
    
    printf("Thread calculated factorial(%d) = %d\n", data->input, res);
    return NULL;
}

int main() {
    pthread_t threads[2];
    ThreadData data[2];
    int results[2] = {0};
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    
    // Инициализация данных для потоков
    data[0] = (ThreadData){5, &results[0], &mutex};
    data[1] = (ThreadData){7, &results[1], &mutex};
    
    // Создание потоков
    for (int i = 0; i < 2; i++) {
        if (pthread_create(&threads[i], NULL, parallel_factorial, &data[i])) {
            perror("pthread_create");
            exit(EXIT_FAILURE);
        }
    }
    
    // Ожидание завершения потоков
    for (int i = 0; i < 2; i++) {
        pthread_join(threads[i], NULL);
    }
    
    // Вывод результатов
    printf("Final results: %d, %d\n", results[0], results[1]);
    printf("Total: %d\n", results[0] + results[1]);
    
    pthread_mutex_destroy(&mutex);
    return 0;
}
