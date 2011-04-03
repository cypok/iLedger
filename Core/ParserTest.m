//
//  ParserTest.m
//  Core
//
//  Created by Vladimir Parfinenko on 03.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "ParserTest.h"

@interface ParserTestDelegate : NSObject <ParserDelegate>
{
    NSMutableArray *log;
}
@property (retain) NSMutableArray *log;
@end

@implementation ParserTestDelegate
@synthesize log;

- (id)init
{
    if (self = [super init]) {
        log = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [log release];
    [super dealloc];
}

- (void)addTransactionOfDate:(NSString *)date withDescription:(NSString *)description
{
    [log addObject:[NSString stringWithFormat:@"transaction <%@> <%@>", date, description]];
}

- (void) addPostingForAccount:(NSString *)account withAmount:(NSString *)amount
{
    [log addObject:[NSString stringWithFormat:@"posting <%@> <%@>", account, amount]];
}

@end



@implementation ParserTest

- (void)setUp
{
    parser = [[Parser alloc] init];
    delegate = [[ParserTestDelegate alloc] init];
    parser.delegate = delegate;
}

- (void)tearDown
{
    [parser release];
    [delegate release];
}

- (void)testParseEmptyFile {
    [parser parseLines:@""];

    STAssertEquals((int)delegate.log.count, 0, @"");
}

- (void)testParseOneTransaction {
    [parser parseLines:@"4-03 milk\n food  10\n assets"];

    STAssertEquals((int)delegate.log.count, 3, @"");
    STAssertEqualObjects([delegate.log objectAtIndex:0], @"transaction <4-03> <milk>", @"transaction header");
    STAssertEqualObjects([delegate.log objectAtIndex:1], @"posting <food> <10>", @"first posting");
    STAssertEqualObjects([delegate.log objectAtIndex:2], @"posting <assets> <(null)>", @"second posting");
}

- (void)testParseOneTransactionWithExtraSpaces {
    [parser parseLines:@"4-03 \t milk \n \t food\t10\n \t\tassets  "];

    STAssertEquals((int)delegate.log.count, 3, @"");
    STAssertEqualObjects([delegate.log objectAtIndex:0], @"transaction <4-03> <milk>", @"transaction header");
    STAssertEqualObjects([delegate.log objectAtIndex:1], @"posting <food> <10>", @"first posting");
    STAssertEqualObjects([delegate.log objectAtIndex:2], @"posting <assets> <(null)>", @"second posting");
}

 
@end
