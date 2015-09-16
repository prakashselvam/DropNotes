//
//  AppDelegate.m
//  DropNotes
//
//  Created by Prakash Selvam on 14/09/15.
//  Copyright (c) 2015 Prakash Selvam. All rights reserved.
//

#import "AppDelegate.h"
#include "DropNotes-prefix.pch"
#import "GALOCNavigationController.h"
#import "DropNotesTableViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "DataManager.h"
@interface AppDelegate () <DBSessionDelegate, DBNetworkRequestDelegate>
@property DropNotesTableViewController *homeView;
@end

@implementation AppDelegate
@synthesize window,homeView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    homeView = [[DropNotesTableViewController alloc]init];
    GALOCNavigationController *navController = [[GALOCNavigationController alloc]initWithRootViewController:homeView];
    window.rootViewController = navController;
    [window makeKeyAndVisible];
    // Set these variables before launching the app
    NSString* appKey = @"c2bwmygb62f86hf";
    NSString* appSecret = @"rtwdeahcfi24r74";
    NSString *root = kDBRootAppFolder;
    DBSession* session = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
    session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
    [DBSession setSharedSession:session];
    
    [DBRequest setNetworkRequestDelegate:self];
    
    NSURL *launchURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    NSInteger majorVersion =
    [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
    if (launchURL && majorVersion < 4) {
        // Pre-iOS 4.0 won't call application:handleOpenURL; this code is only needed if you support
        // iOS versions 3.2 or below
        [self application:application handleOpenURL:launchURL];
        return NO;
    }

    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            //create the file sync object to use in future
            [DataManager sharedDataManager].dropBoxFileSyncObj = [[DropBoxFileSync alloc]init];
        }
        return YES;
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId {
    relinkUserId = userId;
    [[[UIAlertView alloc]
       initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self
       cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil]
     show];
}
#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
    if (index != alertView.cancelButtonIndex) {
        [[DBSession sharedSession] linkFromController:homeView];
    }
    relinkUserId = nil;
}

#pragma mark -
#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted {
    outstandingRequests++;
    if (outstandingRequests == 1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)networkRequestStopped {
    outstandingRequests--;
    if (outstandingRequests == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end
