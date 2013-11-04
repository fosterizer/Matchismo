//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Anish Borkar on 10/23/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong,nonatomic) CardMatchingGame *game;
//label that shows the output of whether each pair matched
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numCardControl;
@property (strong,nonatomic) UIImage *cardBackImage;

-(void) updateUI;
@end

#define TWO_CARD_GAME_INDEX 0
@implementation CardGameViewController

@synthesize game = _game;

- (CardMatchingGame *) game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                         usingDeck:[[PlayingCardDeck alloc] init]];
    }
    return _game;
}

- (UIImage *) cardBackImage {
    if (!_cardBackImage) {
        _cardBackImage = [UIImage imageNamed:@"cardBack.jpg"];
    }
    return _cardBackImage;
}

/*Does this cause a memory leak, because the previously instantiated game goes out of scope? */
- (void) setGame:(CardMatchingGame *)game {
    _game = game;
}


- (void)setCardButtons:(NSArray *)cardButtons {
    
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) updateUI {
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        
        UIImage *backImage = (!cardButton.isSelected) ? self.cardBackImage : nil;
        [cardButton setImage:backImage forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.matchLabel.text = self.game.matchString;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    [self.numCardControl setEnabled:NO];
}

- (IBAction)dealGame:(UIButton *)sender {
    int numCardsToPlay;
    
    if ([self.numCardControl selectedSegmentIndex] == TWO_CARD_GAME_INDEX)
        numCardsToPlay = 2;
    else
        numCardsToPlay = 3;
    
    CardMatchingGame *newGame = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init] numCardsToMatch:numCardsToPlay];
    
    NSLog(@"Initialized new game with %d cards to match.", numCardsToPlay);
    
    self.game = newGame;
    self.flipCount = 0;
    [self updateUI];
    [self.numCardControl setEnabled:YES];
}

- (IBAction)gameSwitch:(UISegmentedControl *)sender {

    NSLog(@"Triggering Game Switch");
    
    int selectedSegment = [sender selectedSegmentIndex];
    
    if (selectedSegment == TWO_CARD_GAME_INDEX)
    {
        NSLog(@"Triggering new two card game");
        [self.game setNumCardGame:2];
        
    } else { //three card game
        NSLog(@"Triggering new three card game");
        [self.game setNumCardGame:3];
    }
}


@end
