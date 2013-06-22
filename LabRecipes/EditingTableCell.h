//
//  EditingTableCell.h
//  LabRecipes
//
//  Created by Yan Xia on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingTableCell : UITableViewCell {
    UILabel *label;
    UILabel *unitLabel;
	UITextField *textField;
    UIButton *unitButton;
    
    UIView *lineView;
    
    NSManagedObject *reagent;
    NSString *attributeString;
    NSString *unitString;
}

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *unitButton;

@property (nonatomic, strong) NSManagedObject *reagent;
@property (nonatomic, strong) NSString *attributeString;
@property (nonatomic, strong) NSString *unitString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
        withReagent:(NSManagedObject *)aReagent withAttributeString:(NSString *)string1 
        withUnitString:(NSString *)string2;

@end
