#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <wait.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdbool.h>

#define MAX_INPUT_LINE 81

int main(int argc, char *argv[]) {

    bool debug_mode=false; //DEBUG MODE
    if (debug_mode){
        printf("====================\nDEBUG MODE ENABLED\n====================\n\n");
    }

    char input[MAX_INPUT_LINE];
    int  line_len;
    char curchar;

	FILE *mainfile;
    mainfile = fopen(".sh360rc","r");

    if (mainfile == NULL) {
        printf("No .sh360rc file found in current directory. Please ensure this file is present.\n");
        exit(1);
    }

    char prompt[11];
    fgets(prompt,11,mainfile);

    //Replace newline with end of string
    int index;
    for(index=0;index<11;index++){
        if(prompt[index]=='\n'){
            prompt[index]='\0';
        }
    }

    char path[10][200]= {{'\0'}}; // No max size of a single path element is actually given - 200 seems big enough
    int entry = 0;
    while(fgets(path[entry], 200, mainfile)){
        entry++;
    }

    //Same stuff - purge newlines
    for(entry=0;entry<10;entry++){
        for(index=0;index<200;index++){
            if(path[entry][index]=='\n'){
                path[entry][index]='\0';
            }
        }
    }

    //DEBUG PRINTOUT OF PATH
    if(debug_mode){
        printf("===FULL PATH DEBUG===\n");
        printf("%s\n", path[0]);
        printf("%s\n", path[1]);
        printf("%s\n", path[2]);
        printf("%s\n", path[3]);
        printf("%s\n", path[4]);
        printf("%s\n", path[5]);
        printf("%s\n", path[6]);
        printf("%s\n", path[7]);
        printf("%s\n", path[8]);
        printf("%s\n", path[9]);
        fflush(stdout);
    }

    for(;;) {
        fprintf(stdout, "%s " ,prompt);
        fflush(stdout);
        fgets(input, MAX_INPUT_LINE, stdin);
        
        //if (input[strlen(input) - 1] == '\n') {
        //    input[strlen(input) - 1] = '\0';
        //}

        if (strcmp(input, "exit") == 0 | strcmp(input, "exit\n") == 0){
            remove(".sh360temp");
            exit(0);
        }
        
        //Split input into cmd and args
        //Replace spaces with newlines to write to temp file, read back, and use fgets()
        for(index=0;index<81;index++){
            if(input[index]==' '){
                input[index]='\n';
            }
        }

        //juggle temp file
	    FILE *tempfilewr;
        tempfilewr = fopen(".sh360temp","w+");
        fprintf (tempfilewr, "%s", input);
        fclose(tempfilewr);

        FILE *tempfiler;
        tempfiler = fopen(".sh360temp","r");
        
        //get the cmd
        char cmdnoargs[282];
        fgets(cmdnoargs,282,tempfiler);
        for(index=0;index<282;index++){
            if(cmdnoargs[index]=='\n'){
                cmdnoargs[index]='\0';
            }
        }

        //Repeat of logic above to seperate path elements but is now used for args
        char arguments[7][282]= {{'\0'}};
        int argnum = 0;
        while(fgets(arguments[argnum], 282, tempfiler)){
            argnum++;
        }

        //Once again purging newlines
        for(argnum=0;argnum<7;argnum++){
            for(index=0;index<282;index++){
                if(arguments[argnum][index]=='\n'){
                    arguments[argnum][index]='\0';
                }
            }
        }

        //DEBUG PRINTOUT OF CMD
        if(debug_mode){
            printf("===CMD DEBUG===\n");
            printf("%s\n",cmdnoargs);
        }

        //DEBUG PRINTOUT OF ARUMENTS
        if(debug_mode){
            printf("===FULL ARGUMENT DEBUG===\n");
            printf("0:%s\n", arguments[0]);
            printf("1:%s\n", arguments[1]);
            printf("2:%s\n", arguments[2]);
            printf("3:%s\n", arguments[3]);
            printf("4:%s\n", arguments[4]);
            printf("5:%s\n", arguments[5]);
            printf("6:%s\n", arguments[6]);
        }

        //Find the executable file
        
        char fullcmdnoargs[282];
        
        strcpy(fullcmdnoargs, ".");
        strcat(fullcmdnoargs, "/");
        strcat(fullcmdnoargs,cmdnoargs);
        
        if (debug_mode){
        printf("===DEBUG: COMMAND SEARCH STARTED===\n");
        }

        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            //printf("FAILED1");
            strcpy(fullcmdnoargs, path[0]);
            strcat(fullcmdnoargs, "/");
            strcat(fullcmdnoargs,cmdnoargs);
        }
        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            //printf("FAILED2");
            strcpy(fullcmdnoargs, path[1]);
            strcat(fullcmdnoargs, "/");
            strcat(fullcmdnoargs,cmdnoargs);
        }
        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            strcpy(fullcmdnoargs, path[2]);
            strcat(fullcmdnoargs, "/");
            strcat(fullcmdnoargs,cmdnoargs);
        }
        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            strcpy(fullcmdnoargs, path[3]);
            strcat(fullcmdnoargs, "/");
            strcat(fullcmdnoargs,cmdnoargs);
        }
        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            strcpy(fullcmdnoargs, path[4]);
            strcat(fullcmdnoargs, "/");
            strcat(fullcmdnoargs,cmdnoargs);
        }
        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            strcpy(fullcmdnoargs, path[5]);
            strcat(fullcmdnoargs, "/");
            strcat(fullcmdnoargs,cmdnoargs);
        }
        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            strcpy(fullcmdnoargs, path[6]);
            strcat(fullcmdnoargs, "/");
            strcat(fullcmdnoargs,cmdnoargs);
        }
        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            strcpy(fullcmdnoargs, path[7]);
            strcat(fullcmdnoargs, "/");
            strcat(fullcmdnoargs,cmdnoargs);
        }
        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            //printf("FAILED9");
            strcpy(fullcmdnoargs, path[8]);
            strcat(fullcmdnoargs, "/");
            strcat(fullcmdnoargs,cmdnoargs);
        }
        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            strcpy(fullcmdnoargs, path[9]);
            strcat(fullcmdnoargs, "/");
            strcat(fullcmdnoargs,cmdnoargs);
        }
        if (access(fullcmdnoargs, F_OK | X_OK) != 0){
            printf("Error: The command you have specified was not found. Please ensure it exists and is executable.\n");
        }
        if (access(fullcmdnoargs, F_OK | X_OK) == 0){
            if (debug_mode) {
                printf("===DEBUG: SUCESSFULLY FOUND COMMAND===\n");
            }
            char *envp[] = { 0 };
            int pid;
            int status;

            //Create array of pointers from arguments array
            char *argumentsp[282];
            argumentsp[0] = fullcmdnoargs;
            if (strcmp(arguments[0],"")){
                //printf("DEBUGIFTRUE1");
                argumentsp[1] = arguments[0];
            }
            if (strcmp(arguments[1],"")){
                argumentsp[2] = arguments[1];
            }
            if (strcmp(arguments[2],"")){
                //printf("DEBUGIFTRUE2");
                argumentsp[3] = arguments[2];
            }
            if (strcmp(arguments[3],"")){
                argumentsp[4] = arguments[3];
            }
            if (strcmp(arguments[4],"")){
                argumentsp[5] = arguments[4];
            }
            if (strcmp(arguments[5],"")){
                argumentsp[6] = arguments[5];
            }
            if (strcmp(arguments[6],"")){
                argumentsp[7] = arguments[6];    
            }

            //DEBUG PRINTOUT OF ARGUMENTSP
            if(debug_mode){
                printf("===FULL ARGUMENTP DEBUG===\n");
                printf("0:%s\n", argumentsp[0]);
                printf("1:%s\n", argumentsp[1]);
                printf("2:%s\n", argumentsp[2]);
                printf("3:%s\n", argumentsp[3]);
                printf("4:%s\n", argumentsp[4]);
                printf("5:%s\n", argumentsp[5]);
                printf("6:%s\n", argumentsp[6]);
                printf("7:%s\n", argumentsp[7]);
            }

            if ((pid = fork()) == 0) {
                if(debug_mode){
                    printf("child: about to start...\n");
                }
                execve(fullcmdnoargs, argumentsp, envp);
                if (debug_mode){
                    printf("ERROR: child: SHOULDN'T BE HERE. SOMETHING WENT WRONG.\n");
                }
            }

            if (debug_mode){
                printf("parent: waiting for child to finish...\n");
            }
            while (wait(&status) > 0) {
                if (debug_mode){
                    printf("parent: child is finished.\n");
                }
            }
        }
    }
}
