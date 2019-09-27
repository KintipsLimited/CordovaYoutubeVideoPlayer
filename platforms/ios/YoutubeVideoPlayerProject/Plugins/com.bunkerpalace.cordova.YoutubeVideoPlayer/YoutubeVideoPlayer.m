//
//  YoutubeVideoPlayer.m
//
//  Created by Adrien Girbone on 15/04/2014.
//
//

#import "YoutubeVideoPlayer.h"
#import "XCDYouTubeKit.h"
#import <AVKit/AVKit.h>

@implementation YoutubeVideoPlayer

- (void)openVideo:(CDVInvokedUrlCommand*)command
{

    CDVPluginResult* pluginResult = nil;
    
    NSString* videoID = [command.arguments objectAtIndex:0];
    
    if (videoID != nil) {
        
        // XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoID];
        
        /*
        XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
        NSArray *arVideoID = [videoID componentsSeparatedByString:@"&"];
        if ([arVideoID count] > 1) {
            videoID = [arVideoID objectAtIndex:0];
            NSString *timePart = [arVideoID objectAtIndex:1];
            NSString *timePart1 = [timePart stringByReplacingOccurrencesOfString:@"t=" withString:@""];  
            NSString *timePartFinal = [timePart1 stringByReplacingOccurrencesOfString:@"s" withString:@""];
            long time = [timePartFinal longLongValue];
            videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoID];
            videoPlayerViewController.moviePlayer.initialPlaybackTime = time;
        } else {
            videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoID];
        }

        [self.viewController presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
        */
        
        [self playVideo: videoID];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        
    } else {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Missing videoID Argument"];
        
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) playVideo:(NSString *) videoId {
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    [self.viewController presentViewController:playerViewController animated:YES completion:nil];

    __weak AVPlayerViewController *weakPlayerViewController = playerViewController;
    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoId completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {
        if (video)
        {
            NSDictionary *streamURLs = video.streamURLs;
            NSURL *streamURL = streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?: streamURLs[@(XCDYouTubeVideoQualityHD720)] ?: streamURLs[@(XCDYouTubeVideoQualityMedium360)] ?: streamURLs[@(XCDYouTubeVideoQualitySmall240)];
            weakPlayerViewController.player = [AVPlayer playerWithURL:streamURL];
            [weakPlayerViewController.player play];
        }
        else
        {
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
