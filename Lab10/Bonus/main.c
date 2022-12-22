#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
// using namespace std;

char str[20];
void Mode1(){   // Todo : Mode1 
    int turn = 0;
    while(1){
        switch(turn){
            case 0: LATD = 5; break;
            case 1: LATD = 10; break;
        }
        turn = ! turn;
        strcpy(str,GetString());
        if(strcmp(str,"e")==0){
            LATD = 0;
            return;
        }
        for(int i = 0;i < 30000;i++);
    }
    return ;
}
void Mode2(){   // Todo : Mode2 
    int turn = 8;
    while(1){
        LATD = turn;
        turn = turn >> 1;
        if(turn == 0) turn = 8;
        strcpy(str,GetString());
        if(strcmp(str,"e")==0){
            LATD = 0;
            return;
        }
        for(int i = 0;i < 30000;i++);
    }
    return ;
}
void main(void) 
{
    
    SYSTEM_Initialize() ;
    
    while(1) {
        //strcpy(str, GetString()); // TODO : GetString() in uart.c

        strcpy(str,GetString());
        if(strcmp(str,"m1\r")==0){
            ClearBuffer();
            UART_Write('\n');
            Mode1();
            ClearBuffer();
        }
        else if(strcmp(str,"m2\r")==0){
            ClearBuffer();
            UART_Write('\n');
            Mode2();
            ClearBuffer();
        }
        else if(strcmp(str,"\r")==0){
            ClearBuffer();
            UART_Write('\n');
            ClearBuffer();
        }
    }
    return;
}

void __interrupt(high_priority) Hi_ISR(void)
{

}
