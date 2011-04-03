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

- (void)logShouldBeEmpty
{
    STAssertEquals(delegate.log.count, (NSUInteger)0, @"");
}

- (void)logShouldBeEqualToStrings:(NSString *)first, ...
{
    NSMutableArray *args = [NSMutableArray arrayWithObject:first];

    va_list va;
    va_start(va, first);
    for (;;) {
        NSString *arg = va_arg(va, NSString *);
        if (!arg) {
            break;
        }
        [args addObject:arg];
    }    
    va_end(va);
    
    STAssertEquals(delegate.log.count, args.count, @"");
    for (NSUInteger i = 0; i < delegate.log.count && i < args.count; ++i) {
        STAssertEqualObjects([delegate.log objectAtIndex:i], [args objectAtIndex:i], @"");
    }
}

- (void)testParseEmptyFile {
    [parser parseLines:@""];

    [self logShouldBeEmpty];
}

- (void)testParseOneTransaction {
    [parser parseLines:@"4-03 milk\n food  10\n assets"];

    [self logShouldBeEqualToStrings:@"transaction <4-03> <milk>",
                                    @"posting <food> <10>",
                                    @"posting <assets> <(null)>",
                                    nil];
}

- (void)testParseOneTransactionWithExtraSpaces {
    [parser parseLines:@"4-03 \t milk \n \t food\t10\n \t\tassets  "];
    
    [self logShouldBeEqualToStrings:@"transaction <4-03> <milk>",
                                    @"posting <food> <10>",
                                    @"posting <assets> <(null)>",
                                    nil];
}

- (void)testParseOneTransactionWithComments {
    [parser parseLines:@"4-03 milk ; awful milk\n food  10  ; bad milk :(\n assets ; no money left"];
    
    [self logShouldBeEqualToStrings:@"transaction <4-03> <milk>",
                                    @"posting <food> <10>",
                                    @"posting <assets> <(null)>",
                                    nil];
}

- (void)testParseOneTransactionWithSpacedAccount {
    [parser parseLines:@"4-03 milk\n food and drink  10\n assets"];
    
    [self logShouldBeEqualToStrings:@"transaction <4-03> <milk>",
                                    @"posting <food and drink> <10>",
                                    @"posting <assets> <(null)>",
                                    nil];
}
 
@end
