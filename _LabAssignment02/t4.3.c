#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int compare_desc(const void *a, const void *b) {
    return (*(int *)b - *(int *)a);
}

void check_odd_even(int *numbers, int count) {
    for (int i = 0; i < count; i++) {
        if (numbers[i] % 2 == 0) {
            printf("%d is Even\n", numbers[i]);
        } else {
            printf("%d is Odd\n", numbers[i]);
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Please provide some numbers to process\n");
        return 1;
    }

    int numbers[argc - 1];
    for (int i = 1; i < argc; i++) {
        numbers[i - 1] = atoi(argv[i]);
    }

    pid_t pid = fork();

    if (pid < 0) {
        printf("Fork failed.\n");
        return 1;
    }

    if (pid == 0) { 
        printf("Child process: Sorting numbers\n");
        qsort(numbers, argc - 1, sizeof(int), compare_desc);

        
        printf("Sorted numbers in descending order: ");
        for (int i = 0; i < argc - 1; i++) {
            printf("%d ", numbers[i]);
        }
        printf("\n");

        exit(0);
    } else { 
        wait(NULL); 
        printf("Parent process: Checking odd or even status\n");
        check_odd_even(numbers, argc - 1);
    }

    return 0;
}

