//
//  Maze.m
//  PandaMaze
//
//  Created by Erika Dains on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Maze.h"
#import "Fruit.h"
#import "GameState.h"

static int SCREEN_WIDTH = 320;
static const int MAZE_HEIGHT = 1000;
static const int CELL_WIDTH = 80;
static const float CELL_HEIGHT = 75;
static const int GRID_ROWS = MAZE_HEIGHT/CELL_HEIGHT;
static int GRID_COLUMNS = 4;//SCREEN_WIDTH/CELL_WIDTH;


/*
0 - Empty block
1 - floor block
2 - wallNoFloor block
3 - wallWithFloor block
4 - trapdoor block
5 - topOfChuteLeft block
6 - bottomOfChuteLeft block
7 - bottomOfChuteRight block
8 - topOfChuteRight block
*/

@implementation Maze
{
    NSMutableArray *_mazeArray;
}

-(void) didLoadFromCCB
{
    //Adjusting for different screen sizes - iphone, ipad, androids, etc.
    SCREEN_WIDTH = [GameState sharedInstance].screenSize;
    if (SCREEN_WIDTH % CELL_WIDTH != 0)
    {
        GRID_COLUMNS = (SCREEN_WIDTH/CELL_WIDTH) + 1;
    }else{
        GRID_COLUMNS = SCREEN_WIDTH/CELL_WIDTH;
    }
    
    self.contentSize = CGSizeMake(SCREEN_WIDTH, MAZE_HEIGHT);
//    CCLOG(@"screen width %i", SCREEN_WIDTH);
    
    [self generateMazeLayout];
    [self generateMazeForDisplay];
}

-(void) generateMazeLayout
{
    _mazeArray = [NSMutableArray array];
    
    for (int i=0; i<GRID_ROWS; i++)
    {
        _mazeArray[i] = [NSMutableArray array];
        for (int j=0; j<GRID_COLUMNS; j++)
        {
            int cellType;
            
            if (j==0)
            {
                if (i==0){
                    cellType = [self generateCellWithCellAbove: -1  AndCellLeft: -1];
                }else{
                    cellType=[self generateCellWithCellAbove: [(NSNumber*)_mazeArray[i-1][j] intValue]  AndCellLeft: -1];
                }
            }else if (j==GRID_COLUMNS-1){
                if (i==0)
                {
                    cellType = [self generateCellWithCellAbove: -1  AndCellLeft: -2];
                }else{
                    cellType=[self generateCellWithCellAbove: [(NSNumber*)_mazeArray[i-1][j] intValue]  AndCellLeft: -2];
                }
            }else{
                if (i==0)
                {
                    cellType = [self generateCellWithCellAbove: -1 AndCellLeft: [(NSNumber*)_mazeArray[i][j-1] intValue]];
                }else{
                    cellType = [self generateCellWithCellAbove: [(NSNumber*)_mazeArray[i-1][j] intValue]
                                                   AndCellLeft: [(NSNumber*)_mazeArray[i][j-1] intValue]];
                }
            }
            if (cellType != 200)
            {
                [_mazeArray[i] addObject:@(cellType)];
            }else{
                j = j-2;
                if (j<0)
                {
                    j = -1;
                }
            }
        }
        if ([self checkRow:i] == NO)
        {
            i--;
        }
    }//closes the double for loop
}

