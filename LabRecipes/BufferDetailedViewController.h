//
//  BufferDetailedViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitSelectionViewController.h"
#import "SharingTableFooterViewController.h"
@class Buffer, NameHeaderViewController, SharingTableFooterViewController;

@interface BufferDetailedViewController : UITableViewController <YXUnitSelectionDelegate, YXMakeDilutionandDelete, UIActionSheetDelegate> {

    NSManagedObjectContext *context;
    Buffer *selectedBuffer;

    NameHeaderViewController *headerViewController;
    SharingTableFooterViewController *footerViewController;
    
    UnitSelectionViewController *unitController;
}

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Buffer *selectedBuffer;
@property (strong, nonatomic) NameHeaderViewController *headerViewController;
@property (strong, nonatomic) SharingTableFooterViewController *footerViewController;

@property (assign) BOOL shouldEditing;

@end
