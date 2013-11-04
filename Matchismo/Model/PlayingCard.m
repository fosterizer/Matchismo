//
//  PlayingCard.m
//  Matchismo
//
//  Created by Anish Borkar on 10/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

//only implemented for 2 and 3 cards
- (int) match:(NSArray *) otherCards{
    
    int score = 0;
    
    if (otherCards.count == 1) {
        //Different scoring than 3 card game
        PlayingCard * otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    } else if (otherCards.count == 2) {
        /*3 ranks:
         
         (1)*(3/51)*(2/50) = 6/(50*51) => 1 * 1 => 234 points
         
         2 ranks:
         
         (1)*(3/51)*(48/50)*3 = 9*48/(50*51) = 6*8*9/(50*51) => 1 * 72 => 234/72 = 3 points
         
         3 suits:
         
         (1)*(12/51)*(11/50) = 6*2*11/(50*51) => 1 * 22 = >11 points
         
         2 suits:
         
         (1)*(12/51)*(39/50)*3 = 6 * 2 * 3 * 39/(50*51) => 1 * 234 => 1 point
         
         ***NO scoring for 2 ranks, 2 suits, even though possible ***
         
         */
        PlayingCard * firstCard = [otherCards objectAtIndex:0];
        PlayingCard * secondCard = [otherCards objectAtIndex:1];
        
        if ([firstCard.suit isEqualToString:self.suit] && [secondCard.suit isEqualToString:self.suit])
        {
            //3 suits
            score = 11;
        } else if ((firstCard.rank == self.rank) && (secondCard.rank = self.rank)){
            //3 ranks
            score = 234;
        } else if ((self.rank == firstCard.rank) || (self.rank == secondCard.rank) || (firstCard.rank = secondCard.rank)) {
            //2 ranks
            score = 3;
        } else if ((self.suit == firstCard.suit) || (self.suit == secondCard.suit) || (firstCard.suit == secondCard.suit)) {
            //2 suits
            score = 1;
        }
        
    }
    
    return score;
}

- (NSString *) contents {
    
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *) validSuits {
    return @[@"♥",@"♦",@"♠",@"♣"];
}

@synthesize suit = _suit;

- (void) setSuit:(NSString *)suit{
    
    if ([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

- (NSString *) suit {
    
    return _suit ? _suit : @"?";
}

+ (NSArray *) rankStrings {
    
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank { return [self rankStrings].count-1; }

- (void) setRank:(NSUInteger)rank {
    
    if (rank <= [PlayingCard maxRank])
        _rank = rank;
}

@end
