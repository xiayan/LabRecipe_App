//
//  SharingTableFooterViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharingTableFooterViewController.h"

@implementation SharingTableFooterViewController
@synthesize dilutionButton, deleteButton;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.dilutionButton = nil;
    self.deleteButton = nil;
}

- (void)toggleButtons {
    self.dilutionButton.hidden = self.editing;
    self.deleteButton.hidden = !self.editing;
}
                                        

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.3 animations:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.dilutionButton.alpha = !editing;
    self.deleteButton.alpha = editing;
    [UIView commitAnimations];
    
    [self performSelector:@selector(toggleButtons) withObject:nil afterDelay:0.3];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dillutionBUttonPressed:(id)sender {
    [self.delegate prepareMakeDilution];
}

- (void)deletionButtonPressed:(id)sender {
    [self.delegate prepareDelete];
}

@end
