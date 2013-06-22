//
//  IngredientDetailViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabRecipesHelper.h"
@class Recipe, Ingredient, UnitSelectionViewController;

@interface IngredientDetailViewController : UITableViewController <YXUnitSelectionDelegate, UITextFieldDelegate> {
    NSManagedObjectContext *context;
    Recipe *recipe;
    Ingredient *ingredient;
    
    BOOL displayFooter;
    UIView *footerView;
}

@property (strong, nonatomic) NSManagedObjectContext *context;
@property(strong, nonatomic) Recipe *recipe;
@property(strong, nonatomic) Ingredient *ingredient;

@property(strong, nonatomic) UnitSelectionViewController *unitController;
@property(assign, nonatomic) BOOL saveMode;

- (id)initWithStyle:(UITableViewStyle)style context:(NSManagedObjectContext *)aContext recipe:(Recipe *)aRecipe ingredient:(Ingredient *)anIngred saveMode:(BOOL)shouldSave;

@end
