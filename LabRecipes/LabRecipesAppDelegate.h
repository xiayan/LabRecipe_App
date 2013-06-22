//
//  LabRecipesAppDelegate.h
//  LabRecipes
//
//  Created by Yan Xia on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabRecipesAppDelegate : UIResponder <UIApplicationDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITableViewController *tableViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSManagedObjectContext *tempContext;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
