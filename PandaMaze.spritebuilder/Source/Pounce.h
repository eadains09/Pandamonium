//
//  Pounce.h
//  PandaMaze
//
//  Created by Erika Dains on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Pounce : CCNode

-(void) standStill;
-(void) moveRightWithForce: (double) acceleration;
-(void) moveLeftWithForce: (double) acceleration;
-(void) moveUpWithForce: (double) acceleration;
-(void) moveUp;
-(void) moveSideways;
-(void) stopForce;

@end
