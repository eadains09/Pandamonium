//
//  Door.m
//  PandaMaze
//
//  Created by Erika Dains on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Door.h"

@implementation Door

-(void) didLoadFromCCB
{
    self.userInteractionEnabled = YES;
}

- (void) touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event
{
    [self openTrapdoor];
}

-(void) openTrapdoor
{
    CGPoint doorPosition;
    
    CCParticleSystem *_trapdoorEffect = (CCParticleSystem*) [CCBReader load: @"Effects/TrapdoorEffect"];
    _trapdoorEffect.autoRemoveOnFinish = YES;
    doorPosition = self.position;
    _trapdoorEffect.position = doorPosition;
    [self.parent addChild:_trapdoorEffect];
    
    [self removeFromParent];
}

@end
