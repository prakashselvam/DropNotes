//
//  LocalNotesFileReader.m
//  DropNotes
//
//  Created by Prakash Selvam on 15/09/15.
//  Copyright (c) 2015 Prakash Selvam. All rights reserved.
//

#import "LocalNotesFileReader.h"
#import "DropNotes-prefix.pch"

@implementation LocalNotesFileReader
@synthesize FilesList;


//Reads file list notes that are stored in documents folder
- (void) ReadFilesList {
    @try {
        NSString *FilesListFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"FilesListFile.plist"];
        FilesList = [[NSMutableDictionary alloc] initWithContentsOfFile:FilesListFilePath];
        if (!FilesList) {
            FilesList = [[NSMutableDictionary alloc]init];
            [[NSFileManager defaultManager] removeItemAtPath:FilesListFilePath error:nil];
            [FilesList writeToFile:FilesListFilePath atomically:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally {
        NSLog(@"Exception");
    }
    
}
//Reads all the notes from local Directory
- (NSMutableDictionary *) ReadNotes {
    NSMutableDictionary *Notes = [[NSMutableDictionary alloc]init];
    for (NSString *key in FilesList) {
        NSString *FileName = [FilesList objectForKey:key];
        [Notes setObject:[self ReadNoteWithFileName:FileName] forKey:FileName];
    }
    return Notes;
}

//Reads a particular file with given name
- (NSString *) ReadNoteWithFileName:(NSString *)fileName {
    if (fileName) {
        NSError *readError = nil;
        NSString *FilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:fileName];
        NSString *FileContent = [[NSString alloc] initWithContentsOfFile:FilePath encoding:NSUTF8StringEncoding error:&readError];
        if (readError) {
            return @"error";
        }
        else{
            return FileContent;
        }
    }
    return @"error";
}
//Writes a particular file with given name and content
- (Boolean) WriteNoteWithFileName:(NSString *)fileName andContent:(NSString *)Content {
    if (fileName && Content) {
        NSError *writeError = nil;
        NSString *FilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:fileName];
        [Content writeToFile:FilePath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
        if (!writeError) {
            return TRUE;
        }
    }
    return FALSE;
}
@end
