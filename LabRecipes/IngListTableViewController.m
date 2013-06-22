//
//  IngListTableViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IngListTableViewController.h"
#import "FirstSaveViewController.h"
#import "Recipe.h"
#import "ThirdDetailViewController.h"

@implementation IngListTableViewController

- (void)addNewEntity {
    FirstSaveViewController *saveViewController = [[FirstSaveViewController alloc]
                                                   initWithNibName:@"FirstSaveViewController" bundle:nil hideToggleView:YES];
    saveViewController.delegate = self;
    saveViewController.showingName = @"Recipe";
    
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:saveViewController];
    [self presentModalViewController:naviController animated:YES];
}

- (void)nameDidEntered:(NSString *)name {
    if (name) {
        Recipe *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        newRecipe.recipeName = name;
        newRecipe.recipeUnit = @"L";
        newRecipe.recipeVolume = @"";
        newRecipe.recipeMagnitude = [NSNumber numberWithDouble:1.0];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } else {
            NSLog(@"Recipes Saving Done!");
        }
        // Create detailviewController, pass on recipe
        ThirdDetailViewController *detailViewController = [[ThirdDetailViewController alloc] 
                                                           initWithStyle:UITableViewStyleGrouped 
                                                           withContext:self.managedObjectContext 
                                                           withRecipe:newRecipe 
                                                           needsEditing:YES];        

        //detailViewController.context = self.managedObjectContext;
        //detailViewController.selectedRecipe = newRecipe;
        [self.navigationController pushViewController:detailViewController animated:NO];
        //detailViewController.needsEditing = YES;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Recipe *entity = nil;
	if (self.searchIsActive)
		entity = [[self filteredListContent] objectAtIndex:[indexPath row]];
	else
        entity = [self.sectionedListContent objectAtIndexPath:indexPath];
    
    ThirdDetailViewController *detailViewController = [[ThirdDetailViewController alloc] 
                                                       initWithStyle:UITableViewStyleGrouped 
                                                       withContext:self.managedObjectContext 
                                                       withRecipe:entity 
                                                       needsEditing:NO];

    //    detailViewController.context = self.managedObjectContext;
//    detailViewController.selectedRecipe = entity;
//    detailViewController.needsEditing = NO;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
