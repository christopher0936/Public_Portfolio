#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "linkedlist.h"

#define MAX_BUFFER_LEN 80

taskval_t *event_list = NULL;

// Provided

void print_task(taskval_t *t, void *arg) {
    printf("task %03d: %5d %3.2f %3.2f\n",
        t->id,
        t->arrival_time,
        t->cpu_request,
        t->cpu_used
    );  
}


void increment_count(taskval_t *t, void *arg) {
    int *ip;
    ip = (int *)arg;
    (*ip)++;
}

void run_simulation(int qlen, int dlen) { // Mainloop function
    taskval_t *ready_q = NULL;

    int tick = 0; //current tick value
    int state = 0; //0=Idle; 1=Dispatch; 2=Processing
    float wait;
    float turnaround;
    taskval_t *currenttask = NULL;
    int qcount = 0; //For enforcing quantum limit

    for(;;){ // Mainloop

        // if theres something on the event list and its time for it to be loaded into ready queue, do so, removing it from the event list
        if(event_list!=NULL){
            if(tick+1>=event_list->arrival_time){
                taskval_t *temp = event_list;
                event_list = remove_front(event_list);
                temp->next = NULL;
                ready_q = add_end(ready_q, temp);
            }
        }

        //Main Logic

        if(state==0){ //Processor is Idle
            printf("[%05d] IDLE\n", tick);
            if(ready_q!=NULL){
                state=1;
            }
            tick++;
        }

        else if(state==1){ // Processor is Dispatching
            int i;
            for(i=0;i<dlen;i++){ //Perform however many dispatch ticks are needed as per dlen
                printf("[%05d] DISPATCHING\n", tick);
                tick++;
            }
            currenttask = ready_q; //currenttask is the task currently being processed
            ready_q = remove_front(ready_q);
            state=2;
        }

        else if(state==2){ // Processor is Processing
            qcount++;

            if(qcount>=qlen && currenttask->cpu_used < currenttask->cpu_request){ //If out of quantum time but task isn't finished yet
                printf("[%05d] id=%05d req=%.2f used=%.2f\n", tick, currenttask->id, currenttask->cpu_request, currenttask->cpu_used);
                currenttask->cpu_used = currenttask->cpu_used+1;
                ready_q = add_end(ready_q, currenttask);
                currenttask = NULL;
                qcount=0;
                state=1; // Go to dispatch to load next from ready_q, which may be the same as what was just unloaded
                tick++;
            }
            else if(currenttask->cpu_used >= currenttask->cpu_request){ //Is Task Done?
                //print output for task completion
                wait = tick - currenttask->cpu_request - currenttask->arrival_time;
                turnaround = tick - currenttask->arrival_time;
                printf("[%05d] id=%05d EXIT w=%.2f ta=%.2f\n", tick, currenttask->id, wait, turnaround);
                //cleanup and continue main loop as needed
                wait=0;
                turnaround=0;
                currenttask = NULL;
                qcount=0;
                if(ready_q!=NULL){
                    state=1; // If theres something in the ready_q, go to dispatch to load it
                } else {
                    state=0; // If theres nothing in the ready_q, go to idle
                }
            }
            else { // Neither of the above are true so continue the loop
                printf("[%05d] id=%05d req=%.2f used=%.2f\n", tick, currenttask->id, currenttask->cpu_request, currenttask->cpu_used);
                currenttask->cpu_used = currenttask->cpu_used+1;
                tick++;
            }
        }

        // Check if simulation is complete
        if(event_list==NULL && ready_q==NULL && currenttask==NULL){
            break;
        }
    }
}

// Provided

int main(int argc, char *argv[]) {
    char   input_line[MAX_BUFFER_LEN];
    int    i;
    int    task_num;
    int    task_arrival;
    float  task_cpu;
    int    quantum_length = -1;
    int    dispatch_length = -1;

    taskval_t *temp_task;

    for (i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--quantum") == 0 && i+1 < argc) {
            quantum_length = atoi(argv[i+1]);
        }
        else if (strcmp(argv[i], "--dispatch") == 0 && i+1 < argc) {
            dispatch_length = atoi(argv[i+1]);
        }
    }

    if (quantum_length == -1 || dispatch_length == -1) {
        fprintf(stderr, 
            "usage: %s --quantum <num> --dispatch <num>\n",
            argv[0]);
        exit(1);
    }


    while(fgets(input_line, MAX_BUFFER_LEN, stdin)) {
        sscanf(input_line, "%d %d %f", &task_num, &task_arrival,
            &task_cpu);
        temp_task = new_task();
        temp_task->id = task_num;
        temp_task->arrival_time = task_arrival;
        temp_task->cpu_request = task_cpu;
        temp_task->cpu_used = 0.0;
        event_list = add_end(event_list, temp_task);
    }

#ifdef DEBUG
    int num_events;
    apply(event_list, increment_count, &num_events);
    printf("DEBUG: # of events read into list -- %d\n", num_events);
    printf("DEBUG: value of quantum length -- %d\n", quantum_length);
    printf("DEBUG: value of dispatch length -- %d\n", dispatch_length);
#endif

    run_simulation(quantum_length, dispatch_length);

    return (0);
}
