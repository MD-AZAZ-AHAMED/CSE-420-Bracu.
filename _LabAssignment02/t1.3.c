#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

#define THREAD_COUNT 5

pthread_mutex_t thread_mutex = PTHREAD_MUTEX_INITIALIZER;

void* worker_thread(void* arg) {
    int thread_number = *((int*)arg);

    pthread_mutex_lock(&thread_mutex);  
    printf("Thread-%d is running\n", thread_number);
    sleep(1);  
    printf("Thread-%d is closed\n", thread_number);
    pthread_mutex_unlock(&thread_mutex);  

    return NULL;
}

int main() {
    pthread_t thread_array[THREAD_COUNT];
    int thread_numbers[THREAD_COUNT];

    for (int i = 0; i < THREAD_COUNT; i++) {
        thread_numbers[i] = i + 1;
        pthread_create(&thread_array[i], NULL, worker_thread, &thread_numbers[i]);
        pthread_join(thread_array[i], NULL);  
    }

    pthread_mutex_destroy(&thread_mutex);  

    return 0;
}

