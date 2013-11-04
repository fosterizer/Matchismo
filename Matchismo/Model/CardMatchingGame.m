//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Anish Borkar on 10/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score; //readwrite not necessary, default
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (readwrite, nonatomic) NSString *matchString;
@end

@implementation CardMatchingGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
#define DEFAULT_CARD_GAME 2

- (NSMutableArray *) cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (void) flipCardAtIndex:(NSUInteger)index {
    
    Card *card = [self cardAtIndex:index];
    
    //TODO: If more than two cards are flipped up, disable playing
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            // see if flipping this card creates a match
            int matchScore = 0;
            NSMutableArray * otherFaceUpCards = [NSMutableArray arrayWithCapacity:self.cards.count]; //of cards
            
            // to store strings of cards that were matched
            NSMutableArray * matchScoreString = [NSMutableArray arrayWithCapacity:20]; //of strings

            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    [otherFaceUpCards addObject:otherCard];
                }
            }
            if (self.numCardGame == otherFaceUpCards.count+1)
                matchScore = [card match:otherFaceUpCards];
            else
                matchScore = 0;
            
            if (matchScore) {
                [matchScoreString addObject:@"Matched"];
                for (Card *faceUpCard in otherFaceUpCards)
                {
                    faceUpCard.unplayable = YES;
                    [matchScoreString addObject:[NSString stringWithFormat:@"%@",faceUpCard.contents]];
                }
                card.unplayable = YES;
                [matchScoreString addObject:[NSString stringWithFormat:@"%@ for %d points!",card.contents, matchScore*MATCH_BONUS]];
                self.matchString = [matchScoreString componentsJoinedByString:@" "];
                self.score += matchScore * MATCH_BONUS;
            } else if ((otherFaceUpCards.count+1 == self.numCardGame) && (matchScore == 0)){
                matchScore = MISMATCH_PENALTY;
                self.score -= matchScore;
                [matchScoreString addObject:@"No match for"];
                for (Card *faceUpCard in otherFaceUpCards)
                {
                    [matchScoreString addObject:[NSString stringWithFormat:@"%@",faceUpCard.contents]];
                }
                [matchScoreString addObject:[NSString stringWithFormat:@"%@ for a penalty of %d points!",card.contents,MISMATCH_PENALTY]];
                self.matchString = [matchScoreString componentsJoinedByString:@" "];
            } else {
                //if no match or mismatch was found, simply return that the card was flipped.
                self.matchString = [NSString stringWithFormat:@"Flipped up %@.", card.contents];
            }
            self.score -= FLIP_COST;
        } else {
         
            //if card is simply flipped back to face down, do nothing and change matchString to empty
            self.matchString = @"";
        }
        card.faceUp = !card.isFaceUp;
    }
        
}

- (Card *) cardAtIndex:(NSUInteger)index {
    
    //count is a property, but you can use self.cards.count as well
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id) initWithCardCount:(NSUInteger)count
               usingDeck:(Deck *) deck {
    
    //always call super init first, unless you're using a convenience
    //initializer, in which case you call the designated initializer
    self = [super init];
    
    if (self) {
        for (int i=0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    
    self.numCardGame = DEFAULT_CARD_GAME;
    
    return self;
}

- (id) initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck numCardsToMatch:(NSUInteger)numCards {
    
    self = [self initWithCardCount:count usingDeck:deck];
    
    self.numCardGame = numCards;
    
    return self;
}

@end
