//
//  BufferListTableViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BufferListTableViewController.h"
#import "FirstSaveViewController.h"
#import "SecondDetailViewController.h"
#import "BufferDetailedViewController.h"
#import "Buffer.h"
#import "LabRecipesHelper.h"

@implementation BufferListTableViewController

- (void)addNewEntity {
    FirstSaveViewController *saveViewController = [[FirstSaveViewController alloc] initWithNibName:@"FirstSaveViewController" bundle:nil hideToggleView:NO];
    saveViewController.delegate = self;
    saveViewController.showingName = @"Buffer";
    
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:saveViewController];
    [self presentModalViewController:naviController animated:YES];
}

- (void)nameDidEntered:(NSString *)name isSolid:(BOOL)solid {
    if (name) {
        Buffer *newBuffer = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];

        newBuffer.bufferName = name;
        newBuffer.bufferVolumeUnit = @"L";
        newBuffer.bufferVolumeMagnitude = [NSNumber numberWithDouble:1.0];
        newBuffer.bufferUnit = @"M";
        newBuffer.bufferMagnitude = [NSNumber numberWithDouble:1.0];
        newBuffer.bufferIsMolar = [NSNumber numberWithBool:YES];
        newBuffer.bufferIsSolid = [NSNumber numberWithBool:solid];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } else {
            NSLog(@"Buffer Saving Done!");
        }
        // Create detailviewController, pass on recipe
        BufferDetailedViewController* detailViewController = [[BufferDetailedViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.context = self.managedObjectContext;
        detailViewController.selectedBuffer = newBuffer;
        detailViewController.shouldEditing = YES;
        [self.navigationController pushViewController:detailViewController animated:NO];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Buffer *entity = nil;
	if (self.searchIsActive)
		entity = [[self filteredListContent] objectAtIndex:[indexPath row]];
	else
        entity = [self.sectionedListContent objectAtIndexPath:indexPath];
    
    BufferDetailedViewController *detailViewController = [[BufferDetailedViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.context = self.managedObjectContext;
    detailViewController.selectedBuffer = entity;
    detailViewController.shouldEditing = NO;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
