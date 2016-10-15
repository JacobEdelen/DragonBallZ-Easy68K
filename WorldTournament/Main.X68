*-----------------------------------------------------------
* Written by : 
* Date       : 10/2/2016
* Description: This is the main game loop of the game
*-----------------------------------------------------------
 

    ORG    $2000
START:                  ; first instruction of program

SPACE_KEY               equ $20
UP_KEY                  equ $26
DOWN_KEY                equ $28
LEFT_KEY                equ $25
RIGHT_KEY               equ $27
Gravity                 equ $9C     ;gravity store for the closest representation of 9.8
PowerUpSquareLength     equ 52
GET_USER_INPUT_COMMAND  equ 19
Player1StartSpriteX     equ 160
Player2StartSpriteX     equ 129
FRAC_BITS               equ 4




* Put program code here



        *change size of terminal
        move.b  #(ScreenChangeCode) , d0
        move.l  #700*$10000+600, d1
        trap    #15
        
        *load in the loading image first and use the draw routine
        lea     LoadingImage, a0
        move.l  #160, d1
        move.l  #170, d2
        move.l  #270, d3
        move.l  #250, d4
        move.l  #0, d5
        move.l  #0, d6
        jsr     DRAWIMAGE
        
        *enable double buffering after the loading screen
        move.b  #92, d0
        move.b  #17, d1
        trap    #15  
        
        *load title music into memory at location 0
        lea     TitleMusic, a1
        move.b  #0,d1
        move.l  #74,d0
        Trap    #15


        *load battle music into memory at location 1      
        lea     BattleMusic, a1
        move.b  #1,d1
        move.l  #74,d0
        Trap    #15

ResetBattleVariables

        *Reset all of the variables for player 1
        move.l  #10,Player1X
        move.l  #550, Player1Y
        move.l  #160, Player1ChunkX
        move.l  #0, Player1ChunkY
        move.l  #10, Player1Speed
        move.l  #0, Player1Jumping
        move.l  #8, Player1Health
        move.l  #0, Player1Left
        move.l  #16, Player1ProjectileWidth
        move.l  #12, Player1ProjectileHeight
        move.l  #10, Player1ProjectileYOffset
        move.l  #1, Player1ProjectileDamage
        
        *Reset all of the variables for player2
        move.l  #636, Player2X
        move.l  #540, Player2Y
        move.l  #129, Player2ChunkX
        move.l  #0, Player2ChunkY
        move.l  #10, Player2Speed
        move.l  #0, Player2Jumping
        move.l  #8, Player2Health
        move.l  #1, Player2Left
        move.l  #16, Player2ProjectileWidth
        move.l  #12, Player2ProjectileHeight
        move.l  #15, Player2ProjectileYOffset
        move.l  #1, Player2ProjectileDamage
        
        *reset the booleans to false for the powerup
        move.l  #0, ActivePowerUp
        move.l  #0, PowerUpGrabbed  


              
      
        *Draw the title screen and call the draw routine
        lea     TitleScreen, a0
        move.l  #700, d1
        move.l  #600, d2
        move.l  #0, d3
        move.l  #0, d4
        move.l  #0, d5
        move.l  #0, d6
        jsr     DRAWIMAGE
        
        *dump double buffer onto screen to display new draw
        move.b  #94, d0
        trap    #15
        
        
        
        *play the music for the title screen
        move.b  #0, d1
        move.l  #2, d2
        move.l  #75, d0
        trap    #15
        
        *Draw the background of the Battle scene
        lea     BackGround, a0
        move.l  #700, d1
        move.l  #550, d2
        move.l  #0, d3
        move.l  #50, d4
        move.l  #0, d5
        move.l  #50, d6
        jsr     DRAWIMAGE
        
        *get a random number and load it into the activation timer
        jsr     seedRandomNumber
        clr.l   d6
        jsr     getRandomByteIntoD6
        move.l  d6, PowerUpActivationTime
        
        
        *store player velocity as a shifted number for calculation
        move.l  Player1Velocity, d0
        lsl     #FRAC_BITS, d0
        move.l  d0, Player1Velocity
        *Store Player positions shifted as well for the Y coordinate.
        move.l  Player1Y, d0
        lsl     #FRAC_BITS, d0
        move.l  d0, Player1Y        
        move.l  Player2Y, d0
        lsl     #FRAC_BITS, d0
        move.l  d0, Player2Y

        *Set drawing pen to black for score bar
        move.l      #80, d0
        move.l      #$00000000, d1
        trap        #15
        move.l      #81, d0
        move.l      #$00000000, d1
        trap        #15
        *Draw a filled black box in the upper 50 pixels of the screen
        move.w      #0, d1
        move.w      #0, d2
        move.w      #700, d3
        move.w      #50, d4
        move.l      #87, d0
        trap        #15
        
        *Draw health bar images
        jsr     DrawPlayer1Health
        jsr     DrawPlayer2Health
        
        *Draw 7 segment health digits with the health of each player displayed
        move.l  Player1Health, d0
        move.l  Player1ScoreX, d5
        jsr     updateHealth
        move.l  Player2Health, d0
        move.l  Player2ScoreX, d5
        jsr     updateHealth
        jsr     drawPlayerCall
        jsr     drawPlayer2Call
        
        
