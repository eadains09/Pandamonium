//
//  Settings.m
//  PandaMaze
//
//  Created by Erika Dains on 8/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Settings.h"
#import "Credits.h"
#import "GameState.h"
#import "PopUp.h"

static BOOL *soundPressed;

@implementation Settings
{
    CCButton *_backButton;
    CCButton *_soundsButton;
    CCButton *_creditsButton;
    CCButton *_moreGamesButton;
    CCButton *_restorePurchasesButton;
    NSMutableArray *buttonArray;
}

-(void) didLoadFromCCB
{
    soundPressed = YES;
    buttonArray = [[NSMutableArray alloc]init];
    buttonArray = [NSMutableArray arrayWithObjects:_backButton, _soundsButton, _creditsButton, _moreGamesButton, nil];
}

-(void) back
{
    CCAnimationManager* animationManager = self.animationManager;
    [animationManager runAnimationsForSequenceNamed:@"Exit Timeline"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popUpDelegate exitPopUp];
        [self removeFromParent];
    });
}

-(void) sounds
{
    _soundsButton.selected = soundPressed;
    soundPressed = !soundPressed;
}

-(void) credits
{
//    [MGWU displayAboutPage];
    Credits *_creditsScene = (Credits*)[CCBReader load:@"Credits"];
    _creditsScene.popUpDelegate = self;
    [self addChild:_creditsScene];
    [self disableButtons];
}

//-(void) similarGames
//{
//    [MGWU displayCrossPromo];
//
//}

-(void) restorePurchases
{
    [MGWU restoreProductsWithCallback:@selector(restoredProducts:) onTarget:self];
}

//delegate methods
-(void) exitPopUp{
    for (CCButton *curButton in buttonArray)
    {
        curButton.userInteractionEnabled = YES;
    }
}

-(void) buttonClicked{}

-(void) restoredProducts: (NSArray*) restoredProducts{
    for (NSString *eachProduct in restoredProducts) {
        if ([eachProduct isEqualToString:[NSString stringWithFormat:@"com.erikadains.PandaMaze.MegaBundle"]]){
            [GameState sharedInstance].teleport += 6;
            [GameState sharedInstance].lightning += 6;
            [GameState sharedInstance].snowflake += 6;
            [self displayRestoreSuccessMessage];
        }else if ([eachProduct isEqualToString:[NSString stringWithFormat:@"com.erikadains.PandaMaze.FreezeBundle"]]){
            [GameState sharedInstance].snowflake += 5;
            [self displayRestoreSuccessMessage];
        }else if ([eachProduct isEqualToString:[NSString stringWithFormat:@"com.erikadains.PandaMaze.LightningBundle"]]){
            [GameState sharedInstance].lightning += 5;
            [self displayRestoreSuccessMessage];
        }else if ([eachProduct isEqualToString:[NSString stringWithFormat:@"com.erikadains.PandaMaze.TeleportBundle"]]){
            [GameState sharedInstance].teleport += 5;
            [self displayRestoreSuccessMessage];
        }
    }
}

//helper methods

-(void) disableButtons
{
    for (CCButton *curButton in buttonArray)
    {
        curButton.userInteractionEnabled = NO;
    }
}

-(void) displayRestoreSuccessMessage
{
    PopUp *restoreSuccessPopUp = (PopUp*)[CCBReader load:@"PurchasedSuccess"];
    restoreSuccessPopUp.popUpDelegate = self;
    restoreSuccessPopUp.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
    [self addChild:restoreSuccessPopUp];
    [self disableButtons];
}


@end
