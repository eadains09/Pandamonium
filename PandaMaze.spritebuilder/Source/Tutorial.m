//
//  Tutorial.m
//  PandaMaze
//
//  Created by Erika Dains on 7/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tutorial.h"
#import "GameState.h"


@implementation Tutorial
{
    CCNode *_tiltDirectionsNode;
    BOOL _tiltDirectionsRemoved;
    CCNode *_collectPowerDirectionsNode;
    BOOL _collectPowerDirectionsRemoved;
    CCNode *_trapdoorDirectionsNode;
    BOOL _trapdoorDirectionsRemoved;
    CCNode *_stuckDirectionsNode;
    CCNode *_stuckDirections2Node;
    BOOL _stuckDirectionsRemoved;
    CCNode *_collectSnowDirectionsNode;
    BOOL _collectSnowDirectionsRemoved;
    CCNode *_jumpDirectionsNode;
    BOOL _jumpDirectionsRemoved;
    CCNode *_jumpPromptNode;
    BOOL _jumpPromptRemoved;
    CCNode *_useSnowflakeDirectionsNode;
    BOOL _snowflakeDirectionsRemoved;
    CCNode *_useSnowflake2Node;
    CCNode *_teleportDirectionsNode;
    CCNode *_teleportDirections2Node;
    BOOL _teleportDirectionsRemoved;
    CCNode *_collectFruitDirectionsNode;
    BOOL _collectFruitDirectionsRemoved;
    CCNode *_tutorialFinishedNode;
    BOOL _tutorialFinishedRemoved;
    CCNode *_speedUpWarningNode;
    BOOL _speedUpWarningRemoved;
    
    CCNode *_mazeBlocksNode;
}

-(void) didLoadFromCCB
{
    _tiltDirectionsRemoved = YES;
    _collectPowerDirectionsRemoved = YES;
    _trapdoorDirectionsRemoved = YES;
    _stuckDirectionsRemoved = YES;
    _collectSnowDirectionsRemoved = YES;
    _jumpDirectionsRemoved = YES;
    _jumpPromptRemoved = YES;
    _snowflakeDirectionsRemoved = YES;
    _teleportDirectionsRemoved = YES;
    _collectFruitDirectionsRemoved = YES;
    _tutorialFinishedRemoved = YES;
    _speedUpWarningRemoved = YES;
}

-(MazeBlocks*) getBlock: (CGPoint) touchPosition
{
    MazeBlocks *_touchedBlock;
    NSArray *allBlocks = [_mazeBlocksNode children];
    
    //TODO: remove blocks of type empty from array
    
    for (CCNode *eachBlock in allBlocks) {
        if ([eachBlock isKindOfClass:MazeBlocks.class] && CGRectContainsPoint([eachBlock boundingBox], touchPosition))
        {
            if (![eachBlock isKindOfClass:Empty.class]){
                if (![eachBlock isKindOfClass:Trapdoor.class])
                {
                    _touchedBlock = (MazeBlocks*)eachBlock;
                    break;
                }
            }
        }else{
        }
        
    }
    
    return _touchedBlock;
}

#pragma mark - Tutorial Directions Screens

-(void) tiltDirections
{
    if (_tiltDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/TiltDirections"];
        [_tiltDirectionsNode addChild:directions];
        _tiltDirectionsRemoved = NO;
    }
}

-(void) removeTiltDirections
{
    if (!_tiltDirectionsRemoved)
    {
        if (_tiltDirectionsNode)
        {
        [_tiltDirectionsNode removeAllChildren];
            [_mazeBlocksNode removeChild:_tiltDirectionsNode cleanup:YES];
            _tiltDirectionsNode = nil;
        
        }
        _tiltDirectionsRemoved = YES;
    }
}

-(void) powerCollectionDirections
{
    if (_collectPowerDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/CollectPowerDirections"];
        [_collectPowerDirectionsNode addChild:directions];
        _collectPowerDirectionsRemoved = NO;
    }
}

