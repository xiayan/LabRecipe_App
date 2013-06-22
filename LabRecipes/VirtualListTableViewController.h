//
//  TestTableViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface VirtualListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
	NSManagedObjectContext *managedObjectContext;	    
	NSFetchedResultsController *fetchedResultsController;
    NSString *entityName;
    NSString *keyName;
    
	NSArray *filteredListContent;
    NSString *savedSearchTerm;
    NSInteger savedScopeButtonIndex;
    
    BOOL searchIsActive;
    
    NSArray *listContent;			// The master content.
    NSArray *sectionedListContent;  // The content filtered into alphabetical sections.
}

@property (nonatomic, strong) NSArray *filteredListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;

@property (nonatomic) BOOL searchIsActive;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *keyName;

@property (nonatomic, retain) NSArray *listContent;
@property (nonatomic, retain, readonly) NSArray *sectionedListContent;

- (id)initWithStyle:(UITableViewStyle)style entityName:(NSString *)anEntity keyName:(NSString *)aKey;

@end

@interface NSArray (YXArrayOfArrays)
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation NSArray (YXArrayOfArrays)

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [[self objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
}

@end