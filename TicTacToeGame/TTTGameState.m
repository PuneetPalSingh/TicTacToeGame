//
//  TTTGameState.m
//  TicTacToeGame
//
//  Created by Puneet Pal Singh on 5/12/16.
//  Copyright © 2016 Puneet Pal Singh. All rights reserved.
//

#import "TTTGameState.h"



@interface TTTGameState ()
@property (strong,nonatomic) NSMutableArray *boardTwoDimensionalArray;
@end

@implementation TTTGameState

///--------------------------------------
#pragma mark - Instance Methods
///--------------------------------------

-(instancetype)initWithNnumberOfPlayers:(NSInteger)numerOfPlayers numberOfCellsInRow:(NSInteger)numberOfCellsInRow{
    
    if (self = [super init]) {
        
        _currentGameState = TTTGameStatePlayerTurnFirst;
        _currentGameResult = TTTGameResultNoResult;
        _numberOfPlayers = numerOfPlayers;
        _boardTwoDimensionalArray = [[NSMutableArray alloc]init];
        _firstPlayerScoreCount = 0;
        _secondPlayerScoreCount = 0;
        _matchDrawCount = 0;
        _numberOfCellsInRow = numberOfCellsInRow;
        
        NSMutableArray *rowArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0 ; i < self.numberOfCellsInRow ; i++) {
            [rowArray addObject:@(0)];
        }
        for (NSInteger i = 0 ; i < self.numberOfCellsInRow ; i++) {
            [self.boardTwoDimensionalArray addObject:[rowArray mutableCopy]];
        }
    }
    return self;
}

///--------------------------------------
#pragma mark - Public Methods
///--------------------------------------

-(NSString *)playerTurnWithGameState:(TTTGameStatePlayerTurn)astate rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex {
    
    if (astate == TTTGameStatePlayerTurnFirst) {
        [[self.boardTwoDimensionalArray objectAtIndex:rowIndex] replaceObjectAtIndex:columnIndex withObject:@"X"];
        
        if (self.numberOfPlayers == 1) {
            self.currentGameState = TTTGameStatePlayerTurnComputer;
        }
        else {
            self.currentGameState = TTTGameStatePlayerTurnSecond;
        }
        return @"X";
    }
    else if (astate == TTTGameStatePlayerTurnSecond) {
        self.currentGameState = TTTGameStatePlayerTurnFirst;
        [[self.boardTwoDimensionalArray objectAtIndex:rowIndex] replaceObjectAtIndex:columnIndex withObject:@"O"];
        
        return @"O";
    }
    else if (astate == TTTGameStatePlayerTurnComputer) {
        self.currentGameState = TTTGameStatePlayerTurnFirst;
        [[self.boardTwoDimensionalArray objectAtIndex:rowIndex] replaceObjectAtIndex:columnIndex withObject:@"O"];
        
        return @"O";
    }
    return nil;
}

-(void)resetGameStateWithNumberOfPlayers:(NSInteger)numberOfPlayers newUser:(BOOL)newUser {
    [self.boardTwoDimensionalArray removeAllObjects];
    
    NSMutableArray *rowArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0 ; i < self.numberOfCellsInRow ; i++) {
        [rowArray addObject:@(0)];
    }
    for (NSInteger i = 0 ; i < self.numberOfCellsInRow ; i++) {
        [self.boardTwoDimensionalArray addObject:[rowArray mutableCopy]];
    }
    if (newUser) {
        self.firstPlayerScoreCount = 0;
        self.secondPlayerScoreCount = 0;
        self.matchDrawCount = 0;
        [self setNumberOfPlayers:numberOfPlayers];
    }
    
    [self setCurrentGameResult:TTTGameResultNoResult];
    [self setCurrentGameState:TTTGameStatePlayerTurnFirst];
}

///--------------------------------------
#pragma mark - Private Methods
///--------------------------------------