-(void) removePowerCollectDirections
{
    if (!_collectPowerDirectionsRemoved)
    {
        if (_collectPowerDirectionsNode)
        {
            [_mazeBlocksNode removeChild:_collectPowerDirectionsNode cleanup:YES];
            _collectPowerDirectionsNode = nil;
        }
            _collectPowerDirectionsRemoved = YES;
    }
}

-(void) trapdoorDirections
{
    if (_trapdoorDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/TrapdoorDirections"];
        [_trapdoorDirectionsNode addChild:directions];
        _trapdoorDirectionsRemoved = NO;
    }
}

-(void) removeTrapdoorDirections
{
    if (!_trapdoorDirectionsRemoved)
    {
        if (_trapdoorDirectionsNode)
        {
            [_mazeBlocksNode removeChild:_trapdoorDirectionsNode cleanup:YES];
            _trapdoorDirectionsNode = nil;
        }
        _trapdoorDirectionsRemoved = YES;
    }
}

-(void) stuckDirections
{
    if (_stuckDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/StuckDirections"];
        [_stuckDirectionsNode addChild:directions];
        _stuckDirectionsRemoved = NO;
    }
}

-(void) removeStuckDirections
{
    if (!_stuckDirectionsRemoved)
    {
        if (_stuckDirectionsNode)
        {
            [_mazeBlocksNode removeChild:_stuckDirectionsNode cleanup:YES];
            _stuckDirectionsNode = nil;
        }
        _stuckDirectionsRemoved = YES;
    }
}

-(void) stuckDirections2
{
    if (_stuckDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/StuckDirections2"];
        [_stuckDirections2Node addChild:directions];
        _stuckDirectionsRemoved = NO;
    }
}

-(void) removeStuckDirections2
{
    if (!_stuckDirectionsRemoved)
    {
        if (_stuckDirections2Node)
        {
            [_mazeBlocksNode removeChild:_stuckDirections2Node cleanup:YES];
            _stuckDirections2Node = nil;
        }
        _stuckDirectionsRemoved = YES;
    }
}

-(void) collectSnowDirections
{
    if (_collectSnowDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/CollectSnowflakeDirections"];
        [_collectSnowDirectionsNode addChild:directions];
        _collectSnowDirectionsRemoved = NO;
    }
}

-(void) removeSnowDirections
{
    if (!_collectSnowDirectionsRemoved)
    {
        if (_collectSnowDirectionsNode)
        {
            [_mazeBlocksNode removeChild:_collectSnowDirectionsNode cleanup:YES];
            _collectSnowDirectionsNode = nil;
        }
        _collectSnowDirectionsRemoved = YES;
    }
}

-(void) jumpDirections
{
    if (_jumpDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/JumpDirections"];
        [_jumpDirectionsNode addChild:directions];
        _jumpDirectionsRemoved = NO;
    }
}

-(void) removeJumpDirections
{
    if (!_jumpDirectionsRemoved)
    {
        if (_jumpDirectionsNode)
        {
            [_mazeBlocksNode removeChild:_jumpDirectionsNode cleanup:YES];
            _jumpDirectionsNode = nil;
        }
        _jumpDirectionsRemoved = YES;
    }
}

-(void) jumpPrompt
{
    if (_jumpPromptRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/JumpPrompt"];
        [_jumpPromptNode addChild:directions];
        _jumpPromptRemoved = NO;
    }
}

-(void) removeJumpPrompt
{
    if (!_jumpPromptRemoved)
    {
        if (_jumpPromptNode)
        {
            [_mazeBlocksNode removeChild:_jumpPromptNode cleanup:YES];
            _jumpPromptNode = nil;
        }
        _jumpPromptRemoved = YES;
    }
}

