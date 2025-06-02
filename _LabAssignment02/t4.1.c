#include <stdio.h>
#include <stdlib.h>

int compare_desc(const void *a, const void *b) {
    return (*(int *)b - *(int *)a); 
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Please provide some numbers to sort.\n");
        return 1;
    }

    int numbers[argc - 1];

    for (int i = 1; i < argc; i++) {
        numbers[i - 1] = atoi(argv[i]);
    }

    qsort(numbers, argc - 1, sizeof(int), compare_desc);

    printf("Sorted numbers in descending order: ");
    for (int i = 0; i < argc - 1; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");

    return 0;
}

