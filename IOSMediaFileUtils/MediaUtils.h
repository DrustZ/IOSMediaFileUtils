//
//  MediaUtils.h
//  FunCam
//
//  Created by 明瑞 on 14/12/22.
//  Copyright (c) 2014年 明瑞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MediaUtils : NSObject

+ (void) SaveFileAtCurrentTime:(NSURL *)fromUrl;
+ (NSURL*) SaveImageAtCurrentTime:(UIImage*)image;
+ (void) mergeTwoVideo:(NSURL *)url1 anotherURL:(NSURL *)url2 toURL:(NSURL *)tourl;
+ (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL;
+ (void)convertToMp4:(NSURL*)inputURL
           outputURL:(NSURL*)outputURL;
+ (UIImage *) imageWithView:(UIView *)view;
+ (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;
@end
