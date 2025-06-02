#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t a, b, c;
    int processCount = 1; 
    
    printf("Parent process with PID %d initially created %d process\n", getpid(), processCount);

    a = fork(); 
    if (a == 0) {
        if (getpid() % 2 != 0) { 
            fork(); 
        }
    } else {
        if (a % 2 != 0) {
            processCount++; 
        }
        processCount++; 

        b = fork(); 
        if (b == 0) {
            
            if (getpid() % 2 != 0) { 
                fork(); 
            }
        } else {

            if (b % 2 != 0) {
                processCount++; 
            }
            processCount++; 
            c = fork(); 
            if (c == 0) {
                
                if (getpid() % 2 != 0) { 
                    fork(); 
                }
            } else {
                
                if (c % 2 != 0) {
                    processCount++; 
                }
                processCount++; 

                
                wait(NULL);
                wait(NULL);
                wait(NULL);

                
                printf("Process with PID %d has created %d processes\n", getpid(), processCount);
            }
        }
    }

    return 0;
}

