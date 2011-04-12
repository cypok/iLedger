//
//  Ledger.h
//  iLedger
//
//  Created by Vladimir Parfinenko on 10.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountsManager.h"
#import "TransactionsManager.h"


@interface NSDate(StringFromDateExtension)

@property (readonly) NSString *string;

@end


@interface Ledger : NSObject
{
    NSString *lines;
    BOOL parsed;
    NSString *parserError;
    AccountsManager *accountsManager;
    TransactionsManager *transactionsManager;
}
@property (copy) NSString *lines;

@property (copy,readonly) NSString *parserError;
@property (readonly) NSArray *transactions;
@property (readonly) NSDictionary *transactionsGroupedByDate;

- (id)initWithLines:(NSString *)ledgerLines;

- (BOOL)parse;

@end
