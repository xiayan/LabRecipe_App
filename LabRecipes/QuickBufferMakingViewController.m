#import "QuickBufferMakingViewController.h"
#import "LabRecipesHelper.h"
#import "LabRecipesAppDelegate.h"
#import "Buffer.h"
#import "EditingTableCell.h"
#import "VolumeEditingCell.h"
#import "mWFieldCell.h"
#import "FirstSaveViewController.h"
#import "LoadingView.h"

#define INFO_SECTION 0
#define MW_ROW 0
#define CONC_ROW 1
#define VOLUME_ROW 2

#define STATUS_SECTION 1

@implementation QuickBufferMakingViewController
@synthesize managedObjectContext, managedObjectModel, persistentStoreCoordinator;
@synthesize tempBuffer;
@synthesize shouldSaveBuffer, displayMessage;
@synthesize mainContext;

static UIButton *senderButton;
static BOOL enableClearButton;

#pragma mark -
#pragma mark View controller
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.shouldSaveBuffer = NO;
        self.displayMessage = NO;
        
        // create the initial self.tempBuffer in tempManagedObjectContext
        self.tempBuffer = [NSEntityDescription insertNewObjectForEntityForName:@"Buffer" inManagedObjectContext:self.managedObjectContext];
        NSLog(@"self.tempBuffer initiated in tempContext");
        self.tempBuffer.bufferMW = @"";
        self.tempBuffer.bufferStockConc = @"";
        self.tempBuffer.bufferVolume = @"";
        self.tempBuffer.bufferIsMolar = [NSNumber numberWithBool:YES];
        self.tempBuffer.bufferMagnitude = [NSNumber numberWithDouble:1.0];
        self.tempBuffer.bufferUnit = @"M";
        self.tempBuffer.bufferVolumeMagnitude = [NSNumber numberWithDouble:1.0];
        self.tempBuffer.bufferVolumeUnit = @"L";
        
        calculateButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(quiteEditingMode)];
        clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAllFields)];
        
        inputButton = [[UIBarButtonItem alloc] initWithTitle:@"Enter" style:UIBarButtonItemStyleBordered target:self action:@selector(enterEditingMode)];
        saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveBuffer)];
    }
    return self;
}

- (void)clearAllFields {
    UITableViewCell *cell;
    UITextField *textField;
    for (int i = 0; i < 3; i++) {
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:INFO_SECTION]];
        textField = [cell performSelector:@selector(textField)];
        textField.text = @"";
    }
    clearButton.enabled = NO;
    enableClearButton = NO;
}

- (BOOL)checkFields {
    BOOL filled = YES;

    if ([self.tempBuffer.bufferMW isEqualToString:@""]) {
        filled = NO;
    }
    if ([self.tempBuffer.bufferStockConc isEqualToString:@""]) {
        filled = NO;
    }
    if ([self.tempBuffer.bufferVolume isEqualToString:@""]) {
        filled = NO;
    }

    return filled;
}

- (void)enterEditingMode {
    self.editing = YES;
}

- (void)quiteEditingMode {
    self.editing = NO;
}

- (void)saveBuffer {
    self.shouldSaveBuffer = YES;
    
    FirstSaveViewController *saveViewController = [[FirstSaveViewController alloc] initWithNibName:@"FirstSaveViewController" bundle:nil hideToggleView:NO];
    saveViewController.delegate = self;
    saveViewController.showingName = @"Buffer";
    
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:saveViewController];
    [self presentModalViewController:naviController animated:YES];
}

