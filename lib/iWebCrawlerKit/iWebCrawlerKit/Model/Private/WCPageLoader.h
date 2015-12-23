//
//  WCPageLoader.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^WCLoaderCompletionBlock)(
    NSString* pageUrl,
    NSString* localPathToPageContents,
    NSError* error);


@interface WCPageLoader : NSObject

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new  NS_UNAVAILABLE;

-(instancetype)initWithCacheDirectory:(NSString*)cacheDir
            maxParallelDownloadsCount:(NSUInteger)maxParallelDownloadsCount
NS_DESIGNATED_INITIALIZER
NS_REQUIRES_SUPER
__attribute__((nonnull));

-(void)loadPageAsync:(NSString*)pageUrl
          completion:(WCLoaderCompletionBlock)callback;

-(void)terminateAllTasks;

@end
