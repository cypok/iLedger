//
//  Parser.h
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 02.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ParserDelegate

- (void)setYear:(NSString *)year;
- (void)addTransactionOfDate:(NSString *)date withDescription:(NSString *)description;
- (void)addPostingForAccount:(NSString *)account withAmount:(NSString *)amount;
- (void)finishTransaction;

@end


@interface Parser : NSObject
{
    id <ParserDelegate> delegate;
}

@property (assign) id <ParserDelegate> delegate;

- (void)parseLines:(NSString *)lines;

@end
