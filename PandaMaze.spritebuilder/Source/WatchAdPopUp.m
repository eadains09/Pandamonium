//
//  WatchAdPopUp.m
//  PandaMaze
//
//  Created by Erika Dains on 8/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "WatchAdPopUp.h"
#import "PowerUpRoulette.h"

@implementation WatchAdPopUp //WatchAd
//{
//    CCButton *_storeButton;
//    CCButton *_watchAdButton;
//    NSMutableArray *buttonArray;
//
//}
//
//-(void) didLoadFromCCB
//{
//    buttonArray = [[NSMutableArray alloc]init];
//    buttonArray = [NSMutableArray arrayWithObjects:_storeButton, _watchAdButton, nil];
//}
//
//-(void) store
//{
//    CCScene *_storeScene = [CCBReader loadAsScene:@"Store"];
//    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
//    [[CCDirector sharedDirector] replaceScene:_storeScene withTransition:_transition];
//}
//
//-(void) watchAd
//{
//    //load ad video
//    [AdColony playVideoAdForZone:@"vz9e9b4cb2c0b44d0aa5" withDelegate:self];
//    //once ad finishes onAdColonyAdAttemptFinished will be called
//}
//
//-(void) disableButtons
//{
//    for (CCButton *curButton in buttonArray)
//    {
//        curButton.userInteractionEnabled = NO;
//    }
//}
//
////delegate methods
//-(void) exitPopUp
//{
//    for (CCButton *curButton in buttonArray)
//    {
//        curButton.userInteractionEnabled = YES;
//    }
//}
//
//-(void) buttonClicked{
//    [self.popUpDelegate buttonClicked];
//}
//
//- (void) onAdColonyAdAttemptFinished:(BOOL)shown inZone:( NSString * )zoneID {
//    if (shown){
//        PowerUpRoulette *_powerUpRoulette = (PowerUpRoulette*)[CCBReader load:@"PowerUpRoulette"];
//        _powerUpRoulette.popUpDelegate = self;
//        _powerUpRoulette.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
//        [self addChild:_powerUpRoulette];
//        [self disableButtons];
//    }else{
//        PopUp *adPlayError = (PopUp*)[CCBReader load: @"AdPlayError"];
//        adPlayError.popUpDelegate = self;
//        adPlayError.positionType = CCPositionTypeNormalized;
//        adPlayError.position = ccp(.5, .5);
//        [self addChild:adPlayError];
//        [self disableButtons];
//    }
//}


@end
