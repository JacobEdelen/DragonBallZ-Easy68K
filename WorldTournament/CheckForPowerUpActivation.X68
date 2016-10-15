*-----------------------------------------------------------
* Title      : CheckForPowerUpActivation
* Written by : Jacob Edelen
* Date       : 10/10/2016
* Description: This program checks to see if the random time has goine to zero before finally activating the power up
*-----------------------------------------------------------

    
CheckForPowerUpActivation
    *If the powerUp has been grabbed, exit
    move.l      PowerUpGrabbed, d0
    cmpi.l      #1, d0
    BEQ         exitActivatePowerUp
    *Also, exit if the powerup is active
    move.l      ActivePowerUp, d0
    cmpi.l      #1, d0
    BEQ         exitActivatePowerUp
    
    *Decrement timer until it hits 0.  Then activate the powerup
DecrementTimer
    move.l      PowerUpActivationTime, d0
    sub.l       #1, d0
    move.l      d0, PowerUpActivationTime
    
CheckTimer
    move.l      PowerUpActivationTime, d0
    cmpi.l      #0, d0
    BGT         exitActivatePowerUp
    
ActivatePowerUp
    jsr         DrawDragonBallCall
    move.l      #1, ActivePowerUp
    
exitActivatePowerUp
    rts

*load in the powerup and draw it in this routine
DrawDragonBallCall
    lea     PowerUp, a0
    move.l  #PowerUpSquareLength, d1
    move.l  #PowerUpSquareLength, d2
    move.l  PowerUpX, d3
    move.l  PowerUpY, d4
    move.l  #0, d5
    move.l  #0, d6
    jsr     DRAWIMAGE
    rts
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