-(TTTGameResult)rowWin {
    NSInteger cellXCount = 0;
    NSInteger cellOCount = 0;
    NSInteger row;
    NSInteger column;
    // Row Game Win
    for (row = 0 ; row < self.numberOfCellsInRow ; row++) {
        for (column = 0 ; column < self.numberOfCellsInRow ; column++) {
            if (![[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isKindOfClass:[NSString class]]) {
                break;
            }
            if ([[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isEqualToString:@"X"]) {
                cellXCount++;
            }
            else if ([[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isEqualToString:@"O"]) {
                cellOCount++;
            }
        }
        if (cellXCount == self.numberOfCellsInRow) {
            return TTTGameResultFirstPlayerWin;
            break;
        }
        else if(cellOCount == self.numberOfCellsInRow){
            if (self.numberOfPlayers == 1) {
                return TTTGameResultComputerWin;
            }
            return TTTGameResultSecondPlayerWin;
            break;
        }
        //Reset X and O counts
        cellXCount = 0;
        cellOCount = 0;
    }
    return TTTGameResultNoResult;
}

-(TTTGameResult)columnWin {
    NSInteger cellXCount = 0;
    NSInteger cellOCount = 0;
    NSInteger row;
    NSInteger column;
    //Column Game Win
    for (column = 0 ; column < self.numberOfCellsInRow ; column++) {
        for (row = 0 ; row < self.numberOfCellsInRow ; row++) {
            if (![[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isKindOfClass:[NSString class]]) {
                break;
            }
            if ([[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isEqualToString:@"X"]) {
                cellXCount++;
            }
            else if ([[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isEqualToString:@"O"]) {
                cellOCount++;
            }
        }
        if (cellXCount == self.numberOfCellsInRow) {
            return TTTGameResultFirstPlayerWin;
            break;
        }
        else if(cellOCount == self.numberOfCellsInRow) {
            if (self.numberOfPlayers == 1) {
                return TTTGameResultComputerWin;
            }
            return TTTGameResultSecondPlayerWin;
            break;
        }
        //Reset X and O counts
        cellXCount = 0;
        cellOCount = 0;
    }
    return TTTGameResultNoResult;
    
}

-(TTTGameResult)diagonalWin {
    
    NSInteger cellXCount = 0;
    NSInteger cellOCount = 0;
    NSInteger row;
    NSInteger column = 0;
    // Left diagonals win
    for (row = 0 ; row < self.numberOfCellsInRow ; row++) {
        if (![[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isKindOfClass:[NSString class]]) {
            break;
        }
        if ([[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isEqualToString:@"X"]) {
            cellXCount++;
        }
        else if ([[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isEqualToString:@"O"]) {
            cellOCount++;
        }
        column++;
    }
    if (cellXCount == self.numberOfCellsInRow) {
        return TTTGameResultFirstPlayerWin;
    }
    else if(cellOCount == self.numberOfCellsInRow) {
        if (self.numberOfPlayers == 1) {
            return TTTGameResultComputerWin;
        }
        return TTTGameResultSecondPlayerWin;
    }
    //Reset X and O counts
    cellXCount = 0;
    cellOCount = 0;
    
    //Reset row and column for next diagonal
    row = 0;
    column = self.numberOfCellsInRow - 1;
    for (column = self.numberOfCellsInRow - 1 ; column >= 0 ; column--) {
        if (![[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isKindOfClass:[NSString class]]) {
            break;
        }
        if ([[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isEqualToString:@"X"]) {
            cellXCount++;
        }
        else if ([[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isEqualToString:@"O"]){
            cellOCount++;
        }
        row++;
    }
    if (cellXCount == self.numberOfCellsInRow) {
        return TTTGameResultFirstPlayerWin;
    }
    else if(cellOCount == self.numberOfCellsInRow) {
        if (self.numberOfPlayers) {
            return TTTGameResultComputerWin;
        }
        return TTTGameResultSecondPlayerWin;
    }
    return TTTGameResultNoResult;
}


///--------------------------------------
#pragma mark - Collection View Controller Delegate Methods
///--------------------------------------


-(void)checkGameResult{
    BOOL emptyCells = NO;
    for (NSInteger column = 0 ; column < self.numberOfCellsInRow ; column++) {
        for (NSInteger row = 0 ; row < self.numberOfCellsInRow ; row++) {
            if (![[[self.boardTwoDimensionalArray objectAtIndex:row] objectAtIndex:column] isKindOfClass:[NSString class]]) {
                emptyCells = YES;
            }
        }
    }
    
    TTTGameResult rowGameResult = [self rowWin];
    if (rowGameResult == TTTGameResultFirstPlayerWin || rowGameResult == TTTGameResultSecondPlayerWin || rowGameResult == TTTGameResultComputerWin) {
        self.currentGameResult = rowGameResult;
        [self.delegate showGameResultWithGameResult:rowGameResult];
    }
    else {
        TTTGameResult columnGameResult = [self columnWin];
        if (columnGameResult == TTTGameResultFirstPlayerWin || columnGameResult == TTTGameResultSecondPlayerWin || columnGameResult == TTTGameResultComputerWin) {
            self.currentGameResult = columnGameResult;
            [self.delegate showGameResultWithGameResult:columnGameResult];
        }
        else{
            TTTGameResult diagonalGameResult = [self diagonalWin];
            if (diagonalGameResult == TTTGameResultFirstPlayerWin || diagonalGameResult == TTTGameResultSecondPlayerWin  || diagonalGameResult == TTTGameResultComputerWin ) {
                self.currentGameResult = diagonalGameResult;
                [self.delegate showGameResultWithGameResult:diagonalGameResult];
            }
            else{
                if (emptyCells == NO) {
                    [self.delegate showGameResultWithGameResult:TTTGameResultDraw];
                }
            }
        }
    }
}

@end
