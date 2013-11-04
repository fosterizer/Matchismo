//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Anish Borkar on 10/27/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

//designated initializer
- (id) initWithCardCount:(NSUInteger)count
               usingDeck:(Deck *) deck;

//convenience initializer, has an additional argument that allows the user to input 2 or 3 card (or any other) game
- (id) initWithCardCount:(NSUInteger)count
               usingDeck:(Deck *) deck
         numCardsToMatch:(NSUInteger) numCards;

-(void)flipCardAtIndex:(NSUInteger) index;

-(Card *) cardAtIndex:(NSUInteger) index;

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSString *matchString;
@property (nonatomic) int numCardGame;

@end
