//
//  TTTCollectionViewController.h
//  TicTacToeGame
//
//  Created by Puneet Pal Singh on 5/12/16.
//  Copyright © 2016 Puneet Pal Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTGameState.h"

@protocol TTTCollectionViewDelegate <NSObject>

-(void)checkGameResult;
-(NSString *)playerTurnWithGameState:(TTTGameStatePlayerTurn)astate rowIndex:(NSInteger)rowIndex columnIndex:(NSInteger)columnIndex lastSelectedIndex:(NSInteger)lastSelectedIndex;
@end

@interface TTTCollectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *ticTacToeCollectionView;
@property (weak, nonatomic) IBOutlet UITextView *boardTypeTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *playersSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *firstPlayerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchDrawLabel;

@property (weak,nonatomic) id <TTTCollectionViewDelegate> delegate;

- (IBAction)playersSegmentedControlButtonPressed:(id)sender;
@end

