//
//  SecondDilutionViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondDilutionViewController : UIViewController <UITextFieldDelegate>
{
    float stockConc;
    UITextField *finalConc;
    UITextField *finalVolume;
    UILabel *statusLabel;
}

@property (strong, nonatomic) IBOutlet UITextField *finalConc;
@property (strong, nonatomic) IBOutlet UITextField *finalVolume;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

- (id)initWithStockConc:(float)conc;
- (IBAction)goBack:(id)sender;

@end
