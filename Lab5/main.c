#include "xc.h"
extern unsigned int isprime(unsigned int a);
void main(void) {
    volatile unsigned char result  = isprime(57);
    while(1)
        ;
    return;
}
