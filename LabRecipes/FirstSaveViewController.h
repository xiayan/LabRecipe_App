//
//  FirstSaveViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UICustomSwitch;

@interface FirstSaveViewController : UIViewController <UITextFieldDelegate> {
    id delegate;
    NSString *showingName;
}

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property(strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) NSString *showingName;

@property(strong, nonatomic) IBOutlet UILabel *stateLabel;
@property(strong, nonatomic) IBOutlet UICustomSwitch *customSwitch;
@property(assign, nonatomic) BOOL showToggleViews;
@property(assign, nonatomic) BOOL isSolid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil hideToggleView:(BOOL)hide;
- (id)delegate;
- (void)setDelegate:(id)anObject;

- (IBAction)toggleValueChanged:(id)sender;

@end