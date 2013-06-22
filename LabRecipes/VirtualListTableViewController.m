#import "VirtualListTableViewController.h"
#import "Buffer.h"

@interface NSMutableArray (YXArrayOfArrays)
// If idx is beyond the bounds of the reciever, this method automatically extends the reciever to fit with empty subarrays.
- (void)addObject:(id)anObject toSubarrayAtIndex:(NSUInteger)idx;
@end

@implementation NSMutableArray (YXArrayOfArrays)

- (void)addObject:(id)anObject toSubarrayAtIndex:(NSUInteger)idx
{
    while ([self count] <= idx) {
        [self addObject:[NSMutableArray array]];
    }
    [[self objectAtIndex:idx] addObject:anObject];
}

@end

@implementation VirtualListTableViewController

@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize filteredListContent;
@synthesize savedSearchTerm;
@synthesize savedScopeButtonIndex;
@synthesize searchIsActive;
@synthesize listContent, sectionedListContent;
@synthesize entityName, keyName;

- (id)initWithStyle:(UITableViewStyle)style entityName:(NSString *)anEntity keyName:(NSString *)aKey {
    self = [super initWithStyle:style];
    if (self) {
        self.entityName = anEntity;
        self.keyName = aKey;
    }
    return self;
}

- (void)setListContent:(NSArray *)inListContent
{
    listContent = inListContent;
    NSMutableArray *sections = [NSMutableArray array];
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    SEL sorterSelector = NSSelectorFromString(self.keyName);
    for (NSManagedObject *product in listContent) {
        NSInteger section = [collation sectionForObject:product collationStringSelector:sorterSelector];
        [sections addObject:product toSubarrayAtIndex:section];
    }
    
    NSInteger section = 0;
    for (section = 0; section < [sections count]; section++) {
        NSArray *sortedSubarray = [collation sortedArrayFromArray:[sections objectAtIndex:section] collationStringSelector:sorterSelector];
        [sections replaceObjectAtIndex:section withObject:sortedSubarray];
    }
    sectionedListContent = sections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewEntity)];
    
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
	searchBar.delegate = self;
	searchBar.showsCancelButton = NO;
//	searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Case Sensitive", @"Case Insensitive", nil]; 
	[searchBar sizeToFit];
    
	self.tableView.tableHeaderView = searchBar;
    
	UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
	[self performSelector:@selector(setSearchDisplayController:) withObject:searchDisplayController];
    
    [searchDisplayController setDelegate:self];
    [searchDisplayController setSearchResultsDataSource:self];
    [searchDisplayController setSearchResultsDelegate:self];
    
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
    
    [self setListContent:[self.fetchedResultsController fetchedObjects]];
    
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[[[self fetchedResultsController] fetchedObjects] count]];
    
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchIsActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear {
	[self.tableView reloadData];
}

- (void)viewDidUnload {
    self.searchIsActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
	self.filteredListContent = nil;
	self.fetchedResultsController = nil;
}

/*
- (void)addWord {
	NSManagedObject *newWord = [NSEntityDescription insertNewObjectForEntityForName:@"Buffer" inManagedObjectContext:[self managedObjectContext]];
	[newWord setValue:[NSString stringWithFormat:@"New Word %d", random() % 100] forKey:@"bufferName"];
    
	[[self managedObjectContext] save:nil];
}
*/

- (void)addNewEntity {
    NSLog(@"Override addNewEntity");
}

/*
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject *entity = nil;
	if (self.searchIsActive)
		entity = [[self filteredListContent] objectAtIndex:[indexPath row]];
	else
		entity = [sectionedListContent objectAtIndexPath:indexPath];
    
	cell.textLabel.text = [entity valueForKey:@"bufferName"];
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return 1;
    }
	else
	{
        return [self.sectionedListContent count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [[self.sectionedListContent objectAtIndex:section] count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
    NSManagedObject *product = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        product = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        product = [self.sectionedListContent objectAtIndexPath:indexPath];
    }
	
    cell.textLabel.text = [product valueForKey:self.keyName];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	NSManagedObject *entity = nil;
	if (self.searchIsActive)
		entity = [[self filteredListContent] objectAtIndex:[indexPath row]];
	else
		entity = [self.sectionedListContent objectAtIndexPath:indexPath];

    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected" message:[entity valueForKey:@"bufferName"] delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alert show];
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
    if ([scope isEqualToString:@"Case Sensitive"]) {
		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH %@", keyName, searchText];
		self.filteredListContent = [[[self fetchedResultsController] fetchedObjects] filteredArrayUsingPredicate:predicate];
	}else {
		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", keyName, searchText];
		self.filteredListContent = [[[self fetchedResultsController] fetchedObjects] filteredArrayUsingPredicate:predicate];
	}
    */
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", keyName, searchText];
    self.filteredListContent = [[[self fetchedResultsController] fetchedObjects] filteredArrayUsingPredicate:predicate];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:
	  [self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
	self.searchIsActive = YES;
    
	//[self performSelector:@selector(addWord) withObject:nil afterDelay:3.0];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	self.searchIsActive = NO;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
    
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:self.keyName ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:entityName];

	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
    
	return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	if (self.searchIsActive) {
		[self searchDisplayController:[self searchDisplayController] shouldReloadTableForSearchString:[[[self searchDisplayController] searchBar] text]];
		[self.searchDisplayController.searchResultsTableView reloadData];
	}else {
        [self.fetchedResultsController performFetch:nil];
        [self setListContent:[fetchedResultsController fetchedObjects]];
		[self.tableView reloadData];
	}
}

#pragma mark -

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[self.sectionedListContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

@end