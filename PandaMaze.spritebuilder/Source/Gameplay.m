//
//  Gameplay.m
//  PandaMaze
//
//  Created by Erika Dains on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Pounce.h"
#import "Maze.h"
#import "LoseOverlay.h"
#import "PauseOverlay.h"
#import "PowerUpCollectables.h"
#import "Trapdoor.h"
#import "GameState.h"
#import "Tutorial.h"
#import "CCPhysics+ObjectiveChipmunk.h"

#import <CoreMotion/CoreMotion.h>

int static COUNTDOWN = 0;
int static FAST_COUNTDOWN = 0;
int static const MAZE_LENGTH = 1000;
float defaultScrollingSpeed = .5;


typedef NS_ENUM(NSInteger, PowerUpType) {
    PowerUpTypeNone,
    PowerUpTypeLightning,
    PowerUpTypeSnowflake,
    PowerUpTypeTeleport,
};

@implementation Gameplay
{
    NSMutableArray *_mazeArray;
    Maze *_maze;
    Maze *_maze2;
    CCNode *_mazeNode;
    float _scrollingSpeed;
    float _speedIncrease;
    float _mazeDistanceScrolled;
    int mazeCount;
    float _pandaTotalDistanceTravelled;
    float _pandaStartpos;
    float _pandaCurrentMazeDistance;
    Pounce *_panda;
    CCNode *_snowNode;
    CCPhysicsNode *_physicsNode;
    PowerUpType _selectedPowerUpType; //enum
    CCLabelTTF *_distanceLabel;
    CCButton *_lightningButton;
    CCButton *_snowflakeButton;
    CCButton *_teleportButton;
    CCLabelTTF *_fruitLabel;
    CCButton *_pauseButton;
    CCButton *_restartButton;
    CCButton *_rightButton;
    CCButton *_leftButton;
    BOOL _firstCollision;
    BOOL _lightningDirections;
    BOOL _teleportDirections;
    BOOL _jumpDirections;
    BOOL _jumpPrompt;
    BOOL _useSnowflakeDirections;
    BOOL _snowflakeDirections;
    BOOL _runTutorial;
    NSTimeInterval _sinceStart;
    CMMotionManager *_motionManager;
    UISwipeGestureRecognizer *swipeUp;
    PauseOverlay* _pauseScreen;
}

-(void) didLoadFromCCB
{
    _physicsNode.collisionDelegate = self;
    [_physicsNode setGravity:CGPointMake(0, -500)];
    self.userInteractionEnabled = YES;
    _mazeArray = [NSMutableArray array];
    
    if (!([GameState sharedInstance].tutorialCompleted) || ([GameState sharedInstance].retryTutorial))
    {
        if ([GameState sharedInstance].screenSize > 320)
        {
            _maze = (Tutorial*)[CCBReader load:@"MazeTutorial/iPadTutorial"];

        }else{
            _maze = (Tutorial*)[CCBReader load:@"MazeTutorial/Tutorial"];
        }
        [GameState sharedInstance].retryTutorial = NO;
        _runTutorial = YES;
        defaultScrollingSpeed = .01;
    }else{
        _maze = (Maze*)[CCBReader load:@"Maze/Maze"];
        defaultScrollingSpeed = .5;
    }
    
    [_mazeArray addObject:_maze];
    mazeCount = 0;
    [_mazeNode addChild:_maze];
    [self updateAllLabels];
    _selectedPowerUpType = PowerUpTypeNone;
    _scrollingSpeed = defaultScrollingSpeed;
    
    _rightButton.visible = NO;
    _leftButton.visible = NO;
//    _physicsNode.debugDraw = TRUE;
   
    _motionManager = [[CMMotionManager alloc] init];
    swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
}

