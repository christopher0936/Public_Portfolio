/*Required Headers*/

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <semaphore.h>
#include "meetup.h"
#include "resource.h"

/*
 * Declarations for barrier shared variables -- plus concurrency-control
 * variables -- must START here.
 */

static resource_t codeword;
int num;
//meetfirst is 1, meetlast is 0
int meetleader;
int joined;
int generation;

pthread_mutex_t squad;
pthread_cond_t fullsquad;

void initialize_meetup(int n, int mf) {
    char label[100];
    int i;

    if (n < 1) {
        fprintf(stderr, "Who are you kidding?\n");
        fprintf(stderr, "A meetup size of %d??\n", n);
        exit(1);
    }

    /*
     * Initialize the shared structures, including those used for
     * synchronization.
     */
    
    //Init shared variables
    num=n; //group size
    meetleader=mf; //first is 1, last is 0
    joined=0; //number of people joined atm - obviously 0 at initialisation
    generation=0;

    //Init sync
    pthread_mutex_init(&squad,NULL);
    pthread_cond_init(&fullsquad,NULL);
}


void join_meetup(char *value, int len) {
    //printf("NOTHING IMPLEMENTED YET FOR join_meetup\n");

    pthread_mutex_lock(&squad);
    
    joined++;
    
    if ((joined==1) && (meetleader==1)){ //if first joined and first is leader - load codeword into codeword resource
        write_resource(&codeword,value,len);
    }
    else if ((joined==num) && (meetleader==0)){ //if nth joined and last is leader - load codeword into codeword resource
        write_resource(&codeword,value,len);
    }

    if (joined<num){ //Waiting on more joiners
        //BLOCK - wait for broadcast
        int my_gen;
        my_gen=generation;
        while (my_gen==generation){
            pthread_cond_wait(&fullsquad,&squad);
        }
        read_resource(&codeword,value,len);
    }
    else {//Full squad lets gooooooo
        read_resource(&codeword,value,len);
        //reset the count of joined
        joined=0;
        //advance generation count
        generation++;
        //broadcast at the squad
        pthread_cond_broadcast(&fullsquad);
    }

    pthread_mutex_unlock(&squad);
}
