//
//  NameFieldCell.m
//  LabRecipes
//
//  Created by Yan Xia on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NameFieldCell.h"

@implementation NameFieldCell
@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = UITextAlignmentLeft;
        textField.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect superBound = self.contentView.bounds;
    CGRect frame = CGRectMake((superBound.origin.x + 15), (superBound.origin.y + 10), 291, 31);
    textField.frame = frame;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
}

@end
