//
//  WCSearchThreadPool.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSearchThreadPool.h"

@implementation WCSearchThreadPool
{
    NSString*  _searchTerm;
    NSUInteger _maxThreadsCount;
}

-(instancetype)initWithSearchKeyword:(NSString*)searchTerm
                     maxThreadsCount:(NSUInteger)maxThreadsCount
{
    NSParameterAssert(0 != maxThreadsCount);
    NSParameterAssert(nil != searchTerm);
    
    self = [super init];
    if (nil == self)
    {
        return nil;
    }
    
    self->_searchTerm = searchTerm;
    self->_maxThreadsCount = maxThreadsCount;
    
    return self;
}

-(void)parseData:(NSString*)pathToLocalFileWithData
      forWebPage:(NSString*)pageUrl
      completion:(WCPageParserCompletionBlock)completionBlock
{
    NSAssert(NO, @"not implemented");
}

@end
