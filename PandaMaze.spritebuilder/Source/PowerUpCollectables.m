//
//  PowerUpCollectables.m
//  PandaMaze
//
//  Created by Erika Dains on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PowerUpCollectables.h"

@implementation PowerUpCollectables

+(CCSprite*) randomPowerUps
{
    CCSprite *_randomPowerUp;
    
    int random = arc4random() % 3;
    
    switch (random) {
        case 0:
            _randomPowerUp = (CCSprite*)[CCBReader load:@"PowerUpCollectables/Lightning"];
            break;
        case 1:
            _randomPowerUp = (CCSprite*)[CCBReader load:@"PowerUpCollectables/Snowflake"];
            break;
        case 2:
            _randomPowerUp = (CCSprite*)[CCBReader load:@"PowerUpCollectables/Teleport"];
            break;
        default:
            CCLOG(@"error adding powerups");
            break;
    }
    return _randomPowerUp;
}

@end
