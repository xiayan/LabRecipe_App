//
//  UnitSelectionViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXUnitSelectionDelegate
- (void)saveButtonPressed:(NSString *)unit isMolar:(BOOL)molar withMagnitude:(double)magnitude;
- (void)cancelButtonPressed;
@end

@interface UnitSelectionViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    UISegmentedControl *segmentedControl;
    UIPickerView *unitPicker;
    UIView *pickerContainer;
    UILabel *separatorLabel;
    
    id<YXUnitSelectionDelegate> __unsafe_unretained delegate;
    
    NSArray *weightUnits;
    NSArray *molarUnits;
    NSArray *volumeUnits;
    NSString *unit;
    
    int selectedSegment;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIPickerView *unitPicker;
@property (strong, nonatomic) IBOutlet UIView *pickerContainer;
@property (strong, nonatomic) IBOutlet UILabel *separatorLabel;
@property (strong, nonatomic) NSString *unit;
@property (unsafe_unretained) id<YXUnitSelectionDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIToolbar *segmentToolBar;

- (IBAction)saveUnit:(id)sender;
- (IBAction)cancelUnit:(id)sender;
- (IBAction)toggleUnit:(id)sender;

@end
