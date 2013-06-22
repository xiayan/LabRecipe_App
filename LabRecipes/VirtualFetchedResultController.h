//
//  VirtualFetchedResultController.h
//  LabRecipes
//
//  Created by Yan Xia on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VirtualFetchedResultController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    
    NSString *entityName;
    NSString *keyName;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSString *keyName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil entityName:(NSString *)entity keyName:(NSString *)key;

@end
