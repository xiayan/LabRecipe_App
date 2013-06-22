//
//  NameFieldCell.m
//  LabRecipes
//
//  Created by Yan Xia on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "mWFieldCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation mWFieldCell
@synthesize label, textField, lineView, unitLabel, attributeString, reagent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withReagent:(NSManagedObject *)aReagent withAttributeString:(NSString *)string1
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.reagent = aReagent;
        attributeString = string1;
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"MW";
        label.textAlignment = UITextAlignmentRight;
        label.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:label];
        
        textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = UITextAlignmentLeft;
        textField.placeholder = @"Molecular Weight";
        textField.font = [UIFont systemFontOfSize:16];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.text = [reagent valueForKey:attributeString];
        [self.contentView addSubview:self.textField];
        
        unitLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        unitLabel.backgroundColor = [UIColor clearColor];
        unitLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        unitLabel.layer.borderWidth = 1.0;
        unitLabel.font = [UIFont systemFontOfSize:16.0];
        unitLabel.textColor = [UIColor blackColor];
        unitLabel.textAlignment = UITextAlignmentCenter;
        unitLabel.text = @"g/mol";
        [self.contentView addSubview:unitLabel];
        
        lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = [UIColor lightGrayColor];
        lineView.autoresizingMask = 0x3f;
        [self.contentView addSubview:lineView];
    }
    return self;
}

#define EDITING_INSET 10.0
#define LABEL_X 5.0
#define LABEL_WIDTH 90.0
#define TEXT_LEFT_MARGIN 25.0
#define TEXTFIELD_WIDTH 85.0
#define TEXTFIELD_HEIGHT 31.0
static CGFloat textFieldWidth;

- (CGRect)labelFrame {
    return CGRectMake(5.0, 12.0, LABEL_WIDTH, 27.0);
}

- (CGRect)textFieldFrame {
    NSString *textString = @"AREALLYREALLYREALLYLONGSTRING";
    NSString *conc = nil;
    conc = [reagent valueForKey:attributeString];
    if (conc == nil || [conc isEqualToString:@""]) {
        unitLabel.hidden = YES;
    } else {
        unitLabel.hidden = NO;
        textString = conc;
    }
    
    CGSize textSize = [textString sizeWithFont:[UIFont systemFontOfSize:16.0] forWidth:150.0 lineBreakMode:UILineBreakModeTailTruncation];
    textFieldWidth = textSize.width + 5.0;
    
    if (self.editing) {
        return CGRectMake(-EDITING_INSET + LABEL_X + LABEL_WIDTH + TEXT_LEFT_MARGIN, 14.0, TEXTFIELD_WIDTH, 27.0);
    } else {
        return CGRectMake(LABEL_X + LABEL_WIDTH + TEXT_LEFT_MARGIN, 15.0, textFieldWidth, 27.0);
    }
}

- (CGRect)unitLabelFrame {
    NSString *textString = @"g/mol";
    
    CGSize unitSize = [textString sizeWithFont:[UIFont systemFontOfSize:16.0] forWidth:70.0 lineBreakMode:UILineBreakModeTailTruncation];
    CGRect theFrame = self.textField.frame;
    return CGRectMake(theFrame.origin.x + theFrame.size.width + 5.0, 
                      10.0, unitSize.width + 12.0, 27.0);
}

- (CGRect)lineFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(LABEL_WIDTH + TEXT_LEFT_MARGIN / 2.0, 0.0, 0.8, contentViewBounds.size.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    label.frame = [self labelFrame];
    
    [reagent setValue:textField.text forKey:attributeString];
    textField.frame = [self textFieldFrame];
    unitLabel.frame = [self unitLabelFrame];
    lineView.frame = [self lineFrame];
    
    if (self.editing) {
        textField.textAlignment = UITextAlignmentCenter;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        //unitLabel.hidden = YES;
        lineView.hidden = NO;
        textField.enabled = YES;
        [UIView commitAnimations];
    } else {
        textField.textAlignment = UITextAlignmentLeft;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        //unitLabel.hidden = NO;
        lineView.hidden = YES;
        textField.enabled = NO;
        [UIView commitAnimations];
    }
}

@end