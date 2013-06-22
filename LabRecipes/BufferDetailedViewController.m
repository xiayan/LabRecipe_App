//
//  BufferDetailedViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabRecipesHelper.h"
#import "LabRecipesAppDelegate.h"
#import "BufferDetailedViewController.h"
#import "NameHeaderViewController.h"
#import "Buffer.h"
#import "EditingTableCell.h"
#import "VolumeEditingCell.h"
#import "mWFieldCell.h"
#import "NameFieldCell.h"
#import "InstructionToggleCell.h"
#import "BufferDilutionViewController.h"
#import "UICustomSwitch.h"

#define INFO_SECTION 0
#define MW_ROW 0
#define CONC_ROW 1
#define VOLUME_ROW 2
#define TOGGLE_ROW 3

#define STATUS_SECTION 1
/*
@interface Buffer (YXSetUpBuffer)

- (void)setUpBufferAtIndex:(int)index forText:(NSString *)text;

@end

@implementation Buffer (YXSetUpBuffer)

- (void)setUpBufferAtIndex:(int)index forText:(NSString *)text {
    // formatting numbers to get rid of typos (such as multiple dots)
    switch (index) {
        case MW_ROW:
            self.bufferMW = [NSString stringWithFormat:@"%g", [text floatValue]];
            break;
        case VOLUME_ROW:
            self.bufferVolume = [NSString stringWithFormat:@"%g", [text floatValue]];
            
            break;
        case CONC_ROW:
            self.bufferStockConc = [NSString stringWithFormat:@"%g", [text floatValue]];
        default:
            break;
    }
}


@end
*/

@implementation BufferDetailedViewController
@synthesize context, selectedBuffer, headerViewController, footerViewController;
@synthesize shouldEditing;

static UIButton *senderButton;
static InstructionToggleCell *toggleCell;

#pragma mark -
#pragma mark View controller
- (BOOL)allFieldsFilled {
    BOOL filled = YES;
    if (selectedBuffer.bufferMW == nil || [selectedBuffer.bufferMW isEqualToString:@"0"]) {
        filled = NO;
    }
    if (selectedBuffer.bufferStockConc == nil || [selectedBuffer.bufferStockConc isEqualToString:@"0"]) {
        filled = NO;
    }
    if (selectedBuffer.bufferVolume == nil || [selectedBuffer.bufferVolume isEqualToString:@"0"]) {
        filled = NO;
    }
    
    return filled;
}

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    
    if (!headerViewController) {
        headerViewController = [[NameHeaderViewController alloc] initWithNibName:@"NameHeaderViewController" bundle:nil];
    }
    headerViewController.nameText = self.selectedBuffer.bufferName;
    
    if (!footerViewController) {
        footerViewController = [[SharingTableFooterViewController alloc] initWithNibName:nil bundle:nil];
        footerViewController.delegate = self;
    }
    self.tableView.tableFooterView = footerViewController.view;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationItem.title = selectedBuffer.bufferName;

    if (shouldEditing) {
        [self.tableView reloadData];
        [self setEditing:YES animated:YES];
        shouldEditing = NO;
    } else {
        [footerViewController setEditing:self.editing animated:NO];
    }
    
//    if (self.editing) {
 //       self.tableView.tableHeaderView = headerViewController.view;
 //   } else self.tableView.tableHeaderView = nil;
    
//    [headerViewController setEditing:self.editing animated:NO];
    
    
    footerViewController.dilutionButton.enabled = [self allFieldsFilled];
}

