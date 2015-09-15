//
//  DataManager.m
//  DropNotes
//
//  Created by Prakash Selvam on 15/09/15.
//  Copyright (c) 2015 Prakash Selvam. All rights reserved.
//

#import "DataManager.h"
static DataManager *instance = nil;
@implementation DataManager
+ (DataManager*)sharedDataManager {
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}
@end
