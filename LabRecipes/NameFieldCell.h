//
//  NameFieldCell.h
//  LabRecipes
//
//  Created by Yan Xia on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
// Simply a textField on the cell

#import <UIKit/UIKit.h>

@interface NameFieldCell : UITableViewCell {
    UITextField *textField;
}

@property (strong, nonatomic) UITextField *textField;

@end
