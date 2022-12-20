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
        //strcpy(str, GetString()); // TODO : GetString() in uart.c

            strcpy(str,GetString());
            if(strcmp(str,"0\r")==0){
                LATD = 0;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"1\r")==0){
                LATD = 1;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"2\r")==0){ 
                LATD = 2;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"3\r")==0){
                LATD = 3;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"4\r")==0){
                LATD = 4;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"5\r")==0){
                LATD = 5;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"6\r")==0){
                LATD = 6;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"7\r")==0){
                LATD = 7;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"8\r")==0){
                LATD = 8;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"9\r")==0){
                LATD = 9;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"10\r")==0){
                LATD = 10;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"11\r")==0){
                LATD = 11;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"12\r")==0){
                LATD = 12;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"13\r")==0){
                LATD = 13;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"14\r")==0){
                LATD = 14;
                ClearBuffer();
                UART_Write('\n');
            }
            else if(strcmp(str,"15\r")==0){
                LATD = 15;
                ClearBuffer();
                UART_Write('\n');
            }
    }
    return;
}

void __interrupt(high_priority) Hi_ISR(void)
{

}
