#include <stdio.h>

int isPerfectNumber(int num) {
    int sum = 0;

    for (int i = 1; i <= num / 2; i++) {
        if (num % i == 0) {
            sum += i;
        }
    }
    return (sum == num);
}
void printPerfectNumbers(int start, int end) {
    for (int i = start; i <= end; i++) {
        if (isPerfectNumber(i)) {
            printf("%d\n", i);
        }
    }
}
int main() {
    int lower_limit, upper_limit;
    printf("Enter the lower limit: ");
    scanf("%d", &lower_limit);
    printf("Enter the upper limit: ");
    scanf("%d", &upper_limit);

    printf("Perfect numbers between %d and %d are:\n", lower_limit, upper_limit);
    printPerfectNumbers(lower_limit, upper_limit);

    return 0;
}
