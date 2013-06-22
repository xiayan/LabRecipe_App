//
//  QuickBufferMakingViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitSelectionViewController.h"
@class Buffer, NameHeaderViewController, SharingTableFooterViewController;

@interface QuickBufferMakingViewController : UITableViewController <YXUnitSelectionDelegate, UITextFieldDelegate> {
    
    UIBarButtonItem *saveButton;
    UIBarButtonItem *clearButton;
    UIBarButtonItem *calculateButton;
    UIBarButtonItem *inputButton;
    
    Buffer *tempBuffer;
    UnitSelectionViewController *unitController;
    
    NSManagedObjectContext *mainContext;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic)NSManagedObjectContext *mainContext;
@property (nonatomic, strong) Buffer *tempBuffer;
@property (assign) BOOL shouldSaveBuffer;
@property (assign) BOOL displayMessage;

//- (id)initWithStyle:(UITableViewStyle)style withContext:(NSManagedObjectContext *)aContext;
- (NSURL *)applicationDocumentsDirectory;

@end
