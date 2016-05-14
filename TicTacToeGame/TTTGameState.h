//
//  TTTGameState.h
//  TicTacToeGame
//
//  Created by Puneet Pal Singh on 5/12/16.
//  Copyright © 2016 Puneet Pal Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTTConstants.h"


typedef NS_ENUM(NSInteger,TTTGameResult){
    TTTGameResultFirstPlayerWin = 0,
    TTTGameResultSecondPlayerWin,
    TTTGameResultDraw,
    TTTGameResultComputerWin,
    TTTGameResultNoResult,
};

typedef NS_ENUM(NSInteger, TTTGameStatePlayerTurn){
    TTTGameStatePlayerTurnFirst = 0,
    TTTGameStatePlayerTurnSecond,
    TTTGameStatePlayerTurnComputer,
};

@protocol TTTGameStateDelegate <NSObject>

-(void)showGameResultWithGameResult:(TTTGameResult)gameResult;
@end

@interface TTTGameState : NSObject
@property (assign,nonatomic) TTTGameStatePlayerTurn currentGameState;
@property (assign,nonatomic) TTTGameResult currentGameResult;
@property (assign,nonatomic) NSInteger numberOfPlayers;
@property (assign,nonatomic) NSInteger firstPlayerScoreCount;
@property (assign,nonatomic) NSInteger secondPlayerScoreCount;
@property (assign,nonatomic) NSInteger matchDrawCount;
@property (assign,nonatomic) NSInteger numberOfCellsInRow;

@property (weak,nonatomic) id <TTTGameStateDelegate> delegate;

-(instancetype)initWithNnumberOfPlayers:(NSInteger)numerOfPlayers numberOfCellsInRow:(NSInteger)numberOfCellsInRow;
-(NSString *)playerTurnWithGameState:(TTTGameStatePlayerTurn)astate rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex;
-(void)resetGameStateWithNumberOfPlayers:(NSInteger)numberOfPlayers newUser:(BOOL)newUser;
@end

