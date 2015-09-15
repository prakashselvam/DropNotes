//
//  NoteEditViewController.m
//  DropNotes
//
//  Created by Prakash Selvam on 15/09/15.
//  Copyright (c) 2015 Prakash Selvam. All rights reserved.
//

#import "NoteEditViewController.h"
#import "GALOCNavigationController.h"
#import "DataManager.h"
#import "DropNotes-prefix.pch"

@interface NoteEditViewController ()
@property (weak) DataManager *dataManager;
@property UITextView *textView;
@property NSString *fileName;
@end

@implementation NoteEditViewController
@synthesize dataManager,textView,fileName;
- (void)viewDidLoad {
    [super viewDidLoad];
    dataManager = [DataManager sharedDataManager];
    GALOCNavigationController *navcontroller = (GALOCNavigationController *)self.parentViewController;
    [navcontroller setHeaderForViewController:@"Drop Notes"];
    [navcontroller setRightButtonWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(done) title:@"Done"];
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    [textView setBackgroundColor:[UIColor pxColorWithHexValue:@"fefefe"]];
    [self.view addSubview:textView];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (dataManager.selected >=0 && dataManager.selected <[dataManager.Notes count]) {
    fileName = [dataManager.localNotesFileReader.FilesList objectAtIndex:dataManager.selected];
    [textView setText:[dataManager.Notes objectForKey:fileName]];
    [textView becomeFirstResponder];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)done {
    if (fileName) {
        [dataManager.localNotesFileReader WriteNoteWithFileName:fileName andContent:textView.text];
    }
    else fileName = [dataManager.localNotesFileReader getNextFileNameAndWriteWithContent:textView.text];
    GALOCNavigationController *navcontroller = (GALOCNavigationController *)self.parentViewController;
    [navcontroller popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
