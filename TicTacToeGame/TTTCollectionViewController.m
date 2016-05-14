//
//  ViewController.m
//  TicTacToeGame
//
//  Created by Puneet Pal Singh on 5/12/16.
//  Copyright © 2016 Puneet Pal Singh. All rights reserved.
//

#define CELLACTUALWIDTH 50
#define CELLACTUALHEIGHT 50
#define CELL_NEW_WIDTH(width,numberOfCellsInRow) ((width / numberOfCellsInRow) - 15)
#define CELL_NEW_HEIGHT(width,numberOfCellsInRow) ((width / numberOfCellsInRow) -15)

#import "TTTCollectionViewController.h"
#import "TTTCollectionViewCell.h"
#import "TTTGameState.h"

static NSString* const cellIdentifier = @"ZeroOrCrossCell";

@interface TTTCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,TTTGameStateDelegate>

@property (strong,nonatomic) NSArray *boardTypesArray;
@property (strong,nonatomic) NSArray *cellsInRowArray;
@property (strong,nonatomic) TTTGameState *gameState;

@end

@implementation TTTCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ticTacToeCollectionView.delegate = self;
    self.ticTacToeCollectionView.dataSource = self;
    self.boardTypesArray = [NSArray arrayWithObjects:@"Board : 3X3",@"Board : 4X4",@"Board : 5X5",@"Board : 6X6",@"Board : 7X7",@"Board : 8X8", nil];
    self.cellsInRowArray = [NSArray arrayWithObjects:@(3), @(4), @(5), @(6), @(7), @(8), nil];
    
    // Create PickerView For Board Selection
    UIPickerView *boardPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 200)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
    doneBarButtonItem.tintColor = [UIColor whiteColor];
    toolBar.items = @[doneBarButtonItem];
    boardPickerView.delegate = self;
    boardPickerView.dataSource = self;
    self.boardTypeTextView.inputView = boardPickerView;
    self.boardTypeTextView.inputAccessoryView = toolBar;
    self.boardTypeTextView.tintColor = [UIColor clearColor];
    
    //Initialize gameState with number of players and cells in row
    self.gameState = [[TTTGameState alloc]initWithNnumberOfPlayers:1 numberOfCellsInRow:3];
    
    // Delegates
    self.gameState.delegate = self;
    self.delegate = (id)self.gameState;
    
    // Register Cell With reused identifier
    [self.ticTacToeCollectionView registerNib:[UINib nibWithNibName:@"TTTCollectionViewCell" bundle:nil]   forCellWithReuseIdentifier:cellIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///--------------------------------------
#pragma mark - UIPickerView Delegate
///--------------------------------------

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.boardTypeTextView.text = [self.boardTypesArray objectAtIndex:row];
    self.gameState.numberOfCellsInRow = [[self.cellsInRowArray objectAtIndex:row] integerValue];
}

///--------------------------------------
#pragma mark - UIPickerView DataSource
///--------------------------------------

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.boardTypesArray count];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 20.0f;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.boardTypesArray objectAtIndex:row];
}

///--------------------------------------
#pragma mark - UIcollectionView DataSource
///--------------------------------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return pow(self.gameState.numberOfCellsInRow,2);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSInteger row = 0;
    static NSInteger column = 0;
    
    TTTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.cellSelected = NO;
    [cell.ZeroOrCrossImageView setImage:[UIImage imageNamed:@"NotSelectedImage"]];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.indexPath = indexPath;
    
    //Set row and column for each cell
    if (column >  self.gameState.numberOfCellsInRow - 1) {
        row++;
        column = 0;
    }
    cell.row = row;
    cell.column = column++;
    if (row >=  self.gameState.numberOfCellsInRow -1 && column >  self.gameState.numberOfCellsInRow -1) {
        row = 0;
        column = 0;
    }
    
    return cell;
}

