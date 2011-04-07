//
//  TransactionsManager.h
//  Core
//
//  Created by Vladimir Parfinenko on 07.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"
#import "AccountsManager.h"


@interface Posting : NSObject
{
    Account *account;
    NSString *amount;
}
@property (readonly) Account *account;
@property (readonly) NSString *amount;

+ (id)postingWithAccount:(Account *)anAccount amount:(NSString *)anAmount;

- (id)initWithAccount:(Account *)anAccount amount:(NSString *)anAmount;

@end


@interface Transaction : NSObject
{
    NSDate *date;
    NSString *description;
    NSMutableArray *postings;
}
@property (readonly) NSDate *date;
@property (readonly) NSString *description;
@property (readonly) NSArray *postings;

- (id)initWithDate:(NSDate *)aDate description:(NSString *)aDescription;

- (void)addPosting:(Posting *)posting;
- (Posting *)postingByIndex:(NSUInteger)index;

@end


@interface TransactionsManager : NSObject <ParserDelegate>
{
    NSMutableArray *transactions;    
}
@property (readonly) NSArray *transactions;

@end

