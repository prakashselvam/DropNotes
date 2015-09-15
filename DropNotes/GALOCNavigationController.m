//
//  GANavigationViewController.m
//  perchline
//
//  Created by prakash on 9/19/14.
//  Copyright (c) 2014 GlobalAnalytics. All rights reserved.
//

#import "GALOCNavigationController.h"
#import "AppDelegate.h"
#import "UIColor+UIColor_PXExtensions.h"

@interface GALOCNavigationController ()

@end

@implementation GALOCNavigationController

@synthesize titleLabel, iconView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewControllerDidStartLoading {
}

- (void) viewControllerDidEndLoading{
}

#pragma mark header setter
- (void)setHeaderForViewController:(NSString *)title{
    [titleLabel removeFromSuperview];
    [iconView removeFromSuperview];
    if ([title isEqualToString:@""]) {

    }
    else{
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 64)];
        titleLabel.text = title;
        [titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor pxColorWithHexValue:@"#727272"]];
        [self.view addSubview:titleLabel];
    }
}


#pragma mark buttons setters
- (void)setRightButtonWithTitle:(NSString *)title {
    if (title == NULL) {
        [[self.topViewController navigationItem] setRightBarButtonItem:nil];
    }
    UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:nil];
    UILabel *temp = [[UILabel alloc] init];
    [bbItem setTintColor: [UIColor pxColorWithHexValue:@"#2196F3"]];
    [bbItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:temp.font,NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[self.topViewController navigationItem] setRightBarButtonItem:bbItem];
}

- (void)setLeftButtonWithTitle:(NSString *)title {
    if (title == NULL) {
        [[self.topViewController navigationItem] setLeftBarButtonItem:nil];
    }
    UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:nil];
    UILabel *temp = [[UILabel alloc] init];
    [bbItem setTintColor: [UIColor pxColorWithHexValue:@"#2196f3"]];
    [bbItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:temp.font,NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[self.topViewController navigationItem] setLeftBarButtonItem:bbItem];
}

- (void)setRightButtonWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action title:(NSString *)title{
    if(!title) {
        switch (systemItem) {
            case UIBarButtonSystemItemCancel:
                title = @"Cancel";
                break;
            case UIBarButtonSystemItemAdd:
                title = @"Add";
                break;
            case UIBarButtonSystemItemSave:
                title = @"Save";
                break;
            default:
                break;
        }
    }
    if (title) {
        [self setRightButtonWithTitle:title];
        UIBarButtonItem *item = self.topViewController.navigationItem.rightBarButtonItem;
        [item setTarget:target];
        [item setAction:action];
    } else {
        UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:action];
        [[self.topViewController navigationItem] setRightBarButtonItem:bbItem];
    }
}

- (void)setLeftButtonWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action title:(NSString *)title{
    if(!title) {
        switch (systemItem) {
            case UIBarButtonSystemItemCancel:
                title = @"Cancel";
                break;
            case UIBarButtonSystemItemAdd:
                title = @"Add";
                break;
            case UIBarButtonSystemItemSave:
                title = @"Save";
                break;
            default:
                break;
        }
    }
    if (title) {
        [self setLeftButtonWithTitle:title];
        UIBarButtonItem *item = self.topViewController.navigationItem.leftBarButtonItem;
        [item setTarget:target];
        [item setAction:action];
    } else {
        UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:action];
        [[self.topViewController navigationItem] setLeftBarButtonItem:bbItem];
    }
}
@end
