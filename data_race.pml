#include "for.h"
byte n = 0;

 
#define pzeroterm (P[0]@Term)
#define poneterm (P[1]@Term)
#define Terminated (pzeroterm && poneterm)

#define lessThanTwenty (n <= 20)
#define geqTen (n >= 10)
#define Twenty (n == 20)
// #define Terminated (np_ == 1)

/*
It is always the case that when terminated, n is equal to 2.

ltl { [] (Terminated -> Two) }
ltl { [] !<> (Terminated && One) }
ltl { [] (Terminated -> Two) }
*/

//ltl { [] ( lessThanTwenty) }
ltl { <> (Terminated -> (n > 21)) }

 active [2] proctype P() {
 byte temp;
 for (i, 1, 10)
 temp = n + 1;
 n = temp 
 rof (i)

 Term: skip;
 }

//  init {
//  atomic {
//  run P();
//  run P();
//  }
//  (_nr_pr == 1) ->
//  printf("The value is %d \n", n)
//  }
