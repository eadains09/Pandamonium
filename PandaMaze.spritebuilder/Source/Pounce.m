//
//  Pounce.m
//  PandaMaze
//
//  Created by Erika Dains on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Pounce.h"

@implementation Pounce
{
    CCSprite *_pandaSprite;
}

//-(void)didLoadFromCCB
//{
//}

-(void) update:(CCTime)delta
{
    //CCLOG(@"velocity.x: %f", self.physicsBody.velocity.x);
    if (self.physicsBody.velocity.x < .01 && self.physicsBody.velocity.x > -0.01)
    {
        //[self standStill];
    }
    
    if (self.physicsBody.velocity.y < 0)
    {
        //allow rotation
        self.rotation = clampf(self.rotation, -45.f, 45.f);
        //or turn into ball
    }else{
        self.rotation = clampf(self.rotation, -1.f, 1.f);
    }
    
    
}

-(void) moveSideways
{
    CGPoint _pos = self.position;
    if (self.physicsBody.velocity.x > 0)
    {
        _pos.x -= 80;
    }else
    {
        _pos.x += 80;
    }
    self.position = _pos;
}

-(void) moveLeft
{
    
}

-(void) standStill
{
    [self.animationManager setPaused:YES];
}

-(void) moveRightWithForce: (double) acceleration
{
    _pandaSprite.flipX = NO;
    [self.physicsBody applyImpulse:ccp(500 * (1.1*acceleration), 0)];
    [self.animationManager setPaused:NO];
}

-(void) moveLeftWithForce: (double) acceleration
{
    _pandaSprite.flipX = YES;
    //self.physicsNode.position = CGPointMake(30, 0);
    [self.physicsBody applyImpulse:ccp(500 * (1.1*acceleration), 0)];
    [self.animationManager setPaused:NO];
}

-(void) moveUpWithForce: (double) acceleration
{
    [self.physicsBody applyImpulse:ccp(0, 550 * acceleration)];
}

-(void) moveUp
{
    CGPoint _pos = self.position;
    _pos.y += 85;
    self.position = _pos;
}

-(void) stopForce
{
    [self.physicsBody setVelocity:CGPointMake(0, 0)];
    self.physicsBody.affectedByGravity = NO;
}

@end
