//
//  SharingTableFooterViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXMakeDilutionandDelete
@optional
- (void)prepareMakeDilution;
- (void)prepareDelete;

@end

@interface SharingTableFooterViewController : UIViewController {
    UIButton *dilutionButton;
    UIButton *deleteButton;
    
    id<YXMakeDilutionandDelete> __unsafe_unretained delegate;
}

@property (nonatomic, strong) IBOutlet UIButton *dilutionButton;
@property (nonatomic, strong) IBOutlet UIButton *deleteButton;
@property (unsafe_unretained) id<YXMakeDilutionandDelete> delegate;

- (IBAction)dillutionBUttonPressed:(id)sender;
- (IBAction)deletionButtonPressed:(id)sender;

@end