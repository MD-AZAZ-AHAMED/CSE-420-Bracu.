#include <stdio.h>
#include <pthread.h>
#include <string.h>

int sums[3]; 

void* compute_ascii_total(void* arg) {
    char* user_name = (char*)arg;
    int total = 0;
    for (int i = 0; user_name[i] != '\0'; i++) {
        total += (int)user_name[i]; 
    }
    pthread_exit((void*)(size_t)total); 
}

void* evaluate_totals(void* arg) {
    int* total_values = (int*)arg;
    if (total_values[0] == total_values[1] && total_values[1] == total_values[2]) {
        printf("Youreka\n");
    } else if (total_values[0] == total_values[1] || total_values[1] == total_values[2] || total_values[0] == total_values[2]) {
        printf("Miracle\n");
    } else {
        printf("Hasta la vista\n");
    }
    pthread_exit(NULL);
}

int main() {
    pthread_t tid[4]; 
    char* user_names[3] = {"Alice", "Bob", "Charlie"}; 

    
    for (int i = 0; i < 3; i++) {
        pthread_create(&tid[i], NULL, compute_ascii_total, (void*)user_names[i]);
    }

    
    for (int i = 0; i < 3; i++) {
        void* result;
        pthread_join(tid[i], &result);
        sums[i] = (int)(size_t)result; 
    }

    
    pthread_create(&tid[3], NULL, evaluate_totals, (void*)sums);
    pthread_join(tid[3], NULL); 

    return 0;
}

