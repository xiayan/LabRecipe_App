//
//  VolumeEditingCell.h
//  Test
//
//  Created by Yan Xia on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditingTableCell.h"

@interface VolumeEditingCell : EditingTableCell {
    UIButton *lButton;
    UIButton *mlButton;
    UIButton *microlButton;
    id __unsafe_unretained delegate;
}

@property (strong, nonatomic) UIButton *lButton;
@property (strong, nonatomic) UIButton *mlButton;
@property (strong, nonatomic) UIButton *microlButton;
@property (unsafe_unretained) id delegate;

@end
