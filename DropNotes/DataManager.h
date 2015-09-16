//
//  DataManager.h
//  DropNotes
//
//  Created by Prakash Selvam on 15/09/15.
//  Copyright (c) 2015 Prakash Selvam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalNotesFileReader.h"
#import "DropBoxFileSync.h"

@interface DataManager : NSObject

@property LocalNotesFileReader *localNotesFileReader;
@property NSMutableDictionary *Notes;
@property NSInteger selected;
@property DropBoxFileSync *dropBoxFileSyncObj;

+ (DataManager*)sharedDataManager;

@end
