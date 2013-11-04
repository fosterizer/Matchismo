//
//  Card.h
//  Matchismo
//
//  Created by Anish Borkar on 10/25/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic,strong) NSString * contents;
@property (nonatomic,getter=isFaceUp) BOOL faceUp;
@property (nonatomic,getter=isUnplayable) BOOL unplayable;

- (int) match:(NSArray *)otherCards;

@end