- (void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    
    //get location in correct space for start position of character
    CGPoint _pandaStartWorld = [_maze convertToWorldSpace:_maze.startPosition.position];
    CGPoint _pandaMazeNodeStartPosition = [_mazeNode convertToNodeSpace:_pandaStartWorld];
    
    _panda = (Pounce*)[CCBReader load:@"Pounce"];
    _panda.position = _pandaMazeNodeStartPosition;
    [_mazeNode addChild:_panda];
    
    _pandaStartpos = _maze.startPosition.position.y;
    _pandaTotalDistanceTravelled = 0;
    
    [_motionManager startAccelerometerUpdates];
}

-(void) update:(CCTime)delta
{
    _sinceStart += delta;
    CGPoint _pandaVerticalWorld = [_mazeNode convertToWorldSpace:_panda.position];
    CGPoint _pandaScreenPosition = [self convertToNodeSpace:_pandaVerticalWorld];
    CGPoint _pandaMazePosition = [_maze convertToNodeSpace:_pandaVerticalWorld];
    
    //Maze scrolling controls

    //begin scrolling if it's been 3 seconds since scene loaded
    if (_sinceStart>=5){
        if (_scrollingSpeed>=0){
            //get current position of physics node
            CGPoint physicsNodePosition = _physicsNode.position;
            //add scrolling speed unit to the position
            physicsNodePosition.y -= _scrollingSpeed;
            //update maze position
            _physicsNode.position = physicsNodePosition;
            //update mazedistance scrolled for use in maze section management
            _mazeDistanceScrolled += _scrollingSpeed;
        }
    }
    
    //For restoring scrolling after freezing power up
    if (_scrollingSpeed < defaultScrollingSpeed){
        COUNTDOWN += 1;
        
        if (COUNTDOWN >= 500 || _pandaScreenPosition.y < self.boundingBox.size.height/4){
            _scrollingSpeed = defaultScrollingSpeed;
            _speedIncrease = 0;
            COUNTDOWN = 0;
        }
    }
    
    //have scrolling speed up when panda in last quarter of screen
    if (_pandaScreenPosition.y < self.boundingBox.size.height/4){
        if (_speedIncrease < 1){
            _speedIncrease += .1;
            _scrollingSpeed += .1;
        }
    }
    
    //restore scrolling speed up after 1 second
    if (_scrollingSpeed > defaultScrollingSpeed){
        FAST_COUNTDOWN += 1;
        
        if (FAST_COUNTDOWN >= 100){
            _scrollingSpeed = defaultScrollingSpeed;
            _speedIncrease = 0;
            FAST_COUNTDOWN = 0;
        }
    }
    
   
    
    //Panda wrap around screen
    if (_pandaScreenPosition.x > (self.boundingBox.size.width)){
        CGPoint pandaNewPosition = _pandaScreenPosition;
        pandaNewPosition.x = 10;
        CGPoint pandaWorldPosition = [self convertToWorldSpace:pandaNewPosition];
        CGPoint pandaPosition = [_mazeNode convertToNodeSpace:pandaWorldPosition];
        _panda.position = pandaPosition;
    }
    
    if (_pandaScreenPosition.x < 0){
        CGPoint pandaNewPosition = _pandaScreenPosition;
        pandaNewPosition.x = (self.boundingBox.size.width - 10);
        CGPoint pandaWorldPosition = [self convertToWorldSpace:pandaNewPosition];
        CGPoint pandaPosition = [_mazeNode convertToNodeSpace:pandaWorldPosition];
        _panda.position = pandaPosition;
    }
    
//    keep panda from scrolling off bottom of screen
//    if (_pandaScreenPosition.y < 0)
//    {
//        CGPoint _pandaPosition1 = [self convertToWorldSpace:_pandaScreenPosition];
//        CGPoint _pandaPosition2 = [_mazeNode convertToNodeSpace:_pandaPosition2];
//        _panda.position = _pandaPosition2;
//    }
    
    //Keep track of distance Panda has travelled
    _pandaCurrentMazeDistance = _pandaStartpos - _pandaMazePosition.y;
    [_distanceLabel setString:[NSString stringWithFormat:@"%i FT", (int)(_pandaTotalDistanceTravelled + _pandaCurrentMazeDistance)/75]];

    
    
    //Tutorial controls
    if (_runTutorial){
        [self tutorialMessageManagement];
    }
    
    //Maze section management
    
    //generate new section of maze
    if ([_mazeArray count] < 2 && _mazeDistanceScrolled > (self.boundingBox.size.height|| 400)){
//    if ([_mazeArray count] < 2 && _mazeDistanceScrolled > 400){
        [self generateNewMazeSection];
    }
    
    //remove old section of maze once off screen and increment scrolling speed
    if (_mazeDistanceScrolled > 1000){
        [self removeOldMaze];
        CGPoint _pandaMazePosition = [_maze convertToNodeSpace:_pandaVerticalWorld];
        _pandaStartpos = _pandaMazePosition.y;
    }
    
    //Accelerometer Controls
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    if (acceleration.x > .1){
        [_panda moveRightWithForce:acceleration.x];
    }else if(acceleration.x < -.1){
        [_panda moveLeftWithForce:acceleration.x];
    }

    //Losing control
    if(_pandaScreenPosition.y-25 > self.boundingBox.size.height){
        [self lose];
    }
}

