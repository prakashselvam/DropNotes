//
//  DropBoxFileSync.m
//  DropNotes
//
//  Created by Prakash Selvam on 16/09/15.
//  Copyright (c) 2015 Prakash Selvam. All rights reserved.
//

#import "DropBoxFileSync.h"

@implementation DropBoxFileSync

- (id)init{
    self = [super init];
    if ([[DBSession sharedSession] isLinked]) {
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
    }
    return self;
}

-(void)WriteFilesToDropBoxWithName:(NSString *)fileName fromlocalPath:(NSString*)localPath {
        // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:fileName toPath:destDir fromPath:localPath];
    //[self.restClient uploadFile:fileName toPath:destDir withParentRev:@"" fromPath:localPath];
}
-(void)deleteFileWithName:(NSString *)name{
    NSString *destPath = [NSString stringWithFormat:@"/%@",name];
    [self.restClient deletePath:destPath];
}

#pragma mark restclient delegates
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}

-(void)restClient:(DBRestClient *)client deletedPath:(NSString *)path {
    
}
-(void)restClient:(DBRestClient *)client deletePathFailedWithError:(NSError *)error {
    
}
@end
