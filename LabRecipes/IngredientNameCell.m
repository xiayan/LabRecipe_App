//
//  IngredientNameCell.m
//  LabRecipes
//
//  Created by Yan Xia on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IngredientNameCell.h"

@implementation IngredientNameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
        withReagent:(NSManagedObject *)aReagent 
withAttributeString:(NSString *)string1 {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier withReagent:aReagent withAttributeString:string1];
    if (self) {
        [self.unitLabel removeFromSuperview];
        self.label.text = @"Name";
        self.textField.placeholder = @"Reagent Name";
    }
    return self;
}

#define EDITING_INSET 10.0
#define LABEL_X 5.0
#define LABEL_WIDTH 90.0
#define TEXT_LEFT_MARGIN 25.0
#define TEXTFIELD_WIDTH 145.0
#define TEXTFIELD_HEIGHT 31.0

- (CGRect)textFieldFrame {

    return CGRectMake(-EDITING_INSET + LABEL_X + LABEL_WIDTH + TEXT_LEFT_MARGIN, 
                      14.0, TEXTFIELD_WIDTH, 27.0);
}

@end
