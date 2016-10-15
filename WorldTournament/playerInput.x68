*Still need to document


ALL_REG                 REG     D0-D7/A0-A6
GET_KEY_INPUT_COMMAND   equ     19        

initPlayerInput
        *ASCII CODE 25 = 0
        move.l          #$20,d2
inputLoop
        clr.l           d0   
        move.b          #GET_KEY_INPUT_COMMAND,d0
*put current ascii value we're looking for into d1 for trap
        move.l          d2,d1
        TRAP            #15
*if key is pressed call function if not just goto next ascii value
        cmpi.b          #0,d1
        beq             noCall
        jsr             callFunction
noCall
*bump to next ascii value
        add.l           #1,d2          
*if we're at Z, then reinit the data to 0 and begin loop again
        cmpi.b          #$5A,d2
        bne             inputLoop
        move.l          #0, Player1BeamPressed
        move.l          #0, Player2BeamPressed
        *end of input, return
        rts

callFunction
*save off registers
        movem.l ALL_REG,-(sp)
*load up FunctionTable[d2-'0']  
        lea     FunctionTable,a0
        sub.l   #$20,d2
        lsl.l   #2,d2
        move.l  (a0,d2),d1
*if it's a null function ptr, nothting to call so leave
        cmpi.l  #0,d1
        beq     noFuncPtr
*move value into A1 and call it
        move.l  d1,a1
        jsr     (a1)  
noFuncPtr
        movem.l (sp)+,ALL_REG
        rts











*input routines
spaceRoutine
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
*shift player 1 out of fraction to increase y value        
        move.l  #550, d0
        move.l  Player1Y, d1
        lsr     #FRAC_BITS, d1
        cmp.l   d0,d1
        BNE     jumpLoop
        *play jump sound if jumping from ground
        lea     JumpSound, a1
        move.l  #0,d1
        move.l  #0,d2
        move.l  #73,d0
        Trap    #15
        
jumpLoop
        *Set player down velocity to 0 and then 
        move.l  #0, Player1Velocity
        move.l  Player1Y, d4
        move.l  #50, d5
        lsl     #FRAC_BITS, d5
        move.l  Player1Y, d6
        move.l  Player1Speed, d3
        lsl     #FRAC_BITS, d3
        sub.l   d3, d6
        cmp     d5, d6
        BLT     spaceRoutineExit
        ;change player to jump sprite and set boolean to jumping
        move.l  Player1JumpSprite, Player1ChunkX
        sub.l   d3, d4
        move.l  d4, Player1Y
        move.l  #1, Player1Jumping
        
spaceRoutineExit
        rts
leftRoutine
*Move player left until it comes in contact with the edge
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        move.l  #1, Player2Left
        move.l  Player2X, d4
        move.l  #0, d5
        move.l  Player2X, d6
        sub.l   Player2Speed, d6
        BLT     leftRoutineExit
        *change player sprites to left
        move.l  #129, Player2IdleSprite
        move.l  #32,  Player2JumpSprite
        move.l  #64, Player2BeamSprite
        move.l  #0, Player2DamageSprite
        
        move.l  #97, Player2ChunkX
        sub.l   Player2Speed, d4
        move.l  d4, Player2X
leftRoutineExit
        rts
        
upRoutine
*same as jumping routine of player 1 but for player 2
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        
        move.l  #540, d0
        move.l  Player2Y, d1
        lsr     #FRAC_BITS, d1
        cmp.l   d0,d1
        BNE     Player2JumpLoop
        
        lea     JumpSound, a1
        move.l  #0,d1
        move.l  #0,d2
        move.l  #73,d0
        Trap    #15
      
Player2JumpLoop
        move.l  #0, Player2Velocity
        move.l  Player2Y, d4
        move.l  #50, d5
        lsl     #4, d5
        move.l  Player2Y, d6
        move.l  Player2Speed, d3
        lsl     #4, d3
        sub.l   d3, d6
        cmp     d5, d6
        BLT     upRoutineExit
        
        move.l  Player2JumpSprite, Player2ChunkX
        sub.l   d3, d4
        move.l  d4, Player2Y
        move.l  #1, Player2Jumping
        
upRoutineExit
        rts   
 