///--------------------------------------
#pragma mark - UIcollectionView Delegate
///--------------------------------------

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TTTCollectionViewCell *selectedCell = (TTTCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (![selectedCell isSelected]) {
        if (self.gameState.currentGameState == TTTGameStatePlayerTurnFirst){
            [selectedCell.ZeroOrCrossImageView setImage:[UIImage imageNamed:@"CrossImage"]];
        }
        else if (self.gameState.currentGameState == TTTGameStatePlayerTurnSecond || self.gameState.currentGameState == TTTGameStatePlayerTurnComputer){
            [selectedCell.ZeroOrCrossImageView setImage:[UIImage imageNamed:@"ZeroImage"]];
        }
        
        [self.gameState playerTurnWithGameState:self.gameState.currentGameState rowIndex:selectedCell.row columnIndex:selectedCell.column];
        [self.delegate checkGameResult];
        
        if (self.playersSegmentedControl.selectedSegmentIndex == 0) {
            if (self.gameState.currentGameResult != TTTGameResultFirstPlayerWin && self.gameState.currentGameResult != TTTGameResultSecondPlayerWin && self.gameState.currentGameResult != TTTGameResultComputerWin) {
                [self computerTurnWithLastUserSelectedIndex:indexPath.row];
            }
        }
        [selectedCell setCellSelected:YES];
    }
}

///--------------------------------------
#pragma mark - UIcollectionView ViewLayout
///--------------------------------------

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = self.ticTacToeCollectionView.frame.size.width;
    return CGSizeMake(CELL_NEW_WIDTH(width, self.gameState.numberOfCellsInRow), CELL_NEW_HEIGHT(width, self.gameState.numberOfCellsInRow));
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.ticTacToeCollectionView performBatchUpdates:nil completion:nil];
}

///--------------------------------------
#pragma mark - Private Methods
///--------------------------------------


-(void)doneButtonPressed:(id)sender{
    [self resetGameWithNewUser:NO];
    [self.boardTypeTextView resignFirstResponder];
}

-(void)resetGameWithNewUser:(BOOL)newUser{
    if (self.playersSegmentedControl.selectedSegmentIndex == 0) {
        [self.gameState resetGameStateWithNumberOfPlayers:1 newUser:newUser];
        if (newUser) {
            self.secondPlayerScoreLabel.text = @"Computer Score: 0";
        }
        else{
            self.secondPlayerScoreLabel.text = [NSString stringWithFormat:@"Computer Score: %ld",(long)self.gameState.secondPlayerScoreCount];
        }
    }
    else{
        [self.gameState resetGameStateWithNumberOfPlayers:2 newUser:newUser];
        if (newUser) {
            self.secondPlayerScoreLabel.text = @"Player 2 Score: 0";
        }
        else{
            self.secondPlayerScoreLabel.text = [NSString stringWithFormat:@"Player 2 Score: %ld",(long)self.gameState.secondPlayerScoreCount];
        }
    }
    
    if (newUser) {
        self.firstPlayerScoreLabel.text = @"Player 1 Score: 0";
        self.matchDrawLabel.text = @"Match Draw: 0";
    }
    else{
        self.firstPlayerScoreLabel.text = [NSString stringWithFormat:@"Player 1 Score: %ld",(long)self.gameState.firstPlayerScoreCount];
        self.matchDrawLabel.text = [NSString stringWithFormat:@"Match Draw: %ld",(long)self.gameState.matchDrawCount];
    }
    [self.ticTacToeCollectionView reloadData];
}

///--------------------------------------
#pragma mark - Public Methods
///--------------------------------------

- (IBAction)playersSegmentedControlButtonPressed:(id)sender {
    if ([sender selectedSegmentIndex] == 0) {
        [self.playersSegmentedControl setSelectedSegmentIndex:0];
    }
    else{
        [self.playersSegmentedControl setSelectedSegmentIndex:1];
    }
    [self resetGameWithNewUser:YES];
}

