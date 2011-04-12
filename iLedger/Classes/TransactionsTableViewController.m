//
//  TransactionsTableViewController.m
//  iLedger
//
//  Created by Vladimir Parfinenko on 12.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "TransactionsTableViewController.h"
#import "TransactionViewController.h"


@interface TransactionsTableViewController()

@property (retain) NSDictionary *transactions;
@property (retain) NSArray *dates;

- (NSDate *)dateForSection:(NSInteger)section;
- (NSArray *)transactionsForSection:(NSInteger)section;
- (Transaction *)transactionForIndexPath:(NSIndexPath *)indexPath;

@end



@implementation TransactionsTableViewController

#pragma mark -
#pragma mark Properties

@synthesize ledger, transactions, dates;

- (void)setLedger:(Ledger *)newLedger
{
    if (![ledger isEqual:newLedger]) {
        ledger = newLedger;
    }
}

- (NSDictionary *)transactions
{
    if (!transactions) {
        self.transactions = [ledger transactionsGroupedByDate];
    }
    return transactions;
}

- (NSArray *)dates
{
    if (!dates) {
        self.dates = [[self.transactions allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
    return dates;
}

#pragma mark -
#pragma mark Initialization and Deinitialization

- (void)setup
{
    self.title = @"Transactions";
    self.tabBarItem = [[[UITabBarItem alloc] initWithTitle:self.title
                                                     image:nil
                                                       tag:0] autorelease];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if ((self = [super initWithStyle:style])) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)dealloc
{
    self.transactions = nil;
    self.dates = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // TODO: move it from here because it scrolls every time
    int section = self.dates.count - 1;
    int row = [[self transactionsForSection:section] count] - 1;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark -
#pragma mark Table view data source

- (NSDate *)dateForSection:(NSInteger)section
{
    return [self.dates objectAtIndex:section];
}

- (NSArray *)transactionsForSection:(NSInteger)section
{
    return [self.transactions objectForKey:[self dateForSection:section]];
}

- (Transaction *)transactionForIndexPath:(NSIndexPath *)indexPath
{
    return [[self.transactions objectForKey:[self dateForSection:indexPath.section]] objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self transactionsForSection:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self dateForSection:section] string];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TransactionsTableViewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Transaction *transaction = [self transactionForIndexPath:indexPath];
    cell.textLabel.text = transaction.description;
    
    NSMutableArray *postingStrings = [NSMutableArray array];
    for (Posting *posting in transaction.postings) {
        NSString *postingString = posting.account.fullName;
        if (posting.amount) {
            postingString = [postingString stringByAppendingFormat:@" %@", posting.amount];
        }
        [postingStrings addObject:postingString];
    }
    cell.detailTextLabel.text = [postingStrings componentsJoinedByString:@", "];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionViewController *transactionVC = [[[TransactionViewController alloc] init] autorelease];
    transactionVC.transaction = [self transactionForIndexPath:indexPath];
    [self.navigationController pushViewController:transactionVC animated:YES];
}

@end

