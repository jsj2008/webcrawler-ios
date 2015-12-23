//
//  WCParserBlocks.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#ifndef WCParserBlocks_h
#define WCParserBlocks_h

#import <Foundation/Foundation.h>


@class NSError;
@protocol WCPageStats;


typedef void (^WCPageParserCompletionBlock)(
    NSString* webPageUrl,
    id<WCPageStats> maybeResult,
    NSError* maybeError);


typedef void (^WCLoaderCompletionBlock)(
    NSString* pageUrl,
    NSString* localPathToPageContents,
    NSError* error);


#endif /* WCParserBlocks_h */