rightRoutine
*Move player 2 right until it come in contact with edge of screen
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        move.l  #0, Player2Left
        move.l  Player2X, d4
        move.l  #700, d5
        sub.l   Player2Width, d5
        move.l  Player2X, d6
        add.l   Player2Speed, d6
        cmp     d5, d6
        BGT     rightRoutineExit
        *change player 2 sprites to right sprites
        move.l  #159, Player2IdleSprite
        move.l  #256,  Player2JumpSprite
        move.l  #224, Player2BeamSprite
        move.l  #288, Player2DamageSprite
        
        move.l  #191, Player2ChunkX
        add.l   Player2Speed, d4
        move.l  d4, Player2X
rightRoutineExit
        rts     
downRoutine
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine0
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine1
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine2
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine3
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine4
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts     
routine5
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine6
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine7
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine8
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routine9
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineA
        *left moveing logic for player1
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        move.l  #1, Player1Left 
        move.l  Player1X, d4
        move.l  #0, d5
        move.l  Player1X, d6
        sub.l   Player1Speed, d6
        BLT     ARoutineExit
        
        move.l  #128, Player1IdleSprite
        move.l  #32,  Player1JumpSprite
        move.l  #64, Player1BeamSprite
        move.l  #0, Player1DamageSprite
                
        move.l  #96, Player1ChunkX
        sub.l   Player1Speed, d4
        move.l  d4, Player1X
ARoutineExit
        rts
routineB
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineC
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineD
        *move right logic for player 1
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        move.l  #0, Player1Left
        move.l  Player1X, d4
        move.l  #700, d5
        sub.l   Player1Width, d5
        move.l  Player1X, d6
        add.l   Player1Speed, d6
        cmp     d5, d6
        BGT     DRoutineExit
        
        move.l  #160, Player1IdleSprite
        move.l  #256,  Player1JumpSprite
        move.l  #224, Player1BeamSprite
        move.l  #288, Player1DamageSprite
        
        move.l  #192, Player1ChunkX
        add.l   Player1Speed, d4
        move.l  d4, Player1X
DRoutineExit
        rts 
routineE
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineF
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineG
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineH
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineI
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineJ
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
routineK
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineL
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineM
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineN
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineO
        *Spawn beam for player 2
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        *check boolean of button pressed and projectile active
        move.l  Player2BeamPressed, d0
        cmpi.l  #0, d0
        BNE     routineOExit
        
        move.l  #1, Player2BeamPressed
        
        move.l  Player2ProjectileActive, d0
        cmpi.l  #0, d0
        BNE     routineOExit
        *update sprite
        move.l  Player2BeamSprite, Player2ChunkX
        
        jsr     spawnPlayer2Projectile
        
routineOExit
        rts

routineP
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineQ
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineR
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineS
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineT
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineU
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineV

        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineW
        *spawn projectile of player 1
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        
        move.l  Player1BeamPressed, d0
        cmpi.l  #0, d0
        BNE     routineWExit
        
        move.l  #1, Player1BeamPressed
        
        move.l  Player1ProjectileActive, d0
        cmpi.l  #0, d0
        BNE     routineWExit
        
        move.l  Player1BeamSprite, Player1ChunkX
        
        jsr     spawnPlayer1Projectile
        
routineWExit
        rts

routineX
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineY
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts

routineZ
        movem.l ALL_REG,-(sp)   
        movem.l (sp)+,ALL_REG
        rts
        

*start data at space and use arrow keys
FunctionTable   
                *0-9
                dc.l    spaceRoutine
                dc.l    0,0,0,0
                dc.l    leftRoutine,upRoutine,rightRoutine,downRoutine
                dc.l    0,0,0,0,0,0,0
                dc.l    routine0,routine1,routine2,routine3,routine4,routine5,routine6,routine7,routine8,routine9
                dc.l    0,0,0,0,0,0,0
                dc.l    routineA,routineB,routineC,routineD,routineE,routineF,routineG
                dc.l    routineH,routineI,routineJ,routineK,routineL,routineM,routineN
                dc.l    routineO,routineP,routineQ,routineR,routineS,routineT,routineU
                dc.l    routineV,routineW,routineX,routineY,routineZ
                
Player1BeamPressed
        dc.l    0
Player2BeamPressed
        dc.l    0
        

























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
