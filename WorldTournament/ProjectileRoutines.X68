*-----------------------------------------------------------
* Title      :  ProjectileRoutines
* Written by :  Jacob Edelen
* Date       :  10/9/2016
* Description:  All routines that the projectile needs to function
*-----------------------------------------------------------


spawnPlayer1Projectile
    *Check if the player already has a projectile active.  If it does, do not spawn another
    move.l  #1, Player1ProjectileActive
    move.l  Player1Left, d1
    cmpi.l  #1, d1
    BEQ     spawnPlayer1ProjectileLeft
spawnPlayer1ProjectileRight
    *player projectile is marked right for position update
    move.l  #0, Player1ProjectileLeft

    *If player is powered up, draw the larger
    move.l  Player1ChunkY, d0
    cmpi.l  #0, d0
    BEQ     drawTinyPlayer1ProjectileRight
    lea     BigBang, a0
    lea     BigBangSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    BRA     drawPlayer1ProjectileRight
            
drawTinyPlayer1ProjectileRight
    *Player is not powered up.  Spawn the smaller projectile
    lea     smallBeam, a0
    
    lea     KiBlastSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
drawPlayer1ProjectileRight
    *spawn player to the right of the player sprite
    move.l  Player1ProjectileWidth, d1
    move.l  Player1ProjectileHeight, d2
    move.l  Player1X, Player1ProjectileX
    move.l  Player1ProjectileX, d0
    add.l   Player1Width, d0
    move.l  d0, Player1ProjectileX
    move.l  Player1ProjectileX, d3
    move.l  Player1Y, d4
    *Shift player Y coordinate to get it out of stored remainder
    lsr.l   #FRAC_BITS, d4
    move.l  d4, Player1ProjectileY
    ;add.l   player1ProjectileOffset, player1ProjectileY
    move.l  Player1ProjectileYOffset,d5
    add.l   d5, Player1ProjectileY
    move.l  Player1ProjectileY, d4
    move.l  Player1ProjectileWidth, Player1ProjectileChunkX
    move.l  Player1ProjectileChunkX, d5
    move.l  Player1ProjectileChunkY, d6
    jsr     DRAWIMAGE
    rts
    
spawnPlayer1ProjectileLeft
    *else, spawn the projectile left and update the boolean for left
    move.l  #1, Player1ProjectileLeft
    
    move.l  Player1ChunkY, d0
    cmpi.l  #0, d0
    BEQ     drawTinyPlayer1ProjectileLeft
    
    lea     BigBang, a0
    
    lea     BigBangSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    BRA     drawPlayer1ProjectileLeft
        
drawTinyPlayer1ProjectileLeft
    lea     smallBeam, a0
    lea     KiBlastSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15

drawPlayer1ProjectileLeft
    move.l  Player1ProjectileWidth, d1
    move.l  Player1ProjectileHeight, d2
    move.l  Player1X, Player1ProjectileX
    move.l  Player1ProjectileX, d0
    sub.l   Player1ProjectileWidth, d0
    move.l  d0, Player1ProjectileX
    move.l  Player1ProjectileX, d3
    move.l  Player1Y, d4
    lsr.l   #FRAC_BITS, d4
    move.l  d4, Player1ProjectileY
    move.l  Player1ProjectileYOffset,d5
    add.l   d5, Player1ProjectileY
    move.l  Player1ProjectileY, d4
    move.l  #0, Player1ProjectileChunkX
    move.l  Player1ProjectileChunkX, d5
    move.l  Player1ProjectileChunkY, d6
    jsr     DRAWIMAGE
    rts
    
*Spawn Player 2 Projectile on either left of right similar to player 1
spawnPlayer2Projectile
    move.l  #1, Player2ProjectileActive
    move.l  Player2Left, d1
    cmpi.l  #1, d1
    BEQ     spawnPlayer2ProjectileLeft
spawnPlayer2ProjectileRight
    move.l  #0, Player2ProjectileLeft


    move.l  Player2ChunkY, d0
    cmpi.l  #0, d0
    BEQ     drawTinyPlayer2ProjectileRight
    
    lea     Kamehameha, a0
    
    lea     KamehamehaSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    BRA     drawPlayer2ProjectileRight
    
    
    
