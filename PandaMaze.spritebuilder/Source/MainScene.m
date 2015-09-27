//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameState.h"
#import "PopUp.h"
#import "Settings.h"
#import "WatchAdPopUp.h"

//BOOL static firstLoad = YES;
BOOL static _tutorialButtonAdded;


@implementation MainScene
{
    WatchAdPopUp *_watchAdPopUp;
    PopUp *loginError;
    CCButton *_tutorialButton;
    CCButton *_storeButton;
    CCButton *_powerUpButton;
    CCButton *_emailButton;
    CCButton *_facebookButton;
    CCButton *_twitterButton;
    CCButton *_settingsButton;
    CCButton *_playButton;
    
    NSMutableArray *buttonArray;
    
}

-(void) didLoadFromCCB
{
    buttonArray = [[NSMutableArray alloc]init];
    buttonArray = [NSMutableArray arrayWithObjects:_tutorialButton, _storeButton, _powerUpButton, _emailButton, _facebookButton, _twitterButton, _settingsButton, _playButton, nil];
}

-(void) onEnter
{
    [super onEnter];
    [GameState sharedInstance].screenSize = self.boundingBox.size.width;
    [GameState sharedInstance].retryTutorial = NO;
    
    if ([GameState sharedInstance].tutorialCompleted == YES){
        _tutorialButton.visible = YES;
        //Start animation or control layout of buttons with tutorial button visible
        if (!_tutorialButtonAdded){
            CCAnimationManager* animationManager = self.animationManager;
            [animationManager runAnimationsForSequenceNamed:@"TutorialAdd Timeline"];
            _tutorialButtonAdded = YES;
        }else{
//            _tutorialButton.positionType = CCPositionTypeNormalized;
//            _tutorialButton.position = ccp(.5, .3);
//            _storeButton.positionType = CCPositionTypeNormalized;
//            _storeButton.position = ccp(.19, .3);
//            _powerUpButton.positionType = CCPositionTypeNormalized;
//            _powerUpButton.position = ccp(.81, .3);
            _tutorialButton.positionType = CCPositionTypeNormalized;
            _tutorialButton.position = ccp(.75, .3);
            _storeButton.positionType = CCPositionTypeNormalized;
            _storeButton.position = ccp(.25, .3);
        }
    }else{
        _tutorialButton.visible = NO;
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (!firstLoad && [GameState sharedInstance].tutorialCompleted)
//        {
//            if ([GameState sharedInstance].lightning == 0 &&
//                [GameState sharedInstance].snowflake == 0 &&
//                [GameState sharedInstance].teleport == 0)
//            {
//                [self displayWatchAdPopUp];
//            }
//        }else{
//            firstLoad = NO;
//        }
//    });
}

- (void) play
{
    CCScene *_gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_gameplayScene withTransition:_transition];
}

-(void) store
{
    CCScene *_storeScene = [CCBReader loadAsScene:@"Store"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_storeScene withTransition:_transition];
}

-(void) tutorial
{
    [GameState sharedInstance].retryTutorial = YES;
    CCScene *_gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_gameplayScene withTransition:_transition];
}

//-(void) powerUp
//{
//    [self displayWatchAdPopUp];
//}

-(void) email
{
    if([MGWU canInviteFriends]){
        [MGWU inviteFriendsWithMessage:@"I'm playing a fun new game called Pandamonium! Check it out!"];
    }else{
        [self displayLoginError];
    }
}

-(void) twitter
{
    if([MGWU isTwitterActive]){
        [MGWU postToTwitter:@"Check out this fun new game I'm playing...Pandamonium! @makegameswithus"];
    }else{
        [self displayLoginError];
    }
}

-(void) facebook
{
    if([MGWU isFacebookActive]){
        [MGWU shareWithTitle:@"Pandamonium!" caption:@"Check out this fun new game I'm playing!" andDescription:@"Navigate the red panda through the maze!"];
    }else{
        [MGWU loginToFacebook];
    }
}

-(void) settings
{
    Settings *settingsScreen = (Settings*)[CCBReader load:@"Settings"];
    settingsScreen.popUpDelegate = self;
    [self addChild:settingsScreen];
    [self disableButtons];
    
}

-(void) clear
{
    [GameState sharedInstance].lightning = 0;
    [GameState sharedInstance].snowflake = 0;
    [GameState sharedInstance].teleport = 0;
    [GameState sharedInstance].tutorialCompleted = NO;
}


//Delegate methods
-(void) exitPopUp{
    for (CCButton *curButton in buttonArray)
    {
        curButton.userInteractionEnabled = YES;
    }
}

-(void) buttonClicked{}


//locally called methods
-(void) disableButtons
{
    for (CCButton *curButton in buttonArray)
    {
        curButton.userInteractionEnabled = NO;
    }
}

//-(void) displayWatchAdPopUp
//{
//    _watchAdPopUp = (WatchAdPopUp*)[CCBReader load:@"WatchAd"];
//    _watchAdPopUp.popUpDelegate = self;
//    _watchAdPopUp.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
//    [self addChild:_watchAdPopUp];
//    [self disableButtons];
//}

-(void) displayLoginError
{
    loginError = (PopUp*)[CCBReader load: @"LoginError"];
    loginError.popUpDelegate = self;
    loginError.positionType = CCPositionTypeNormalized;
    loginError.position = ccp(.5, .5);
    [self addChild:loginError];
    [self disableButtons];
}

@end
