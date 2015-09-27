//
//  PowerUpRoulette.m
//  PandaMaze
//
//  Created by Erika Dains on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PowerUpRoulette.h"
#import "GameState.h"

@implementation PowerUpRoulette
{
    CCLabelTTF *_winningPowerPack;
    CCLabelTTF *_headerLabel;
    CCNode *_powerPackNode;
    CCButton *_barrel1;
    CCButton *_barrel2;
    CCButton *_barrel3;
}

-(void) didLoadFromCCB
{
    _barrel1.userInteractionEnabled = YES;
    _barrel2.userInteractionEnabled = YES;
    _barrel3.userInteractionEnabled = YES;
    [_headerLabel setString:[NSString stringWithFormat:@"CHOOSE A BARREL!"]];
}

-(void) barrel
{
    int randomPower = arc4random() % 3;
    int randomQuanity = (1 + arc4random() % 3);

    if (randomPower == 0)
    {
        [_winningPowerPack setString:[NSString stringWithFormat: @"%i LIGHTNING POWER UPS!", randomQuanity]];
        [GameState sharedInstance].lightning += randomQuanity;
    }
    if (randomPower == 1)
    {
        [_winningPowerPack setString:[NSString stringWithFormat: @"%i FREEZE POWER UPS!", randomQuanity]];
        [GameState sharedInstance].snowflake += randomQuanity;
    }
    
    if (randomPower == 2)
    {
        [_winningPowerPack setString:[NSString stringWithFormat: @"%i TELEPORT POWER UPS!", randomQuanity]];
        [GameState sharedInstance].teleport += randomQuanity;
    }
    
    _barrel1.userInteractionEnabled = NO;
    _barrel2.userInteractionEnabled = NO;
    _barrel3.userInteractionEnabled = NO;
    
    [_headerLabel setString:[NSString stringWithFormat:@"CONGRATULATIONS!"]];
    _powerPackNode.visible = YES;
    
    [self.popUpDelegate buttonClicked];
}

-(void) close
{
    //close pop up
    [self removeFromParent];
    [self.popUpDelegate exitPopUp];
}

-(void) onExit
{
    [super onExit];
    _powerPackNode.visible = NO;
}

@end
