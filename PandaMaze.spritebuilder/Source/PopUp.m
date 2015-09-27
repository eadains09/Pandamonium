//
//  PopUp.m
//  PandaMaze
//
//  Created by Erika Dains on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PopUp.h"
#import "PowerUpRoulette.h"

@implementation PopUp //PurchaseFail, PurchaseSuccess, LoginError
{
    PowerUpRoulette *_powerUpRoulette;
    CCButton *_watchAdButton;
    NSMutableArray *buttonArray;
}

-(void) didLoadFromCCB
{
    buttonArray = [[NSMutableArray alloc]init];
    buttonArray = [NSMutableArray arrayWithObjects:_watchAdButton, nil];
}

//-(void) watchAd
//{
//    //load ad video
//    [AdColony playVideoAdForZone:@"vz9e9b4cb2c0b44d0aa5" withDelegate:nil];
//    //once ad finishes load choose power up screen
//    _powerUpRoulette = (PowerUpRoulette*)[CCBReader load:@"PowerUpRoulette"];
//    _powerUpRoulette.popUpDelegate = self;
//    _powerUpRoulette.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
//    [self addChild:_powerUpRoulette];
//    [self disableButtons];
//}

-(void) close
{
    [self.popUpDelegate exitPopUp];
    [self removeFromParent];
}

-(void) disableButtons
{
    for (CCButton *curButton in buttonArray)
    {
        curButton.userInteractionEnabled = NO;
    }
}

//delegate methods
-(void) exitPopUp
{
    for (CCButton *curButton in buttonArray)
    {
        curButton.userInteractionEnabled = YES;
    }
}

-(void) buttonClicked{
    [self.popUpDelegate buttonClicked];
}

@end
