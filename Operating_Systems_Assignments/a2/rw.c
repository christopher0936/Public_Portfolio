/*Required Headers*/

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <semaphore.h>
#include "rw.h"
#include "resource.h"

/*
 * Declarations for reader-writer shared variables -- plus concurrency-control
 * variables -- must START here.
 */

//shared variables
sem_t rw_mutex;
sem_t mutex;
int read_count;

//provided
static resource_t data;

void initialize_readers_writer() {
    /*
     * Initialize the shared structures, including those used for
     * synchronization.
     */
    /* Any code for initializing synchronization 
    constructs or other variables needed for the correct operation of your 
    readers/writer solution must appear in this function. It is called from within 
    myserver.c. */

    //basing off textbook pseudocode

    sem_init(&rw_mutex,0,1); //semaphore rw mutex = 1;

    sem_init(&mutex,0,1); //semaphore mutex = 1;

    read_count=0; //int read count = 0;
}


void rw_read(char *value, int len) {
    /* As long as there is no thread writing the 
    resource, this function will read from the resource’s variable data (in 
    essence, the chars of a string) and copy this into value via a call to 
    read_resource(). (The len parameter is the size of the character array 
    passed in as the argument value.) If there are threads writing, then the 
    thread calling rw_read must be blocked until the writer is finished.
    */

    //printf("NOTHING IMPLEMENTED YET FOR rw_read\n");

    //again basing off textbook pseudocode
    sem_wait(&mutex);
    read_count++;
    if (read_count==1){
        sem_wait(&rw_mutex);
    }
    sem_post(&mutex);

    //....READ
    read_resource(&data,value,len);

    sem_wait(&mutex);
    read_count--;
    if (read_count==0){
        sem_post(&rw_mutex);
    }
    sem_post(&mutex);
}


void rw_write(char *value, int len) {
    /* As long as there are no threads reading 
    the resource, this function will write the value into the resource variable. via 
    a call to write_resource(). (The len field is the size of the character array 
    passed in as the first argument.) If there are threads reading this specific 
    resource, then the thread that has called rw_write must block until the all 
    readers on the resource are finished their read.
    */

    //printf("NOTHING IMPLEMENTED YET FOR rw_write\n");
    
    //again off textbook pseudocode
    sem_wait(&rw_mutex);

    //...WRITE
    write_resource(&data,value,len);

    sem_post(&rw_mutex);
}
