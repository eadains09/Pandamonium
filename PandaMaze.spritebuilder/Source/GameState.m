//
//  GameState.m
//  PandaMaze
//
//  Created by Erika Dains on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

static NSString* const GAME_STATE_HIGHSCORE = @"GAME_STATE_HIGHSCORE";
static NSString* const GAME_STATE_SNOWFLAKE = @"GAME_STATE_SNOWFLAKE";
static NSString* const GAME_STATE_LIGHTNING = @"GAME_STATE_LIGHTNING";
static NSString* const GAME_STATE_TELEPORT = @"GAME_STATE_TELEPORT";
static NSString* const GAME_STATE_FRUIT = @"GAME_STATE_FRUIT";
static NSString* const GAME_STATE_TUTORIAL_COMP = @"GAME_STATE_TUTORIAL_COMP";


@implementation GameState

+ (instancetype)sharedInstance {
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc]init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

#pragma mark - NSUSERDEFAULTS CONTROL METHODS
-(void) setInteger: (int) item forKey: (NSString*) key
{
    [[NSUserDefaults standardUserDefaults] setInteger:item forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //MGWU encrypted user defaults
//    NSNumber *nsItem = [NSNumber numberWithInt:item];
//    [MGWU setObject:nsItem forKey:@"key"];
    
}

-(id) objectForKey: (NSString*) key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: key];
    
    //MGWU encrypted user defaults
//    return [MGWU objectForKey:@"key"];
}

-(void) setBool: (BOOL) item forKey: (NSString*) key
{
    [[NSUserDefaults standardUserDefaults] setBool:item forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL) boolForKey: (NSString*) key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

#pragma mark - OVERRIDING GETTER AND SETTERS
-(void) setHighscore:(int)highscore
{
    [self setInteger:highscore forKey:GAME_STATE_HIGHSCORE];
}

-(int) highscore
{
    NSNumber *readHighScore = [self objectForKey:GAME_STATE_HIGHSCORE];
    return [readHighScore intValue];
}

-(void) setLightning:(int)lightning
{
    [self setInteger:lightning forKey:GAME_STATE_LIGHTNING];
}

-(int) lightning
{
    NSNumber *readLightning = [self objectForKey:GAME_STATE_LIGHTNING];
    return [readLightning intValue];
}

-(void) setSnowflake:(int)snowflake
{
    [self setInteger:snowflake forKey:GAME_STATE_SNOWFLAKE];
}

-(int) snowflake
{
    NSNumber *readSnowflake = [self objectForKey:GAME_STATE_SNOWFLAKE];
    return [readSnowflake intValue];
}

-(void) setTeleport:(int)teleport
{
    [self setInteger:teleport forKey:GAME_STATE_TELEPORT];
}

-(int) teleport
{
    NSNumber *readTeleport = [self objectForKey:GAME_STATE_TELEPORT];
    return [readTeleport intValue];
}

-(void) setFruit:(int)fruit
{
    [self setInteger:fruit forKey:GAME_STATE_FRUIT];
}

-(int) fruit
{
    NSNumber *readFruit = [self objectForKey:GAME_STATE_FRUIT];
    return [readFruit intValue];
}

-(void) setTutorialCompleted:(BOOL)tutorialCompleted
{
    [self setBool:tutorialCompleted forKey:GAME_STATE_TUTORIAL_COMP];
}

-(BOOL) tutorialCompleted
{
    return [self boolForKey:GAME_STATE_TUTORIAL_COMP];
}

@end
