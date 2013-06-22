//
//  LabRecipesFirstViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabRecipesHelper.h"

@interface LabRecipesFirstViewController : UIViewController <UITextFieldDelegate, YXSaveViewDelegate>
{
    UITextField *mwField;
    UITextField *concField;
    UITextField *volumeField;
    UILabel *statusField;
    
    UIButton *prepareToSaveButton;
    UIButton *clearButton;
}

@property (strong, nonatomic) IBOutlet UITextField *mwField;
@property (strong, nonatomic) IBOutlet UITextField *concField;
@property (strong, nonatomic) IBOutlet UITextField *volumeField;
@property (strong, nonatomic) IBOutlet UILabel *statusField;
@property (strong, nonatomic) IBOutlet UIButton *prepareToSaveButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;

- (IBAction)prepareToSave:(id)sender;
- (IBAction)clearInputs:(id)sender;

@end

