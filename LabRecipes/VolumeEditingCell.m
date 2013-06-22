//
//  VolumeEditingCell.m
//  Test
//
//  Created by Yan Xia on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VolumeEditingCell.h"
@interface VolumeEditingCell (SubViewFrames)
- (CGRect)_unitLabelFrame;
- (CGRect)_lButtonFrame;
- (CGRect)_mlButtonFrame;
- (CGRect)_microlButtonFrame;
@end


@implementation VolumeEditingCell
@synthesize lButton, mlButton, microlButton;
@synthesize delegate;

static NSString *Background = @"green_button_2";
static const double scale = 1e-3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withReagent:(NSManagedObject *)aReagent withAttributeString:(NSString *)string1 withUnitString:(NSString *)string2 {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier withReagent:aReagent withAttributeString:string1 withUnitString:string2];
    
    if (self) {
        self.textField.placeholder = @"Volume";
        
        [self.unitButton setTitle:@"L" forState:UIControlStateNormal];
        [self.unitButton addTarget:self action:@selector(showVolumes) forControlEvents:UIControlEventTouchDown];
        
        self.lButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [lButton setBackgroundImage:[UIImage imageNamed:Background] forState:UIControlStateNormal];
        [lButton setTitle:@"L" forState:UIControlStateNormal];
        [lButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [lButton.titleLabel setTextColor:[UIColor whiteColor]];
        [lButton addTarget:self action:@selector(volumeSelected:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:lButton];
        
        self.mlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mlButton setBackgroundImage:[UIImage imageNamed:Background] forState:UIControlStateNormal];
        [mlButton setTitle:@"mL" forState:UIControlStateNormal];
        [mlButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [mlButton.titleLabel setTextColor:[UIColor whiteColor]];
        [mlButton addTarget:self action:@selector(volumeSelected:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:mlButton];
        
        self.microlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [microlButton setBackgroundImage:[UIImage imageNamed:Background] forState:UIControlStateNormal];
        [microlButton setTitle:@"μL" forState:UIControlStateNormal];
        [microlButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [microlButton.titleLabel setTextColor:[UIColor whiteColor]];
        [microlButton addTarget:self action:@selector(volumeSelected:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:microlButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.unitLabel.frame = [self _unitLabelFrame];
    self.unitLabel.text = [reagent valueForKey:unitString];
    
    microlButton.frame = [self _microlButtonFrame];
    mlButton.frame = [self _microlButtonFrame];
    lButton.frame = [self _microlButtonFrame];
    
    microlButton.hidden = YES;
    mlButton.hidden = YES;
    lButton.hidden = YES;
    
    if (!self.editing) {
        textField.hidden = NO;
    }
}

- (void)toggleButtons:(NSNumber *)number {
    BOOL shouldHide = [number boolValue];
    unitButton.hidden = shouldHide;
    textField.hidden = shouldHide;
    microlButton.hidden = !shouldHide;
    mlButton.hidden = !shouldHide;
    lButton.hidden = !shouldHide;
}

- (void)showVolumes {
    [self toggleButtons:[NSNumber numberWithBool:YES]];
    
    label.text = @"Unit";
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    mlButton.frame = [self _mlButtonFrame];
    lButton.frame = [self _lButtonFrame];
    [UIView commitAnimations];
}

- (void)volumeSelected:(id)sender {
    UIButton *pressedButton =  (UIButton *)sender;
    NSString *title = pressedButton.titleLabel.text;
    double magnitude = 0.0;
    if ([title isEqualToString:@"L"]) {
        magnitude = pow(scale, 0.0);
    } else if ([title isEqualToString:@"mL"]) {
        magnitude = pow(scale, 1.0);
    } else if ([title isEqualToString:@"μL"]) {
        magnitude = pow(scale, 2.0);
    }
    
    [unitButton setTitle:title forState:UIControlStateNormal];
    label.text = @"Volume";
    
    [self.delegate performSelector:@selector(unitSelected:withMagnitude:) withObject:title withObject:[NSNumber numberWithDouble:magnitude]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    mlButton.frame = [self _microlButtonFrame];
    lButton.frame = [self _microlButtonFrame];
    [UIView commitAnimations];
    
    [self performSelector:@selector(toggleButtons:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.5];
}

#define BUTTON_WIDTH 48.0
#define BUTTON_RIGHT_MARGIN 10.0
#define BUTTON_Y 11.0

- (CGRect)_unitLabelFrame {
    NSString *textString = @"mL/2";
    NSString *unit;
    
    if ((unit = [reagent valueForKey:unitString])) {
        textString = unit;
    }
    
    CGSize unitSize = [textString sizeWithFont:[UIFont systemFontOfSize:16.0] forWidth:70.0 lineBreakMode:UILineBreakModeTailTruncation];
    CGRect theFrame = self.textField.frame;
    return CGRectMake(theFrame.origin.x + theFrame.size.width + 5.0, 
                      10.0, unitSize.width + 10.0, 27.0);
}

- (CGRect)_microlButtonFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - BUTTON_WIDTH - BUTTON_RIGHT_MARGIN, BUTTON_Y, BUTTON_WIDTH, 27.0);
}

- (CGRect)_mlButtonFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - 2 * BUTTON_WIDTH - BUTTON_RIGHT_MARGIN - 0.5, BUTTON_Y, BUTTON_WIDTH, 27.0);
}

- (CGRect)_lButtonFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - 3 * BUTTON_WIDTH - BUTTON_RIGHT_MARGIN - 1.0, BUTTON_Y, BUTTON_WIDTH, 27.0);
}

@end