#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t childProcessID, grandchildProcessID;
    int status;

    childProcessID = fork();
    if (childProcessID < 0) {
        perror("Fork failed");
        exit(EXIT_FAILURE);
    }

    if (childProcessID == 0) {
        grandchildProcessID = fork();
        if (grandchildProcessID < 0) {
            perror("Fork failed");
            exit(EXIT_FAILURE);
        }
        if (grandchildProcessID == 0) {
            printf("I am grandchild\n");
            exit(EXIT_SUCCESS);
        } else {
            waitpid(grandchildProcessID, &status, 0); 
            printf("I am child\n");
            exit(EXIT_SUCCESS);
        }
    } else {
        waitpid(childProcessID, &status, 0); 
        printf("I am parent\n");
    }

    return 0;
}
