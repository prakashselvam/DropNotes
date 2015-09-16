//
//  DropNotesTableViewController.m
//  DropNotes
//
//  Created by Prakash Selvam on 14/09/15.
//  Copyright (c) 2015 Prakash Selvam. All rights reserved.
//

#import "DropNotesTableViewController.h"
#import "GALOCNavigationController.h"
#import "LocalNotesFileReader.h"
#import "DataManager.h"
#import "DropNotes-prefix.pch"
#import "NoteEditViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface DropNotesTableViewController () <UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
@property (weak) DataManager *dataManager;
@property UITableView *notesTableView;
@end

@implementation DropNotesTableViewController
@synthesize dataManager,notesTableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //To initialize the nav bar
    GALOCNavigationController *navcontroller = (GALOCNavigationController *)self.parentViewController;
    [navcontroller setHeaderForViewController:@"Drop Notes"];
    [navcontroller setRightButtonWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(addnew) title:@"Add"];
    [navcontroller setLeftButtonWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh) title:@"Sync"];
    //To initialize Notes Reader
    dataManager = [DataManager sharedDataManager];
    dataManager.localNotesFileReader = [[LocalNotesFileReader alloc] init];
    //Initialize table view
    notesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40)];
    [self.view addSubview:notesTableView];
    [notesTableView setDataSource:self];
    [notesTableView setDelegate:self];
    [[DBSession sharedSession] linkFromController:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}
-(void)viewDidAppear:(BOOL)animated {
    //add button for drop box sync
    UIView *dropBoxButton = [[UIView alloc]initWithFrame:
                             CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40,
                                        [UIScreen mainScreen].bounds.size.width, 40)];
    [dropBoxButton setBackgroundColor:[UIColor pxColorWithHexValue:@"#2196F3"]];
//    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
//    [line setBackgroundColor:[UIColor pxColorWithHexValue:@"#2196F3"]];
//    [dropBoxButton addSubview:line];
    UIImage *dropboxIcon = [UIImage imageNamed:@"dropbox.png"];
    UIImageView *dropboxIconView = [[UIImageView alloc]initWithImage:dropboxIcon];
    [dropboxIconView setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2, 2, 36, 36)];
    [dropBoxButton addSubview:dropboxIconView];
    UILabel *buttonDropBoxLabel = [[UILabel alloc]initWithFrame:
                                   CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    [buttonDropBoxLabel setTextColor:[UIColor whiteColor]];
    [buttonDropBoxLabel setTextAlignment:NSTextAlignmentCenter];
    buttonDropBoxLabel.text = @"Sync with DropBox";
    [dropBoxButton addSubview:buttonDropBoxLabel];
    [dropBoxButton setUserInteractionEnabled:TRUE];
    //Setup onclick for button dropbox
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(syncWithDropBox)];
    [dropBoxButton addGestureRecognizer:singleFingerTap];
    [self.view addSubview:dropBoxButton];
}
- (void)syncWithDropBox {
    BOOL a = [[DBSession sharedSession] isLinked];
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    else {
        [[[UIAlertView alloc]
           initWithTitle:@"Already Loged in!" message:@"Do you want to Log Out?"
           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil]
         show];
    }
}
- (void)refresh {
    [dataManager.localNotesFileReader ReadFilesList];
    dataManager.Notes = [dataManager.localNotesFileReader ReadNotes];
    [dataManager.localNotesFileReader syncAllFilesToDropbox];
    [self.notesTableView reloadData];
}
- (void)addnew{
    dataManager.selected = -1;
    [self pushToNewNotes];
}
- (void)pushToNewNotes {
    NoteEditViewController *viewController = [[NoteEditViewController alloc]initWithNibName:@"NoteEditViewController" bundle:nil];
    GALOCNavigationController *navcontroller = (GALOCNavigationController *)self.parentViewController;
    [navcontroller pushViewController:viewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dataManager.Notes count];
    //return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    @try {
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cel" forIndexPath:indexPath];
    }
    @catch (NSException *exception) {
    }
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cel"];
    }
    NSUInteger row = [dataManager.Notes count]-indexPath.row-1;
    cell.textLabel.text = [self getTitleOrContent:row flag:TRUE];
    cell.detailTextLabel.text = [self getTitleOrContent:row flag:FALSE];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
- (NSString *)getTitleOrContent: (NSUInteger)index flag:(Boolean)flag{
    NSArray *keys = dataManager.localNotesFileReader.FilesList;
    NSString *Title = @"";
    Title = [dataManager.Notes objectForKey:[keys objectAtIndex:index]];
    NSUInteger length;
    if (flag) length = 20;
    else length = 100;
    if ([Title length]<length) {
        length = [Title length];
    }
    Title = [Title substringToIndex:length];
    return Title;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
//Called if a row is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [dataManager.Notes count]-indexPath.row-1;
    dataManager.selected = row;
    [self pushToNewNotes];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [dataManager.Notes count]-indexPath.row-1;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *keys = dataManager.localNotesFileReader.FilesList;
        NSString *key = [keys objectAtIndex:row];
        [dataManager.Notes removeObjectForKey:key];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [dataManager.localNotesFileReader deleteFileWithFileName:key];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
    if (index == alertView.cancelButtonIndex) {
        [alertView dismissWithClickedButtonIndex:index animated:YES];
    }
    else if(index != alertView.cancelButtonIndex){
        [alertView dismissWithClickedButtonIndex:index animated:YES];
        [[DBSession sharedSession] unlinkAll];
    }
}
@end
