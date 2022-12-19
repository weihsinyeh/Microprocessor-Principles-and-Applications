#include "xc.inc"
    GLOBAL _add
    PSECT mytext , local, class = CODE , reloc = 2;
_add:
    MOVFF 0x001 , LATD
    MOVFF 0x003 , LATC
    
    MOVFF LATD,WREG
    ADDWF 0x003,W
    MOVFF WREG,0x001
    
    RETURN


