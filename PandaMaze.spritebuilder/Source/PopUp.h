//
//  WatchAd.h
//  PandaMaze
//
//  Created by Erika Dains on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "PopUpHandlerDelegate.h"

@interface PopUp : CCNode <PopUpHandlerDelegate>

@property(nonatomic, weak) id<PopUpHandlerDelegate> popUpDelegate;

@end
