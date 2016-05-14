//
//  TTTCollectionViewCell.h
//  TicTacToeGame
//
//  Created by Puneet Pal Singh on 5/12/16.
//  Copyright © 2016 Puneet Pal Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ZeroOrCrossImageView;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger column;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic,getter=isSelected) BOOL cellSelected;

@end
