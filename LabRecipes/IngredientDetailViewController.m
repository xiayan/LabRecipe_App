//
//  IngredientDetailViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IngredientDetailViewController.h"
#import "UnitSelectionViewController.h"
#import "Buffer.h"
#import "Recipe.h"
#import "Ingredient.h"
#import "EditingTableCell.h"
#import "IngredientNameCell.h"
#import "ThirdDetailViewController.h"

@implementation IngredientDetailViewController

@synthesize context;
@synthesize recipe, ingredient;
@synthesize unitController;
@synthesize saveMode;

static UIButton *senderButton;
//static EditingTableCell *concCell;
static EditingTableCell *finalConcCell;
static BOOL isFinalCell;

#define NAME_ROW 0
#define STOCK_ROW 1
#define FINAL_ROW 2

#pragma mark -
#pragma mark View controller


- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (void)setUpNewIngredient:(Ingredient *)newIngredient {
    newIngredient.ingredientConc = @"";
    newIngredient.ingredientFinalConc = @"";
    newIngredient.ingredientFinalMagnitude = [NSNumber numberWithDouble:1.0];
    newIngredient.ingredientFinalUnit = @"M";
    newIngredient.ingredientMagnitude = [NSNumber numberWithDouble:1.0];
    newIngredient.ingredientName = @"";
    newIngredient.ingredientUnit = @"M";
    newIngredient.isMolar = [NSNumber numberWithBool:YES];
    newIngredient.finalIsMolar = [NSNumber numberWithBool:YES];
    
    // Display Order will be set up when saving the object.
}

- (BOOL)allFieldsFilled {
    EditingTableCell *cell;
    BOOL allFillded = YES;
    
    for (int i = 0; i < 3; i++) {
        cell = (EditingTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cell.textField.text isEqual: @""]) {
            allFillded = NO;
            break;
        }
    }
    return allFillded;
}

