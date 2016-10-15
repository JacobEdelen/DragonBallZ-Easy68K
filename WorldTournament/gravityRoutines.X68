*-----------------------------------------------------------
* Title      : GravityRoutines
* Written by : Jacob Edelen
* Date       : 10/13/2016
* Description: This file stores all the updates to the position of the players due to gravity
*-----------------------------------------------------------

updatePlayerGravity
        *update position of player due to gravity 
        jsr     Player1GravityRoutine
        jsr     Player2GravityRoutine
        jsr     checkForPlayer1Ground
        jsr     checkForPlayer2Ground
        rts

Player1GravityRoutine
        *If the player is still jumping, do not apply gravity
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #SPACE_KEY,d1
        TRAP            #15
        cmpi.b          #0,d1
        bne             exitGravity
        move.l          Player1Jumping, d5
        cmpi.l          #1, d5
        BNE             exitGravity
        *If the player is moving left or right, then do not use the jumping sprite
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #$41,d1
        TRAP            #15
        cmpi.b          #0,d1
        bne             applyPlayer1Gravity
        
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #$44,d1
        TRAP            #15
        cmpi.b          #0,d1
        bne             applyPlayer1Gravity
        
        *Change sprite to jumping sprite
        move.l          Player1JumpSprite, Player1ChunkX
applyPlayer1Gravity
        *ACCELERATION HERE
        *add gravity to acceleration and then acceleration to Y position of player every frame
        move.l          Player1Velocity, d0
        move.l          #Gravity, d1
        add.l           d1, d0
        move.l          d0, Player1Velocity        
        move.l          Player1Y, d4
        add.l           Player1Velocity, d4
        move.l          d4, Player1Y
        rts
        
checkForPlayer1Ground
    *Check if the velocity added to the position is greater than the ground of the player
    move.l  Player1Y, d4
    add.l   Player1Velocity, d4
    *shift right since the Y position is stored while shifted
    lsr     #FRAC_BITS, d4
    move.l  Ground, d5
    cmp     d5, d4
    BGT     setPlayer1Ground     
    
returnPlayer1Ground    
    rts
    
setPlayer1Ground
    *set player1 Y position to the ground
    move.l  #0, Player1Velocity
    move.l  Player1IdleSprite, Player1ChunkX
    jsr     updatePlayersBackGrounds
    move.l  Ground, d4
    lsl     #FRAC_BITS, d4
    move.l  d4, Player1Y
    move.l  #0, Player1Jumping
    *Play landing sound upon contact
    lea     LandingSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    bra     returnPlayer1Ground        
        
        
*Calculate gravity for player 2 in the same as as player 1 but account for height difference between players     
Player2GravityRoutine
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #$26,d1
        TRAP            #15
        cmpi.b          #0,d1
        bne             exitGravity

        move.l          Player2Jumping, d5
        cmpi.l          #1, d5
        BNE             exitGravity
        
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #$25,d1
        TRAP            #15
        cmpi.b          #0,d1
        bne             applyPlayer2Gravity
        
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #$27,d1
        TRAP            #15
        cmpi.b          #0,d1
        bne             applyPlayer2Gravity
        
        move.l          Player2JumpSprite, Player2ChunkX
applyPlayer2Gravity 
        move.l          Player2Velocity, d0
        add.l           #Gravity, d0
        move.l          d0, Player2Velocity       
        move.l          Player2Y, d4
        add.l           Player2Velocity, d4        
        move.l          d4, Player2Y
exitGravity
        rts
        
checkForPlayer2Ground
    move.l  Player2Y, d4
    add.l   Player2Velocity, d4
    lsr     #FRAC_BITS, d4
    move.l  Ground, d5
    *Player 1 and player 2 have a height difference
    sub.l   #5, d5
    cmp     d5, d4
    BGT     setPlayer2Ground     
    
returnPlayer2Ground    
    rts
    
setPlayer2Ground
    move.l  #0, Player2Velocity
    move.l  Player2IdleSprite, Player2ChunkX
    jsr     updatePlayersBackGrounds
    move.l  Ground, d4
    sub.l   #10, d4
    lsl     #FRAC_BITS, d4
    move.l  d4, Player2Y
    move.l  #0, Player2Jumping
    
    lea     LandingSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    bra     returnPlayer2Ground







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
