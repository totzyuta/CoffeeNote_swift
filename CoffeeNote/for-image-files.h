//
//  for-image-files.h
//  CoffeeNote
//
//  Created by totz on 10/18/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface for_image_files : NSObject

- (NSString *)joinString:(NSString *)string withNumber:(NSNumber *)number;
- (UIImage *)loadImage:(NSString *)filePath;

@end
