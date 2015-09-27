//
//  PandaMazeActivity.m
//  PandaMaze
//
//  Created by Erika Dains on 7/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PandaMazeActivity.h"

@implementation PandaMazeActivity

- (CCScene *)startScene
{
    return [CCBReader loadAsScene:@"MainScene"];
}

- (BOOL)onKeyUp:(int32_t)keyCode keyEvent:(AndroidKeyEvent *)event
{
    if (keyCode == AndroidKeyEventKeycodeBack)
    {
        [self finish];
    }
    return NO;
}

@end
