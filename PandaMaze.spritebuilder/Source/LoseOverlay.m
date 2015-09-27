//
//  LoseOverlay.m
//  PandaMaze
//
//  Created by Erika Dains on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LoseOverlay.h"
#import "GameState.h"
#import "PopUp.h"
#import "WatchAdPopUp.h"


@implementation LoseOverlay
{
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_endWordsLabel;
    CCButton *_homeButton;
    CCButton *_restartButton;
    CCButton *_storeButton;
    CCButton *_facebookButton;
    CCButton *_emailButton;
    CCButton *_twitterButton;
    NSMutableArray *buttonArray;
    WatchAdPopUp *_watchAdPopUp;
    PopUp *loginError;
}

-(void) didLoadFromCCB
{
    buttonArray = [[NSMutableArray alloc] init];
    buttonArray = [NSMutableArray arrayWithObjects:_homeButton, _restartButton, _storeButton, _facebookButton, _emailButton, _twitterButton, nil];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GameOverPhrases" ofType:@"plist"];
    NSArray *statements = [NSArray arrayWithContentsOfFile:path];
    NSString *chosenStatement;
    if ([GameState sharedInstance].score < 1){
        int randomPhrase = arc4random()%2;
        chosenStatement = statements[0][randomPhrase];
    }else if ([GameState sharedInstance].score < 20){
        int randomPhrase = arc4random()%4;
        chosenStatement = statements[1][randomPhrase];
    }else if([GameState sharedInstance].score < 50){
        int randomPhrase = arc4random()%4;
        chosenStatement = statements[2][randomPhrase];
    }else if ([GameState sharedInstance].score < 75){
        int randomPhrase = arc4random()%6;
        chosenStatement = statements[3][randomPhrase];
    }else if ([GameState sharedInstance].score < 100){
        int randomPhrase = arc4random()%3;
        chosenStatement = statements[4][randomPhrase];
    }else{//greater than 100
        //int randomPhrase = arc4random()%3;
        chosenStatement = statements[4][0];
    }
    [_endWordsLabel setString:chosenStatement];
    [_scoreLabel setString:[NSString stringWithFormat:@"%i FT", [GameState sharedInstance].score]];
    [_highScoreLabel setString:[NSString stringWithFormat:@"%i FT", [GameState sharedInstance].highscore]];
    
    if([MGWU canInviteFriends]){
        _emailButton.enabled = YES;
    }else{
        _emailButton.enabled = NO;
    }
    
    if([MGWU isTwitterActive]){
        _twitterButton.enabled = YES;
    }else{
        _twitterButton.enabled = NO;
    }
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if ([GameState sharedInstance].lightning == 0 &&
//            [GameState sharedInstance].snowflake == 0 &&
//            [GameState sharedInstance].teleport == 0){
//            [self displayWatchAdPopUp];
//        }
//    });
}

//helper methods
//-(void) displayWatchAdPopUp
//{
//    _watchAdPopUp = (WatchAdPopUp*)[CCBReader load:@"WatchAd"];
//    _watchAdPopUp.popUpDelegate = self;
//    _watchAdPopUp.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
//    [self addChild:_watchAdPopUp];
//    [self disableButtons];
//}

-(void) disableButtons
{
    for (CCButton *curButton in buttonArray)
    {
        curButton.userInteractionEnabled = NO;
    }
}

//delegate methods
-(void) exitPopUp{
    for (CCButton *curButton in buttonArray)
    {
        curButton.userInteractionEnabled = YES;
    }
}

-(void) buttonClicked{
    [self.popUpDelegate buttonClicked];
}

//buttons methods
-(void) restart
{
    CCScene *_restartMaze = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_restartMaze withTransition:_transition];
}

-(void) home
{
    CCScene *_returnToMain = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_returnToMain withTransition: _transition];
}

-(void) store
{
    CCScene *_storeScene = [CCBReader loadAsScene:@"Store"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_storeScene withTransition:_transition];
}

-(void) email
{
    NSString *message = [NSString stringWithFormat:@"I just traveled %i ft in Pandamonium! How far can you get?", [GameState sharedInstance].score];
    [MGWU inviteFriendsWithMessage:message];
}

-(void) twitter
{
    NSString *message = [NSString stringWithFormat:@"I just traveled %i ft in Pandamonium! @makegameswithus", [GameState sharedInstance].score];
    [MGWU postToTwitter:message];
}

-(void) facebook
{
    NSString *message = [NSString stringWithFormat:@"I just traveled %i ft in Pandamonium! How far can you get?", [GameState sharedInstance].score];
    if([MGWU isFacebookActive]){
        [MGWU shareWithTitle:@"Pandamonium!" caption:message andDescription:@"Navigate the red panda through the maze!"];
    }else{
        [MGWU loginToFacebook];
    }
}

@end
