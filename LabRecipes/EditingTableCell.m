//
//  EditingTableCell.m
//  LabRecipes
//
//  Created by Yan Xia on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditingTableCell.h"
#import <QuartzCore/QuartzCore.h>

@interface EditingTableCell (SubviewFrames)
- (CGRect)_labelFrame;
- (CGRect)_unitLabelFrame;
- (CGRect)_textfieldFrame;
- (CGRect)_unitButtonFrame;
- (CGRect)_lineViewFrame;
@end

#pragma mark -
#pragma mark EditingTableCell implementation

@implementation EditingTableCell
@synthesize label, unitLabel, textField, unitButton;
@synthesize reagent, attributeString, unitString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withReagent:(NSManagedObject *)aReagent withAttributeString:(NSString *)string1 withUnitString:(NSString *)string2
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.reagent = aReagent;
        self.attributeString = string1;
        self.unitString = string2;
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textColor = [UIColor blackColor];
        label.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:label];
        
        textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = UITextAlignmentLeft;
        textField.font = [UIFont systemFontOfSize:16.0];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = @"Concentration";
        textField.text = [reagent valueForKey:attributeString];
        [self.contentView addSubview:textField];
        
        lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.autoresizingMask = 0x3f;
        lineView.alpha = 0.0;
        [self.contentView addSubview:lineView];
        
        unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        unitLabel.backgroundColor = [UIColor clearColor];
        unitLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        unitLabel.layer.borderWidth = 1.0;
        unitLabel.font = [UIFont systemFontOfSize:16.0];
        unitLabel.textColor = [UIColor blackColor];
        unitLabel.textAlignment = UITextAlignmentCenter;
        unitLabel.text = [reagent valueForKey:unitString];
        [self.contentView addSubview:unitLabel];
        
        unitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [unitButton setBackgroundImage:[UIImage imageNamed:@"grey_button_2"] forState:UIControlStateNormal];
        [unitButton setTitle:[reagent valueForKey:unitString] forState:UIControlStateNormal];
        [unitButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [unitButton.titleLabel setTextColor:[UIColor whiteColor]];
        unitButton.alpha = 0.0;
        [self.contentView addSubview:unitButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    label.frame = [self _labelFrame];
        
    // save new number when editing ends
    if (reagent != nil) {
        [reagent setValue:textField.text forKey:attributeString];
        unitLabel.text = [reagent valueForKey:unitString];
        [unitButton setTitle:[reagent valueForKey:unitString] forState:UIControlStateNormal];
    }
    textField.frame = [self _textfieldFrame];
    
    lineView.frame = [self _lineViewFrame];
    
    if (self.editing) {
        textField.textAlignment = UITextAlignmentCenter;
        unitButton.frame = [self _unitButtonFrame];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        // first move label to the button position
        unitLabel.frame = [self _unitButtonFrame];
        unitLabel.alpha = 0.0;
        unitButton.alpha = 1.0;
        unitButton.frame = [self _unitButtonFrame];
        lineView.alpha = 1.0;
        [UIView commitAnimations];
        unitButton.enabled = YES;
        textField.enabled = YES;
    } else {
        textField.textAlignment = UITextAlignmentLeft;
        unitLabel.frame = [self _unitLabelFrame];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        unitButton.frame = [self _unitLabelFrame];
        unitButton.alpha = 0.0;
        unitLabel.alpha = 1.0;
        lineView.alpha = 0.0;
        [UIView commitAnimations];
        unitButton.enabled = NO;
        textField.enabled = NO;
    }
}

#define EDITING_INSET 10.0
#define LABEL_X 5.0
#define LABEL_WIDTH 90.0
#define TEXT_LEFT_MARGIN 25.0
#define TEXTFIELD_WIDTH 80.0
#define TEXTFIELD_HEIGHT 60.0
#define BUTTON_WIDTH 65.0
#define BUTTON_RIGHT_MARGIN 10.0
static CGFloat textFieldWidth;

- (CGRect)_labelFrame {
    return CGRectMake(5.0, 10.0, LABEL_WIDTH, 27.0);
}

- (CGRect)_textfieldFrame {
    NSString *conc = nil;
    NSString *textString = @"AREALREALREALREALREALLONGSTRINGHD";
    
    conc = [reagent valueForKey:attributeString];
    if (conc == nil || [conc isEqualToString:@""]) {
        unitLabel.hidden = YES;
    } else {
        textString = conc;
        unitLabel.hidden = NO;
    }
    
    CGSize textSize = [textString sizeWithFont:[UIFont systemFontOfSize:16.0] forWidth:150.0 lineBreakMode:UILineBreakModeTailTruncation];
    textFieldWidth = textSize.width + 5.0;
    if (self.editing) {
        return CGRectMake(-EDITING_INSET + LABEL_X + LABEL_WIDTH + TEXT_LEFT_MARGIN, 12.0, TEXTFIELD_WIDTH, 27.0);
    } else {
        return CGRectMake(LABEL_X + LABEL_WIDTH + TEXT_LEFT_MARGIN, 15.0, textFieldWidth, 27.0);
    }
}

- (CGRect)_unitLabelFrame {
    NSString *unit = nil;
    NSString *textString = nil;
    
    if ((unit = [reagent valueForKey:unitString])) {
        textString = unit;
    }
    
    CGSize unitSize = [textString sizeWithFont:[UIFont systemFontOfSize:16.0] forWidth:70.0 lineBreakMode:UILineBreakModeTailTruncation];
    CGRect theFrame = self.textField.frame;
    return CGRectMake(theFrame.origin.x + theFrame.size.width + 5.0, 
                      10.0, unitSize.width + 10.0, 27.0);
}

- (CGRect)_unitButtonFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - BUTTON_WIDTH - BUTTON_RIGHT_MARGIN, 10.0, BUTTON_WIDTH, 27.0);
}

- (CGRect)_lineViewFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(LABEL_WIDTH + TEXT_LEFT_MARGIN / 2.0, 0.0, 0.8, contentViewBounds.size.height);
}

@end