///--------------------------------------
#pragma mark - Game Result Delegate Methods
///--------------------------------------

-(void)showGameResultWithGameResult:(TTTGameResult)playerWon{
    UIAlertController * playerWonAlertView;
    if (!(playerWon == TTTGameResultNoResult)) {
        if (playerWon == TTTGameResultFirstPlayerWin) {
            playerWonAlertView = [UIAlertController
                                  alertControllerWithTitle:@"Congragulations!"
                                  message:@"Player 1 Wins"
                                  preferredStyle:UIAlertControllerStyleAlert];
            
            self.gameState.firstPlayerScoreCount += 1;
            self.firstPlayerScoreLabel.text = [NSString stringWithFormat:@"Player 1 Score: %ld",(long)self.gameState.firstPlayerScoreCount];
        }
        else if(playerWon == TTTGameResultSecondPlayerWin) {
            playerWonAlertView = [UIAlertController
                                  alertControllerWithTitle:@"Congragulations!"
                                  message:@"Player 2 Wins"
                                  preferredStyle:UIAlertControllerStyleAlert];
            self.gameState.secondPlayerScoreCount += 1;
            self.secondPlayerScoreLabel.text = [NSString stringWithFormat:@"Player 2 Score: %ld",(long)self.gameState.secondPlayerScoreCount];
        }
        else if(playerWon == TTTGameResultComputerWin) {
            playerWonAlertView = [UIAlertController
                                  alertControllerWithTitle:@"Congragulations!"
                                  message:@"Computer Wins"
                                  preferredStyle:UIAlertControllerStyleAlert];
            self.gameState.secondPlayerScoreCount += 1;
            self.secondPlayerScoreLabel.text = [NSString stringWithFormat:@"Computer Score: %ld",(long)self.gameState.secondPlayerScoreCount];
        }
        else {
            playerWonAlertView = [UIAlertController
                                  alertControllerWithTitle:@"Draw!"
                                  message:@"Match Draw"
                                  preferredStyle:UIAlertControllerStyleAlert];
            self.gameState.matchDrawCount += 1;
            self.matchDrawLabel.text = [NSString stringWithFormat:@"Match Draw: %ld",(long)self.gameState.matchDrawCount];
        }
        UIAlertAction* startAgainButton = [UIAlertAction
                                           actionWithTitle:@"Play Again"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               [self resetGameWithNewUser:NO];
                                               
                                           }];
        [playerWonAlertView addAction:startAgainButton];
        [self presentViewController:playerWonAlertView animated:YES completion:nil];
    }
    
}

-(void)computerTurnWithLastUserSelectedIndex:(NSInteger)lastUserSelectedIndex {
    
    NSMutableArray *randomNumbersArray = [[NSMutableArray alloc]init];
    NSInteger totalNumberOfCells = pow(self.gameState.numberOfCellsInRow,2);
    
    while (1) {
        NSInteger randomIndex = arc4random() % totalNumberOfCells;
        if (![randomNumbersArray containsObject:@(randomIndex)] && randomNumbersArray.count < totalNumberOfCells) {
            [randomNumbersArray addObject:@(randomIndex)];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:randomIndex inSection:0];
            TTTCollectionViewCell *selectedCell = (TTTCollectionViewCell *)[self.ticTacToeCollectionView cellForItemAtIndexPath:indexPath];
            
            if (![selectedCell isSelected] && randomIndex != lastUserSelectedIndex) {
                [selectedCell.ZeroOrCrossImageView setImage:[UIImage imageNamed:@"ZeroImage"]];
                [self.gameState playerTurnWithGameState:self.gameState.currentGameState rowIndex:selectedCell.row columnIndex:selectedCell.column];
                [self.delegate checkGameResult];
                [selectedCell setCellSelected:YES];
                break;
            }
        }
        else if (randomNumbersArray.count + 1 == totalNumberOfCells){
            break;
        }
    }
}


@end
