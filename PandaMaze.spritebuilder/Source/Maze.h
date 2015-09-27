//
//  Maze.h
//  PandaMaze
//
//  Created by Erika Dains on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "MazeBlocks.h"
#import "Trapdoor.h"
#import "Empty.h"
#import "PowerUpCollectables.h"



@interface Maze : CCNode

@property (nonatomic, strong) CCNode *startPosition;

-(MazeBlocks*) getBlock: (CGPoint) touchPosition;
-(void) tiltDirections;
-(void) removeTiltDirections;
-(void) powerCollectionDirections;
-(void) removePowerCollectDirections;
-(void) trapdoorDirections;
-(void) removeTrapdoorDirections;
-(void) stuckDirections;
-(void) removeStuckDirections;
-(void) stuckDirections2;
-(void) removeStuckDirections2;
-(void) collectSnowDirections;
-(void) removeSnowDirections;
-(void) jumpDirections;
-(void) removeJumpDirections;
-(void) jumpPrompt;
-(void) removeJumpPrompt;
-(void) useSnowflakeDirections;
-(void) removeSnowflakeDirections;
-(void) useSnowflake2Directions;
-(void) removeSnowflake2Directions;
-(void) teleportDirections;
-(void) removeTeleportDirections;
-(void) teleportDirections2;
-(void) removeTeleportDirections2;
-(void) collectFruitDirections;
-(void) removeFruitDirections;
-(void) tutorialFinishedDirections;
-(void) removeTutorialFinishedDirections;
-(void) speedUpWarning;

@end
