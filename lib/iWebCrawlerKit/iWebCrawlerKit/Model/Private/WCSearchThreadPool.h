//
//  WCSearchThreadPool.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WCParserBlocks.h"

@interface WCSearchThreadPool : NSObject

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new  NS_UNAVAILABLE;

-(instancetype)initWithSearchKeyword:(NSString*)searchTerm
                     maxThreadsCount:(NSUInteger)maxThreadsCount
NS_DESIGNATED_INITIALIZER
NS_REQUIRES_SUPER
__attribute__((nonnull));



-(void)parseData:(NSString*)pathToLocalFileWithData
      forWebPage:(NSString*)pageUrl
      completion:(WCPageParserCompletionBlock)completionBlock;

@end