#pragma mark - Maze Section Management

-(void) generateNewMazeSection
{
    mazeCount ++;
//    CCLOG(@"new maze added: %i", mazeCount);
    _maze2 = (Maze*)[CCBReader load:@"Maze/Maze"];
    _maze2.position = ccp(0, ((-1*mazeCount) * (MAZE_LENGTH)));
    [_mazeArray addObject:_maze2];
    [_mazeNode addChild:_maze2];
    [_panda setZOrder:0];
}


-(void) removeOldMaze
{
//    CCLOG(@"maze removed");

    _pandaTotalDistanceTravelled = _pandaTotalDistanceTravelled + _pandaCurrentMazeDistance;

    [_maze removeFromParent];
    [_mazeArray removeObjectAtIndex:0];
    _maze = [_mazeArray objectAtIndex:0];
    
    if (defaultScrollingSpeed < 2)
    {
        defaultScrollingSpeed +=.2;
        _speedIncrease = 0;
        FAST_COUNTDOWN = 0;
        _scrollingSpeed = defaultScrollingSpeed;
    }
    _mazeDistanceScrolled = 0;
    _maze2 = nil;
}

#pragma mark - Collision Methods

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair pounce:(CCNode *)pounce lightning:(PowerUpCollectables *)lightning
{
    [[_physicsNode space] addPostStepBlock:^{
        [lightning removeFromParent];
        [GameState sharedInstance].lightning += 1;
        [_lightningButton setTitle: [NSString stringWithFormat:@"%i", [GameState sharedInstance].lightning]];
    } key:lightning];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair pounce:(CCNode *)pounce snowflake:(CCNode *) snowflake
{
    [[_physicsNode space] addPostStepBlock:^{
        [snowflake removeFromParent];
        [GameState sharedInstance].snowflake += 1;
        [_snowflakeButton setTitle: [NSString stringWithFormat:@"%i", [GameState sharedInstance].snowflake]];
        if (!_useSnowflakeDirections)
        {
            [_maze removeJumpPrompt];
            [_maze removeSnowDirections];
            [_maze useSnowflakeDirections];
            _useSnowflakeDirections = YES;
            _snowflakeDirections = YES;
        }
    } key:snowflake];
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair pounce:(CCNode *)pounce teleport:(CCNode *)teleport
{
    [[_physicsNode space] addPostStepBlock:^{
        [teleport removeFromParent];
        [GameState sharedInstance].teleport += 1;
        [_teleportButton setTitle:[NSString stringWithFormat:@"%i", [GameState sharedInstance].teleport]];
    } key:teleport];
    return TRUE;
}

- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair pounce:(CCNode *)pounce fruit:(CCNode *)fruit
{
    [[_physicsNode space] addPostStepBlock:^{
        [fruit removeFromParent];
        [GameState sharedInstance].fruit += 1;
        [_fruitLabel setString: [NSString stringWithFormat:@"%i", [GameState sharedInstance].fruit]];
    } key:fruit];
    return TRUE;
}

#pragma mark - Tutorial Methods

-(void) tutorialMessageManagement
{
    CGPoint _pandaVerticalWorld = [_mazeNode convertToWorldSpace:_panda.position];
    CGPoint _pandaMazePosition = [_maze convertToNodeSpace:_pandaVerticalWorld];
    
    if (_pandaMazePosition.x > 70 && _pandaMazePosition.x < 80){
        if (_pandaMazePosition.y > 1000 && _pandaMazePosition.y < 1010){
            [_maze tiltDirections];
        }
    }
    if (_pandaMazePosition.y > 920 && _pandaMazePosition.y < 945){
        [_maze removeTiltDirections];
    }
    if (_pandaMazePosition.y > 895 && _pandaMazePosition.y < 915){
        [_maze powerCollectionDirections];
    }
    if (_pandaMazePosition.y > 830 && _pandaMazePosition.y < 840){
        [_maze removePowerCollectDirections];
        [_maze trapdoorDirections];
    }
    if (_pandaMazePosition.y > 745 && _pandaMazePosition.y < 770){
        [_maze removeTrapdoorDirections];
        [_maze stuckDirections];
        _lightningDirections = YES;
    }
    if (_pandaMazePosition.y > 640 && _pandaMazePosition.y < 670){
        [_maze removeStuckDirections2];
    }
    if (_pandaMazePosition.y > 540 && _pandaMazePosition.y < 590){
        [_maze jumpDirections];
        _jumpDirections = YES;
    }
    if (_pandaMazePosition.x > 10 && _pandaMazePosition.x < 95){
        if (_pandaMazePosition.y > 450 && _pandaMazePosition.y < 470){
            [_maze collectSnowDirections];
        }
    }
    if (_pandaMazePosition.x > 80 && _pandaMazePosition.x < 100){
        if (_pandaMazePosition.y > 390 && _pandaMazePosition.y < 455){
            [_maze jumpPrompt];
            _jumpPrompt = YES;
        }
    }
    if (_pandaMazePosition.y > 315 && _pandaMazePosition.y < 375){
        [_maze removeJumpPrompt];
        [_maze removeSnowDirections];
    }
    if (_pandaMazePosition.x > 160 && _pandaMazePosition.x < 320){
        if (_pandaMazePosition.y > 230 && _pandaMazePosition.y < 300){
            [_maze removeSnowflake2Directions];
            [_maze collectFruitDirections];
            _teleportDirections = YES;
        }
    }
    if (_pandaMazePosition.y > 170 && _pandaMazePosition.y < 230){
        [_maze removeFruitDirections];
        [_maze teleportDirections];
        _teleportDirections = YES;
    }
    if (_pandaMazePosition.y < 150){
        [_maze removeTeleportDirections2];
    }
    if (_pandaMazePosition.y < 130){
        [_maze tutorialFinishedDirections];
        [self updateAllLabels];
    }
    
    if (_pandaMazePosition.y < 95)
    {
        [GameState sharedInstance].tutorialCompleted = YES;
        _runTutorial = NO;
        defaultScrollingSpeed = .25;
        if (FAST_COUNTDOWN == 0)
        {
            _scrollingSpeed = defaultScrollingSpeed;
        }
        _mazeDistanceScrolled = 0;
        [_maze speedUpWarning];
    }
}


#pragma mark - Touch Methods

-(void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
{
    //actions on touchEnded
}

- (void) touchEnded:(CCTouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_maze];
    CGPoint touchInMazeLocation;
    int mazeNum;
    MazeBlocks *touchedBlock;
    if (touchLocation.y > 70)
    {
        touchInMazeLocation = touchLocation;
        touchedBlock = [_maze getBlock: touchInMazeLocation];
        mazeNum = 1;
    }else
    {
        touchInMazeLocation = [touch locationInNode:_maze2];
        mazeNum = 2;
        touchedBlock = [_maze2 getBlock: touchInMazeLocation];
    }
    
    
    switch (_selectedPowerUpType) {
        case PowerUpTypeLightning:
            if (touchedBlock){
                [self lightningEffect: touchedBlock];
            }
            break;
        case PowerUpTypeTeleport:
            [self teleportEffect:touchLocation];
            break;
        default:
            break;
    }
    
    _selectedPowerUpType = PowerUpTypeNone;
}

-(void) touchCancelled:(CCTouch /*UITouch*/ *)touch withEvent:(UIEvent *)event
{
    _selectedPowerUpType = PowerUpTypeNone;
}

- (void)swipeUp {
    [_panda moveUpWithForce:20];
    if (_jumpDirections){
        [_maze removeJumpDirections];
        _jumpDirections = NO;
    }
    if (_jumpPrompt){
        [_maze removeJumpPrompt];
        _jumpPrompt = NO;
    }
}

#pragma mark - Effects

-(void) lightningEffect: (CCNode*) block
{
    CCParticleSystem *_lightningEffect = (CCParticleSystem*) [CCBReader load: @"Effects/Explosion"];
    _lightningEffect.autoRemoveOnFinish = YES;
    _lightningEffect.position = block.position;
    [block.parent addChild:_lightningEffect];
    
    [block removeFromParent];
    
    [GameState sharedInstance].lightning -= 1;
    [_lightningButton setTitle: [NSString stringWithFormat:@"%i", [GameState sharedInstance].lightning]];
}

-(void) snowflakeEffect
{
    CCParticleSystem *_snowflakeEffect = (CCParticleSystem*) [CCBReader load: @"Effects/Snow"];
    _snowflakeEffect.autoRemoveOnFinish = YES;
    [_snowNode addChild:_snowflakeEffect];
    _scrollingSpeed = 0;
    
    [GameState sharedInstance].snowflake -= 1;
    [_snowflakeButton setTitle: [NSString stringWithFormat:@"%i", [GameState sharedInstance].snowflake]];
}

-(void) teleportEffect: (CGPoint) touchPos
{
    CCParticleSystem *disappearanceEffect = (CCParticleSystem*) [CCBReader load:@"Effects/Appearance"];
    disappearanceEffect.autoRemoveOnFinish = YES;
    disappearanceEffect.position = _panda.position;
    [_mazeNode addChild:disappearanceEffect];
    _panda.visible = NO;
    
    [GameState sharedInstance].teleport -= 1;
    [_teleportButton setTitle:[NSString stringWithFormat:@"%i", [GameState sharedInstance].teleport]];
    
    CGPoint touchInWorld = [_maze convertToWorldSpace:touchPos];
    CGPoint touchInMazeNode = [_mazeNode convertToNodeSpace:touchInWorld];
    
    _panda.position = touchInMazeNode;
    CCParticleSystem *appearanceEffect = (CCParticleSystem*) [CCBReader load:@"Effects/Appearance"];
    appearanceEffect.autoRemoveOnFinish = YES;
    appearanceEffect.position = touchInMazeNode;
    [_mazeNode addChild:appearanceEffect];
    _panda.visible = YES;
}

-(void) updateAllLabels{
    [_lightningButton setTitle: [NSString stringWithFormat:@"%i", [GameState sharedInstance].lightning]];
    [_snowflakeButton setTitle: [NSString stringWithFormat:@"%i", [GameState sharedInstance].snowflake]];
    [_teleportButton setTitle:[NSString stringWithFormat:@"%i", [GameState sharedInstance].teleport]];
    [_fruitLabel setString:[NSString stringWithFormat:@"%i", [GameState sharedInstance].fruit]];
}


#pragma mark - End Scenarios

- (void) lose
{
    [self disableScreen];
    [GameState sharedInstance].score = (_pandaTotalDistanceTravelled + _pandaCurrentMazeDistance)/75;
    if ([GameState sharedInstance].score > [GameState sharedInstance].highscore)
    {
        [GameState sharedInstance].highscore = [GameState sharedInstance].score;
    }
    //Analytics Logging, next three lines
    NSNumber *score = [NSNumber numberWithInt:[GameState sharedInstance].score];
    NSDictionary *gameScore = [[NSDictionary alloc] initWithObjectsAndKeys: score, @"score", nil];
    [MGWU logEvent:@"Game_Lost" withParams:gameScore];
    
    LoseOverlay* _loseScreen = (LoseOverlay*) [CCBReader load:@"LoseOverlay"];
    _loseScreen.popUpDelegate = self;
    _loseScreen.positionType = CCPositionTypeNormalized;
    _loseScreen.position = ccp(0.5f,0.5f);
    [self addChild:_loseScreen];
}

- (void) disableScreen
{
    self.paused = YES;
    _lightningButton.userInteractionEnabled = NO;
    _snowflakeButton.userInteractionEnabled = NO;
    _teleportButton.userInteractionEnabled = NO;
    _pauseButton.userInteractionEnabled = NO;
    _restartButton.userInteractionEnabled = NO;
}

-(void) enableScreen
{
    self.paused = NO;
    _lightningButton.userInteractionEnabled = YES;
    _snowflakeButton.userInteractionEnabled = YES;
    _teleportButton.userInteractionEnabled = YES;
    _pauseButton.userInteractionEnabled = YES;
    _restartButton.userInteractionEnabled = YES;
}

- (void)onExit
{
    [super onExit];
    [_motionManager stopAccelerometerUpdates];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:swipeUp];
}

#pragma  mark - Delegate Methods
-(void) exitPopUp{}

-(void) buttonClicked{
    [self updateAllLabels];
}

#pragma mark - Buttons

-(void) restart
{
    CCScene *_restartMaze = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_restartMaze withTransition:_transition];
}

