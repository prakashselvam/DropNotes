//
//  GANavigationViewController.h
//  perchline
//
//  Created by prakash on 9/19/14.
//  Copyright (c) 2014 GlobalAnalytics. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GALOCNavigationController : UINavigationController{
    int branchTag; /**< Indicates the index of the branch of the current class. */
    UILabel *titleLabel;
    UIImageView *iconView;
}
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;

- (void) viewControllerDidStartLoading;
- (void) viewControllerDidEndLoading;
- (void)setLeftButtonWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action title:(NSString *)title;
- (void)setRightButtonWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action title:(NSString *)title;
- (void)setHeaderForViewController:(NSString *)title;

@end
