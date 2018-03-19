#include <stdio.h>
#include "includes.h"
#include <string.h>

#define DEBUG 1

/* Definition of Task Stacks */
/* Stack grows from HIGH to LOW memory */
#define   TASK_STACKSIZE       2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];
OS_STK    stat_stk[TASK_STACKSIZE];

/* Decaring the semaphone */
OS_EVENT *aSemaphore;
OS_EVENT *bSemaphore;
int state=0;

/* Definition of Task Priorities */
#define TASK1_PRIORITY      6  // highest priority
#define TASK2_PRIORITY      7
#define TASK_STAT_PRIORITY 12  // lowest priority 

void printStackSize(INT8U prio)
{
    INT8U err;
    OS_STK_DATA stk_data;

    err = OSTaskStkChk(prio, &stk_data);
    if (err == OS_NO_ERR) 
    {
        if (DEBUG == 1)
           printf("Task Priority %d - Used: %d; Free: %d\n", 
                   prio, stk_data.OSFree, stk_data.OSUsed);
    }
    else
    {
        if (DEBUG == 1)
           printf("Stack Check Error!\n");    
    }
}

/* Prints a message and sleeps for given time interval */
void task1(void* pdata)
{
  INT8U err_aSemaphore;

  while (1)
{ 
  OSSemPend(aSemaphore,0,&err_aSemaphore);
  printf("Task0-state",state)
  if(state==0)
  OSSemPost(bSemaphore);
  else
  {
	state=0;
    OSSemPost(aSemaphore);
  }
}

/* Prints a message and sleeps for given time interval */
void task2(void* pdata)
{
  INT8U err_bSemaphore;

  while (1)
{ 
  OSSemPend(bSemaphore,0,&err_bSemaphore);
  printf("Task1-state",state)
  if(state==0)
  {
	state=1;
    OSSemPost(bSemaphore);
  }
  else
  OSSemPost(aSemaphore);
}

/* Printing Statistics */
void statisticTask(void* pdata)
{
    while(1)
    {
        printStackSize(TASK1_PRIORITY);
        printStackSize(TASK2_PRIORITY);
        printStackSize(TASK_STAT_PRIORITY);
    }
}

/* The main function creates two task and starts multi-tasking */
int main(void)
{
  printf("Lab 1 - Two Tasks using Handshake (Task 2.4)\n");

/* Declaring a binary semaphore */
  aSemaphore = OSSemCreate(1);    
  bSemaphore = OSSemCreate(0);

  OSTaskCreateExt
    (task1,                        // Pointer to task code
     NULL,                         // Pointer to argument that is
                                   // passed to task
     &task1_stk[TASK_STACKSIZE-1], // Pointer to top of task stack
     TASK1_PRIORITY,               // Desired Task priority
     TASK1_PRIORITY,               // Task ID
     &task1_stk[0],                // Pointer to bottom of task stack
     TASK_STACKSIZE,               // Stacksize
     NULL,                         // Pointer to user supplied memory
                                   // (not needed here)
     OS_TASK_OPT_STK_CHK |         // Stack Checking enabled 
     OS_TASK_OPT_STK_CLR           // Stack Cleared                                 
    );

  OSTaskCreateExt
    (task2,                        // Pointer to task code
     NULL,                         // Pointer to argument that is
                                   // passed to task
     &task2_stk[TASK_STACKSIZE-1], // Pointer to top of task stack
     TASK2_PRIORITY,               // Desired Task priority
     TASK2_PRIORITY,               // Task ID
     &task2_stk[0],                // Pointer to bottom of task stack
     TASK_STACKSIZE,               // Stacksize
     NULL,                         // Pointer to user supplied memory
                                   // (not needed here)
     OS_TASK_OPT_STK_CHK |         // Stack Checking enabled 
     OS_TASK_OPT_STK_CLR           // Stack Cleared                       
    );  

  if (DEBUG == 1)
  {
    OSTaskCreateExt
      (statisticTask,                // Pointer to task code
       NULL,                         // Pointer to argument that is
                                     // passed to task
       &stat_stk[TASK_STACKSIZE-1],  // Pointer to top of task stack
       TASK_STAT_PRIORITY,           // Desired Task priority
       TASK_STAT_PRIORITY,           // Task ID
       &stat_stk[0],                 // Pointer to bottom of task stack
       TASK_STACKSIZE,               // Stacksize
       NULL,                         // Pointer to user supplied memory
                                     // (not needed here)
       OS_TASK_OPT_STK_CHK |         // Stack Checking enabled 
       OS_TASK_OPT_STK_CLR           // Stack Cleared                              
      );`enter code here`
  }  

  OSStart();
  return 0;
}