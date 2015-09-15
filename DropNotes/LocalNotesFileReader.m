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

-(id) init{
    self = [super init];
    return self;
}
//Reads file list notes that are stored in documents folder
- (void) ReadFilesList {
    @try {
        NSString *FilesListFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"FilesListFile.plist"];
        FilesList = [[NSMutableArray alloc] initWithContentsOfFile:FilesListFilePath];
        if (!FilesList) {
            FilesList = [[NSMutableArray alloc]init];
            [self WriteFileList:FilesList];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally {
        NSLog(@"Exception");
    }
    
}
- (void)WriteFileList:(NSMutableArray *)filesList {
    @try {
        if (filesList) {
            NSString *FilesListFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"FilesListFile.plist"];
            [[NSFileManager defaultManager] removeItemAtPath:FilesListFilePath error:nil];
            [filesList writeToFile:FilesListFilePath atomically:YES];
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
    @try {
        for (NSString *FileName in FilesList) {
            [Notes setObject:[self ReadNoteWithFileName:FileName] forKey:FileName];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally {
        NSLog(@"Exception");
    }
    return Notes;
}

//Reads a particular file with given name
- (NSString *) ReadNoteWithFileName:(NSString *)fileName {
    @try {
        if (fileName) {
            NSError *readError = nil;
            NSString *FilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:fileName];
            NSString *FileContent = [[NSString alloc] initWithContentsOfFile:FilePath encoding:NSUTF8StringEncoding error:&readError ];
            if (readError) {
                return @"error";
            }
            else{
                return FileContent;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally {
        NSLog(@"Exception");
    }
    return @"error";
}
//Writes a particular file with given name and content
- (Boolean) WriteNoteWithFileName:(NSString *)fileName andContent:(NSString *)Content {
    @try {
        if (fileName && Content) {
            NSError *writeError = nil;
            NSString *FilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:fileName];
            [Content writeToFile:FilePath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
            if (!writeError) {
                return TRUE;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally {
        NSLog(@"Exception");
    }
    return FALSE;
}
//to delete a file with name
- (void)deleteFileWithFileName:(NSString *)FileName {
    NSString *FilesListFilePath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:FileName];
    [[NSFileManager defaultManager] removeItemAtPath:FilesListFilePath error:nil];
    [FilesList removeObject:FileName];
    [self WriteFileList:FilesList];
}
//Get a name to give for new notes added by the user
- (NSString *)getNextFileNameAndWriteWithContent:(NSString *)Content {
    NSString *nextFileName = @"dropnotes0.txt";
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *key = [formatter stringFromDate:[NSDate date]];
    @try {
        if (FilesList) {
            nextFileName = [NSString stringWithFormat:@"%@.txt",key];
            [FilesList addObject:nextFileName];
            [self WriteFileList:FilesList];
            [self WriteNoteWithFileName:nextFileName andContent:Content];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
    @finally {
        NSLog(@"Exception");
    }
    return nextFileName;
}
@end












