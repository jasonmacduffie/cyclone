/** 
 * Cyclone Scheme
 * Copyright (c) 2014, Justin Ethier
 * All rights reserved.
 *
 * This file contains the C runtime code used only by the main program module.
 * May want to consider migrating this into another runtime module.
 */

#ifndef CYCLONE_RUNTIME_MAIN_H
#define CYCLONE_RUNTIME_MAIN_H

#include "cyclone.h"

long global_stack_size = 0;
long global_heap_size = 0;

static long long_arg(int argc,char **argv,char *name,long dval);
static void c_entry_pt(int,closure,closure);
static void main_main(long stack_size,long heap_size,char *stack_base) never_returns;

static void main_main (stack_size,heap_size,stack_base)
     long stack_size,heap_size; char *stack_base;
{char in_my_frame;
 mclosure0(clos_exit,&my_exit);  /* Create a closure for exit function. */
 gc_ans[0] = &clos_exit;            /* It becomes the argument to test. */
 gc_num_ans = 1;
 /* Allocate stack buffer. */
 stack_begin = stack_base;
#if STACK_GROWS_DOWNWARD
 stack_limit1 = stack_begin - stack_size;
 stack_limit2 = stack_limit1 - 2000;
#else
 stack_limit1 = stack_begin + stack_size;
 stack_limit2 = stack_limit1 + 2000;
#endif
#if DEBUG_SHOW_DIAG
 printf("main: sizeof(cons_type)=%ld\n",(long) sizeof(cons_type));
#endif
 if (check_overflow(stack_base,&in_my_frame))
   {printf("main: Recompile with STACK_GROWS_DOWNWARD set to %ld\n",
           (long) (1-STACK_GROWS_DOWNWARD)); exit(0);}
#if DEBUG_SHOW_DIAG
 printf("main: stack_size=%ld  stack_base=%p  stack_limit1=%p\n",
        stack_size,(void *)stack_base,(void *)stack_limit1);
 printf("main: Try different stack sizes from 4 K to 1 Meg.\n");
#endif
 /* Do initializations of Lisp objects and rewrite rules.
 quote_list_f = mlist1(boolean_f); quote_list_t = mlist1(boolean_t); */

 /* Make temporary short names for certain atoms. */
 {

  /* Define the rules, but only those that are actually referenced. */

  /* Create closure for the test function. */
  mclosure0(run_test,&c_entry_pt);
  gc_cont = &run_test;
  /* Initialize constant expressions for the test runs. */

  /* Allocate heap area for second generation. */
  /* Use calloc instead of malloc to assure pages are in main memory. */
#if DEBUG_SHOW_DIAG
  printf("main: Allocating and initializing heap...\n");
#endif
  bottom = calloc(1,heap_size);
  allocp = (char *) ((((long) bottom)+7) & -8);
  alloc_end = allocp + heap_size - 8;
  
  dhallocp = dhbottom = calloc(1, heap_size);
  dhalloc_end = dhallocp + heap_size - 8;
#if DEBUG_SHOW_DIAG
  printf("main: heap_size=%ld  allocp=%p  alloc_end=%p\n",
         (long) heap_size,(void *)allocp,(void *)alloc_end);
  printf("main: Try a larger heap_size if program bombs.\n");
  printf("Starting...\n");
#endif
  start = clock(); /* Start the timing clock. */

  /* Tank, load the jump program... */
  setjmp(jmp_main);
#if DEBUG_GC
  printf("Done with GC\n");
#endif

  if (type_of(gc_cont) == cons_tag || prim(gc_cont)) {
    Cyc_apply_from_buf(gc_num_ans, gc_cont, gc_ans);
  } else {
    do_dispatch(gc_num_ans, ((closure)gc_cont)->fn, gc_cont, gc_ans);
  }

  /*                                                                      */
  printf("main: your setjmp and/or longjmp are broken.\n"); exit(0);}}

static long long_arg(argc,argv,name,dval)
     int argc; char **argv; char *name; long dval;
{int j;
 for(j=1;(j+1)<argc;j += 2)
   if (strcmp(name,argv[j]) == 0)
     return(atol(argv[j+1]));
 return(dval);}

#endif /* CYCLONE_RUNTIME_MAIN_H */