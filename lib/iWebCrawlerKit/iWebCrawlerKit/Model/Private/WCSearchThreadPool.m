//
//  WCSearchThreadPool.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSearchThreadPool.h"

#import "WCParserTaskInfo.h"
#import "WCSearchThread.h"



@implementation WCSearchThreadPool
{
    NSString*  _searchTerm;
    NSUInteger _maxThreadsCount;
    
    NSMutableDictionary* _workingThreadsByUrl;
    NSMutableArray* _idleThreads;
    
    NSMutableArray* _pendingInput;
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
    
    self->_workingThreadsByUrl = [NSMutableDictionary new];
    self->_idleThreads = [NSMutableArray new];
    self->_pendingInput = [NSMutableArray new];
    
    return self;
}

-(BOOL)canParseImmediately
{
    @synchronized(self)
    {
        return [self->_workingThreadsByUrl count] < self->_maxThreadsCount;
    }
}

-(BOOL)shouldCreateNewThread
{
    @synchronized(self)
    {
        return (0 == [self->_idleThreads count]);
    }
}

-(BOOL)isPendingTasksExist
{
    @synchronized(self)
    {
        return 0 != [self->_pendingInput count];
    }
}

-(void)parseData:(NSString*)pathToLocalFileWithData
      forWebPage:(NSString*)pageUrl
      completion:(WCPageParserCompletionBlock)completionBlock
{
    WCParserTaskInfoPOD* inputData = [WCParserTaskInfoPOD new];
    {
        inputData.pageUrl = pageUrl;
        inputData.pathToLocalFileWithData = pathToLocalFileWithData;
        inputData.completionBlock = completionBlock;
    }

    
    if ([self canParseImmediately])
    {
        [self runParsingTask: inputData];
    }
    else
    {
        @synchronized(self)
        {
            [self->_pendingInput addObject: inputData];
        }
    }
}

-(void)runParsingTask:(id<WCParserTaskInfo>)taskInfo
{
    if ([self shouldCreateNewThread])
    {
        [self runParsingTaskOnNewThread: taskInfo];
    }
    else
    {
        [self runParsingTaskOnExistingThread: taskInfo];
    }
}

-(void)runParsingTaskOnNewThread:(id<WCParserTaskInfo>)taskInfo
{
    WCSearchThread* thread = [[WCSearchThread alloc] initWithSearchTerm: self->_searchTerm];
    [thread start];
    
    [self runParsingTask: taskInfo
                onThread: thread];
}

-(void)runParsingTaskOnExistingThread:(id<WCParserTaskInfo>)taskInfo
{
    WCSearchThread* thread = nil;
    
    @synchronized(self)
    {
        thread = self->_idleThreads[0];
        [self->_idleThreads removeObjectAtIndex: 0];
    }
    
    [self runParsingTask: taskInfo
                onThread: thread];
    
}

-(void)runParsingTask:(id<WCParserTaskInfo>)taskInfo
             onThread:(WCSearchThread*)thread
{
    NSString* pageUrl = [taskInfo pageUrl];
    WCPageParserCompletionBlock originalCallback = [taskInfo completionBlock];
    
    @synchronized(self)
    {
        self->_workingThreadsByUrl[pageUrl] = thread;
    }
    

    
    __weak WCSearchThreadPool* weakSelf = self;
    WCPageParserCompletionBlock hookedCallback =
    ^void(NSString *webPageUrl, id<WCPageStats> maybeResult, NSError *maybeError)
    {
        WCSearchThreadPool* strongSelf = weakSelf;
        
        [strongSelf consumeFinishedThreadForUrl: webPageUrl];
        [strongSelf tryLaunchPendingTasks];
        
        originalCallback(webPageUrl, maybeResult, maybeError);
    };
    
    
    [thread parseWebPage: pageUrl
                contents: [taskInfo pathToLocalFileWithData]
                callback: hookedCallback];

}

-(void)consumeFinishedThreadForUrl:(NSString*)webPageUrl
{
    @synchronized(self)
    {
        NSThread* thread = self->_workingThreadsByUrl[webPageUrl];
        [self->_workingThreadsByUrl removeObjectForKey: webPageUrl];
        [self->_idleThreads addObject: thread];
    }
}

-(void)tryLaunchPendingTasks
{
    while
    (
        [self isPendingTasksExist] &&
        [self canParseImmediately]
    )
    {
        id<WCParserTaskInfo> taskInfo = nil;
        
        @synchronized(self)
        {
            taskInfo = self->_pendingInput[0];
            [self->_pendingInput removeObjectAtIndex: 0];
        }
        
        [self runParsingTask: taskInfo];
    }
}
    
@end