-(void) pause
{
    [self disableScreen];
    _pauseScreen = (PauseOverlay*) [CCBReader load:@"PauseOverlay" owner:self];
    _pauseScreen.positionType = CCPositionTypeNormalized;
    _pauseScreen.position = ccp(0.5f,0.5f);
    [self addChild:_pauseScreen];
}

-(void) play
{
    [_pauseScreen removeFromParent];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self enableScreen];
    });
}

-(void) lightning
{
    if ([GameState sharedInstance].lightning > 0)
    {
        _selectedPowerUpType = PowerUpTypeLightning;
        if (_lightningDirections)
        {
            [_maze removeStuckDirections];
            [_maze stuckDirections2];
            _lightningDirections = NO;
        }
    }
}

-(void) snowflake
{
    if ([GameState sharedInstance].snowflake > 0)
    {
        if (_snowflakeDirections)
        {
            [_maze removeSnowflakeDirections];
            [_maze useSnowflake2Directions];
            _snowflakeDirections = NO;
        }
        COUNTDOWN = 0;
        [self snowflakeEffect];
    }
}

-(void) teleport
{
    if ([GameState sharedInstance].teleport > 0)
    {
        _selectedPowerUpType = PowerUpTypeTeleport;
        if (_teleportDirections)
        {
            [_maze removeTeleportDirections];
            [_maze teleportDirections2];
            _teleportDirections = NO;
        }
    }
}

-(void) right
{
    [_panda moveRightWithForce:8];
}

-(void) left
{
    [_panda moveLeftWithForce:-8];
}

@end
