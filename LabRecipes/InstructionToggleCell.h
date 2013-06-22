//
//  InstructionToggleCell.h
//  LabRecipes
//
//  Created by Yan Xia on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Buffer, UICustomSwitch;

@interface InstructionToggleCell : UITableViewCell {
    
    UILabel *stateLabel;
    UISwitch *toggleSwitch;
    UICustomSwitch *customSwitch;
    
    UIView *lineView;
}

@property(strong, nonatomic) UILabel *stateLabel;
@property(strong, nonatomic) UISwitch *toggleSwitch;
@property(strong, nonatomic) UICustomSwitch *customSwitch;

@end
