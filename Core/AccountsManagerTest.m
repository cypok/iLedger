//
//  AccountsManagerTest.m
//  Core
//
//  Created by Vladimir Parfinenko on 06.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "AccountsManagerTest.h"

@implementation AccountsManagerTest

- (void)setUp
{
    accountsManager = [[AccountsManager alloc] init];
}

- (void)tearDown
{
    [accountsManager release];
}

- (void)testCreatingRootAccount
{
    Account *account = [accountsManager accountByName:@"expenses"];
    STAssertEqualObjects(account.name, @"expenses", @"");
    STAssertEqualObjects(account.parent, nil, @"");
}

- (void)testGettingEqualRootAccounts
{
    Account *account1 = [accountsManager accountByName:@"expenses"];
    Account *account2 = [accountsManager accountByName:@"expenses"];
    STAssertEquals(account1, account2, @"");
}

- (void)testCreatingChildAccount
{
    Account *account =    [accountsManager accountByName:@"expenses"];
    Account *subAccount = [accountsManager accountByName:@"expenses:food"];
    STAssertEqualObjects(subAccount.name, @"food", @"");
    STAssertEqualObjects(subAccount.parent, account, @"");
}

- (void)testGettingEqualChildAccounts
{
    Account *subAccount1 = [accountsManager accountByName:@"expenses:food"];
    Account *subAccount2 = [accountsManager accountByName:@"expenses:food"];
    STAssertEquals(subAccount1, subAccount2, @"");
}

- (void)testFullNameOfAccount
{
    Account *account =    [accountsManager accountByName:@"expenses"];
    Account *subAccount = [accountsManager accountByName:@"expenses:food"];
    STAssertEqualObjects(account.fullName, @"expenses", @"");
    STAssertEqualObjects(subAccount.fullName, @"expenses:food", @"");
}

- (void)testGettingAccountWithEmptyName
{
    STAssertThrows([accountsManager accountByName:@""], @"");
}

- (void)testGettingAccountWithUnfinishedName
{
    STAssertThrows([accountsManager accountByName:@"expenses:"], @"");
}

- (void)testGettingAccountWithBlankMiddleAccount
{
    
    STAssertThrows([accountsManager accountByName:@"expenses: :food"], @"");
}

@end
