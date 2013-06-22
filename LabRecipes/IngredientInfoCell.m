//
//  IngredientInfoCell.m
//  LabRecipes
//
//  Created by Yan Xia on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IngredientInfoCell.h"
#import "Recipe.h"
#import "Ingredient.h"

@interface IngredientInfoCell (cellFrames) 
- (CGRect)molarInfoFrame;
- (CGRect)volumeInfoFrame;
@end

@implementation IngredientInfoCell
@synthesize molarInfo, volumeInfo;
@synthesize selectedIngredient, recipe;
@synthesize molarSize, volumeSize;

- (NSString *)textForMolarLabel {
    return [NSString stringWithFormat:@"%g%@ %@", [selectedIngredient.ingredientFinalConc floatValue], selectedIngredient.ingredientFinalUnit, selectedIngredient.ingredientName];
}

- (NSString *)textForVolumeLabel {
    NSString *message;
    if (self.recipe.recipeVolume == nil || [self.recipe.recipeVolume isEqualToString:@""]) {
        message = @"Volume Required";
    } else {
        double finalVolume = [recipe.recipeVolume doubleValue] * [recipe.recipeMagnitude doubleValue];
        message = [selectedIngredient calculateDilution:finalVolume];
    }
    return message;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIngredient:(Ingredient *)anIngredient withRecipe:(Recipe *)aRecipe
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedIngredient = anIngredient;
        self.recipe = aRecipe;
        
        molarInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        molarInfo.numberOfLines = 0;
        molarInfo.lineBreakMode = UILineBreakModeTailTruncation;
        molarInfo.backgroundColor = [UIColor clearColor];
        molarInfo.font = [UIFont boldSystemFontOfSize:18.0];
        molarInfo.textColor = [UIColor blackColor];
        molarInfo.textAlignment = UITextAlignmentLeft;
        molarInfo.text = [self textForMolarLabel];
        [self.contentView addSubview:self.molarInfo];
        
        volumeInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        molarInfo.numberOfLines = 0;
        molarInfo.lineBreakMode = UILineBreakModeTailTruncation;
        volumeInfo.backgroundColor = [UIColor clearColor];
        volumeInfo.font = [UIFont systemFontOfSize:16.0];
        volumeInfo.textColor = [UIColor blackColor];
        volumeInfo.textAlignment = UITextAlignmentRight;
        volumeInfo.text = [self textForVolumeLabel];
        [self.contentView addSubview:self.volumeInfo];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withRecipe:(Recipe *)aRecipe {
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.recipe = aRecipe;
        
        molarInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        molarInfo.numberOfLines = 0;
        molarInfo.lineBreakMode = UILineBreakModeTailTruncation;
        molarInfo.backgroundColor = [UIColor clearColor];
        molarInfo.font = [UIFont boldSystemFontOfSize:18.0];
        molarInfo.textColor = [UIColor blackColor];
        molarInfo.textAlignment = UITextAlignmentLeft;
        molarInfo.text = [self textForMolarLabel];
        [self.contentView addSubview:self.molarInfo];
        
        volumeInfo = [[UILabel alloc] initWithFrame:CGRectZero];
        molarInfo.numberOfLines = 0;
        molarInfo.lineBreakMode = UILineBreakModeTailTruncation;
        volumeInfo.backgroundColor = [UIColor clearColor];
        volumeInfo.font = [UIFont systemFontOfSize:16.0];
        volumeInfo.textColor = [UIColor blackColor];
        volumeInfo.textAlignment = UITextAlignmentRight;
        volumeInfo.text = [self textForVolumeLabel];
        [self.contentView addSubview:self.volumeInfo];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    molarInfo.text = [self textForMolarLabel];
    if (!self.editing) {
        volumeInfo.text = [self textForVolumeLabel];
    }
    self.molarInfo.frame = [self molarInfoFrame];
    self.volumeInfo.frame = [self volumeInfoFrame];
}

#define LABEL_Y 10.0
#define LEFT_INSET 30.0
#define DIST_FROM_RIGHT 15.0

- (CGSize)molarSize {
    NSString *message = [self textForMolarLabel];
    CGFloat messageWidth = (self.editing) ? 190 : 155;
    return [message sizeWithFont:[UIFont boldSystemFontOfSize:18.0] constrainedToSize:CGSizeMake(messageWidth, 70.0) lineBreakMode:UILineBreakModeTailTruncation];
}

- (CGSize)volumeSize {
    NSString *message = [self textForVolumeLabel];
    return [message sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(150.0, 70.0) lineBreakMode:UILineBreakModeCharacterWrap];
}

- (CGRect)molarInfoFrame {
    return CGRectMake(10.0, LABEL_Y, self.molarSize.width, self.molarSize.height);
}

- (CGRect)volumeInfoFrame {
    CGSize contentSize = self.contentView.bounds.size;
    if (self.editing) {
        return CGRectZero;
    } else {
        return CGRectMake(contentSize.width - self.volumeSize.width - DIST_FROM_RIGHT, LABEL_Y, self.volumeSize.width, self.volumeSize.height);
    }
}

@end
