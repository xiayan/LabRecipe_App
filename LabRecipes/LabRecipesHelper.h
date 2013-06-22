#import "UnitSelectionViewController.h"
@class Buffer;

@protocol YXSaveViewDelegate <NSObject>
@optional
- (void)nameDidEntered:(NSString *)name;
- (void)nameDidEntered:(NSString *)name isSolid:(BOOL)solid;

@end


@protocol YXBufferPickerDelegate <NSObject>
@required
- (void)bufferDidSelected:(Buffer *)selectedBuffer;

@end

@interface UIViewController (SemiTransparentModalView)
- (void)presentSemiModalViewController:(UnitSelectionViewController *)vc;
-(void) dismissSemiModalViewController:(UnitSelectionViewController*)vc;

@end

@implementation UIViewController (SemiTransparentModalView)
        
- (void)presentSemiModalViewController:(UnitSelectionViewController *)vc {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint middleCenter = CGPointMake(keyWindow.center.x, keyWindow.center.y + 9.0);
    vc.view.center = middleCenter;
    [keyWindow addSubview:vc.view];
    
    CGPoint vcCenter = vc.view.center;
    CGPoint offScreenCenter = CGPointMake(vcCenter.x, vcCenter.y * 2.5);
    CGPoint pickerContainerCenter = CGPointMake(vcCenter.x, 330.0);
    vc.pickerContainer.center = offScreenCenter;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    vc.pickerContainer.center = pickerContainerCenter;
    [UIView commitAnimations];
}

-(void) dismissSemiModalViewController:(UnitSelectionViewController*)vc {
    CGPoint middleCenter = vc.view.center;
    CGPoint offScreenCenter = CGPointMake(middleCenter.x, middleCenter.y * 2.5);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    //	[UIView setAnimationDelegate:self];
    //	[UIView setAnimationDidStopSelector:@selector(dismissSemiModalViewControllerEnded:finished:context:)];
    vc.pickerContainer.center = offScreenCenter;
    [UIView commitAnimations];
    
    [vc.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
}

@end