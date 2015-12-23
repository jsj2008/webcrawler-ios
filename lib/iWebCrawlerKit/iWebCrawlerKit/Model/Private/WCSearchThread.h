//
//  WCSearchThread.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCParserBlocks.h"

@interface WCSearchThread : NSThread

+ (void)detachNewThreadSelector:(SEL)selector
                       toTarget:(id)target
                     withObject:(id)argument
NS_UNAVAILABLE;

+(instancetype)new NS_UNAVAILABLE;
-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithSearchTerm:(NSString*)searchTerm
NS_DESIGNATED_INITIALIZER
NS_REQUIRES_SUPER
__attribute__((nonnull));

-(void)parseWebPage:(NSString*)pageUrl
           contents:(NSString*)localFilePath
           callback:(WCPageParserCompletionBlock)callback;

@end
