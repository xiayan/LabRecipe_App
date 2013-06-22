//
//  ThirdDetailViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThirdDetailViewController.h"
#import "LabRecipesAppDelegate.h"
#import "Buffer.h"
#import "Recipe.h"
#import "Ingredient.h"
#import "InstructionViewController.h"
#import "IngredientDetailViewController.h"
#import "EditingTableCell.h"
#import "NameHeaderViewController.h"
#import "mWFieldCell.h"
#import "NameFieldCell.h"
#import "IngredientInfoCell.h"
#import "VolumeEditingCell.h"
#import "BufferPickingTableViewController.h"

@implementation ThirdDetailViewController
@synthesize context;
@synthesize selectedRecipe;
@synthesize allIngredients;
@synthesize headerViewController;
@synthesize needsEditing;

#define INGREDIENTS_SECTION 0
#define VOLUME_SECTION 1

#pragma mark -
#pragma mark View controller

- (void)sortIngredientSection {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayOrder" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	
	NSMutableArray *sortedIngredients = [[NSMutableArray alloc] initWithArray:[selectedRecipe.ingredients allObjects]];
	[sortedIngredients sortUsingDescriptors:sortDescriptors];
	self.allIngredients = sortedIngredients;
    
    [self.tableView reloadData];
  //  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:INGREDIENTS_SECTION] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (id)initWithStyle:(UITableViewStyle)style withContext:(NSManagedObjectContext *)aContext withRecipe:(Recipe *)aRecipe needsEditing:(BOOL)editing {
    
    self = [super initWithStyle:style];
    
    if (self) {
        self.context = aContext;
        self.selectedRecipe = aRecipe;
        self.needsEditing = editing;
        
//        [self sortIngredientSection];
    }
    return self;
}

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = YES;    
    
    if (!headerViewController) {
        headerViewController = [[NameHeaderViewController alloc] initWithNibName:@"NameHeaderViewController" bundle:nil];
        headerViewController.nameText = self.selectedRecipe.recipeName;
    }
    
    if (!footerViewController) {
        footerViewController = [[SharingTableFooterViewController alloc] initWithNibName:nil bundle:nil];
        footerViewController.delegate = self;
        // No need for dilution button in the Recipe View.
        [footerViewController.dilutionButton removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
	
	self.navigationItem.title = selectedRecipe.recipeName;

    [headerViewController setEditing:self.editing animated:NO];
    
    [self sortIngredientSection];
    
    if (self.needsEditing && self.editing == NO) {
        [self setEditing:YES animated:YES];
        self.needsEditing = NO;
    }
}
 
- (void)viewDidUnload {
	[super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    [self.headerViewController setEditing:editing animated:animated];
    
	[self.navigationItem setHidesBackButton:editing animated:YES];
	
    
	[self.tableView beginUpdates];
	
    NSUInteger ingredientsCount = [selectedRecipe.ingredients count];
    
    NSIndexPath *createNew = [NSIndexPath indexPathForRow:ingredientsCount inSection:INGREDIENTS_SECTION];
    NSIndexPath *chooseFromList = [NSIndexPath indexPathForRow:ingredientsCount + 1 inSection:INGREDIENTS_SECTION];
    
    
    NSArray *ingredientsInsertIndexPath = [NSArray arrayWithObjects:createNew, chooseFromList, nil];
    
    if (editing) {
        [self.tableView insertRowsAtIndexPaths:ingredientsInsertIndexPath withRowAnimation:UITableViewRowAnimationFade];
	} else {
        [self.tableView deleteRowsAtIndexPaths:ingredientsInsertIndexPath withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //EditingTableCell *cell = (EditingTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:VOLUME_SECTION]];
    //cell.textField.enabled = YES;
    
    [self.tableView endUpdates];
	
	if (!editing) {
        self.tableView.tableHeaderView = nil;
        self.tableView.tableFooterView = nil;
        self.selectedRecipe.recipeName = self.headerViewController.nameText;
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	} else {
        self.tableView.tableHeaderView = headerViewController.view;
        self.tableView.tableFooterView = footerViewController.view;
        NameFieldCell *cell = (NameFieldCell *)[self.headerViewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.textField becomeFirstResponder];
    }
    
    self.navigationItem.title = selectedRecipe.recipeName;
    
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:INGREDIENTS_SECTION] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    /*
    EditingTableCell *cell = (EditingTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:VOLUME_SECTION]];
    if (textField == cell.textField) {
        self.selectedRecipe.recipeVolume = cell.textField.text;
        [self.tableView reloadData];
    }
    */
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    // Return a title or nil as appropriate for the section.
    switch (section) {
        case INGREDIENTS_SECTION:
            title = @"Ingredients";
            break;
        case VOLUME_SECTION:
            title = @"Final Volume";
            break;
        default:
            break;
    }
    return title;;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    /*
     The number of rows depends on the section.
     In the case of ingredients, if editing, add a row in editing mode to present an "Add Ingredient" cell.
	 */
    switch (section) {
        case VOLUME_SECTION:
            rows = 1;
            break;
        case INGREDIENTS_SECTION:
            rows = [selectedRecipe.ingredients count];
            if (self.editing) {
                rows += 2;
            }
            break;
		default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell1 = nil;
    IngredientInfoCell *cell2 = nil;
    VolumeEditingCell *cell3 = nil;    
    
    static NSString *IngredientsCellIdentifier = @"IngredientsCell";
    static NSString *AddIngredientCellIdentifier = @"AddIngredientCell";
    static NSString *VolumeCellIdentifier = @"VolumeEditingCell";
    
    cell1 = [tableView dequeueReusableCellWithIdentifier:AddIngredientCellIdentifier];
    cell2 = (IngredientInfoCell *)[tableView dequeueReusableCellWithIdentifier:IngredientsCellIdentifier];
    cell3 = (VolumeEditingCell *)[tableView dequeueReusableCellWithIdentifier:VolumeCellIdentifier];
    
    if (indexPath.section == INGREDIENTS_SECTION) {
		NSUInteger ingredientCount = [selectedRecipe.ingredients count];
        if (indexPath.row < ingredientCount) {
            if (cell2 == nil) {
                cell2 = [[IngredientInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                                  reuseIdentifier:IngredientsCellIdentifier 
                                                       withRecipe:self.selectedRecipe];
                cell2.accessoryType = UITableViewCellAccessoryNone;
                cell2.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

            Ingredient *ingredientForCell = ([allIngredients count] > 0) ? [allIngredients objectAtIndex:indexPath.row] : nil;
            cell2.selectedIngredient = ingredientForCell;
            return cell2;
            
        } else if (indexPath.row == ingredientCount){
            if (cell1 == nil) {
                // Create a cell to display "Add Ingredient".
                cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddIngredientCellIdentifier];
                cell1.editingAccessoryType = UITableViewCellAccessoryNone;
            }
            cell1.textLabel.text = @"Add Ingredient";
            return cell1;
            
        } else {
            if (cell1 == nil) {
                // Create a cell to display "Add Ingredient".
                cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddIngredientCellIdentifier];
                cell1.editingAccessoryType = UITableViewCellAccessoryNone;
            }
            
            cell1.textLabel.text = @"Choose from Buffer List";
            return cell1;
        }
    } else if (indexPath.section == VOLUME_SECTION) {
        if (cell3 == nil) {
            cell3 = [[VolumeEditingCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                             reuseIdentifier:VolumeCellIdentifier 
                                                 withReagent:self.selectedRecipe 
                                         withAttributeString:@"recipeVolume" 
                                              withUnitString:@"recipeUnit"];
        }
        cell3.label.text = @"Volume";
        cell3.textField.placeholder = @"Volume";
        cell3.delegate = self;
        
        cell3.accessoryType = UITableViewCellAccessoryNone;
        cell3.editingAccessoryType = UITableViewCellAccessoryNone;
        return cell3;
    }
    return nil;
}

- (NSString *)molarLabelText:(Ingredient *)selectedIngredient {
    return [NSString stringWithFormat:@"%g%@ %@", [selectedIngredient.ingredientConc floatValue], selectedIngredient.ingredientUnit, selectedIngredient.ingredientName];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0;
    if (indexPath.section == INGREDIENTS_SECTION) {
        if (indexPath.row < [allIngredients count]) {
            CGFloat textWidth = (self.editing) ? 190.0 : 155.0;
            
            Ingredient *ingredientAtRow = [allIngredients objectAtIndex:indexPath.row];
            NSString *molarString = [self molarLabelText:ingredientAtRow];
            CGSize molarSize = [molarString sizeWithFont:[UIFont boldSystemFontOfSize:18.0] constrainedToSize:CGSizeMake(textWidth, 70.0) lineBreakMode:UILineBreakModeTailTruncation];
            if (molarSize.height > 22.0) {
                height = 22.0 + molarSize.height;
            }
        }
    }
    return height;
}

#pragma mark -
#pragma mark Editing rows

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    UIViewController *nextViewController = nil;
    
    if (section == INGREDIENTS_SECTION) {
        if (indexPath.row <= [allIngredients count]) {
            Ingredient *ingredientForDetail = ([allIngredients count] == indexPath.row) ? nil : [allIngredients objectAtIndex:indexPath.row];
            nextViewController = [[IngredientDetailViewController alloc] 
                                  initWithStyle:UITableViewStyleGrouped 
                                  context:self.context 
                                  recipe:selectedRecipe 
                                  ingredient:ingredientForDetail
                                  saveMode:NO];

//            ((IngredientDetailViewController *)nextViewController).context = self.context;
            nextViewController.hidesBottomBarWhenPushed = YES;
        } else {
            nextViewController = [[BufferPickingTableViewController alloc] initWithStyle:UITableViewStylePlain entityName:@"Buffer" keyName:@"bufferName"];

            ((BufferPickingTableViewController *)nextViewController).managedObjectContext = self.context;
            ((BufferPickingTableViewController *)nextViewController).delegate = self;
            ((BufferPickingTableViewController *)nextViewController).hideRightBarButton = YES;
            nextViewController.hidesBottomBarWhenPushed = YES;
        }
    }
    
    if (nextViewController) {
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
    // Only allow editing in the ingredients section.
    // In the ingredients section, the last row (row number equal to the count of ingredients) is added automatically (see tableView:cellForRowAtIndexPath:) to provide an insertion cell, so configure that cell for insertion; the other cells are configured for deletion.
    if (indexPath.section == INGREDIENTS_SECTION) {
        // If this is the last item, it's the insertion row.
        if (indexPath.row >= [selectedRecipe.ingredients count]) {
            style = UITableViewCellEditingStyleInsert;
        }
        else {
            style = UITableViewCellEditingStyleDelete;
        }
    }
    
    return style;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Only allow deletion, and only in the ingredients section
    if ((editingStyle == UITableViewCellEditingStyleDelete) && (indexPath.section == INGREDIENTS_SECTION)) {
        // Remove the corresponding ingredient object from the recipe's ingredient list and delete the appropriate table view cell.
        Ingredient *ingredient = [allIngredients objectAtIndex:indexPath.row];
        [selectedRecipe removeIngredientsObject:ingredient];
        [allIngredients removeObject:ingredient];
        
        //NSManagedObjectContext *context = ingredient.managedObjectContext;
        [context deleteObject:ingredient];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}


#pragma mark -
#pragma mark Moving rows

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canMove = NO;
    // Moves are only allowed within the ingredients section.  Within the ingredients section, the last row (Add Ingredient) cannot be moved.
    if (indexPath.section == INGREDIENTS_SECTION) {
        canMove = (indexPath.row < [selectedRecipe.ingredients count]);
    }
    return canMove;
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSIndexPath *target = proposedDestinationIndexPath;
    
    /*
     Moves are only allowed within the ingredients section, so make sure the destination is in the ingredients section.
     If the destination is in the ingredients section, make sure that it's not the Add Ingredient row -- if it is, retarget for the penultimate row.
     */
	NSUInteger proposedSection = proposedDestinationIndexPath.section;
	
    if (proposedSection < INGREDIENTS_SECTION) {
        target = [NSIndexPath indexPathForRow:0 inSection:INGREDIENTS_SECTION];
    } else if (proposedSection > INGREDIENTS_SECTION) {
        target = [NSIndexPath indexPathForRow:([selectedRecipe.ingredients count] - 1) inSection:INGREDIENTS_SECTION];
    } else {
        NSUInteger ingredientsCount_1 = [selectedRecipe.ingredients count] - 1;
        
        if (proposedDestinationIndexPath.row > ingredientsCount_1) {
            target = [NSIndexPath indexPathForRow:ingredientsCount_1 inSection:INGREDIENTS_SECTION];
        }
    }
	
    return target;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	/*
	 Update the ingredients array in response to the move.
	 Update the display order indexes within the range of the move.
	 */
    Ingredient *ingredient = [allIngredients objectAtIndex:fromIndexPath.row];
    [allIngredients removeObjectAtIndex:fromIndexPath.row];
    [allIngredients insertObject:ingredient atIndex:toIndexPath.row];
	
	NSInteger start = fromIndexPath.row;
	if (toIndexPath.row < start) {
		start = toIndexPath.row;
	}
	NSInteger end = toIndexPath.row;
	if (fromIndexPath.row > end) {
		end = fromIndexPath.row;
	}
	for (NSInteger i = start; i <= end; i++) {
		ingredient = [allIngredients objectAtIndex:i];
		ingredient.displayOrder = [NSNumber numberWithInteger:i];
	}
}

#pragma mark - Buffer Picking Delegate
- (void)bufferDidSelected:(Buffer *)selectedBuffer {
    Ingredient *newIngredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.context];

    newIngredient.ingredientConc = selectedBuffer.bufferStockConc;
    newIngredient.ingredientFinalConc = @"";
    newIngredient.ingredientFinalMagnitude = selectedBuffer.bufferMagnitude;
    newIngredient.ingredientFinalUnit = selectedBuffer.bufferUnit;
    newIngredient.ingredientMagnitude = selectedBuffer.bufferMagnitude;
    newIngredient.ingredientName = selectedBuffer.bufferName;
    newIngredient.ingredientUnit = selectedBuffer.bufferUnit;
    newIngredient.isMolar = selectedBuffer.bufferIsMolar;
    newIngredient.finalIsMolar = selectedBuffer.bufferIsMolar;
    
    IngredientDetailViewController *nextViewController = [[IngredientDetailViewController alloc] 
                                                          initWithStyle:UITableViewStyleGrouped 
                                                          context:self.context 
                                                          recipe:selectedRecipe 
                                                          ingredient:newIngredient
                                                          saveMode:YES];
    nextViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:nextViewController animated:YES];
}

#pragma mark - Volume Button Selector
- (void)unitSelected:(NSString *)newUnit withMagnitude:(NSNumber *)magnitude {
    selectedRecipe.recipeUnit = newUnit;
    selectedRecipe.recipeMagnitude = magnitude;
}

#pragma mark - FooterView Delegates
- (void)prepareDelete {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil, nil];
//    UITabBarController *rootTabBarController = [(LabRecipesAppDelegate *)[[UIApplication sharedApplication]delegate] tabBarController];
    [actionSheet showInView:self.view];
//    [actionSheet showFromTabBar:rootTabBarController.tabBar];
}

#pragma mark - UIActionSheet delegate
- (void) deleteBuffer {
    [self.context deleteObject:selectedRecipe];
    
    NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	} else {
        NSLog(@"Recipe deleted");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self deleteBuffer];
    }
}

@end