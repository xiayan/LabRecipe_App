//
//  BufferDilutionViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BufferDilutionViewController.h"
#import "EditingTableCell.h"
#import "VolumeEditingCell.h"
#import "Buffer.h"

#define INFO_SECTION 0
#define INSTRUCTION_SECTION 1
#define CONC_ROW 0
#define VOLUME_ROW 1

@implementation BufferDilutionViewController
@synthesize unitController, selectedBuffer, context;
@synthesize shouldEditing;

static UIButton *senderButton;

//static float finalConc;
//static float finalVolume;
//static float concMagnitude;
//static float volumeMagnitude;

//static NSString *concUnit;
//static NSString *volumeUnit;
//static NSString *instruction;

//static BOOL concEntered = NO;
//static BOOL volumeEntered = NO;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.shouldEditing = NO;
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:INSTRUCTION_SECTION]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - View lifecycle
- (void)cancelDilutionView {
    if (tempBuffer) {
        [context deleteObject:tempBuffer];
        NSLog(@"tempBuffer deleted");
        
        /*
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        */
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDilutionView)];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    if (tempBuffer) {
        [context deleteObject:tempBuffer];
        NSLog(@"tempBuffer deleted");
        /*
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        */
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!tempBuffer) {
        tempBuffer = [NSEntityDescription insertNewObjectForEntityForName:@"Buffer" inManagedObjectContext:self.context];
        NSLog(@"tempBuffer created");
    }
    
    tempBuffer.bufferUnit = selectedBuffer.bufferUnit;
    tempBuffer.bufferVolumeUnit = selectedBuffer.bufferVolumeUnit;
    tempBuffer.bufferMagnitude = selectedBuffer.bufferMagnitude;
    tempBuffer.bufferVolumeMagnitude = selectedBuffer.bufferVolumeMagnitude;
    tempBuffer.bufferIsMolar = selectedBuffer.bufferIsMolar;
    
    if (shouldEditing) {
        [self setEditing:YES animated:YES];
        shouldEditing = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)allFieldsEntered {
    BOOL filled = YES;
    if (tempBuffer.bufferStockConc == nil || [tempBuffer.bufferStockConc isEqualToString:@""]) {
        filled = NO;
    }
    if (tempBuffer.bufferVolume == nil || [tempBuffer.bufferVolume isEqualToString:@""]) {
        filled = NO;
    }
    return filled;
}

- (NSString *)calculateFinalVolume {
    NSString *message;
    
    if ([self allFieldsEntered]) {
        message = [selectedBuffer calculateDilution:tempBuffer];
    } else {
        message = @"Fields missing";
    }
    
    /*
    float stockTotoal = [selectedBuffer.bufferStockConc floatValue] * [selectedBuffer.bufferMagnitude floatValue];
    if (dilutionTotal > stockTotoal) {
        message = @"Dilution is more concentrated than stock";
    } else {
        float volume = dilutionTotal * finalVolume * volumeMagnitude / stockTotoal;
        message = [NSString stringWithFormat:@"Dilute %gL Stock", volume];
    }
    
    NSLog(@"conc: %f, volume:%f, concMagnitude:%f, volumeMag:%f", finalConc, finalVolume, concMagnitude, volumeMagnitude);
    instruction = message;
    */
    
    return message;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    if (section == INFO_SECTION) {
        title = @"Diluent Info";
    } else {
        title = @"Instruction";
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    
    if (section == INFO_SECTION) {
        row = 2;
    } else {
        row = 1;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *EditingCell = @"EditingCell";
    static NSString *VolumeCell = @"VolumeCell";
    static NSString *GenericCell = @"GenericCell";
    
    EditingTableCell *cell1 = (EditingTableCell *)[tableView dequeueReusableCellWithIdentifier:EditingCell];
    VolumeEditingCell *cell2 = (VolumeEditingCell *)[tableView dequeueReusableCellWithIdentifier:VolumeCell];
    UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:GenericCell];
    
    if (cell1 == nil) {
        cell1 = [[EditingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EditingCell withReagent:tempBuffer withAttributeString:@"bufferStockConc" withUnitString:@"bufferUnit"];
        [cell1.unitButton setTitle:self.selectedBuffer.bufferUnit forState:UIControlStateNormal];
    }
    if (cell2 == nil) {
        cell2 = [[VolumeEditingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VolumeCell withReagent:tempBuffer withAttributeString:@"bufferVolume" withUnitString:@"bufferVolumeUnit"];
        [cell2.unitButton setTitle:selectedBuffer.bufferVolumeUnit forState:UIControlStateNormal];
    }
    if (cell3 == nil) {
        cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GenericCell];
        cell3.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        cell3.textLabel.numberOfLines = 0;
    }
    
    if (indexPath.section == INFO_SECTION) {
        if (indexPath.row == CONC_ROW) {
            cell1.label.text = @"Final";
            [cell1.unitButton addTarget:self action:@selector(showUnitPicker:) forControlEvents:UIControlEventTouchDown];
        //    [self configureEditingCell:cell1];
            return cell1;
        } else {
            cell2.label.text = @"Volume";
            cell2.delegate = self;
            
            //[self configureVolumeCell:cell2];
            return cell2;
        }
    } else {
        if (self.editing) {
            cell3.textLabel.text = @"Entering ... ";
        } else {
            cell3.textLabel.text = [self calculateFinalVolume];
        }
        return cell3;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == INSTRUCTION_SECTION) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == INSTRUCTION_SECTION && indexPath.row == 0 && !self.editing) {
        NSString *newText = [self calculateFinalVolume];
        CGSize size1 = [newText sizeWithFont:[UIFont boldSystemFontOfSize:20] forWidth:350.0 lineBreakMode:UILineBreakModeCharacterWrap];
        if (size1.width > 330.0) {
            return 66.0;
        }
    }
    return 44.0;
}

- (void)showUnitPicker:(id)sender {
    senderButton = (UIButton *)sender;
    
    UIView *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
    
    if (!unitController) {
        unitController = [[UnitSelectionViewController alloc] initWithNibName:nil bundle:nil];
    }
    unitController.unit = (tempBuffer.bufferUnit == nil) ? @"M" : tempBuffer.bufferUnit;
    unitController.delegate = self;
    
    [self presentSemiModalViewController:unitController];
    // hide segmentControll so that user cannot choose other unit style
//    unitController.segmentToolBar.hidden = YES;
}

#pragma mark - Unit Selection Delegates
- (void)saveButtonPressed:(NSString *)unit isMolar:(BOOL)molar withMagnitude:(double)magnitude {
    [senderButton setTitle:unit forState:UIControlStateNormal];
    tempBuffer.bufferUnit = unit;
    tempBuffer.bufferIsMolar = [NSNumber numberWithBool:molar];
    tempBuffer.bufferMagnitude = [NSNumber numberWithDouble:magnitude];
    [self dismissSemiModalViewController:self.unitController];
}

- (void)cancelButtonPressed {
    [self dismissSemiModalViewController:self.unitController];
}

#pragma mark - Volume Button Method
- (void)unitSelected:(NSString *)newUnit withMagnitude:(NSNumber *)magnitude {
    tempBuffer.bufferVolumeUnit = newUnit;
    tempBuffer.bufferVolumeMagnitude = magnitude;
}

@end
