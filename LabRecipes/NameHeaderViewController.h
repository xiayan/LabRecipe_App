//
//  NameHeaderViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameHeaderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    NSString *nameText;
    UILabel *nameLabel;
    UITableView *tableView;
}

@property (strong, nonatomic) NSString *nameText;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