TitleLoop
        *check to see if the user presses the space key
        move.b          #GET_KEY_INPUT_COMMAND,d0
        move.l          #SPACE_KEY,d1
        TRAP            #15
        cmpi.l          #0, d1
        BEQ             TitleLoop
                
        *Halt the title music and play the battle music
        move.b  #0,d1 
        move.l  #2,d2
        move.l  #77,d0
        Trap    #15
        
        move.b  #1, d1
        move.l  #1, d2
        move.l  #77, d0
        trap    #15
        
        *place double buffer on the view of the screen
        move.b  #94, d0
        trap    #15

*main gameloop to update entities and draw them
GAMELOOP:
    jsr     updatePlayersBackgrounds
    jsr     initPlayerInput
    jsr     updatePlayerGravity
    jsr     CheckForPlayerCollision
    jsr     CheckForPowerUpActivation
    jsr     updateProjectilesBackgrounds
    jsr     CheckProjectileCollision 
    jsr     drawPlayers
    
    
    move.b  #94, d0                     ;Get the double buffer onto the screen
    trap    #15
    
    *Check both players health to see if they are at 0.  If they are, end the game
    move.l  Player2Health, d0
    cmpi.l  #1, d0
    BLT     PLAYER1WINROUTINE
    
    move.l  Player1Health, d0
    cmpi.l  #1, d0
    BLT     PLAYER2WINROUTINE
    
    bra     GAMELOOP                    ;Otherwise, game is still running.  Loop back
    
    
*Player 2's health reached 0  so create player 2 win screen  
PLAYER1WINROUTINE  
    *Draw over players and projectiles
    jsr     updatePlayersBackgrounds
    
    jsr     updateProjectilesBackground
    *Draw win banner
    lea     Player1WinsBanner, a0
    move.l  #700, d1
    move.l  #100, d2
    move.l  #0, d3
    move.l  #300, d4
    move.l  #0, d5
    move.l  #0, d6
    jsr     DRAWIMAGE
    
    *Draw player 1 and 2 in end game positions
    lea     DeadPlayer2, a0
    move.l  #50, d1
    move.l  #30, d2
    move.l  #636, d3
    move.l  #560, d4
    move.l  #0, d5
    move.l  #0, d6
    jsr     DRAWIMAGE
    
    move.l  #10, Player1X
    move.l  #540, Player1Y
    move.l  Player1Y, d0
    lsl.l   #4, d0
    move.l  d0, Player1Y
    move.l  #160, Player1ChunkX
    jsr DrawPlayerCall
    
    *Halt music and play victory sound for player 1
    move.b  #1, d1
    move.l  #2, d2
    move.l  #77, d0
    trap    #15
    
    lea     VegetaWinSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    *Get image on double buffer
    move.b  #94, d0
    trap    #15
    
    *Stay on screen until user presses space key
PLAYER1WINLOOP
    move.b          #GET_KEY_INPUT_COMMAND,d0
    move.l          #$20,d1
    TRAP            #15
    cmpi.l          #0, d1
    BNE             ResetBattleVariables
    BRA             PLAYER1WINLOOP
    
    *Player 1's health has reached 0.  Do the same as above, but for player 2
PLAYER2WINROUTINE    
    jsr     updatePlayersBackgrounds
    
    jsr     updateProjectile2Background
    
    lea     Player2WinsBanner, a0
    move.l  #700, d1
    move.l  #100, d2
    move.l  #0, d3
    move.l  #300, d4
    move.l  #0, d5
    move.l  #0, d6
    jsr     DRAWIMAGE
    
    move.l  #636, Player2X
    move.l  #540, Player2Y
    move.l  Player2Y, d0
    lsl.l   #FRAC_BITS, d0
    move.l  d0, Player2Y
    move.l  #129, Player2ChunkX
    jsr DrawPlayer2Call
    
    move.b  #1, d1
    move.l  #2, d2
    move.l  #77, d0
    trap    #15
    
    lea     GokuWinSound, a1
    move.l  #0,d1
    move.l  #0,d2
    move.l  #73,d0
    Trap    #15
    
    lea     DeadPlayer1, a0
    move.l  #50, d1
    move.l  #30, d2
    move.l  #10, d3
    move.l  #560, d4
    move.l  #0, d5
    move.l  #0, d6
    jsr     DRAWIMAGE
    
    
    move.b  #94, d0
    trap    #15

