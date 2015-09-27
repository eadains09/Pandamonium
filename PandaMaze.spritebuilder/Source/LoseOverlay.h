//
//  LoseOverlay.h
//  PandaMaze
//
//  Created by Erika Dains on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "PopUpHandlerDelegate.h"

@interface LoseOverlay : CCNode <PopUpHandlerDelegate>

@property(nonatomic, weak) id<PopUpHandlerDelegate> popUpDelegate;


@end
