//
//  PauseOverlay.m
//  PandaMaze
//
//  Created by Erika Dains on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PauseOverlay.h"

@implementation PauseOverlay


-(void) home
{
    CCScene *_returnToMain = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_returnToMain withTransition: _transition];
}

-(void) restart
{
    CCScene *_restartMaze = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_restartMaze withTransition:_transition];
}

@end
