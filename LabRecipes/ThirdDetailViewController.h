//
//  ThirdDetailViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 1/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabRecipesHelper.h"
#import "SharingTableFooterViewController.h"

@class Recipe, NameHeaderViewController;

@interface ThirdDetailViewController : UITableViewController <UITextFieldDelegate, YXBufferPickerDelegate, YXMakeDilutionandDelete, UIActionSheetDelegate> {
    NSManagedObjectContext *context;
    Recipe *selectedRecipe;
    NSMutableArray *allIngredients;
    
    NameHeaderViewController *headerViewController;
    SharingTableFooterViewController *footerViewController;

    BOOL needsEditing;
}

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Recipe *selectedRecipe;
@property (strong, nonatomic) NSMutableArray *allIngredients;
@property (strong, nonatomic) NameHeaderViewController *headerViewController;
@property (assign, nonatomic) BOOL needsEditing;

- (id)initWithStyle:(UITableViewStyle)style withContext:(NSManagedObjectContext *)aContext withRecipe:(Recipe *)aRecipe needsEditing:(BOOL)needsEditing;


@end