-(void) useSnowflakeDirections
{
    if (_snowflakeDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/UseSnowflake"];
        [_useSnowflakeDirectionsNode addChild:directions];
        _snowflakeDirectionsRemoved = NO;
    }
}

-(void) removeSnowflakeDirections
{
    if (!_snowflakeDirectionsRemoved)
    {
        if (_useSnowflakeDirectionsNode)
        {
            [_mazeBlocksNode removeChild:_useSnowflakeDirectionsNode cleanup:YES];
            _useSnowflakeDirectionsNode = nil;
        }
        _snowflakeDirectionsRemoved = YES;
    }
}

-(void) useSnowflake2Directions
{
    if (_snowflakeDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/UseSnowflake2"];
        [_useSnowflake2Node addChild:directions];
        _snowflakeDirectionsRemoved = NO;
    }
}

-(void) removeSnowflake2Directions
{
    if (!_snowflakeDirectionsRemoved)
    {
        if (_useSnowflake2Node)
        {
            [_mazeBlocksNode removeChild:_useSnowflake2Node cleanup:YES];
            _useSnowflake2Node = nil;
        }
        _snowflakeDirectionsRemoved = YES;
    }
}

-(void) teleportDirections
{
    if (_teleportDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/TeleportDirections"];
        [_teleportDirectionsNode addChild:directions];
        _teleportDirectionsRemoved = NO;
    }
}

-(void) removeTeleportDirections
{
    if (!_teleportDirectionsRemoved)
    {
        if (_teleportDirectionsNode)
        {
            [_mazeBlocksNode removeChild:_teleportDirectionsNode cleanup:YES];
            _teleportDirectionsNode = nil;
        }
        _teleportDirectionsRemoved = YES;
    }
}

-(void) teleportDirections2
{
    if (_teleportDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/TeleportDirections2"];
        [_teleportDirections2Node addChild:directions];
        _teleportDirectionsRemoved = NO;
    }
}

-(void) removeTeleportDirections2
{
    if (!_teleportDirectionsRemoved)
    {
        if (_teleportDirections2Node)
        {
            [_mazeBlocksNode removeChild:_teleportDirections2Node cleanup:YES];
            _teleportDirections2Node = nil;
        }
        _teleportDirectionsRemoved = YES;
    }
}

-(void) collectFruitDirections
{
    if (_collectFruitDirectionsRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/CollectFruitDirections"];
        [_collectFruitDirectionsNode addChild:directions];
        _collectFruitDirectionsRemoved = NO;
    }
}

-(void) removeFruitDirections
{
    if (!_collectFruitDirectionsRemoved)
    {
        if (_collectFruitDirectionsNode)
        {
            [_mazeBlocksNode removeChild:_collectFruitDirectionsNode cleanup:YES];
            _collectFruitDirectionsNode = nil;
        }
        _collectFruitDirectionsRemoved = YES;
    }
}

-(void) tutorialFinishedDirections
{
    if (_tutorialFinishedRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/TutorialFinished"];
        [_tutorialFinishedNode addChild:directions];
        [self tutorialFinishedAchievements];
        _tutorialFinishedRemoved = NO;
    }
}

-(void) removeTutorialFinishedDirections
{
    if (!_tutorialFinishedRemoved)
    {
        if (_tutorialFinishedNode)
        {
            [_mazeBlocksNode removeChild:_tutorialFinishedNode cleanup:YES];
            _tutorialFinishedNode = nil;
        }
    }
}

-(void) speedUpWarning
{
    if (_speedUpWarningRemoved)
    {
        CCNode *directions = [CCBReader load:@"MazeTutorial/SpeedUpWarning"];
        [_speedUpWarningNode addChild:directions];
        _speedUpWarningRemoved = NO;
    }
}

-(void) tutorialFinishedAchievements
{
    [GameState sharedInstance].lightning += 2;
    [GameState sharedInstance].snowflake += 2;
    [GameState sharedInstance].teleport += 2;
}
@end
