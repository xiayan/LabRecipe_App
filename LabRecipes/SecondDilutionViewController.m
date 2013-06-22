//
//  SecondDilutionViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondDilutionViewController.h"

@implementation SecondDilutionViewController
@synthesize finalConc, finalVolume, statusLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithStockConc:(float)conc
{
    self = [self initWithNibName:@"SecondDilutionViewController" bundle:nil];
    if (self) {
        stockConc = conc;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)configureStatus
{
    float conc = [finalConc.text floatValue];
    float volume = [finalVolume.text floatValue];
    float calculatedVolume = (conc * volume) / stockConc;
    self.statusLabel.text = [NSString stringWithFormat:@"Add %f L of stock", calculatedVolume];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.finalConc = nil;
    self.finalVolume = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 0 && [string isEqualToString:@""]) {
        self.statusLabel.text = @"Fill up both fields to calculate";
    } else {
        if ([self.finalVolume.text isEqualToString:@""] || [self.finalConc.text isEqualToString:@""]) {
            self.statusLabel.text = @"Fill up both fields to calculate";
        } else {
            [self performSelector:@selector(configureStatus)];
        }
    }
    return YES;
}
*/
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.finalVolume.text isEqualToString:@""] || [self.finalConc.text isEqualToString:@""]) {
        self.statusLabel.text = @"Fill up both fields to calculate";
    } else {
        [self performSelector:@selector(configureStatus)];
    }
}

@end