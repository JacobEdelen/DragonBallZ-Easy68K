*-----------------------------------------------------------
* Title      :  PowerUpCollision
* Written by :  Jacob Edelen
* Date       :  10/8/2016
* Description:  Handles the colision of the player entities and the powerup under active circumstances
*-----------------------------------------------------------


* Check for collision of the powerup on all four sides for both players
CheckForPlayerCollision
    move.l  ActivePowerUp, d1
    cmpi.l  #1, d1
    BNE     exitCollision

    move.l  Player2X, d1
    move.l  Player2Y, d2
    lsr.l   #4, d2
    move.l  PowerUpX, d3
    move.l  PowerUpY, d4
    
    add.l   #32, d1 
    cmp     d1, d3
    BGT     Player1Collision
    
    sub.l   #32, d1
    add.l   #52, d3
    cmp     d1, d3
    BLT     Player1Collision
    
    add.l   #46, d2
    cmp     d2, d4
    BGT     Player1Collision
    
    sub.l   #46, d2
    add.l   #52, d4
    cmp     d2, d4
    BLT     Player1Collision
    BRA     powerUpPlayer2

    
Player1Collision
    move.l  Player1X, d1
    move.l  Player1Y, d2
    lsr.l   #4, d2
    move.l  PowerUpX, d3
    move.l  PowerUpY, d4
    
    add.l   #32, d1 
    cmp     d1, d3
    BGT     exitCollision
    
    sub.l   #32, d1
    add.l   #52, d3
    cmp     d1, d3
    BLT     exitCollision
    
    add.l   #41, d2
    cmp     d2, d4
    BGT     exitCollision
    
    sub.l   #41, d2
    add.l   #52, d4
    cmp     d2, d4
    BLT     exitCollision
    
*Depending on which player grabs it, remove powerup from the screen, update player sprite, and play the power sound
powerUpPlayer1
    add.l   #41, Player1ChunkY
    move.l  #288, Player1ChunkX
    jsr     updatePowerUpBackGround
    jsr     updatePlayersBackgrounds
    move.b  #94, d0
    trap    #15
    
    move.l  #50, Player1ProjectileWidth
    move.l  #40, Player1ProjectileHeight
    move.l  Player1DamageSprite, Player1ChunkX
    move.l  #5, Player1ProjectileYOffset
    move.l  #2, Player1ProjectileDamage
    
    lea     SuperVegeta, a1
    move.l  #0, d1
    move.l  #0, d2
    move.l  #73, d0
    trap    #15  
    
    move.l  #0, ActivePowerUp
    move.l  #1, PowerUPGrabbed
    rts

powerUpPlayer2

    add.l   #46, Player2ChunkY
    move.l  #288, Player2ChunkX
    jsr     updatePowerUpBackGround
    jsr     updatePlayersBackgrounds
    move.b  #94, d0
    trap    #15
    
    move.l  #74, Player2ProjectileWidth
    move.l  #56, Player2ProjectileHeight
    move.l  Player2DamageSprite, Player2ChunkX
    move.l  #-2, Player2ProjectileYOffset
    move.l  #2, Player2ProjectileDamage
    
    lea     SuperGoku, a1
    move.l  #0, d1
    move.l  #0, d2
    move.l  #73, d0
    trap    #15
    
    move.l  #0, ActivePowerUp
    move.l  #1, PowerUPGrabbed
    rts

exitCollision
    rts











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
