//
//  BufferPickingTableViewController.h
//  LabRecipes
//
//  Created by Yan Xia on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VirtualListTableViewController.h"
#import "LabRecipesHelper.h"

@interface BufferPickingTableViewController : VirtualListTableViewController {
    BOOL hideRightBarButton;
    id<YXBufferPickerDelegate> __unsafe_unretained delegate;
}

@property (assign, nonatomic) BOOL hideRightBarButton;
@property (unsafe_unretained) id<YXBufferPickerDelegate> delegate;

@end
