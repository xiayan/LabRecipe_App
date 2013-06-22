//
//  SecondDetailViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SecondDetailViewController.h"
#import "SecondDilutionViewController.h"
#import "LabRecipesAppDelegate.h"
#import "Buffer.h"
#import "NameHeaderViewController.h"

static BOOL keyboardIsShown = NO;
static GLuint kTabBarHeight = 49;
static float kKeyboardAnimationDuration = 0.3;

@implementation SecondDetailViewController
@synthesize selectedBuffer;
@synthesize scrollView, nameField, mwField, stockConcField, volumeField, statusLabel, dilutionButton;
@synthesize nameHeaderController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)changeBorderStyle:(UITextBorderStyle)style Enabled:(BOOL)enable
{
    for (UITextField *field in self.scrollView.subviews) {
        if ([field class] == [UITextField class]) {
            field.enabled = enable;
            field.borderStyle = style;
        }
    }
}

#pragma mark - View lifecycle

- (void)configureStatusLabel
{
    float mw = [[self.mwField text] floatValue];
    float conc = [[self.stockConcField text] floatValue];
    float volume = [[self.volumeField text] floatValue];
    float grams = mw * conc * volume;
    self.statusLabel.text = [NSString stringWithFormat:@"Add %g grams into %g L solvent", grams, volume];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.selectedBuffer.bufferName;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self changeBorderStyle:UITextBorderStyleNone Enabled:NO];
    //self.nameField.text = [selectedBuffer valueForKey:@"bufferName"];
    //self.mwField.text = [selectedBuffer valueForKey:@"bufferMW"];
    //self.stockConcField.text = [selectedBuffer valueForKey:@"bufferStockConc"];
    //self.volumeField.text = [selectedBuffer valueForKey:@"bufferVolume"];
    
    self.nameField.text = selectedBuffer.bufferName;
    self.mwField.text = selectedBuffer.bufferMW;
    self.stockConcField.text = selectedBuffer.bufferStockConc;
    self.volumeField.text = selectedBuffer.bufferVolume;
    
    [self configureStatusLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
    CGSize scrollContentSize = CGSizeMake(320, 345);
    self.scrollView.contentSize = scrollContentSize;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.nameField = nil;
    self.mwField = nil;
    self.stockConcField = nil;
    self.volumeField = nil;
    //self.finalConcField = nil;
    self.statusLabel = nil;
    self.dilutionButton = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil]; 
}

- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the scrollview
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the UIScrollView if the keyboard is already shown.  This can happen if the user, after fixing editing a UITextField, scrolls the resized UIScrollView to another UITextField and attempts to edit the next UITextField.  If we were to resize the UIScrollView again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    for (UITextField *subView in self.scrollView.subviews) {
        if ([subView isFirstResponder]) {
            [self.scrollView scrollRectToVisible:subView.frame animated:YES];
            break;
        }
    }
    
    keyboardIsShown = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        [self changeBorderStyle:UITextBorderStyleRoundedRect Enabled:YES];
        self.dilutionButton.hidden = YES;
    } else {
        [self changeBorderStyle:UITextBorderStyleNone Enabled:NO];
        self.dilutionButton.hidden = NO;
        [self saveChanges];
    }
}

- (void)prepareToCalculate:(id)sender
{
    SecondDilutionViewController *dilutionViewController = [[SecondDilutionViewController alloc] initWithStockConc:[stockConcField.text floatValue]];
    [self presentModalViewController:dilutionViewController animated:YES];
}

- (void)saveChanges
{
    NSManagedObjectContext *context = [(LabRecipesAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

    //[selectedBuffer setValue:nameField.text forKey:@"bufferName"];
    //[selectedBuffer setValue:mwField.text forKey:@"bufferMW"];
    //[selectedBuffer setValue:stockConcField.text forKey:@"bufferStockConc"];
    //[selectedBuffer setValue:volumeField.text forKey:@"bufferVolume"];
    
    selectedBuffer.bufferName = nameField.text;
    selectedBuffer.bufferMW = mwField.text;
    selectedBuffer.bufferStockConc = stockConcField.text;
    selectedBuffer.bufferVolume = volumeField.text;
    
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } else {
        NSLog(@"Saving Done!");
    }
}

# pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end