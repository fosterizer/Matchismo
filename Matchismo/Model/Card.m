//
//  Card.m
//  Matchismo
//
//  Created by Anish Borkar on 10/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "Card.h"

@implementation Card

//slightly modified implementation to account for multiple card games
- (int) match:(NSArray *)otherCards{

    int score = 0;
    
    for (Card *card in otherCards)
    {
        if ([card.contents isEqualToString:self.contents])
        {
            score++;
        }
    }
    return score;
}

@end
