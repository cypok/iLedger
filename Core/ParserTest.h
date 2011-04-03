//
//  ParserTest.h
//  Core
//
//  Created by Vladimir Parfinenko on 03.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "Parser.h"

@class ParserTestDelegate;

@interface ParserTest : SenTestCase {
    Parser *parser;
    ParserTestDelegate *delegate;
}

@end
