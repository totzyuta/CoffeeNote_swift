//
//  for-image-files.m
//  CoffeeNote
//
//  Created by totz on 10/18/14.
//  Copyright (c) 2014 totz. All rights reserved.
//

#import "for-image-files.h"

@implementation for_image_files

- (UIImage *)loadImage:(NSString *)filePath
{
  // ファイルから画像データを読み込み、UIImageオブジェクトを作成
  UIImage *image= [[UIImage alloc] initWithContentsOfFile:filePath];
  return image;
}

@end
