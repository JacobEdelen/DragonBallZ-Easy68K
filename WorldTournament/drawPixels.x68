*-----------------------------------------------------------
* Written by    :Jacob Edelen
* Date Created  :9/7/2016
* Description   :Takes in 7 arguments to a subroutine and runs the method to 
*                draw a section of an image in the console
*
*-----------------------------------------------------------

;EQUs for trap code calls
PenColorCode      EQU     80
DrawPixelCode     EQU     82
ScreenChangeCode  EQU     33

DrawChunk
;reads in file information and user input
;and sets the variables at the bottom and on stack
;which will be used to draw the chunk of the bmp file

        move.l  4(sp), a0               ;store the pointer to the image data into an address for access
        move.l  10(a0), d0              ;grab the offset from header to pixels
        rol.w   #8, d0                  ;rotate the word by 8 to move offset to appropriate position          
        swap    d0                      ;now swap the words of the offset for the next rotate
        rol.w   #8, d0                  ;finally rotate the words one time to make the true offset value readable
        add.w   d0, a0                  ;change position in memory to pixel data
        
        *Calculate beginning position of chunk to draw from Y position
        clr.l   d4
        move.l  36(sp),d4
        move.l  20(sp), d5
        add.l   12(sp), d5
        sub.l   d5, d4
        clr.l   d5
        move.w  d4, d5
        clr.l   d4
        
        move.l  32(sp), d4
        
        mulu.w  d4, d5
        *set position in address at the beginning of chunk draw
        add.l   d5, a0
        add.l   d5, a0 
        add.l   d5, a0    
         
         
         
               
        move.l  12(sp), d3
        
OUTERLOOP
        move.w  #0, d6                  ;set or reset x counter for for loop
        move.l  16(sp), d4
        mulu.w  #3, d4
        add.w   d4, a0                  ;add start of x to 0
        
INNERLOOP
        clr.l   d4                      ;make sure d4 has nothing in it
        move.b  (a0)+,d4                ;grab the first pixel
        swap.w  d4                      ;swap the pixel to change its position in memory for the rest of the pixel data
        clr.l   d5                      ;make sure d5 is also clear
        move.l  d4, d5                  ;store previously found pixel data in d5 for next value
        clr.l   d4                      ;clear d4 for the next bit of memory
        move.b  (a0)+, d4               ;grab next memory bit
        lsl     #8, d4                  ;shift left to get pixel in top of second word to combine with previous pixel bit
        add.l   d4, d5                  ;combine the data
        clr.l   d4                      ;clear d4 once again
        move.b  (a0)+, d4               ;get last bit needed
        add.l   d4, d5                  ;combine it to the end of the previous two bits to get the pixel value
        
        
        clr.l   d4                      ;If pixel is pink, do not draw it
        move.b  $FF, d4
        swap    d4
        move.b  $FF, d4
        
        cmp     d4, d5
        BEQ     INCREMENT
        
        BRA     DRAWPIXEL               ;pixel meets criteria and can be printed
        
INCREMENT
        clr.l   d4                      ;make sure d4 is empty for use  
        add.w   #1,d6                   ;increment x counter by one
        
        *Check for end of X row
        move.l  16(sp), d4
        add.l   d6, d4
        move.l  32(sp), d5
        cmp     d5, d4
        BEQ     INCREMENTY
      
        move.l  8(sp), d4               ;move width of image into register
        cmp     d4, d6                  ;see if counter is beyond x bounds
        BNE     INNERLOOP               ;if it is not, loop again
        
        ;skip after outside of box on x axis
        clr.l   d4
        move.l  16(sp), d4
        add.l   8(sp), d4
        clr.l   d5
        move.l  32(sp), d5
        sub.l   d4, d5
        mulu.w  #3, d5
        ;add offset to address
        add.l   d5, a0

INCREMENTY        
        ;take care of padding
        add.l   Padding, a0             ;add padding.  If there is none, the address won't skip anything
        
        sub.w   #1, d3                  ;decrement y counter to see if you are out of the y iteration
        BNE     OUTERLOOP               ;if it is not, loop back to outer loop
        BRA     ENDROUTINE              ;branch to end of subroutine, whole image has been iterated
        
DRAWPIXEL
        move.l  d5, d1                  ;move pixel data into d1 for pen color
        move.l  #PenColorCode, d0       ;set trap code for setting the pen color
        trap    #15                     ;set pen color
                         
        move.l   24(sp), d1             ;store the starting x position of the chunk
        add.l    d6, d1                 ;add iteration position of x to start of chunk
        
        move.l  28(sp), d2              ;start at top of chunk to flip image
        add.l   d3, d2                  ;subtract current y position
        move.l  #DrawPixelCode, d0      ;Set trap code to draw pixel at position
        trap    #15                     ;draw pixel at position
        
        BRA     INCREMENT               ;increment position
        
ENDROUTINE
        rts                             ;branch back to end of program

DRAWIMAGE
*...
*setup before subroutine
*...'
        *Reset padding for multiple calls
        move.l  #0, Padding
        
        move.l  #36, d0                 ;number of 7 4 byte arguments to prepare stack to receive
        sub.l   d0, sp                  ;prepare stack to receive arguments 
        
        move.l  a0, (sp)                ;load pointer to the .bmp file onto the stack
        
        ;store width of chunk on the stack
        move.l  d1, 4(sp)
        ;store height of the chunk on the stack 
        move.l  d2, 8(sp)               
        
        ;add start of chunk to move with image
        move.l   d5, 12(sp)             ;store Top left x of draw chunk on stack
        
        ;subtract y position from height to get start y
        move.l  d6, 16(sp)              ;store Top left y of draw chunk on stack                      

        move.l  d3, 20(sp)              ;store Beginning print location for x axis on stack
        move.l  d4, 24(sp)              ;store Beginning print location for y axis on stack
        
        move.l  18(a0), d1              ;get width of image from .bmp file
        rol.w   #8, d1          
        swap    d1
        rol.w   #8, d1                  ;rotate and swap long word to get true width value to use later
        move.l  d1, 28(sp)              ;store width of image to make variable not global

        
        ;calculate for padding.  
        ;This only concerns width
        move.l  #4, d2                  ;move 4 into register for padding calculation
        mulu.w  #3, d1                  ;multiply image width by 3 for formula
        divu.w  #4, d1                  ;divide by four to find remainder
        swap    d1                      ;swap remainder into lower word
        clr.l   d4                      ;make sure d4 is empty
        move.w  #0, d4                  ;move 0 into d4 
        cmp.w   d1, d4                  ;if equal, there is no padding
        BEQ     RUNPROGRAM              ;continue in program for special case of being divisible by 4
        
ACCOUNTFORPADDING
        sub.w   d1, d2                  ;subtract remainder from 4 to get padding
        move.l  d2, Padding             ;store padding for later use
        
        
RUNPROGRAM       
        move.l  22(a0), d2              ;get height of image from .bmp file
        rol.w   #8, d2          
        swap    d2
        rol.w   #8, d2                  ;rotate and swap long word to get true height value to use later
        move.l  d2, 32(sp)              ;store height of image to make variable not global

        jsr     DrawChunk               ;call subroutine to draw chunk of image       
       
        clr.l   d0
        move.l  #36, d0                
        add.l   d0, sp                  ;fix stack
        
        clr.l   d7
        
        rts

Padding
        dc.l    0
































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
