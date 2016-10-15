*-----------------------------------------------------------
* Title      :  ProjectileCollision
* Written by :  Jacob Edelen
* Date       :  10/8/2016
* Description:  Handles the colision of the player entities and the projectiles under active circumstances
*-----------------------------------------------------------

CheckProjectileCollision

Player2BeamCollisionDetection
    *Make sure that the projectile is active, otherwise check the next collision detection
    move.l  Player1ProjectileActive, d1
    cmpi.l  #1, d1
    BNE     Player1BeamCollisionDetection

    move.l  Player2X, d1
    move.l  Player2Y, d2
    *shift remainder bits out of player Y to calculate in the same base
    lsr.l   #FRAC_BITS, d2
    move.l  Player1ProjectileX, d3
    move.l  Player1ProjectileY, d4
    
    *Compare all four sides of projectile with player 2
    add.l   Player2Width, d1 
    cmp     d1, d3
    BGT     Player1BeamCollisionDetection
    
    sub.l   Player2Width, d1
    add.l   Player1ProjectileWidth, d3
    cmp     d1, d3
    BLT     Player1BeamCollisionDetection
    
    add.l   Player2Height, d2
    cmp     d2, d4
    BGT     Player1BeamCollisionDetection
    
    sub.l   Player2Height, d2
    add.l   Player1ProjectileHeight, d4
    cmp     d2, d4
    BLT     Player1BeamCollisionDetection
    *if all checks fail, then collision has occured
    jsr     BeamHitPlayer2

*Perform same collision logic with player 1 and the beam of player 2
Player1BeamCollisionDetection
    move.l  Player2ProjectileActive, d1
    cmpi.l  #1, d1
    BNE     BeamToBeamCollisionDetection

    move.l  Player1X, d1
    move.l  Player1Y, d2
    lsr.l   #FRAC_BITS, d2
    move.l  Player2ProjectileX, d3
    move.l  Player2ProjectileY, d4
    
    add.l   Player1Width, d1 
    cmp     d1, d3
    BGT     BeamToBeamCollisionDetection
    
    sub.l   Player1Width, d1
    add.l   Player2ProjectileWidth, d3
    cmp     d1, d3
    BLT     BeamToBeamCollisionDetection
    
    add.l   Player1Height, d2
    cmp     d2, d4
    BGT     BeamToBeamCollisionDetection
    
    sub.l   Player1Height, d2
    add.l   Player2ProjectileHeight, d4
    cmp     d2, d4
    BLT     BeamToBeamCollisionDetection
    jsr     BeamHitPlayer1

*Now use the same logic to see if the two beams have collided
BeamToBeamCollisionDetection
    move.l  Player2ProjectileActive, d1
    cmpi.l  #1, d1
    BNE     exitBeamCollisionDetection
    
    move.l  Player1ProjectileActive, d1
    cmpi.l  #1, d1
    BNE     exitBeamCollisionDetection

    move.l  Player1ProjectileX, d1
    move.l  Player1ProjectileY, d2
    move.l  Player2ProjectileX, d3
    move.l  Player2ProjectileY, d4
    
    add.l   Player1ProjectileWidth, d1 
    cmp     d1, d3
    BGT     exitBeamCollisionDetection
    
    sub.l   Player1ProjectileWidth, d1
    add.l   Player2ProjectileWidth, d3
    cmp     d1, d3
    BLT     exitBeamCollisionDetection
    
    add.l   Player1ProjectileHeight, d2
    cmp     d2, d4
    BGT     exitBeamCollisionDetection
    
    sub.l   Player1ProjectileHeight, d2
    add.l   Player2ProjectileHeight, d4
    cmp     d2, d4
    BLT     exitBeamCollisionDetection    
    BRA     BeamsCollided

BeamHitPlayer1
    *Player 1 has been hit.  Subtract the beam damage from health
    move.l  Player1Health, d1
    sub.l   Player2ProjectileDamage, d1
    *Check if player health is below 0
    cmpi.l  #0, d1
    BGE     ContinueBeamHitPlayer1
    * if it is, set health to 0
    jsr     SetHealthToZero
ContinueBeamHitPlayer1  
*update player health and sprite
    move.l  d1, Player1Health
    move.l  Player1DamageSprite, Player1ChunkX
    
    move.l  #0, Player2ProjectileActive
    
    *draw background behind player
    lea     BackGround, a0
    move.l  Player2ProjectileWidth, d1
    move.l  Player2ProjectileHeight, d2
    move.l  Player2ProjectileX, d3
    move.l  Player2ProjectileY, d4
    move.l  Player2ProjectileX, d5
    move.l  Player2ProjectileY, d6
    jsr     DRAWIMAGE
    *draw updated score for players
    jsr     updateScoreBackGround
    move.l  Player1Health, d0
    move.l  Player1ScoreX, d5
    jsr     updateHealth
    move.l  Player2Health, d0
    move.l  Player2ScoreX, d5
    jsr     updateHealth
    
    *spawn sound of player that was hit
    lea     VegetaHitSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    bra     exitBeamCollisionDetection

    *perform same logic when player 2 collides with player 1's beam
BeamHitPlayer2

    move.l  Player2Health, d1
    sub.l   Player1ProjectileDamage, d1
    cmpi.l  #0, d1
    BGE     ContinueBeamHitPlayer2
    jsr     SetHealthToZero
ContinueBeamHitPlayer2  
    move.l  d1, Player2Health
    move.l  Player2DamageSprite, Player2ChunkX
    
    move.l  #0, Player1ProjectileActive
    
    lea     BackGround, a0
    move.l  Player1ProjectileWidth, d1
    move.l  Player1ProjectileHeight, d2
    move.l  Player1ProjectileX, d3
    move.l  Player1ProjectileY, d4
    move.l  Player1ProjectileX, d5
    move.l  Player1ProjectileY, d6
    jsr     DRAWIMAGE
    
    jsr     updateScoreBackGround
    move.l  Player1Health, d0
    move.l  Player1ScoreX, d5
    jsr     updateHealth
    move.l  Player2Health, d0
    move.l  Player2ScoreX, d5
    jsr     updateHealth
    
    lea     GokuHitSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    bra     exitBeamCollisionDetection
    *if the beams collide, remove them from the scene by drawing over them and then play a sound
BeamsCollided
    move.l  #0, Player1ProjectileActive
    
    lea     BackGround, a0
    move.l  Player1ProjectileWidth, d1
    move.l  Player1ProjectileHeight, d2
    move.l  Player1ProjectileX, d3
    move.l  Player1ProjectileY, d4
    move.l  Player1ProjectileX, d5
    move.l  Player1ProjectileY, d6
    jsr     DRAWIMAGE
    
    move.l  #0, Player2ProjectileActive
    
    lea     BackGround, a0
    move.l  Player2ProjectileWidth, d1
    move.l  Player2ProjectileHeight, d2
    move.l  Player2ProjectileX, d3
    move.l  Player2ProjectileY, d4
    move.l  Player2ProjectileX, d5
    move.l  Player2ProjectileY, d6
    jsr     DRAWIMAGE
    
    lea     ExplosionSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15

exitBeamCollisionDetection
    rts
    
SetHealthToZero
    move.l  #0, d1
    rts











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