- (void)viewDidUnload {
	[super viewDidUnload];
    [toggleCell removeObserver:self forKeyPath:@"toggleSwitch.isOn"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:YES];
    [self.headerViewController setEditing:editing animated:animated];
    [self.footerViewController setEditing:editing animated:animated];
    
    [self.tableView beginUpdates];
    
    NSArray *bufferStateInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:INFO_SECTION]];
    if (editing) {
        [self.tableView insertRowsAtIndexPaths:bufferStateInsertIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView deleteRowsAtIndexPaths:bufferStateInsertIndexPath withRowAnimation:UITableViewRowAnimationAutomatic]; 
    }
    
    [self.tableView endUpdates];
    
	
    if (editing) {
        self.tableView.tableHeaderView = headerViewController.view;
        NameFieldCell *cell = (NameFieldCell *)[self.headerViewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.textField becomeFirstResponder];
    } 
    
    if (!editing) {
        self.selectedBuffer.bufferName = self.headerViewController.nameText;
        self.tableView.tableHeaderView = nil;
        self.footerViewController.dilutionButton.enabled = [self allFieldsFilled];
		NSError *error = nil;
		if (![context save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
    self.navigationItem.title = selectedBuffer.bufferName;
    
    /*
    // For some reason the mwcell is not saving
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:MW_ROW inSection:INFO_SECTION]] withRowAnimation:UITableViewRowAnimationAutomatic];
    */
    
    if ([selectedBuffer.bufferIsSolid boolValue]) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:STATUS_SECTION]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

/*
- (void)saveInfoSectionFromTextField:(UITextField *)textField {
    EditingTableCell *cell = nil;
    for (int i = 1; i < 3; i++) {
        cell =  (EditingTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:INFO_SECTION]];
        if (textField == cell.textField) {
            [self.selectedBuffer setUpBufferAtIndex:i forText:textField.text];
        }
    }
    
    mWFieldCell *cell1 = (mWFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:MW_ROW inSection:INFO_SECTION]];
    if (textField == cell1.textField) {
        [self.selectedBuffer setUpBufferAtIndex:MW_ROW forText:textField.text];
    }
}
*/
/*
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    //[self saveInfoSectionFromTextField:textField];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}
*/
 
#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number;
    if ([self.selectedBuffer.bufferIsSolid boolValue]) {
        number = 2;
    } else {
        number = 1;
    }
    return number;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    
    if (section == STATUS_SECTION && [selectedBuffer.bufferIsSolid boolValue]) {
        title = @"Instruction";
    } else if (section == INFO_SECTION) {
        title = @"Stock Info";
    } else {
        title = nil;
    }
    return title;;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    if (section == INFO_SECTION) {
        rows = (self.editing)? 4 : 3;
    } else {
        if ([self.selectedBuffer.bufferIsSolid boolValue]) {
            rows = 1;
        } else {
            rows = 0;
        }
    }
    
    return rows;
}

/*
- (void)configureMWCell:(mWFieldCell *)cell {
    NSString *bufferMWAmount = (selectedBuffer.bufferMW == nil) ? @"" : selectedBuffer.bufferMW;
    if (self.editing) {
        cell.textField.text = bufferMWAmount;
    } else {
        if ([bufferMWAmount isEqualToString:@""]) bufferMWAmount = @"0";
        cell.textField.text = [NSString stringWithFormat:@"%@ g/mol", bufferMWAmount];
    }
}

- (void)configureEditingCell:(EditingTableCell *)cell {
    NSString *bufferConcTitle = (selectedBuffer.bufferUnit == nil) ? @"M" : selectedBuffer.bufferUnit;
    [cell.unitButton setTitle:bufferConcTitle forState:UIControlStateNormal];
    
    NSString *bufferConcAmount = (selectedBuffer.bufferStockConc == nil) ? @"" : selectedBuffer.bufferStockConc;
    
    if (self.editing) {
        cell.textField.text = bufferConcAmount;
    } else {
        if ([bufferConcAmount isEqualToString:@""]) bufferConcAmount = @"0";
//        cell.textField.text = [NSString stringWithFormat:@"%@ %@", bufferConcAmount, bufferConcTitle];
        cell.textField.text = bufferConcAmount;
    }
}

- (void)configureVolumeCell:(VolumeEditingCell *)cell {
    NSString *bufferVolumeTitle = (selectedBuffer.bufferVolumeUnit == nil) ? @"L" : selectedBuffer.bufferVolumeUnit;
    [cell.unitButton setTitle:bufferVolumeTitle forState:UIControlStateNormal];
    
    NSString *bufferAmount = (selectedBuffer.bufferVolume == nil) ? @"" : selectedBuffer.bufferVolume;
    if (self.editing) {
        cell.textField.text = bufferAmount;
    } else {
        if ([bufferAmount isEqualToString:@""]) bufferAmount = @"0";
//        cell.textField.text = [NSString stringWithFormat:@"%@ %@", bufferAmount, bufferVolumeTitle];
        cell.textField.text = bufferAmount;
    }
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {        
    EditingTableCell *cell = nil;
    VolumeEditingCell *cell2 = nil;
    UITableViewCell *cell3 = nil;
    mWFieldCell *cell4 = nil;
    InstructionToggleCell *cell5 = nil;
    
    static NSString *InfoIdentifier = @"EditingCell";
    static NSString *VolumeIdentifier = @"VolumeEditingCell";
    static NSString *GenericIdentifier = @"GenericCell";
    static NSString *MWIdentifier = @"MWEditingCell";
    static NSString *StateToggleCell = @"StateToggleCell";
    
    if (indexPath.section == INFO_SECTION) {
        if (indexPath.row == MW_ROW) {
            cell4 = (mWFieldCell *)[tableView dequeueReusableCellWithIdentifier:MWIdentifier];
            if (cell4 == nil) {
                cell4 = [[mWFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MWIdentifier withReagent:self.selectedBuffer withAttributeString:@"bufferMW"];
            }
            return cell4;
        } else if (indexPath.row == VOLUME_ROW) {
            cell2 = (VolumeEditingCell *)[tableView dequeueReusableCellWithIdentifier:VolumeIdentifier];
            if (cell2 == nil) {
                cell2 = [[VolumeEditingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VolumeIdentifier withReagent:self.selectedBuffer withAttributeString:@"bufferVolume" withUnitString:@"bufferVolumeUnit"];
                cell2.label.text = @"Volume";
                cell2.textField.placeholder = @"Volume";
                cell2.delegate = self;
            }
            return cell2;
        } else if (indexPath.row == CONC_ROW) {
            cell = (EditingTableCell *)[tableView dequeueReusableCellWithIdentifier:InfoIdentifier];
            if (cell == nil) {
                cell = [[EditingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoIdentifier withReagent:self.selectedBuffer withAttributeString:@"bufferStockConc" withUnitString:@"bufferUnit"];
                [cell.unitButton addTarget:self action:@selector(showUnitPicker:) forControlEvents:UIControlEventTouchDown];
                cell.label.text = @"Stock";
                cell.textField.placeholder = @"Stock Volume";
            }
            return cell;
        } else if (indexPath.row == 3) {
            cell5 = (InstructionToggleCell *)[tableView dequeueReusableCellWithIdentifier:StateToggleCell];
            if (cell5 == nil) {
                cell5 = [[InstructionToggleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StateToggleCell];
            }
            cell5.customSwitch.on = [selectedBuffer.bufferIsSolid boolValue];
            [cell5.customSwitch addTarget:self action:@selector(toggleStatusSecton:) forControlEvents:UIControlEventValueChanged];
            //[cell5.toggleSwitch addTarget:self action:@selector(toggleStatusSecton:) forControlEvents:UIControlEventValueChanged];
            return cell5;
        } else return nil;
    } 
    
    if (indexPath.section == STATUS_SECTION && [selectedBuffer.bufferIsSolid boolValue]) {
        cell3 = [tableView dequeueReusableCellWithIdentifier:GenericIdentifier];
        if (!cell3) {
            cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GenericIdentifier];
            cell3.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
            // Allowing multiple lines
            cell3.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
            cell3.textLabel.numberOfLines = 0;
            //            [cell3.textLabel sizeToFit];
        }
        if (self.editing) {
            cell3.textLabel.text = @"Editing ... ";
        } else {
            cell3.textLabel.text = [selectedBuffer calculateWeight];
        }
        return cell3;
    } else return nil;
}

- (void)toggleStatusSecton:(id)sender {
    
    UISwitch *aSwitch = (UISwitch *)sender;
    
    selectedBuffer.bufferIsSolid = [NSNumber numberWithBool:aSwitch.isOn];
    
    if ([selectedBuffer.bufferIsSolid boolValue]) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:STATUS_SECTION] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:STATUS_SECTION] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == STATUS_SECTION && indexPath.row == 0 && !self.editing) {
        NSString *instructionMessage = [selectedBuffer calculateWeight];
        CGSize size1 = [instructionMessage sizeWithFont:[UIFont boldSystemFontOfSize:16.0] constrainedToSize:CGSizeMake(280, 300.0) lineBreakMode:UILineBreakModeTailTruncation];
        if (size1.height > 20.0) {
            return size1.height + 22.0;
        }
    }
    return 44.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == STATUS_SECTION) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - FooterView Delegates
- (void)prepareMakeDilution {
    BufferDilutionViewController *dilutionController = [[BufferDilutionViewController alloc] initWithStyle:UITableViewStyleGrouped];
    dilutionController.selectedBuffer = self.selectedBuffer;
    dilutionController.context = self.context;
    dilutionController.shouldEditing = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dilutionController];

    // Formatting navigationBar
    nav.navigationBar.barStyle = UIBarStyleBlack;
    dilutionController.navigationItem.title = @"Dilution";
    
    [self presentModalViewController:nav animated:YES];
}

- (void)prepareDelete {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil, nil];
//    UITabBarController *rootTabBarController = [(LabRecipesAppDelegate *)[[UIApplication sharedApplication]delegate] tabBarController];
//    [actionSheet showFromTabBar:rootTabBarController.tabBar];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet delegate
- (void) deleteBuffer {
    [context deleteObject:selectedBuffer];
    
    NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	} else {
        NSLog(@"Buffer deleted");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self deleteBuffer];
    }
}

#pragma mark - Unit Button Selector
- (void)showUnitPicker:(id)sender {
    senderButton = (UIButton *)sender;
    
    UIView *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
    
    if (!unitController) {
        unitController = [[UnitSelectionViewController alloc] initWithNibName:nil bundle:nil];
    }
    unitController.unit = (selectedBuffer.bufferUnit == nil) ? @"M" : selectedBuffer.bufferUnit;
    unitController.delegate = self;
    
    [self presentSemiModalViewController:unitController];
}

#pragma mark - Unit Picker Delegates
- (void)saveButtonPressed:(NSString *)unit isMolar:(BOOL)molar withMagnitude:(double)magnitude {
    selectedBuffer.bufferMagnitude = [NSNumber numberWithDouble:magnitude];
    selectedBuffer.bufferIsMolar = [NSNumber numberWithBool:molar];
    selectedBuffer.bufferUnit = unit;
    [senderButton setTitle:unit forState:UIControlStateNormal];
    [self dismissSemiModalViewController:unitController];
}

- (void)cancelButtonPressed {
    [self dismissSemiModalViewController:unitController];
}

#pragma mark - Volume Button Selector
- (void)unitSelected:(NSString *)newUnit withMagnitude:(NSNumber *)magnitude {
    selectedBuffer.bufferVolumeUnit = newUnit;
    selectedBuffer.bufferVolumeMagnitude = magnitude;
}

@end