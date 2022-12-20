#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
// using namespace std;

char str[20];
void Mode1(){   // Todo : Mode1 
    return ;
}
void Mode2(){   // Todo : Mode2 
    return ;
}
void main(void) 
{
    
    SYSTEM_Initialize() ;
    
    while(1) {
        strcpy(str, GetString()); // TODO : GetString() in uart.c
        if(str == '\r')
            UART_Write_Text('\n');
        //ClearBuffer();
        //UART_Write_Text(str);
    }
    return;
}

void __interrupt(high_priority) Hi_ISR(void)
{

}