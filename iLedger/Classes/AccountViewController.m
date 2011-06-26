//
//  AccountViewController.m
//  iLedger
//
//  Created by Vladimir Parfinenko on 17.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "AccountViewController.h"
#import "TextSizeUILabelExtension.h"


@interface AccountViewController()

@property (readonly) CGFloat paddingOfCell, widthOfCell;

@end


@implementation AccountViewController

#pragma mark -
#pragma mark Properties

@synthesize ledger, account;

#pragma mark -
#pragma mark Initialization and Deinitialization

- (void)setup
{
    self.title = @"Account";
}

- (id)init
{
    if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self awakeFromNib];
    [self setup];
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat padding = self.paddingOfCell;
    CGFloat width = self.widthOfCell;
    
    UILabel *nameLabel = [[[UILabel alloc] init] autorelease];
    nameLabel.text = self.account.fullName;
    nameLabel.font = [UIFont boldSystemFontOfSize:24];
    nameLabel.textAlignment = UITextAlignmentCenter;
    nameLabel.numberOfLines = 0;
    nameLabel.lineBreakMode = UILineBreakModeWordWrap;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.shadowColor = [UIColor whiteColor];
    nameLabel.shadowOffset = CGSizeMake(0, 1);
        
    int height = [nameLabel sizeOfTextForWidth:width].height;
    nameLabel.frame = CGRectMake(padding, padding, width, height);
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding + width + padding, padding + height)];
    [header addSubview:nameLabel];
    
    self.tableView.tableHeaderView = header;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Table view data source

/*
 TableView structure:
 
    Account's fullname          // header

    Balance             $100    // section 0, row 0
 
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:     return 1;
        default:    return 0;
    }
}

// Padding of grouped UITableViewCell
- (CGFloat)paddingOfCell
{
    return 10;
}

- (CGFloat)widthOfCell
{
    return self.view.bounds.size.width - 2 * self.paddingOfCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccountTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *key;
    NSString *value;
    
    switch (indexPath.row) {
        case 0:
            key = @"Balance";
            value = [[self.ledger balanceForAccount:self.account includingChildAccounts:YES] description];
            break;
    }
    
    cell.textLabel.text = key;
    cell.detailTextLabel.text = value;
    
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
}

@end
