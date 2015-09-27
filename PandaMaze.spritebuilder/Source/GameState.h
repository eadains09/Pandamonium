//
//  GameState.h
//  PandaMaze
//
//  Created by Erika Dains on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameState : NSObject

+(instancetype) sharedInstance;

@property (nonatomic) int lightning;
@property (nonatomic) int snowflake;
@property (nonatomic) int teleport;
@property (nonatomic) int fruit;
@property (nonatomic) int score;
@property (nonatomic) int highscore;
@property (nonatomic) BOOL tutorialCompleted;
@property (nonatomic) BOOL retryTutorial;
@property (nonatomic) float screenSize;

@end
