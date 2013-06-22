//
//  NameFieldCell.h
//  LabRecipes
//
//  Created by Yan Xia on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mWFieldCell : UITableViewCell {
    UILabel *label;
    UITextField *textField;
    UIView *lineView;
    UILabel *unitLabel;
    
    NSManagedObject *reagent;
    NSString *attributeString;
}

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *unitLabel;
@property (strong, nonatomic) NSManagedObject *reagent;
@property (strong, nonatomic) NSString *attributeString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withReagent:(NSManagedObject *)aReagent withAttributeString:(NSString *)string1;

@end
