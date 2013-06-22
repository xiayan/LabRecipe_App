//
//  InstructionToggleCell.m
//  LabRecipes
//
//  Created by Yan Xia on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InstructionToggleCell.h"
#import "Buffer.h"
#import "UICustomSwitch.h"

@interface InstructionToggleCell (frames)

- (CGRect)stateLabelFrame;
- (CGPoint)toggleSwitchCenter;
- (CGRect)lineViewFrame;

@end

@implementation InstructionToggleCell
@synthesize stateLabel, toggleSwitch, customSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        stateLabel.text = @"State";
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.font = [UIFont boldSystemFontOfSize:20];
        stateLabel.textColor = [UIColor blackColor];
        stateLabel.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:stateLabel];
        
        
//        toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
//        [self.contentView addSubview:toggleSwitch];
        
        customSwitch = [UICustomSwitch switchWithLeftText:@"Solid" andRight:@"Liquid"];
        customSwitch.on = YES;
        [self.contentView addSubview:customSwitch];
        
        lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.autoresizingMask = 0x3f;
        lineView.alpha = 1.0;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    stateLabel.frame = [self stateLabelFrame];
//    toggleSwitch.center = [self toggleSwitchCenter];
    customSwitch.center = [self toggleSwitchCenter];
    lineView.frame = [self lineViewFrame];
}

#define LABEL_WIDTH 90.0

- (CGRect)stateLabelFrame {
    return CGRectMake(5.0, 10.0, 90.0, 27.0);
}

- (CGPoint)toggleSwitchCenter {
    CGPoint center = self.contentView.center;
    return CGPointMake(center.x + 10.0, center.y);
}

- (CGRect)lineViewFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(LABEL_WIDTH + 25.0 / 2.0, 0.0, 0.8, contentViewBounds.size.height);
}

@end
