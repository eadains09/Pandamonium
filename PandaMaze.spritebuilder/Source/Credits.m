//
//  Credits.m
//  PandaMaze
//
//  Created by Erika Dains on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Credits.h"

@implementation Credits

-(void) back
{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"Exit Timeline"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popUpDelegate exitPopUp];
        [self removeFromParent];
    });

}

@end
