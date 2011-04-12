//
//  TransactionViewController.m
//  iLedger
//
//  Created by Vladimir Parfinenko on 12.04.11.
//  Copyright 2011 . All rights reserved.
//

#import "TransactionViewController.h"

@interface UILabel(TextSizeUILabelExtension)
- (CGSize)sizeOfText;
- (CGSize)sizeOfTextForWidth:(CGFloat)width;
@end

@implementation UILabel(TextSizeUILabelExtension)

- (CGSize)sizeOfText
{
    return [self.text sizeWithFont:self.font];
}

- (CGSize)sizeOfTextForWidth:(CGFloat)width
{
    return [self.text sizeWithFont:self.font forWidth:width lineBreakMode:self.lineBreakMode];
}

@end


@implementation TransactionViewController

#pragma mark -
#pragma mark Properties

@synthesize transaction;

- (void)setTransaction:(Transaction *)newTransaction
{
    if (![transaction isEqual:newTransaction]) {
        transaction = newTransaction;
    }
}

#pragma mark -
#pragma mark Initialization and Deinitialization

- (void)setup
{
    self.title = @"Transaction";
}

- (id)init
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self awakeFromNib];
    [self setup];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
 */

- (void)dealloc
{
    self.transaction = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat offset = 20;
    CGFloat width = 320 - offset*2;
    
    UILabel *dateLabel = [[[UILabel alloc] init] autorelease];
    dateLabel.text = self.transaction.date.string;
    dateLabel.font = [UIFont systemFontOfSize:20];
    
    UILabel *descriptionLabel = [[[UILabel alloc] init] autorelease];
    descriptionLabel.text = self.transaction.description;
    descriptionLabel.font = [UIFont boldSystemFontOfSize:24];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    int labelsHeight = 0;
    for (UILabel *label in [NSArray arrayWithObjects:dateLabel, descriptionLabel, nil]) {
        label.backgroundColor = [UIColor clearColor];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1);
        
        int height = [label sizeOfTextForWidth:width].height;
        label.frame = CGRectMake(offset, offset + labelsHeight, width, height);
        labelsHeight += height;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, offset + width + offset, offset + labelsHeight)];
    [header addSubview:dateLabel];
    [header addSubview:descriptionLabel];
    
    self.tableView.tableHeaderView = header;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
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

- (Posting *)postingForIndexPath:(NSIndexPath *)indexPath
{
    return [self.transaction.postings objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.transaction.postings.count;
}

#define CELL_FONT_SIZE 20
#define CELL_VPADDING 5
#define CELL_HPADDING 8

- (CGFloat)heightOfLabelLineInCell
{
    return [@"Abc" sizeWithFont:[UIFont systemFontOfSize:CELL_FONT_SIZE]].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: no animation, right alignment looks bad
    // TODO: use AdvancedTableViewCells example

    static NSString *CellIdentifier = @"PostingTableViewCell";
    NSInteger accountLabelTag = 1;
    NSInteger amountLabelTag = 2;
    
    UILabel *accountLabel;
    UILabel *amountLabel;
    
    CGFloat lineHeight = [self heightOfLabelLineInCell];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

        NSLog(@"contentView size: %fx%f", cell.contentView.frame.size.width, cell.contentView.frame.size.height);
        
        UIView *container = [[[UIView alloc] init] autorelease];
        
        accountLabel = [[[UILabel alloc] init] autorelease];
        accountLabel.tag = accountLabelTag;
        accountLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
        accountLabel.backgroundColor = [UIColor clearColor];

        amountLabel = [[[UILabel alloc] init] autorelease];
        amountLabel.tag = amountLabelTag;
        amountLabel.textAlignment = UITextAlignmentRight;
        amountLabel.font = [UIFont systemFontOfSize:CELL_FONT_SIZE];
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.minimumFontSize = 12;
        amountLabel.adjustsFontSizeToFitWidth = YES;

        accountLabel.frame = CGRectMake(0, 0, 0, lineHeight);
        [container addSubview:accountLabel];

        amountLabel.frame = CGRectMake(0, lineHeight, 0, lineHeight);
        [container addSubview:amountLabel];

        container.frame = CGRectMake(CELL_HPADDING, CELL_VPADDING, 0, 2*lineHeight);

        [cell.contentView addSubview:container];
    } else {
        accountLabel = (UILabel *)[cell viewWithTag:accountLabelTag];
        amountLabel  = (UILabel *)[cell viewWithTag:amountLabelTag];
    }
    
    CGFloat width = self.view.bounds.size.width - 2 * (CELL_HPADDING + 10/*padding of grouped UITableViewCell*/);
    CGRect frame;
    
    frame = accountLabel.frame;
    frame.size.width = width;
    accountLabel.frame = frame;
    
    frame = amountLabel.frame;
    frame.size.width = width;
    amountLabel.frame = frame;


    Posting *posting = [self postingForIndexPath:indexPath];
    accountLabel.text = posting.account.fullName;
    amountLabel.text = posting.amount ? posting.amount : @"...";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 2 * (CELL_VPADDING + [self heightOfLabelLineInCell]);
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
    // do nothing
}


@end