- (void)nameDidEntered:(NSString *)name isSolid:(BOOL)solid {
    if (name) {
        Buffer *newBuffer = [NSEntityDescription insertNewObjectForEntityForName:@"Buffer" inManagedObjectContext:self.mainContext];
        
        newBuffer.bufferName = name;
        newBuffer.bufferVolumeUnit = tempBuffer.bufferVolumeUnit;
        newBuffer.bufferVolumeMagnitude = tempBuffer.bufferVolumeMagnitude;
        newBuffer.bufferUnit = tempBuffer.bufferUnit;
        newBuffer.bufferMagnitude = tempBuffer.bufferMagnitude;
        newBuffer.bufferIsMolar = tempBuffer.bufferIsMolar;
        newBuffer.bufferVolume = tempBuffer.bufferVolume;
        newBuffer.bufferStockConc = tempBuffer.bufferStockConc;
        newBuffer.bufferMW = tempBuffer.bufferMW;
        newBuffer.bufferIsSolid = [NSNumber numberWithBool:solid];
        
        
        NSError *error = nil;
        if (![self.mainContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } else {
            NSLog(@"New Buffer Saving Done!");
        }

    }
    self.displayMessage = YES;
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        self.navigationItem.rightBarButtonItem = calculateButton;
        self.navigationItem.leftBarButtonItem = clearButton;
        clearButton.enabled = enableClearButton;
        //First responder code
        mWFieldCell *cell = (mWFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:INFO_SECTION]];
        [cell.textField becomeFirstResponder];
        } else {
            self.navigationItem.rightBarButtonItem = inputButton;
            self.navigationItem.leftBarButtonItem = saveButton;
            saveButton.enabled = [self checkFields];
    }
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:MW_ROW inSection:STATUS_SECTION]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidLoad {
    self.navigationItem.title = @"Quick Calculation";
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    
    self.navigationItem.rightBarButtonItem = inputButton;
    self.navigationItem.leftBarButtonItem = saveButton;
    saveButton.enabled = NO;
    clearButton.enabled = NO;
    enableClearButton = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.displayMessage) {
        // semi Transparent modal view codes
        UIView *rootView = [self.view.window.subviews objectAtIndex:0];
        LoadingView *loadingView = [[LoadingView alloc] initWithFrame:rootView.bounds];
        [loadingView loadingViewInView:rootView];
        [loadingView performSelector:@selector(removeView) withObject:nil afterDelay:1.5];
        
        self.displayMessage = NO;
    }
}

