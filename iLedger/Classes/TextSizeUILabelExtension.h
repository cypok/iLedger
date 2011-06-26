//
//  TextSizeUILabelExtension.h
//  iLedger
//
//  Created by Vladimir Parfinenko on 17.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UILabel(TextSizeUILabelExtension)

- (CGSize)sizeOfText;
- (CGSize)sizeOfTextForWidth:(CGFloat)width;

@end

