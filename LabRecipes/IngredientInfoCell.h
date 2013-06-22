//
//  IngredientInfoCell.h
//  LabRecipes
//
//  Created by Yan Xia on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Ingredient, Recipe;

@interface IngredientInfoCell : UITableViewCell {
    UILabel *molarInfo;
    UILabel *volumeInfo;
    
    Ingredient *selectedIngredient;
    const Recipe *recipe;
}

@property (strong, nonatomic) UILabel *molarInfo;
@property (strong, nonatomic) UILabel *volumeInfo;

@property (strong, nonatomic) Ingredient *selectedIngredient;
@property (strong, nonatomic) Recipe *recipe;

@property (assign, nonatomic) CGSize molarSize;
@property (assign, nonatomic) CGSize volumeSize;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIngredient:(Ingredient *)anIngredient withRecipe:(Recipe *)aRecipe;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withRecipe:(Recipe *)aRecipe;

@end
