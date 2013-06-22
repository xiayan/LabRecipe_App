//
//  NameHeaderViewController.m
//  LabRecipes
//
//  Created by Yan Xia on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NameHeaderViewController.h"
#import "NameFieldCell.h"

@implementation NameHeaderViewController
@synthesize nameText;
@synthesize nameLabel, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setUpNames {
    NameFieldCell *cell = (NameFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.nameText = cell.textField.text;
    self.nameLabel.text = cell.textField.text;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        self.nameLabel.hidden = YES;
        self.tableView.hidden = NO;
    } else {
        nameLabel.text = nameText;
        self.nameLabel.hidden = NO;
        self.tableView.hidden = YES;
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
}

#pragma mark - Table View Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellID = @"cellID";
	
	NameFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[NameFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
        cell.textField.delegate = self;
	}
	
    cell.textField.text = nameText;
	return cell; 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self setUpNames];
    return YES;
}

@end
