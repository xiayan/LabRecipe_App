//
//  LabRecipeSecondController.m
//  LabRecipes
//
//  Created by Yan Xia on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LabRecipeSecondController.h"
#import "SecondDetailViewController.h"
#import "Buffer.h"

@implementation LabRecipeSecondController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityName:(NSString *)entity keyName:(NSString *)key {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil entityName:@"Buffer" keyName:@"bufferName"];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

#pragma mark - View Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

/*
// Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    Buffer *buffer = [fetchedResultsController objectAtIndexPath:indexPath];
    
    SecondDetailViewController *detailViewController = [[SecondDetailViewController alloc] initWithNibName:@"SecondDetailViewController" bundle:nil];
    detailViewController.selectedBuffer = buffer;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