PLAYER2WINLOOP
    move.b          #GET_KEY_INPUT_COMMAND,d0
    move.l          #$20,d1
    TRAP            #15
    cmpi.l          #0, d1
    BNE             ResetBattleVariables
    BRA             PLAYER2WINLOOP
    
*-------------------------------------------*
            *Subroutines*
    
*draw over projectile backgrounds and then draw the projectile in it's new position on screen
updateProjectilesBackgrounds
    jsr     updateProjectilesBackGround
    jsr     updateProjectile2Background
    rts

*Load in values of both player 1 and 2 and call draw sub routine
DrawPlayerCall
    lea     Vegeta, a0
    move.l  Player1Width, d1
    move.l  Player1Height, d2
    move.l  Player1X, d3
    move.l  Player1Y, d4 
    lsr     #4, d4
    move.l  Player1ChunkX, d5
    move.l  Player1ChunkY, d6
    jsr     DRAWIMAGE
    
    rts   
DrawPlayer2Call
    lea     Goku, a0
    move.l  Player2Width, d1
    move.l  Player2Height, d2
    move.l  Player2X, d3
    move.l  Player2Y, d4
    lsr     #FRAC_BITS, d4
    move.l  Player2ChunkX, d5
    move.l  Player2ChunkY, d6
    jsr     DRAWIMAGE
    
    rts
    
*Draw the health bars of both players
DrawPlayer1Health
    lea     Player1HealthImage, a0
    move.l  #200, d1
    move.l  #50, d2
    move.l  #0, d3
    move.l  #0, d4
    move.l  #0, d5
    move.l  #0, d6
    jsr     DRAWIMAGE
    rts
DrawPlayer2Health
    lea     Player2HealthImage, a0
    move.l  #200, d1
    move.l  #50, d2
    move.l  #500, d3
    move.l  #0, d4
    move.l  #0, d5
    move.l  #0, d6
    jsr     DRAWIMAGE
    rts
*Draw the backgrounds of both players
updatePlayersBackgrounds
    lea     BackGround, a0
    move.l  Player1Width, d1
    move.l  Player1Height, d2
    move.l  Player1X, d3
    move.l  Player1Y, d4
    lsr     #FRAC_BITS, d4
    move.l  Player1X, d5
    move.l  Player1Y, d6
    lsr     #FRAC_BITS, d6
    jsr     DRAWIMAGE
    lea     BackGround, a0
    move.l  Player2Width, d1
    move.l  Player2Height, d2
    move.l  Player2X, d3
    move.l  Player2Y, d4
    lsr     #FRAC_BITS, d4
    move.l  Player2X, d5
    move.l  Player2Y, d6
    lsr     #FRAC_BITS, d6
    jsr     DRAWIMAGE
    rts
    
*Draw over both score backgrounds
updateScoreBackGround
    move.l      #80, d0
    move.l      #$00000000, d1
    trap        #15
    
    move.l      #81, d0
    move.l      #$00000000, d1
    trap        #15

    move.w      #205, d1
    move.w      #5, d2
    move.w      #235, d3
    move.w      #50, d4
    move.l      #87, d0
    trap        #15
    
    move.w      #460, d1
    move.w      #5, d2
    move.w      #495, d3
    move.w      #50, d4
    move.l      #87, d0
    trap        #15
    
    rts
*Draw over power up with background
updatePowerUpBackGround
    lea         BackGround, a0
    move.l      #52, d1
    move.l      #52, d2
    move.l      PowerUpX, d3
    move.l      PowerUpY, d4
    move.l      PowerUpX, d5
    move.l      PowerUpY, d6
    jsr         DRAWIMAGE
    rts
*draw both players
drawPlayers 
      
    lea     Vegeta, a0
    move.l  Player1Width, d1
    move.l  Player1Height, d2
    move.l  Player1X, d3
    move.l  Player1Y, d4
    lsr     #FRAC_BITS, d4
    move.l  Player1ChunkX, d5
    move.l  Player1ChunkY, d6
    jsr     DRAWIMAGE
    
    lea     Goku, a0
    move.l  Player2Width, d1
    move.l  Player2Height, d2
    move.l  Player2X, d3
    move.l  Player2Y, d4
    lsr     #FRAC_BITS, d4
    move.l  Player2ChunkX, d5
    move.l  Player2ChunkY, d6
    jsr     DRAWIMAGE
    
    move.b  #94, d0
    trap    #15
    
    rts
    
    
    
* Put variables and constants here
Player1Width
    dc.l   32
Player1Height
    dc.l   41 
Player1X
    dc.l    10
Player1Y
    dc.l    550
Player1ChunkX
    dc.l    160
