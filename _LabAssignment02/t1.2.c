#include <stdio.h>
#include <fcntl.h>   
#include <unistd.h>  
#include <string.h>  

int main(int argc, char *argv[]) {
    int fileDesc;  
    char input[100]; 

    if (argc < 2) {
        printf("Please provide a filename as an argument.\n");
        return 1;
    }
  
    fileDesc = open(argv[1], O_WRONLY | O_CREAT | O_APPEND, 0644);
    if (fileDesc < 0) {
        perror("File cannot be opened or created");
        return 1;
    }

    while (1) {
        printf("Enter text (type '-1' to exit): ");
        fgets(input, sizeof(input), stdin);
  
        input[strcspn(input, "\n")] = 0;

        if (strcmp(input, "-1") == 0) {
            break;
        }
      
        if (write(fileDesc, input, strlen(input)) < 0) {
            perror("Error writing to the file");
            close(fileDesc);
            return 1;
        }

        
        write(fileDesc, "\n", 1);
    }

    
    close(fileDesc);
    printf("Data has been successfully written to the file.\n");

    return 0;
}

my name is sankalpa
i am from Brac university
