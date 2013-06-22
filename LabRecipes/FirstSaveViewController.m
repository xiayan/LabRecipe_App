//
//  FirstSaveViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstSaveViewController.h"
#import "LabRecipesHelper.h"
#import "UICustomSwitch.h"

@implementation FirstSaveViewController
@synthesize nameField, nameLabel, showingName;
@synthesize stateLabel, customSwitch;
@synthesize showToggleViews, isSolid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isSolid = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil hideToggleView:(BOOL)hide {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showToggleViews = !hide;
    }
    return self;
}

- (id)delegate
{
    return delegate;
}

- (void)setDelegate:(id)anObject
{
    delegate = anObject;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)cancel {
    if (self.showToggleViews) {
        [self.delegate nameDidEntered:nil isSolid:self.isSolid];
    } else {
        [self.delegate nameDidEntered:nil];   
    }
}

- (void)save {
    NSString *name = self.nameField.text;
    if (self.showToggleViews) {
        [self.delegate nameDidEntered:name isSolid:self.isSolid];
    } else {
        [self.delegate nameDidEntered:name];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [NSString stringWithFormat:@"Add %@", self.showingName];

    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.nameLabel.text = self.showingName;

    if (self.showToggleViews) {
        self.customSwitch.on = YES;
    } else {
        [self.customSwitch removeFromSuperview];
        [self.stateLabel removeFromSuperview];
    }
    
    [nameField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.nameField = nil;
    self.nameLabel = nil;
    self.stateLabel = nil;
//    self.toggleSwitch = nil;
    self.customSwitch = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (range.location == 0 && [string isEqualToString:@""]) {
        //self.saveButton.enabled = NO;
        //saveButton.titleLabel.textColor = [UIColor grayColor];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        //self.saveButton.enabled = YES;
        //saveButton.titleLabel.textColor = [UIColor blackColor];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    return YES;
}

- (IBAction)toggleValueChanged:(id)sender {
    UICustomSwitch *theSwitch = (UICustomSwitch *)sender;
    self.isSolid = theSwitch.isOn;
    NSLog(@"Called: %i", theSwitch.isOn);
}

@end