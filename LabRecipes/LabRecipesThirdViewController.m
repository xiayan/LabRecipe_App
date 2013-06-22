//
//  LabRecipesThirdViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LabRecipesThirdViewController.h"
#import "LabRecipesAppDelegate.h"
#import "FirstSaveViewController.h"
#import "ThirdDetailViewController.h"
#import "Recipe.h"
#import "Ingredient.h"

@implementation LabRecipesThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityName:(NSString *)entity keyName:(NSString *)key {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil entityName:@"Recipe" keyName:@"recipeName"];
    if (self) {
        self.title = NSLocalizedString(@"Third", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

#pragma mark - View Cycle

- (void)createNewRecipe:(id)sender {
    FirstSaveViewController *saveViewController = [[FirstSaveViewController alloc] initWithNibName:@"FirstSaveViewController" bundle:nil hideToggleView:YES];
    saveViewController.delegate = self;
    saveViewController.showingName = @"Recipe";
    
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:saveViewController];
    [self presentModalViewController:naviController animated:YES];
}

- (void)nameDidEntered:(NSString *)name {
    if (name) {
        NSManagedObjectContext *context = [(LabRecipesAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        Recipe *newRecipe = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:context];
        newRecipe.recipeName = name;
        
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } else {
            NSLog(@"Recipes Saving Done!");
        }
        // Create detailviewController, pass on recipe
        ThirdDetailViewController *detailViewController = [[ThirdDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.selectedRecipe = newRecipe;
        [self.navigationController pushViewController:detailViewController animated:NO];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNewRecipe:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    Recipe *recipe = [fetchedResultsController objectAtIndexPath:indexPath];
    
    ThirdDetailViewController *detailViewController = [[ThirdDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    detailViewController.selectedRecipe = recipe;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
