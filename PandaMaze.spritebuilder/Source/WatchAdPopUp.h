//
//  WatchAdPopUp.h
//  PandaMaze
//
//  Created by Erika Dains on 8/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PopUp.h"

@interface WatchAdPopUp : PopUp <PopUpHandlerDelegate>//, AdColonyAdDelegate>

@property(nonatomic, weak) id<PopUpHandlerDelegate> popUpDelegate;


@end
