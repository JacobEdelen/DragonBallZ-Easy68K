*-----------------------------------------------------------
* Title      :  healthTracker
* Written by :  Jacob Edelen
* Date       :  10/7/16
* Description:  This creates a 7 segment LED for health
*-----------------------------------------------------------

*update health based on current health
updateHealth
    *get the position of the current health based on the player health passed in
    move.l      #zeroDigit, a0
    *multiply digit by 4 to get correct hex number at the end of the file
    lsl.l       #2, d0
    add.l       d0, a0    
    *store the current hex value of health
    move.l      (a0), d6
    
    *Change pen to white for each segment
    move.l      #80, d0
    move.l      #$00FFFFFF, d1
    trap        #15
    
    move.l      #81, d0
    move.l      #$00FFFFFF, d1
    trap        #15

*shift through each value of 7 segment representation
*if the number is 1, draw that segment
GDigitRoutine
    move.l      d6, d1     
    AND.l       #1, d1
    BEQ         FDigitRoutine
    move.w      #5, d1
    add.l       d5, d1
    move.w      #20, d2
    move.w      #35, d3
    add.l       d5, d3
    move.w      #30, d4
    jsr         DrawDigitPosition
FDigitRoutine
    lsr.l         #4, d6
    move.l      d6, d1
    AND.l       #1, d1
    BEQ         EDigitRoutine
    move.w      #5, d1
    add.l       d5, d1
    move.w      #5, d2
    move.w      #15, d3
    add.l       d5, d3
    move.w      #25, d4
    jsr         DrawDigitPosition
EDigitRoutine
    lsr.l         #4, d6
    move.l      d6, d1
    AND.l       #1, d1
    BEQ         DDigitRoutine
    move.w      #5, d1
    add.l       d5, d1
    move.w      #25, d2
    move.w      #15, d3
    add.l       d5, d3
    move.w      #45, d4
    jsr         DrawDigitPosition
DDigitRoutine
    lsr.l         #4, d6
    move.l      d6, d1
    AND.l       #1, d1
    BEQ         CDigitRoutine
    move.w      #5, d1
    add.l       d5, d1
    move.w      #35, d2
    move.w      #35, d3
    add.l       d5, d3
    move.w      #45, d4
    jsr         DrawDigitPosition
CDigitRoutine
    lsr.l         #4, d6
    move.l      d6, d1
    AND.l       #1, d1
    BEQ         BDigitRoutine
    move.w      #25, d1
    add.l       d5, d1
    move.w      #25, d2
    move.w      #35, d3
    add.l       d5, d3
    move.w      #45, d4
    jsr         DrawDigitPosition
BDigitRoutine
    lsr.l         #4, d6
    move.l      d6, d1
    AND.l       #1, d1
    BEQ         ADigitRoutine
    move.w      #25, d1
    add.l       d5, d1
    move.w      #5, d2
    move.w      #35, d3
    add.l       d5, d3
    move.w      #25, d4
    jsr         DrawDigitPosition
ADigitRoutine
    lsr.l         #4, d6
    move.l      d6, d1
    AND.l       #1, d1
    BEQ         FinishHealth
    move.w      #5, d1
    add.l       d5, d1
    move.w      #5, d2
    move.w      #35, d3
    add.l       d5, d3
    move.w      #15, d4
    jsr         DrawDigitPosition
    
    BRA         FinishHealth
*routine that we call when the value is turned on
DrawDigitPosition
    move.l      #87, d0
    trap        #15
    rts

FinishHealth
    rts

* Put variables and constants here
*All 9 digits represented in 7 segment
zeroDigit   
    dc.l    $01111110
oneDigit    
    dc.l    $00110000
twoDigit    
    dc.l    $01101101
threeDigit  
    dc.l    $01111001
fourDigit   
    dc.l    $00110011
fiveDigit       
    dc.l    $01011011
sixDigit    
    dc.l    $01011111
sevenDigit  
    dc.l    $01110000
eightDigit  
    dc.l    $01111111
nineDigit   
    dc.l    $01111011








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
