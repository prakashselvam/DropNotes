//
//  DropBoxFileSync.h
//  DropNotes
//
//  Created by Prakash Selvam on 16/09/15.
//  Copyright (c) 2015 Prakash Selvam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropBoxFileSync : NSObject <DBRestClientDelegate>
@property (nonatomic, strong) DBRestClient *restClient;
-(void)WriteFilesToDropBoxWithName:(NSString *)fileName fromlocalPath:(NSString*)localPath;
-(void)deleteFileWithName:(NSString *)name;
@end