drawTinyPlayer2ProjectileRight
    lea     smallBeam, a0
    
    lea     KiBlastSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
drawPlayer2ProjectileRight
    move.l  Player2ProjectileWidth, d1
    move.l  Player2ProjectileHeight, d2
    move.l  Player2X, Player2ProjectileX
    move.l  Player2ProjectileX, d0
    add.l   Player2Width, d0
    move.l  d0, Player2ProjectileX
    move.l  Player2ProjectileX, d3
    move.l  Player2Y, d4
    lsr.l   #4, d4
    move.l  d4, Player2ProjectileY
    move.l  Player2ProjectileYOffset,d5
    add.l   d5, Player2ProjectileY
    move.l  Player2ProjectileY, d4
    move.l  Player2ProjectileWidth, Player2ProjectileChunkX
    move.l  Player2ProjectileChunkX, d5
    move.l  Player2ProjectileChunkY, d6
    jsr     DRAWIMAGE
    rts
spawnPlayer2ProjectileLeft
    move.l  #1, Player2ProjectileLeft
    
    move.l  Player2ChunkY, d0
    cmpi.l  #0, d0
    BEQ     drawTinyPlayer2ProjectileLeft
    
    lea     Kamehameha, a0
    
    lea     KamehamehaSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    BRA     drawPlayer2ProjectileLeft
    
    
    
drawTinyPlayer2ProjectileLeft
    lea     smallBeam, a0
    
    lea     KiBlastSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15

drawPlayer2ProjectileLeft
    move.l  Player2ProjectileWidth, d1
    move.l  Player2ProjectileHeight, d2
    move.l  Player2X, Player2ProjectileX
    move.l  Player2ProjectileX, d0
    sub.l   Player2ProjectileWidth, d0
    move.l  d0, Player2ProjectileX
    move.l  Player2ProjectileX, d3
    move.l  Player2Y, d4
    lsr.l   #FRAC_BITS, d4
    move.l  d4, Player2ProjectileY
    move.l  Player2ProjectileYOffset,d5
    add.l   d5, Player2ProjectileY
    move.l  Player2ProjectileY, d4
    move.l  #0, Player2ProjectileChunkX
    move.l  Player2ProjectileChunkX, d5
    move.l  Player2ProjectileChunkY, d6
    jsr     DRAWIMAGE
    rts

    


updateProjectilesBackground
    move.l  Player1ProjectileActive, d0
    cmpi.l  #1, d0
    BNE     exitProjectileUpdate
    
    lea     BackGround, a0
    move.l  Player1ProjectileWidth, d1
    move.l  Player1ProjectileHeight, d2
    move.l  Player1ProjectileX, d3
    move.l  Player1ProjectileY, d4
    move.l  Player1ProjectileX, d5
    move.l  Player1ProjectileY, d6
    jsr     DRAWIMAGE
    
    move.l  Player1ProjectileActive, d0
    cmpi.l  #1, d0
    BNE     exitProjectileUpdate

    move.l  Player1ProjectileLeft, d0
    cmpi.l  #1, d0
    BNE     updateProjectilesPositionRight

updateProjectilesPositionLeft
    
    
    move.l  Player1ProjectileX, d0
    sub.l   ProjectileSpeed, d0
    move.l  d0, Player1ProjectileX

    move.l  Player1ProjectileX, d0
    add.l   Player1ProjectileWidth, d0
    cmpi.l  #0, d0
    BGT     moveProjectileLeft
    
    move.l  #0, Player1ProjectileActive

moveProjectileLeft
    move.l  Player1ChunkY, d0
    cmpi.l  #0, d0
    BEQ     updateTinyPlayer1ProjectileLeft
    
    lea     BigBang, a0
    BRA     updateDrawProjectile1Left
    
updateTinyPlayer1ProjectileLeft
    lea     smallBeam, a0

updateDrawProjectile1Left

    move.l  Player1ProjectileWidth, d1
    move.l  Player1ProjectileHeight, d2
    move.l  Player1ProjectileX, d3
    move.l  Player1ProjectileY, d4
    move.l  Player1ProjectileChunkX, d5
    move.l  Player1ProjectileChunkY, d6
    jsr     DRAWIMAGE
    
    BRA     exitProjectileUpdate
    
