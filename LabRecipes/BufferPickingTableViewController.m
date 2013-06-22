//
//  BufferPickingTableViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BufferPickingTableViewController.h"
#import "Buffer.h"

@implementation BufferPickingTableViewController
@synthesize hideRightBarButton;
@synthesize delegate;

#pragma mark - Table view delegate

- (void)viewDidLoad {
    [super viewDidLoad];
    if (hideRightBarButton) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	Buffer *buffer = nil;
	if (self.searchIsActive)
		buffer = [[self filteredListContent] objectAtIndex:[indexPath row]];
	else
        buffer = [[self.sectionedListContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
//    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate bufferDidSelected:buffer];
}

@end