-(int) generateCellWithCellAbove: (int) above AndCellLeft: (int) left
{
    int acceptedCellType;
    NSMutableSet *_possVal1;
    NSMutableSet *_possVal2;
    NSMutableSet *_valsInCommon;
    
    //Finding the proper possible values based on what type of cell the one above target is.
    switch (above) {
        case -1:
            //for no row above
            _possVal1 = [NSMutableSet setWithObjects:@0, @1, nil];
            break;
        case 0:
            _possVal1 = [NSMutableSet setWithObjects:@1, @4, @5, @6, @7, @8, nil];
            break;
        case 1:
            _possVal1 = [NSMutableSet setWithObjects:@0, @1, @2, @3, @4, @5, @8, nil];
            break;
        case 2:
            _possVal1 = [NSMutableSet setWithObjects:/*@0, */@1, @2, @3, @4, nil];
            break;
        case 3:
            _possVal1 = [NSMutableSet setWithObjects:@0, @1, @2, @3, @4, @5, @8, nil];
            break;
        case 4:
            _possVal1 = [NSMutableSet setWithObjects:@1,/* @4,*/ @6, @7, @8, nil];//@0, @1, nil];
            break;
        case 5:
            _possVal1 = [NSMutableSet setWithObjects:@0, @1, @4, @6, @7, nil];
            break;
        case 6:
            _possVal1 = [NSMutableSet setWithObjects:@0, @1, @2, @3, @4, @8, nil];
            break;
        case 7:
            _possVal1 = [NSMutableSet setWithObjects:@0, @1, @2, @3, @4, @5, nil];
            break;
        case 8:
            _possVal1 = [NSMutableSet setWithObjects:@0, @1, @4, @6, @7, nil];
            break;
        default:
            NSLog(@"Error with above value: %i", above);
            break;
    }
    
    //Finding the proper possible values based on what type of cell the one to the left of the target is.
    switch (left) {
        case -2:
            //for last column in row
            _possVal2 = [NSMutableSet setWithObjects:@0, @1, @3, @4, @6, nil];//@1, @3, @6, nil];
            break;
        case -1:
            //for first column in row
            _possVal2 = [NSMutableSet setWithObjects:@0, @1, @3, @4, @7, nil];//@1, @3, @7, nil];
            break;
        case 0:
            _possVal2 = [NSMutableSet setWithObjects:@0, @1, @3, @6, @7, nil];//@1, @2, @3, @4, @5, @6, @7, @8, nil];
            break;
        case 1:
            _possVal2 = [NSMutableSet setWithObjects:@0, @1, @3, @4, @5, @7, nil];
            break;
        case 2:
            _possVal2 = [NSMutableSet setWithObjects:/*@0, */@1, @4, nil];
            break;
        case 3:
            _possVal2 = [NSMutableSet setWithObjects:@0, @1, @4, @5, @7, nil];
            break;
        case 4:
            _possVal2 = [NSMutableSet setWithObjects:@1, @2, @3, @5, @6, @7, nil];//@1, @3, @5, @7, nil];
            break;
        case 5:
            _possVal2 = [NSMutableSet setWithObjects:@4, @6, nil];//@0, @4, @6, nil];
            break;
        case 6:
            _possVal2 = [NSMutableSet setWithObjects:@1, @3, @4, @5, nil];//@0, @1, @3, @4, @5, @7, nil];
            break;
        case 7:
            _possVal2 = [NSMutableSet setWithObjects:/*@0, added: @1,/ */@4, @8, nil];
            break;
        case 8:
            _possVal2 = [NSMutableSet setWithObjects:@1, @4, @7, nil];//@0, @1, @3, @4, @5, @7, nil];
            break;
        default:
            NSLog(@"Error with left value: %i", left);
            break;
    }
    
    _valsInCommon = [NSMutableSet setWithSet:_possVal1];
    [_valsInCommon intersectSet:_possVal2];
    
    int sizeOfArray = (int)[_valsInCommon count];
    if (sizeOfArray > 0)
    {
        NSArray *_commonArray = [_valsInCommon allObjects];
        int randomNum = arc4random()%sizeOfArray;
        acceptedCellType = [(NSNumber*)_commonArray[randomNum] intValue];
    }else{
        CCLOG(@"no common values between cell above: %i and cell left: %i", above, left);
        acceptedCellType = 200;
    }
    
    return acceptedCellType;
}

-(BOOL) checkRow: (int) rowNumber
{
    BOOL _ok = YES;
    int emptySpacesCount=0;
    
    for (int i=0; i<GRID_COLUMNS; i++)
    {
        if ([(NSNumber*)_mazeArray[rowNumber][i] intValue] == 0 ||[(NSNumber*)_mazeArray[rowNumber][i] intValue] == 4)
        {
            emptySpacesCount++;
        }
    }
    
    if (emptySpacesCount< 1 || emptySpacesCount>2)//CHANGE THIS BASED ON HOW MANY columns THERE ARE?
    {
        _ok = NO;
    }
    
    return _ok;
}

