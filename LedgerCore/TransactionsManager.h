//
//  TransactionsManager.h
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 07.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"
#import "AccountsManager.h"


@interface NSDate (MyNSDateWithComponentsExtension)
@property (readonly) NSInteger year, month, day;

- (NSDate *)dateWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay;

@end


@interface Posting : NSObject
{
    Account *account;
    NSString *amount;
}
@property (readonly) Account *account;
@property (readonly) NSString *amount;

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

- (void)addPostingWithAccount:(Account *)anAccount amount:(NSString *)anAmount;
- (Posting *)postingByIndex:(NSUInteger)index;

@end


@interface TransactionsManager : NSObject <ParserDelegate>
{
    AccountsManager *accountsManager;
    NSMutableArray *transactions;
    NSInteger transactionYear;
    NSArray *fullDateFormatters, *shortDateFormatters;
}
@property (readonly) NSArray *transactions;

- (id)initWithAccountsManager:(AccountsManager *)anAccountsManager;

@end