Player1ChunkY
    dc.l    0
Player1Speed
    dc.l    10
Player1Jumping
    dc.l    0
Player1Health
    dc.l    8
Player1Left
    dc.l    0
Player1IdleSprite
    dc.l    160
Player1JumpSprite
    dc.l    256
Player1BeamSprite
    dc.l    224   
Player1DamageSprite
    dc.l    288 
Player1ProjectileActive
    dc.l    0
Player1ProjectileLeft
    dc.l    0
Player1ProjectileWidth
    dc.l    16
Player1ProjectileHeight
    dc.l    12
Player1ProjectileX
    dc.l    700
Player1ProjectileY
    dc.l    0
Player1ProjectileYOffset
    dc.l    10
Player1ProjectileChunkX
    dc.l    74
Player1ProjectileChunkY
    dc.l    0
Player1ProjectileDamage
    dc.l    1
Player2Width
    dc.l   32
Player2Height
    dc.l    46 
Player2X
    dc.l    636
Player2Y
    dc.l    540
Player2ChunkX
    dc.l    129
Player2ChunkY
    dc.l    0
Player2Speed
    dc.l    10
Player2Jumping
    dc.l    0
Player2Health
    dc.l    5
Player2Left
    dc.l    1
Player2IdleSprite
    dc.l    129
Player2JumpSprite
    dc.l    32
Player2BeamSprite
    dc.l    64
Player2DamageSprite
    dc.l    0
Player2ProjectileActive
    dc.l    0
Player2ProjectileLeft
    dc.l    0
Player2ProjectileWidth
    dc.l    16
Player2ProjectileHeight
    dc.l    12
Player2ProjectileX
    dc.l    700
Player2ProjectileY
    dc.l    10
Player2ProjectileYOffset
    dc.l    10
Player2ProjectileChunkX
    dc.l    42
Player2ProjectileChunkY
    dc.l    0
Player2ProjectileDamage
    dc.l    1
PowerUpX
    dc.l    325
PowerUpY
    dc.l    250
Ground
    dc.l    550
Player1Velocity
    dc.l    0
Player2Velocity
    dc.l    0
ProjectileSpeed
    dc.l    20
ActivePowerUp
    dc.l    0
Player1ScoreX
    dc.l    200
Player2ScoreX
    dc.l    460
PowerUpActivationTime
    dc.l    0
PowerUpGrabbed
    dc.l    0
    
    
*sounds declared here
TitleMusic
    dc.l    'TitleTheme.wav',0
BattleMusic
    dc.l    'BattleTheme.wav',0
SuperVegeta
    dc.l    'SuperVegeta.wav',0
SuperGoku    
    dc.l    'SuperGoku.wav',0
LandingSound
    dc.l    'groundhit.wav',0
KiBlastSound
    dc.l    'kiblast.wav',0
KamehamehaSound
    dc.l    'Kamehameha.wav',0
BigBangSound
    dc.l    'bigBang.wav',0
JumpSound    
    dc.l    'jump.wav', 0
GokuHitSound
    dc.l    'GokuHit.wav',0
VegetaHitSound
    dc.l    'VegetaHit.wav',0
GokuWinSound
    dc.l    'GokuWin.wav',0
VegetaWinSound
    dc.l    'VegetaWin.wav'
ExplosionSound
    dc.l    'wallhit.wav',0
    
*images declared here    
Background
    INCBIN "worldTournamentResized.bmp"
LoadingImage
    INCBIN "loading.bmp"
TitleScreen
    INCBIN "Title.bmp"
Vegeta
    INCBIN "VegetaSheet.bmp"
Goku
    INCBIN "GokuSheet.bmp"
Player1HealthImage
    INCBIN "Player1Health.bmp"
PowerUp
    INCBIN "Dragonball.bmp" 
Player2HealthImage
    INCBIN "Player2Health.bmp"
SmallBeam
    INCBIN "smallBeam.bmp"
Kamehameha
    INCBIN "Kamehameha.bmp"
BigBang
    INCBIN "bigBang.bmp"

Player1WinsBanner
    INCBIN "Player1Wins.bmp"
Player2WinsBanner
    INCBIN "Player2Wins.bmp"
DeadPlayer1
    INCBIN "DeadVegeta.bmp"
DeadPlayer2
    INCBIN "GokuLost.bmp"     
    
*include other files 
 include "DrawPixels.x68"  
 include "playerInput.x68"
 include "healthDisplay.x68"
 include "PowerUpCollision.x68"
 include "ProjectileRoutines.x68"
 include "ProjectileCollision.x68"
 include "CheckForPowerUpActivation.x68"
 include "randomNumbers.x68"
 include "gravityRoutines.x68"
    
   

QUIT
    END    START        ; last line of source


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