-(void) generateMazeForDisplay
{
    float x = 0;
    float y = CELL_HEIGHT * GRID_ROWS;
    MazeBlocks *_currentBlock;
    int randomPowerUpRow = 1 + arc4random() % (3 - 1);
    int randomFruitRow = 2 + arc4random() % (3 - 2);
    
    for (int i = 0; i<GRID_ROWS; i++)
    {
        x = 0;
        NSMutableSet *_possPos = [NSMutableSet set];
        for (int j = 0; j<GRID_COLUMNS; j++)
        {
            int blockType = [(NSNumber*)_mazeArray[i][j] intValue];
            
            switch (blockType) {
                case 0:
                    _currentBlock = (Empty*)[CCBReader load:@"Maze/Empty"];
                        [_possPos addObject:[NSNumber numberWithInt:j]];
                    break;
                case 1:
                    _currentBlock = (MazeBlocks*)[CCBReader load:@"Maze/Floor"];
                        [_possPos addObject:[NSNumber numberWithInt:j]];
                    break;
                case 2:
                    _currentBlock = (MazeBlocks*)[CCBReader load:@"Maze/WallWithFloor"];
                    //_currentBlock = (MazeBlocks*)[CCBReader load:@"Maze/Wall"];
                    break;
                case 3:
                    _currentBlock = (MazeBlocks*)[CCBReader load:@"Maze/WallWithFloor"];
                    break;
                case 4:
                    _currentBlock = (Trapdoor*)[CCBReader load: @"Maze/Trapdoor"];
                        [_possPos addObject:[NSNumber numberWithInt:j]];
                    break;
                case 5:
                    _currentBlock = (MazeBlocks*)[CCBReader load: @"Maze/TopOfChuteLeft"];
                    break;
                case 6:
                    _currentBlock = (MazeBlocks*)[CCBReader load:@"Maze/BottomOfChuteLeft"];
                    break;
                case 7:
                    _currentBlock = (MazeBlocks*)[CCBReader load:@"Maze/BottomOfChuteRight"];
                    break;
                case 8:
                    _currentBlock = (MazeBlocks*)[CCBReader load:@"Maze/TopOfChuteRight"];
                    break;
                default:
                    NSLog(@"Error loading CCB Files");
                    break;
            }
            _currentBlock.position = ccp(x, y);
            [self addChild:_currentBlock];
            x+=CELL_WIDTH;
        }
        if (i == randomPowerUpRow)
        {
            int sizeOfArray = (int)[_possPos count];
            if(sizeOfArray > 0)
            {
                int randomPos = arc4random()%sizeOfArray;
                NSArray *_possPosArray = [_possPos allObjects];
                float _selectedPos =[(NSNumber*)_possPosArray[randomPos] floatValue];
                int xPos = _selectedPos * CELL_WIDTH;
                [_possPos removeObject:[NSNumber numberWithFloat:_selectedPos]];
                
                PowerUpCollectables *_currentPowerUp = (PowerUpCollectables*)[PowerUpCollectables randomPowerUps];
                _currentPowerUp.position = ccp(xPos+(CELL_WIDTH/2), y+35);
                _currentPowerUp.physicsBody.sensor = YES;
                [self addChild:_currentPowerUp];
            }
            randomPowerUpRow = i + (6 + arc4random() % (10 - 6));
        }else if (randomPowerUpRow < i){
            randomPowerUpRow = i + (6 + arc4random() % (10 - 6));
        }
        int setSize = (int) [_possPos count];
        
        if (i == randomFruitRow && setSize > 0)
        {
            int sizeOfArray = (int)[_possPos count];
            if (sizeOfArray > 0)
            {
                int randomPos = arc4random()%sizeOfArray;
                NSArray *_possPosArray = [_possPos allObjects];
                int xPos = [(NSNumber*)_possPosArray[randomPos] intValue] * CELL_WIDTH;
                
                Fruit *_currentFruit = (Fruit*)[Fruit randomFruit];
                _currentFruit.position = ccp(xPos+(CELL_WIDTH/2), y+35);
                _currentFruit.physicsBody.sensor = YES;
                [self addChild:_currentFruit];
            }
            randomFruitRow = i + (1 + arc4random() % (2 - 1));
        }else if (randomFruitRow < i){
            randomFruitRow = i + (1 + arc4random() % (2 - 1));
        }
        y-=CELL_HEIGHT;
    }
}

-(MazeBlocks*) getBlock: (CGPoint) touchPosition
{
    MazeBlocks *_touchedBlock;
    NSArray *allBlocks = [self children];
    
    //TODO: remove blocks of type empty from array
    
    for (CCNode *eachBlock in allBlocks) {
        if ([eachBlock isKindOfClass:MazeBlocks.class] && CGRectContainsPoint([eachBlock boundingBox], touchPosition))
        {
            if (![eachBlock isKindOfClass:Empty.class])
            {
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

#pragma mark - tutorial class methods
-(void) tiltDirections{}
-(void) removeTiltDirections{}
-(void) powerCollectionDirections{}
-(void) removePowerCollectDirections{}
-(void) trapdoorDirections{}
-(void) removeTrapdoorDirections{}
-(void) stuckDirections{}
-(void) removeStuckDirections{}
-(void) stuckDirections2{}
-(void) removeStuckDirections2{}
-(void) collectSnowDirections{}
-(void) removeSnowDirections{}
-(void) jumpDirections{}
-(void) removeJumpDirections{}
-(void) jumpPrompt{}
-(void) removeJumpPrompt{}
-(void) useSnowflakeDirections{}
-(void) removeSnowflakeDirections{}
-(void) useSnowflake2Directions{}
-(void) removeSnowflake2Directions{}
-(void) teleportDirections{}
-(void) removeTeleportDirections{}
-(void) teleportDirections2{}
-(void) removeTeleportDirections2{}
-(void) collectFruitDirections{}
-(void) removeFruitDirections{}
-(void) tutorialFinishedDirections{}
-(void) removeTutorialFinishedDirections{}
-(void) speedUpWarning{}

@end
