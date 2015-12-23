//
//  WCSearchThread.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSearchThread.h"

@implementation WCSearchThread
{
    NSString* _searchTerm;
    
    NSString* _pageUrl;
    NSString* _localFilePath;
    WCPageParserCompletionBlock _callback;
    
    NSCondition* _suspendCondition;
    
    NSMutableArray* _foundLinks;
    NSUInteger _foundWordsCounter;
    
    
    // Supposed that loading entire file to memory is a good enough approach.
    // TODO : use IO streams to optimize memory footprint
    //
    //
    NSString* _pageContents;
}

-(instancetype)initWithSearchTerm:(NSString*)searchTerm
{
    NSParameterAssert(nil != searchTerm);
    
    self = [super init];
    if (nil == self)
    {
        return nil;
    }
    
    self->_searchTerm = searchTerm;
    self->_suspendCondition = [NSCondition new];
    
    return self;
}


-(void)parseWebPage:(NSString*)pageUrl
           contents:(NSString*)localFilePath
           callback:(WCPageParserCompletionBlock)callback
{
    NSParameterAssert(nil == self->_pageUrl);
    
    [self->_suspendCondition lock];
    {
        self->_pageUrl       = pageUrl      ;
        self->_localFilePath = localFilePath;
        self->_callback      = callback     ;
        
        
        self->_foundWordsCounter = 0;
        [self->_foundLinks removeAllObjects];
    }
    [self->_suspendCondition signal];
    [self->_suspendCondition unlock];
}

-(void)cleanupInputs
{
    self->_pageUrl       = nil;
    self->_localFilePath = nil;
    self->_callback      = nil;
    
    self->_pageContents = nil;
    self->_foundWordsCounter = 0;
    [self->_foundLinks removeAllObjects];
}

#pragma mark - override NSThread
-(void)main
{
    // Note : Suspend pattern taken from the discussion below
    // http://stackoverflow.com/questions/1557070/how-to-pause-an-nsthread-until-notified
    //
    //
    
    while (![self isCancelled])
    {
        [self->_suspendCondition lock];
        while (nil == self->_pageUrl)
        {
            [self->_suspendCondition wait];
        }
        

        [self doParsing];
        
        
        [self cleanupInputs];
        [self->_suspendCondition unlock];
    }
}

-(void)doParsing
{
    if ([self isCancelled])
    {
        return;
    }

    NSError* fileReadError = nil;
    self->_pageContents = [NSString stringWithContentsOfFile: self->_localFilePath
                                                    encoding: NSUTF8StringEncoding
                                                       error: &fileReadError];
    if (nil != fileReadError)
    {
        self->_callback(self->_pageUrl, nil, fileReadError);
        return;
    }
    
    
    if ([self isCancelled])
    {
        return;
    }
    [self searchForOccurrences];
    
    
    
    if ([self isCancelled])
    {
        return;
    }
    [self searchForLinks];
}

-(void)searchForOccurrences
{
    [self doesNotRecognizeSelector: _cmd];
}

-(void)searchForLinks
{
    [self doesNotRecognizeSelector: _cmd];
}

@end
