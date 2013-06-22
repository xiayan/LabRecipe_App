//
//  UnitSelectionViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UnitSelectionViewController.h"

@implementation UnitSelectionViewController
@synthesize segmentedControl, unitPicker, pickerContainer, unit;
@synthesize separatorLabel;
@synthesize delegate;
@synthesize segmentToolBar;

static const double scale = 1e-3;
static double magnitude;
static int firstNum = 1;
static int secondNum = 1;
static int molarNum = 1;

#define MOLAR_INDEX 0
#define WEIGHT_INDEX 1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        weightUnits = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"g"], 
                       [NSString stringWithFormat:@"mg"],
                       [NSString stringWithFormat:@"μg"],
                       [NSString stringWithFormat:@"ng"], nil];
        molarUnits = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"M"], 
                      [NSString stringWithFormat:@"mM"],
                      [NSString stringWithFormat:@"μM"],
                      [NSString stringWithFormat:@"nM"],nil];
        volumeUnits = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"L"], 
                      [NSString stringWithFormat:@"mL"],
                      [NSString stringWithFormat:@"μL"],
                      [NSString stringWithFormat:@"nL"],nil];
        selectedSegment = MOLAR_INDEX;
    }
    return self;
}

- (void)choosePickerSelection {
    if ([self.unit rangeOfString:@"/"].location == NSNotFound) {
        selectedSegment = MOLAR_INDEX;
        molarNum = [molarUnits indexOfObject:unit];
        firstNum = 1;
        secondNum = 1;
    } else {
        selectedSegment = WEIGHT_INDEX;
        NSArray *choosenUnit = [self.unit componentsSeparatedByString:@"/"];
        NSString *firstUnit = [choosenUnit objectAtIndex:0];
        NSString *secondUnit = [choosenUnit objectAtIndex:1];
        
        firstNum = [weightUnits indexOfObject:firstUnit];
        secondNum = [volumeUnits indexOfObject:secondUnit];
        molarNum = 1;
    }
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.segmentedControl = nil;
    self.unitPicker = nil;
    self.pickerContainer = nil;
    self.separatorLabel = nil;
    self.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self choosePickerSelection];
    self.segmentedControl.selectedSegmentIndex = selectedSegment;
    separatorLabel.hidden = YES;
    
    if (selectedSegment == WEIGHT_INDEX) {
        [self.unitPicker selectRow:firstNum inComponent:0 animated:NO];
        [self.unitPicker selectRow:secondNum inComponent:2 animated:NO];
        separatorLabel.hidden = NO;
    } else {
        [self.unitPicker selectRow:molarNum inComponent:0 animated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)synthesizeUnitString {
    NSString *finalUnit = nil;
    
    if (selectedSegment == WEIGHT_INDEX) {
        NSInteger frontNumber = [unitPicker selectedRowInComponent:0];
        NSInteger rearNumber = [unitPicker selectedRowInComponent:2];
        
        // update the magnitude of the unit
        magnitude = pow(scale, frontNumber) / pow(scale, rearNumber);
        
        NSString *frontUnit = [weightUnits objectAtIndex:frontNumber];
        NSString *rearUnit = [volumeUnits objectAtIndex:rearNumber];
        
        finalUnit = [NSString stringWithFormat:@"%@/%@", frontUnit, rearUnit];
        
    } else {        
        NSInteger selectedNumber = [unitPicker selectedRowInComponent:0];
        magnitude = pow(scale, selectedNumber);
        finalUnit = [molarUnits objectAtIndex:selectedNumber];
    }
    
    return finalUnit;
}

- (void)saveUnit:(id)sender {
    NSString *anUnit = [self synthesizeUnitString];
    BOOL isMolar = ([anUnit rangeOfString:@"/"].location == NSNotFound);
    [self.delegate saveButtonPressed:anUnit isMolar:isMolar withMagnitude:magnitude];
}

- (void)cancelUnit:(id)sender {
    [self.delegate cancelButtonPressed];
}

- (void)toggleUnit:(id)sender {
    selectedSegment = [segmentedControl selectedSegmentIndex];
    if (selectedSegment == WEIGHT_INDEX) {
        separatorLabel.hidden = NO;
    } else {
        separatorLabel.hidden = YES;
    }
    
    [self.unitPicker reloadAllComponents];
}

#pragma mark -
#pragma mark PickerView Delegate and DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (selectedSegment == WEIGHT_INDEX) {
        return 3;
    } else if (selectedSegment == MOLAR_INDEX) {
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (selectedSegment == WEIGHT_INDEX) {
        if (component == 1) {
            return 0;
        }
        return 4;
    } else if (selectedSegment == MOLAR_INDEX) {
        return 4;
    } else return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 80, 32);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:28]];
    }
    
    if (selectedSegment == WEIGHT_INDEX) {
        if (component == 0) {
            [pickerLabel setText:[weightUnits objectAtIndex:row]];
        } else if (component == 2) {
            [pickerLabel setText:[volumeUnits objectAtIndex:row]];
        } else {
            [pickerLabel setText:nil];
        }
    } else if (selectedSegment == MOLAR_INDEX) {
        [pickerLabel setText:[molarUnits objectAtIndex:row]];
    }
    
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width = 0.0;
    if (selectedSegment == WEIGHT_INDEX) {
        switch (component) {
            case 0:
            case 2:
                width = 120.0;
                break;
            case 1:
                width = 30.0;
                break;
            default:
                break;
        }
    } else if (selectedSegment == MOLAR_INDEX) {
        width = 270.0;
    }
    return width;
}

@end