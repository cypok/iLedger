//
//  AccountsManager.h
//  LedgerCore
//
//  Created by Vladimir Parfinenko on 05.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const ACCOUNTS_SEPARATOR;


@interface Account : NSObject
{
    Account *parent;
    NSMutableDictionary *children;
    NSString *name;
}
@property (readonly) Account *parent;
@property (readonly) NSString *fullName;

@end


@interface AccountsManager : NSObject {
    NSMutableDictionary *rootAccounts;
}

- (Account *)accountByName:(NSString *)accountName;

@end
