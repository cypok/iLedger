//
//  iLedgerAppDelegate.h
//  iLedger
//
//  Created by Vladimir Parfinenko on 09.04.11.
//  Copyright 2011 . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iLedgerAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    UIViewController *controller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIViewController *controller;

@end