- (id)initWithStyle:(UITableViewStyle)style context:(NSManagedObjectContext *)aContext recipe:(Recipe *)aRecipe ingredient:(Ingredient *)anIngred saveMode:(BOOL)shouldSave {

    self = [self initWithStyle:style];
    if (self) {
        self.context = aContext;
        self.recipe = aRecipe;
        self.saveMode = shouldSave;

        if (anIngred) {
            self.ingredient = anIngred;
        } else {
            self.ingredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:self.context];
            [self setUpNewIngredient:self.ingredient];
        }
        
        // Configure the UINavigationBarItems
        if (anIngred == nil || self.saveMode) {
            // If a new ingredient, provide the save button and cancel button
            UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
            saveButton.enabled = NO;
            self.navigationItem.rightBarButtonItem = saveButton;
            
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelButton;
        } else {
            self.navigationItem.rightBarButtonItem = self.editButtonItem;
        }
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	self.tableView.allowsSelection = NO;
	self.tableView.allowsSelectionDuringEditing = NO;
    
    // Title
    NSString *name = (self.ingredient) ? self.ingredient.ingredientName : @"New Ingredient";

    self.navigationItem.title = name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // This view should always in editing mode. When not editing, it should be popped.
    self.editing = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)storeInfoToIngredient {
    EditingTableCell *cell = nil;
    cell = (EditingTableCell *)[self.tableView cellForRowAtIndexPath:
                                [NSIndexPath indexPathForRow:NAME_ROW inSection:0]];
    self.ingredient.ingredientName = cell.textField.text;
    
    cell = (EditingTableCell *)[self.tableView cellForRowAtIndexPath:
                                [NSIndexPath indexPathForRow:STOCK_ROW inSection:0]];
    self.ingredient.ingredientConc = cell.textField.text;
    
    cell = (EditingTableCell *)[self.tableView cellForRowAtIndexPath:
                                [NSIndexPath indexPathForRow:FINAL_ROW inSection:0]];
    self.ingredient.ingredientFinalConc = cell.textField.text;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        EditingTableCell *cell = (EditingTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [cell.textField becomeFirstResponder];
    } else { // If not editing, pop the view
        
        [self storeInfoToIngredient];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = [self allFieldsFilled];
}

#pragma mark -
#pragma mark Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ConcCellIdentifier = @"ConcEditingCell";
    static NSString *FinalConcCellIdentifier = @"FinalEditingCell";
    static NSString *IngredientNameCellIdentifier = @"NameCell";
    
    EditingTableCell *cell1 = (EditingTableCell *)[tableView dequeueReusableCellWithIdentifier:ConcCellIdentifier];
    EditingTableCell *cell2 = (EditingTableCell *)[tableView dequeueReusableCellWithIdentifier:ConcCellIdentifier];
    IngredientNameCell *cell3 = (IngredientNameCell *)[tableView dequeueReusableCellWithIdentifier:IngredientNameCellIdentifier];
    
    if (indexPath.row == 0) {
        if (cell3 == nil) {
            cell3 = [[IngredientNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IngredientNameCellIdentifier withReagent:self.ingredient withAttributeString:@"ingredientName"];
            cell3.textField.delegate = self;
        }
        cell3.label.text = @"Ingredient";
        cell3.textField.placeholder = @"Name";
        return cell3;
    }
	else if (indexPath.row == 1) {
        if (cell1 == nil) {
            cell1 = [[EditingTableCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                            reuseIdentifier:ConcCellIdentifier 
                                                withReagent:self.ingredient 
                                        withAttributeString:@"ingredientConc" 
                                             withUnitString:@"ingredientUnit"];
            //concCell = cell1;
            [cell1.unitButton addTarget:self action:@selector(showUnitPicker:) forControlEvents:UIControlEventTouchDown];
            cell1.textField.delegate = self;
        }
        
        cell1.label.text = @"Stock";
        cell1.textField.placeholder = @"Stock Concentration";
        return cell1;
    }
    else if (indexPath.row == 2) {
        if (cell2 == nil) {
            cell2 = [[EditingTableCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                            reuseIdentifier:FinalConcCellIdentifier 
                                                withReagent:self.ingredient 
                                        withAttributeString:@"ingredientFinalConc" 
                                             withUnitString:@"ingredientFinalUnit"];
            [cell2.unitButton addTarget:self action:@selector(showUnitPicker:) forControlEvents:UIControlEventTouchDown];
            cell2.textField.delegate = self;
        }
        
        cell2.label.text = @"Final";
        cell2.textField.placeholder = @"Final Concentration";
        finalConcCell = cell2;
        return cell2;
    } else {
        return nil;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark -
#pragma mark Save and cancel

- (void)save:(id)sender {
    [self storeInfoToIngredient];
    
    ingredient.displayOrder = [NSNumber numberWithInteger:[recipe.ingredients count]];
    [recipe addIngredientsObject:ingredient];
    
	/*
	 Save the managed object context.
	 */
	NSError *error = nil;
	if (![context save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    // Always pop to ThirdDetailViewController
    NSArray *viewControllers = [self.navigationController viewControllers];
    for (UIViewController *controller in viewControllers) {
        if ([controller class] == [ThirdDetailViewController class]) {
            [self.navigationController popToViewController:controller animated:YES];
            break;
        }
    }
}

- (void)cancel:(id)sender {
    [context deleteObject:self.ingredient];
    NSLog(@"New Ingredient deleted");
    [self.navigationController popViewControllerAnimated:YES];
}

/*
- (void)chooseFromStock:(id)sender {
    BufferPickingTableViewController *bufferPickingController = [[BufferPickingTableViewController alloc] initWithStyle:UITableViewStylePlain entityName:@"Buffer" keyName:@"bufferName"];
    bufferPickingController.managedObjectContext = self.context;
    bufferPickingController.delegate = self;
    bufferPickingController.hideRightBarButton = YES;
    bufferPickingController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bufferPickingController animated:YES];
}
*/


#pragma mark - Unit Button Selector
- (void)showUnitPicker:(id)sender {
    senderButton = (UIButton *)sender;
    
    if ([[senderButton superview] superview] == finalConcCell) {
        isFinalCell = YES;
    } else {
        isFinalCell = NO;
    }
        
    UIView *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
    
    if (!unitController) {
        unitController = [[UnitSelectionViewController alloc] initWithNibName:nil bundle:nil];
    }
    unitController.unit = (isFinalCell) ? ingredient.ingredientFinalUnit : ingredient.ingredientUnit;
    unitController.delegate = self;
    
    [self presentSemiModalViewController:unitController];
    if (isFinalCell) {
        unitController.segmentedControl.selectedSegmentIndex = ([self.ingredient.isMolar boolValue]) ? 0 : 1;
        unitController.segmentToolBar.hidden = YES;
    } else {
        unitController.segmentToolBar.hidden = NO;
    }
}

#pragma mark - Unit Picker Delegates
- (void)saveButtonPressed:(NSString *)unit isMolar:(BOOL)molar withMagnitude:(double)magnitude {

    if (isFinalCell) {
        ingredient.ingredientFinalMagnitude = [NSNumber numberWithDouble:magnitude];
        ingredient.finalIsMolar = [NSNumber numberWithBool:molar];
        ingredient.ingredientFinalUnit = unit;
    } else {
        ingredient.ingredientMagnitude = [NSNumber numberWithDouble:magnitude];
        ingredient.isMolar = [NSNumber numberWithBool:molar];
        ingredient.ingredientUnit = unit;
    }
    
    [senderButton setTitle:unit forState:UIControlStateNormal];
    
    [self dismissSemiModalViewController:unitController];
}

- (void)cancelButtonPressed {
    [self dismissSemiModalViewController:unitController];
}


@end
