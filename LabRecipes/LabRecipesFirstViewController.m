//
//  LabRecipesFirstViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LabRecipesFirstViewController.h"
#import "LabRecipesAppDelegate.h"
#import "FirstSaveViewController.h"
#import "Buffer.h"

@implementation LabRecipesFirstViewController
@synthesize mwField, concField, volumeField, statusField;
@synthesize prepareToSaveButton, clearButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Quick", @"Quick");
        self.tabBarItem.image = [UIImage imageNamed:@"calculator"];
    }

    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.prepareToSaveButton setHidden:YES];
    [self.clearButton setHidden:YES];
    [self.mwField addObserver:self forKeyPath:@"text" options:0 context:NULL];
    [self.concField addObserver:self forKeyPath:@"text" options:0 context:NULL];
    [self.volumeField addObserver:self forKeyPath:@"text" options:0 context:NULL];
}
/*
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![mwField.text isEqualToString:@""] && ![concField.text isEqualToString:@""] && ![volumeField.text isEqualToString:@""]) {
        [self performSelector:@selector(calculateWeight)];
        [self performSelector:@selector(askToSaveStock)];
    }
}

- (void)calculateWeight
{
    float molecularWeight = [self.mwField.text floatValue];
    float concentration = [self.concField.text floatValue];
    float volume = [self.volumeField.text floatValue];
    float gram = molecularWeight * concentration * volume;
    self.statusField.text = [NSString stringWithFormat:@"%f", gram];
}
*/

- (void)askToSaveStock
{
    [self.prepareToSaveButton setHidden:NO];
    [self.clearButton setHidden:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mwField = nil;
    self.concField = nil;
    self.volumeField = nil;
    self.statusField = nil;
    self.statusField = nil;
    self.prepareToSaveButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Actions
- (void)prepareToSave:(id)sender
{
    FirstSaveViewController *saveViewController = [[FirstSaveViewController alloc] initWithNibName:@"FirstSaveViewController" bundle:nil];
    saveViewController.delegate = self;
    saveViewController.showingName = @"Reagent";
    
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:saveViewController];
    [self presentModalViewController:naviController animated:YES];
}

- (void)nameDidEntered:(NSString *)name
{
    if (name) {
        NSManagedObjectContext *context = [(LabRecipesAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        //NSManagedObject *newBuffer = [NSEntityDescription insertNewObjectForEntityForName:@"Buffer" inManagedObjectContext:context];
        Buffer *newBuffer = [NSEntityDescription insertNewObjectForEntityForName:@"Buffer" inManagedObjectContext:context];
        //[newBuffer setValue:name forKey:@"bufferName"];
        //[newBuffer setValue:mwField.text forKey:@"bufferMW"];
        //[newBuffer setValue:concField.text forKey:@"bufferStockConc"];
        //[newBuffer setValue:volumeField.text forKey:@"bufferVolume"];
        newBuffer.bufferName = name;
        newBuffer.bufferMW = mwField.text;
        newBuffer.bufferStockConc = concField.text;
        newBuffer.bufferVolume = volumeField.text;
        
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } else {
            NSLog(@"Reagent Saving Done!");
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)clearInputs:(id)sender
{
    self.mwField.text = nil;
    self.concField.text = nil;
    self.volumeField.text = nil;
    self.statusField.text = @"Fill up all 3 fields to calculate";
    self.prepareToSaveButton.hidden = YES;
    self.clearButton.hidden = YES;
}

#pragma mark - Textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end