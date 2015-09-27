//
//  SimilarGames.m
//  PandaMaze
//
//  Created by Erika Dains on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SimilarGames.h"

@implementation SimilarGames

-(void) back
{
    CCScene *_returnToMain = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_returnToMain withTransition: _transition];
}

@end
