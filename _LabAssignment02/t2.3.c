#include <stdio.h>
#include <pthread.h>
#include <unistd.h>  

#define THREAD_COUNT 5
#define PRINT_COUNT 5

void* print_numbers(void* arg) {
    int id = *((int*)arg);
    int initial_value = id * PRINT_COUNT + 1;  
   
    for (int num = initial_value; num < initial_value + PRINT_COUNT; num++) {
        printf("Thread %d prints %d\n", id, num);
        sleep(1);  
    }
   
    pthread_exit(NULL);
}

int main() {
    pthread_t thread_array[THREAD_COUNT];
    int ids[THREAD_COUNT];

    
    for (int index = 0; index < THREAD_COUNT; index++) {
        ids[index] = index;
        pthread_create(&thread_array[index], NULL, print_numbers, &ids[index]);
    }

    
    for (int index = 0; index < THREAD_COUNT; index++) {
        pthread_join(thread_array[index], NULL);
    }

    return 0;
}

