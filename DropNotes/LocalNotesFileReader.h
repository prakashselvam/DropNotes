//
//  LocalNotesFileReader.h
//  DropNotes
//
//  Created by Prakash Selvam on 15/09/15.
//  Copyright (c) 2015 Prakash Selvam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropBoxFileSync.h"

@interface LocalNotesFileReader : NSObject

@property NSMutableArray *FilesList;

-(id) init;
- (void) ReadFilesList;
- (NSMutableDictionary *) ReadNotes;
- (NSString *) ReadNoteWithFileName:(NSString *)fileName;
- (Boolean) WriteNoteWithFileName:(NSString *)fileName andContent:(NSString *)Content;
- (NSString *)getNextFileNameAndWriteWithContent:(NSString *)Content;
- (void)deleteFileWithFileName:(NSString *)FileName;
- (void)syncAllFilesToDropbox;
@end
