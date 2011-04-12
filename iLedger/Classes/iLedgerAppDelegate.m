//
//  iLedgerAppDelegate.m
//  iLedger
//
//  Created by Vladimir Parfinenko on 09.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "iLedgerAppDelegate.h"
#import "PlainTextViewController.h"
#import "TransactionsTableViewController.h"
#import "Ledger.h"


@implementation iLedgerAppDelegate

@synthesize window, controller;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL *file = [[NSBundle mainBundle] URLForResource:@"my.ledger" withExtension:nil];
    Ledger *ledger = [[Ledger alloc] initWithLines:[NSString stringWithContentsOfURL:file usedEncoding:nil error:nil]];
    NSAssert([ledger parse], @"initial file should be parsed correctly");
    
    PlainTextViewController *plainTextVC = [[[PlainTextViewController alloc] init] autorelease];
    plainTextVC.ledger = ledger;
    
    TransactionsTableViewController *transactionsTVC = [[[TransactionsTableViewController alloc] init] autorelease];
    transactionsTVC.ledger = ledger;

    UITabBarController *tbc = [[[UITabBarController alloc] init] autorelease];
    tbc.viewControllers = [NSArray arrayWithObjects:plainTextVC, transactionsTVC, nil];
    
    self.controller = tbc;
    [window addSubview:self.controller.view];

    [window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc
{
    [window release];
    self.controller = nil;
    [super dealloc];
}

@end
