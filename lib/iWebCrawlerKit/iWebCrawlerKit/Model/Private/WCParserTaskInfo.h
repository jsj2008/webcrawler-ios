//
//  WCParserTaskInfo.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 24/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WCParserBlocks.h"

@protocol WCParserTaskInfo <NSObject>

-(NSString*)pathToLocalFileWithData;
-(NSString*)pageUrl;
-(WCPageParserCompletionBlock)completionBlock;

@end



@interface WCParserTaskInfoPOD : NSObject<WCParserTaskInfo>

@property (nonatomic, strong) NSString* pathToLocalFileWithData;
@property (nonatomic, strong) NSString* pageUrl;
@property (nonatomic, strong) WCPageParserCompletionBlock completionBlock;

@end
