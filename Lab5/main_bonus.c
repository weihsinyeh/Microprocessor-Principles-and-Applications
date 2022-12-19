#include "xc.h"
extern unsigned int mypow(unsigned int a,unsigned int b);
void main(void) {
    volatile unsigned int ans  = mypow(6,5); 
    while(1)
        ;
    return;
}