- (void)viewDidUnload {
	[super viewDidUnload];
    
    // delete everything in tempContext
    NSFetchRequest *tempBuffers = [[NSFetchRequest alloc] init];
    [tempBuffers setEntity:[NSEntityDescription entityForName:@"Buffer" inManagedObjectContext:self.managedObjectContext]];
    [tempBuffers setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * temp = [self.managedObjectContext executeFetchRequest:tempBuffers error:&error];
    
    for (NSManagedObject * buffer in temp) {
        [managedObjectContext deleteObject:buffer];
        NSLog(@"%@ deleted", buffer);
    }
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark UITableView Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    
    if (section == STATUS_SECTION) {
        title = @"Instruction";
    } else if (section == INFO_SECTION) {
        title = @"Info";
    }
    return title;;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    switch (section) {
        case INFO_SECTION:
            rows = 3;
            break;
        case STATUS_SECTION:
            rows = 1;
            break;
		default:
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {        
    EditingTableCell *cell = nil;
    VolumeEditingCell *cell2 = nil;
    UITableViewCell *cell3 = nil;
    mWFieldCell *cell4 = nil;
    
    static NSString *InfoIdentifier = @"EditingCell";
    static NSString *VolumeIdentifier = @"VolumeEditingCell";
    static NSString *GenericIdentifier = @"GenericCell";
    static NSString *MWIdentifier = @"MWEditingCell";
    
    if (indexPath.section == INFO_SECTION) {
        if (indexPath.row == MW_ROW) {
            cell4 = (mWFieldCell *)[tableView dequeueReusableCellWithIdentifier:MWIdentifier];
            if (cell4 == nil) {
                cell4 = [[mWFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MWIdentifier withReagent:self.tempBuffer withAttributeString:@"bufferMW"];
                cell4.textField.delegate = self;
            }
            return cell4;
        } else if (indexPath.row == VOLUME_ROW) {
            cell2 = (VolumeEditingCell *)[tableView dequeueReusableCellWithIdentifier:VolumeIdentifier];
            if (cell2 == nil) {
                cell2 = [[VolumeEditingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VolumeIdentifier withReagent:self.tempBuffer withAttributeString:@"bufferVolume" withUnitString:@"bufferVolumeUnit"];
                [cell2.unitButton setTitle:@"L" forState:UIControlStateNormal];
                cell2.label.text = @"Volume";
                cell2.textField.placeholder = @"Volume";
                cell2.delegate = self;
                cell2.textField.delegate = self;
            }
            return cell2;
        } else if (indexPath.row == CONC_ROW) {
            cell = (EditingTableCell *)[tableView dequeueReusableCellWithIdentifier:InfoIdentifier];
            if (cell == nil) {
                cell = [[EditingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoIdentifier withReagent:self.tempBuffer withAttributeString:@"bufferStockConc" withUnitString:@"bufferUnit"];
                [cell.unitButton setTitle:@"M" forState:UIControlStateNormal];
                [cell.unitButton addTarget:self action:@selector(showUnitPicker:) forControlEvents:UIControlEventTouchDown];
                cell.label.text = @"Conc";
                cell.textField.placeholder = @"Concentration";
                cell.textField.delegate = self;
            }
            return cell;
        } else return nil;
    } else {
        cell3 = [tableView dequeueReusableCellWithIdentifier:GenericIdentifier];
        if (!cell3) {
            cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GenericIdentifier];
            // Allowing multiple lines
            cell3.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
            cell3.textLabel.numberOfLines = 0;
        }
        if (self.editing) {
            cell3.textLabel.text = @"Editing ... ";
        } else {
            cell3.textLabel.text = [self.tempBuffer calculateWeight];
        }
        return cell3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == STATUS_SECTION && indexPath.row == 0 && !self.editing) {
        NSString *instructionMessage = [self.tempBuffer calculateWeight];
        CGSize size1 = [instructionMessage sizeWithFont:[UIFont boldSystemFontOfSize:20] forWidth:350.0 lineBreakMode:UILineBreakModeCharacterWrap];

        if (size1.width > 330.0) {
            return 66.0;
        }
    }
    return 44.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == STATUS_SECTION) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - TextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""] && range.location == 0) {
        clearButton.enabled = NO;
        enableClearButton = NO;
    } else {
        clearButton.enabled = YES;
        enableClearButton = YES;
    }
    return YES;
}

#pragma mark - Unit Button Selector
- (void)showUnitPicker:(id)sender {
    senderButton = (UIButton *)sender;
    
    UIView *firstResponder = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
    
    if (!unitController) {
        unitController = [[UnitSelectionViewController alloc] initWithNibName:nil bundle:nil];
    }
    unitController.unit = (self.tempBuffer.bufferUnit == nil) ? @"M" : self.tempBuffer.bufferUnit;
    unitController.delegate = self;
    
    [self presentSemiModalViewController:unitController];
}

#pragma mark - Unit Picker Delegates
- (void)saveButtonPressed:(NSString *)unit isMolar:(BOOL)molar withMagnitude:(double)magnitude {
    self.tempBuffer.bufferMagnitude = [NSNumber numberWithDouble:magnitude];
    self.tempBuffer.bufferIsMolar = [NSNumber numberWithBool:molar];
    self.tempBuffer.bufferUnit = unit;
    [senderButton setTitle:unit forState:UIControlStateNormal];
    [self dismissSemiModalViewController:unitController];
}

- (void)cancelButtonPressed {
    [self dismissSemiModalViewController:unitController];
}

#pragma mark - Volume Button Selector
- (void)unitSelected:(NSString *)newUnit withMagnitude:(NSNumber *)magnitude {
    self.tempBuffer.bufferVolumeUnit = newUnit;
    self.tempBuffer.bufferVolumeMagnitude = magnitude;
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LabRecipes" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LabRecipesTemp.sqlite"];
    NSLog(@"location: %@", storeURL);
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