updateProjectilesPositionRight   
    move.l  Player1ProjectileX, d0
    add.l   ProjectileSpeed, d0
    move.l  d0, Player1ProjectileX

    move.l  Player1ProjectileX, d0
    cmpi.l  #700, d0
    BLT     moveProjectileRight
    
    move.l  #0, Player1ProjectileActive

moveProjectileRight
    move.l  Player1ChunkY, d0
    cmpi.l  #0, d0
    BEQ     updateTinyPlayer1ProjectileRight
    
    lea     BigBang, a0
    BRA     updateDrawProjectile1Right
    
updateTinyPlayer1ProjectileRight
    lea     smallBeam, a0

updateDrawProjectile1Right
    move.l  Player1ProjectileWidth, d1
    move.l  Player1ProjectileHeight, d2
    move.l  Player1ProjectileX, d3
    move.l  Player1ProjectileY, d4
    move.l  Player1ProjectileChunkX, d5
    move.l  Player1ProjectileChunkY, d6
    jsr     DRAWIMAGE
    
    BRA     exitProjectileUpdate
    
*update Player 2 projectiles
updateProjectile2Background
    move.l  Player2ProjectileActive, d0
    cmpi.l  #1, d0
    BNE     exitProjectileUpdate

    lea     BackGround, a0
    move.l  Player2ProjectileWidth, d1
    move.l  Player2ProjectileHeight, d2
    move.l  Player2ProjectileX, d3
    move.l  Player2ProjectileY, d4
    move.l  Player2ProjectileX, d5
    move.l  Player2ProjectileY, d6
    jsr     DRAWIMAGE
    
    move.l  Player2ProjectileActive, d0
    cmpi.l  #1, d0
    BNE     exitProjectileUpdate

    move.l  Player2ProjectileLeft, d0
    cmpi.l  #1, d0
    BNE     updateProjectile2PositionRight

updateProjectile2PositionLeft
    
    
    move.l  Player2ProjectileX, d0
    sub.l   ProjectileSpeed, d0
    move.l  d0, Player2ProjectileX

    move.l  Player2ProjectileX, d0
    add.l   Player2ProjectileWidth, d0
    cmpi.l  #0, d0
    BGT     moveProjectile2Right
    
    move.l  #0, Player2ProjectileActive

moveProjectile2Left
    move.l  Player2ChunkY, d0
    cmpi.l  #0, d0
    BEQ     updateTinyPlayer2ProjectileLeft
    
    lea     Kamehameha, a0
    BRA     updateDrawProjectile2Left
    
updateTinyPlayer2ProjectileLeft
    lea     smallBeam, a0

updateDrawProjectile2Left
    move.l  Player2ProjectileWidth, d1
    move.l  Player2ProjectileHeight, d2
    move.l  Player2ProjectileX, d3
    move.l  Player2ProjectileY, d4
    move.l  Player2ProjectileChunkX, d5
    move.l  Player2ProjectileChunkY, d6
    jsr     DRAWIMAGE
    
    BRA     exitProjectileUpdate
    
updateProjectile2PositionRight   
    move.l  Player2ProjectileX, d0
    add.l   ProjectileSpeed, d0
    move.l  d0, Player2ProjectileX

    move.l  Player2ProjectileX, d0
    cmpi.l  #700, d0
    BLT     moveProjectile2Right
    
    move.l  #0, Player2ProjectileActive

moveProjectile2Right
    move.l  Player2ChunkY, d0
    cmpi.l  #0, d0
    BEQ     updateTinyPlayer2ProjectileRight
    
    lea     Kamehameha, a0
    BRA     updateDrawProjectile2Right
    
updateTinyPlayer2ProjectileRight
    lea     smallBeam, a0

updateDrawProjectile2Right
    move.l  Player2ProjectileWidth, d1
    move.l  Player2ProjectileHeight, d2
    move.l  Player2ProjectileX, d3
    move.l  Player2ProjectileY, d4
    move.l  Player2ProjectileChunkX, d5
    move.l  Player2ProjectileChunkY, d6
    jsr     DRAWIMAGE
    
    BRA     exitProjectileUpdate
    
    
    
*Player2 move projectile    
exitProjectileUpdate
    rts

 









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
