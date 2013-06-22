//
//  SecondDetailViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Buffer, NameHeaderViewController;

@interface SecondDetailViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Buffer *selectedBuffer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *mwField;
@property (strong, nonatomic) IBOutlet UITextField *stockConcField;
@property (strong, nonatomic) IBOutlet UITextField *volumeField;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *dilutionButton;
@property (strong, nonatomic) NameHeaderViewController *nameHeaderController;

- (IBAction)prepareToCalculate:(id)sender;
- (void)changeBorderStyle:(UITextBorderStyle)style Enabled:(BOOL)enable;
- (void)saveChanges;

@end
