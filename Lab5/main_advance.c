#include "xc.h"
extern unsigned int divide_signed(unsigned int a,unsigned int b);
void main(void) {
    volatile unsigned int res  = divide_signed(3,-4);
    volatile char quotient =  (res & 0xFF00) >> 8 ;
    volatile char remainder = res & 0x00FF ;    
    while(1)
        ;
    return;
}