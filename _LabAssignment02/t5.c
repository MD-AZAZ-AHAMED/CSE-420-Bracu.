#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main() {
    pid_t parent_process, child_process, grandchild_process;
    int i;

    
    parent_process = fork();

    if (parent_process < 0) {
        perror("Fork failed");
        exit(1);
    }

    if (parent_process == 0) {
        
        printf("Child Process: PID = %d, Parent PID = %d\n", getpid(), getppid());
        
        for (i = 1; i <= 3; i++) {
            grandchild_process = fork();
            if (grandchild_process < 0) {
                perror("Fork failed");
                exit(1);
            }
            if (grandchild_process == 0) {
                
                printf("Grandchild %d: PID = %d, Parent PID = %d\n", i, getpid(), getppid());
                exit(0); 
            }
        }

        
        for (i = 0; i < 3; i++) {
            wait(NULL);
        }

        
        exit(0);
    } else {
        
        printf("Parent Process: PID = %d\n", getpid());
        wait(NULL); 
    }

    return 0;
}

