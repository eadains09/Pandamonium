//
//  Store.m
//  PandaMaze
//
//  Created by Erika Dains on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Store.h"
#import "GameState.h"
#import "PopUp.h"

@implementation Store
{
    CCLabelTTF *_fruitLabel;
    CCButton *_lightningButton;
    CCButton *_snowflakeButton;
    CCButton *_teleportButton;
    
    CCButton *_buyLightningWithFruitButton;
    CCButton *_buyLightningIAPButton;
    CCButton *_buyFreezeWithFruitButton;
    CCButton *_buyFreezeIAPButton;
    CCButton *_buyTeleportWithFruitButton;
    CCButton *_buyTeleportIAPButton;
    CCButton *_buyMegaWithFruitButton;
    CCButton *_buyMegaIAPButton;
    CCButton *_backButton;
    NSMutableArray *buttonArray;
}

-(void) didLoadFromCCB
{
    [self updateLabels];
    
    buttonArray = [[NSMutableArray alloc] init];
    buttonArray = [NSMutableArray arrayWithObjects: _buyLightningWithFruitButton, _buyLightningIAPButton, _buyFreezeWithFruitButton, _buyFreezeIAPButton, _buyTeleportWithFruitButton, _buyTeleportIAPButton, _buyMegaWithFruitButton, _buyMegaIAPButton, _backButton, nil];
}

-(void) buyTeleportWithFruit
{
    if ([GameState sharedInstance].fruit >= 100)
    {
        [GameState sharedInstance].fruit -= 100;
        [GameState sharedInstance].teleport += 5;
        [self updateLabels];
        [self displayPurchaseSuccessMessage];
    }else{
        [self displayPurchaseFailMessage];
    }
}

-(void) buyTeleportIAP
{
    //InApp Purchases with MGWU SDK
    [MGWU buyProduct:@"com.erikadains.PandaMaze.TeleportBundle" withCallback:@selector(boughtProduct:) onTarget:self];
}

-(void) buyLightningWithFruit
{
    if ([GameState sharedInstance].fruit >= 50)
    {
        [GameState sharedInstance].fruit -= 50;
        [GameState sharedInstance].lightning += 5;
        [self updateLabels];
        [self displayPurchaseSuccessMessage];
    }else{
        [self displayPurchaseFailMessage];
    }
}

-(void) buyLightningIAP
{
    [MGWU buyProduct:@"com.erikadains.PandaMaze.LightningBundle" withCallback:@selector(boughtProduct:) onTarget:self];
}

-(void) buyFreezeWithFruit
{
    if ([GameState sharedInstance].fruit >= 50)
    {
        [GameState sharedInstance].fruit -= 50;
        [GameState sharedInstance].snowflake += 5;
        [self updateLabels];
        [self displayPurchaseSuccessMessage];
    }else{
        [self displayPurchaseFailMessage];
    }
}

-(void) buyFreezeIAP
{
    [MGWU buyProduct:@"com.erikadains.PandaMaze.FreezeBundle" withCallback:@selector(boughtProduct:) onTarget:self];
}

-(void) buyMegaWithFruit
{
    if ([GameState sharedInstance].fruit >= 150)
    {
        [GameState sharedInstance].fruit -= 150;
        [GameState sharedInstance].teleport += 6;
        [GameState sharedInstance].lightning += 6;
        [GameState sharedInstance].snowflake += 6;
        [self updateLabels];
        [self displayPurchaseSuccessMessage];
    }else{
        [self displayPurchaseFailMessage];
    }
}

-(void) buyMegaIAP
{
    [MGWU buyProduct:@"com.erikadains.PandaMaze.MegaBundle" withCallback:@selector(boughtProduct:) onTarget:self];
}

-(void) back
{
    CCScene *_returnToMain = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *_transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:_returnToMain withTransition: _transition];
}

//delegate methods
-(void) exitPopUp{
    for (CCButton *curButton in buttonArray)
    {
        curButton.userInteractionEnabled = YES;
    }
}

-(void) buttonClicked{
    [self updateLabels];
}

-(void) boughtProduct: (NSString*) product{
    
    if ([product isEqualToString:[NSString stringWithFormat:@"com.erikadains.PandaMaze.MegaBundle"]]){
        [GameState sharedInstance].teleport += 6;
        [GameState sharedInstance].lightning += 6;
        [GameState sharedInstance].snowflake += 6;
        [self updateLabels];
        [self displayPurchaseSuccessMessage];
    }else if ([product isEqualToString:[NSString stringWithFormat:@"com.erikadains.PandaMaze.FreezeBundle"]]){
        [GameState sharedInstance].snowflake += 5;
        [self updateLabels];
        [self displayPurchaseSuccessMessage];
    }else if ([product isEqualToString:[NSString stringWithFormat:@"com.erikadains.PandaMaze.LightningBundle"]]){
        [GameState sharedInstance].lightning += 5;
        [self updateLabels];
        [self displayPurchaseSuccessMessage];
    }else if ([product isEqualToString:[NSString stringWithFormat:@"com.erikadains.PandaMaze.TeleportBundle"]]){
        [GameState sharedInstance].teleport += 5;
        [self updateLabels];
        [self displayPurchaseSuccessMessage];
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

-(void) displayPurchaseSuccessMessage
{
    PopUp *purchaseSuccessPopUp = (PopUp*)[CCBReader load:@"PurchasedSuccess"];
    purchaseSuccessPopUp.popUpDelegate = self;
    purchaseSuccessPopUp.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
    [self addChild:purchaseSuccessPopUp];
    [self disableButtons];
}

-(void) displayPurchaseFailMessage
{
    PopUp* purchaseFailPopUp = (PopUp*)[CCBReader load:@"PurchasedFail"];
    purchaseFailPopUp.popUpDelegate = self;
    purchaseFailPopUp.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
    [self addChild:purchaseFailPopUp];
    [self disableButtons];
}

-(void) updateLabels
{
    [_fruitLabel setString: [NSString stringWithFormat:@"%i", [GameState sharedInstance].fruit]];
    [_lightningButton setTitle: [NSString stringWithFormat:@"%i", [GameState sharedInstance].lightning]];
    [_snowflakeButton setTitle: [NSString stringWithFormat:@"%i", [GameState sharedInstance].snowflake]];
    [_teleportButton setTitle:[NSString stringWithFormat:@"%i", [GameState sharedInstance].teleport]];
}

@end
