//
//  Fruit.m
//  PandaMaze
//
//  Created by Erika Dains on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Fruit.h"

@implementation Fruit

+(CCSprite*) randomFruit
{
    CCSprite *_randomFruit;
    
    int random = arc4random() % 5;
    
    switch (random) {
        case 0:
            _randomFruit = (CCSprite*)[CCBReader load:@"Fruit/Apple"];
            break;
        case 1:
            _randomFruit = (CCSprite*)[CCBReader load:@"Fruit/Strawberry"];
            break;
        case 2:
            _randomFruit = (CCSprite*)[CCBReader load:@"Fruit/Grapes"];
            break;
        case 3:
            _randomFruit = (CCSprite*)[CCBReader load:@"Fruit/Watermelon"];
            break;
        case 4:
            _randomFruit = (CCSprite*)[CCBReader load:@"Fruit/Banana"];
            break;
        default:
            CCLOG(@"error adding fruit");
            break;
    }
    return _randomFruit;
}

@end
