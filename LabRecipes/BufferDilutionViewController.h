//
//  BufferDilutionViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabRecipesHelper.h"
@class UnitSelectionViewController, Buffer;

@interface BufferDilutionViewController : UITableViewController <YXUnitSelectionDelegate> {
    UnitSelectionViewController *unitController;
    
    NSManagedObjectContext *context;
    const Buffer *selectedBuffer;
    Buffer *tempBuffer;
}

@property (strong, nonatomic) UnitSelectionViewController *unitController;
@property (strong, nonatomic) const Buffer *selectedBuffer;
@property (strong, nonatomic) NSManagedObjectContext *context;

@property (assign) BOOL shouldEditing;

@end
