//
//  SADocument.m
//  ShapeArt
//
//  Created by Marek Hrusovsky on 17/11/14.
//  Copyright (c) 2014 Marek Hrusovsky. All rights reserved.
//

#import "SADocument.h"

@interface SADocument()
@property (strong, readwrite) SADocumentModel *currenDocumentModel;
@end

@implementation SADocument

#pragma mark - Serialization / Deserialization

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
  SADocumentModel *documentModel = nil;
  
  if ([contents length] > 0) {
    documentModel = [NSKeyedUnarchiver unarchiveObjectWithData:contents];
  }
  
  if (documentModel) {
    self.currenDocumentModel = documentModel;
  } else {
    self.currenDocumentModel = [[SADocumentModel alloc] init];
  }
  return YES;
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError {
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.currenDocumentModel];
  return data;
}


+ (NSURL *)documentURL
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentDirectory = [paths objectAtIndex:0];
  
  NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"document"];
  NSURL *fileURL = [NSURL fileURLWithPath:filePath];
  return fileURL;
}

@end
