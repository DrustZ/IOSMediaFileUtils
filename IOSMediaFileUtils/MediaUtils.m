//
//  MediaUtils.m
//  FunCam
//
//  Created by 明瑞 on 14/12/22.
//  Copyright (c) 2014年 明瑞. All rights reserved.

#import "MediaUtils.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <AVFoundation/AVBase.h>

@implementation MediaUtils

+ (void) SaveFileAtCurrentTime:(NSURL *)fromUrl
{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSError *error;
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSDate *date = [NSDate new];
    NSDateFormatter *formate = [NSDateFormatter new];
    formate.dateFormat = @"yyyyMMddHHmmss";
    NSString *dstr = [formate stringFromDate:date];
    dstr = [dstr stringByAppendingString:@".mp4"];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:dstr];
    NSLog(@"已经保存为视频文件");
    
    
    [filemanager copyItemAtURL:fromUrl toURL:fileURL error:&error];
    [filemanager removeItemAtURL:fromUrl error:nil];
}

+ (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status)
         {
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"Completed exporting!");
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"Failed:%@", exportSession.error.description);
                 break;
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"Canceled:%@", exportSession.error);
                 break;
             default:
                 break;
         }     }];
}

+ (void)convertToMp4:(NSURL*)inputURL
           outputURL:(NSURL*)outputURL {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        //  UNCOMMENT ABOVE LINES FOR CROP VIDEO
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    
                    NSLog(@"Export canceled");
                    
                    break;
                default:
                    
                    break;
                    
            }
        }];
    }
}

+ (NSURL*) SaveImageAtCurrentTime:(UIImage*)image
{
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSDate *date = [NSDate new];
    NSDateFormatter *formate = [NSDateFormatter new];
    formate.dateFormat = @"yyyyMMddHHmmss";
    NSString *dstr = [formate stringFromDate:date];
    dstr = [dstr stringByAppendingString:@".png"];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:dstr];
    
    NSData* image_data = UIImagePNGRepresentation(image);
    [image_data writeToURL:fileURL atomically:YES];
    NSLog(@"已经保存为图像");
    
    return fileURL;
}

+ (void) mergeTwoVideo:(NSURL *)url1 anotherURL:(NSURL *)url2 toURL:(NSURL *)tourl
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:url2.path]) {
        NSLog(@"不需要进行多段视频合并");
        return;
    };
    
    //first, we merge the pure video and the pure audio
    AVMutableComposition* composition = [AVMutableComposition composition];
    AVURLAsset* video1 = [[AVURLAsset alloc]initWithURL:url1 options:nil];
    AVURLAsset* video2 = [[AVURLAsset alloc]initWithURL:url2 options:nil];

    AVMutableCompositionTrack * composedTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack * composedAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *videoAsset1Track = [[video1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVAssetTrack *videoAsset2Track = [[video2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];

    CMTime endtime1 = videoAsset1Track.timeRange.duration;
    CMTime endtime2 = videoAsset2Track.timeRange.duration;
    CMTime starttime1 = videoAsset1Track.timeRange.start;
    CMTime starttime2 = videoAsset2Track.timeRange.start;
    CMTime duration1 = CMTimeSubtract(endtime1, starttime1);
    //CMTime endtime = CMTimeSubtract(video2.duration, CMTimeMake(1, 100));
    //insert videos
    [composedTrack insertTimeRange:CMTimeRangeMake(starttime1, endtime1)
                           ofTrack:[[video1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                            atTime:kCMTimeZero
                             error:nil];
    
    
    [composedTrack insertTimeRange:CMTimeRangeMake(starttime2, endtime2)
                           ofTrack:[[video2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                            atTime:duration1
                             error:nil];
    //now insert audios
    [composedAudioTrack insertTimeRange:CMTimeRangeMake(starttime1, endtime1)
                           ofTrack:[[video1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                            atTime:kCMTimeZero
                             error:nil];
    
    
    [composedAudioTrack insertTimeRange:CMTimeRangeMake(starttime2, endtime2)
                           ofTrack:[[video2 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                            atTime:duration1
                             error:nil];
    
    NSString* myDocumentPath= tourl.path;
    
    if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
    }
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
    
    
    exporter.outputURL=tourl;
    exporter.outputFileType = @"com.apple.quicktime-movie";
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        switch ([exporter status]) {
            caseAVAssetExportSessionStatusFailed:
                break;
            caseAVAssetExportSessionStatusCancelled:
                break;
            caseAVAssetExportSessionStatusCompleted:
                break;
            default:
                break;
        }
    }];
}
// The import will be completed only when control reaches to  Handler block

@end
