//
//  WCSearchModelImpl.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 22/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSearchModelImpl.h"

#import "WCPageLoader.h"
#import "WCSearchThreadPool.h"
#import "WCMutableArrayReport.h"


typedef std::vector< __weak id<WCSearchModelDelegate> > WCSearchModelDelegate_vt;

@implementation WCSearchModelImpl
{
    WCSearchModelDelegate_vt _delegateList;
    NSString* _cacheDir;
    
    WCPageLoader* _loader;
//    id _pendingUrlsList;
//    id _loadedUrlsList;
//    id _processedUrlsList;
    
    WCSearchThreadPool* _parserThreadPool;
    NSMutableSet* _visitedPages;
    
    WCMutableArrayReport* _report;
    
    id<WCSettingsState> _settings;
}

#pragma mark - memory management
-(void)dealloc
{
    [self terminate];
}

-(void)terminate
{
    self->_status = WCSearchTerminated;
    
    [self->_loader terminateAllTasks];
    
    [self notifyTerminate];
    
    [self clearDelegateList];
    self->_loader = nil;
//    self->_pendingUrlsList = nil;
//    self->_loadedUrlsList = nil;
}

#pragma mark - setup
-(instancetype)initWithCacheDirectory:(NSString*)cacheDir
{
    self = [super init];
    if (nil == self)
    {
        return nil;
    }
    
    self->_cacheDir = cacheDir;
    self->_visitedPages = [NSMutableSet new];
    
    return self;
}

#pragma mark - delegate list
-(id<WCReportState>)report
{
    return self->_report;
}

-(void)addVmDelegate:(id<WCSearchModelDelegate>)delegate
{
    self->_delegateList.push_back(delegate);
}

-(void)clearDelegateList
{
    self->_delegateList.clear();
}

#pragma mark - logic
-(void)startWithSettings:(id<WCSettingsState>)settings
{
    NSParameterAssert(WCSearchInProgress != self.status);
    
    self->_settings = settings;
    self->_status = WCSearchInProgress;
    
    
    NSUInteger threadsCount = [settings maxThreadCount];
    NSString* rootPage = [settings rootUrlForSearch];
    
    self->_report = [WCMutableArrayReport new];
    
    self->_parserThreadPool =
    [[WCSearchThreadPool alloc] initWithSearchKeyword: [settings searchTerm]
                                      maxThreadsCount: threadsCount];
    
    self->_loader =
    [[WCPageLoader alloc] initWithCacheDirectory: self->_cacheDir
                       maxParallelDownloadsCount: threadsCount];
    
    [self loadPageAsync: rootPage];
}

-(void)loadPageAsync:(NSString*)webPage
{
    __weak WCSearchModelImpl* weakSelf = self;
    
    [self->_visitedPages addObject: webPage];
    
    WCLoaderCompletionBlock onRootPageLoaded =
    ^void(NSString *pageUrl, NSString *localPathToPageContents, NSError *error)
    {
        WCSearchModelImpl* strongSelf = weakSelf;
        
        if (nil == localPathToPageContents)
        {
            [strongSelf notifyFinish];
        }
        else
        {
            [strongSelf parseLoadedPageAsync: pageUrl
                                     content: localPathToPageContents];
        }
    };
    
    [self->_loader loadPageAsync: webPage
                      completion: onRootPageLoaded];
    
}

-(void)parseLoadedPageAsync:(NSString*)webPageUrl
                    content:(NSString*)pathToPageContentsFile
{
    __weak WCSearchModelImpl* weakSelf = self;
    
    WCPageParserCompletionBlock onPageParsed =
    ^void(NSString* pageUrl, id<WCPageStats> maybeResult, NSError *maybeError)
    {
        WCSearchModelImpl* strongSelf = weakSelf;
        
        if (nil == maybeResult)
        {
            // TODO : maybe add error handling code
            return;
        }
        
        [strongSelf updateReportAndProcessNewLinks: maybeResult];
    };
    
    [self->_parserThreadPool parseData: pathToPageContentsFile
                            forWebPage: webPageUrl
                            completion: onPageParsed];
}

-(void)updateReportAndProcessNewLinks:(id<WCPageStats>)newReportItem
{
    [self->_report addRecord: newReportItem];
    
    NSArray* links = [newReportItem links];
    for (NSString* singleLink in links)
    {
        if ([self->_visitedPages count] >= [self->_settings maxWebPageCount])
        {
            break;
        }
        else if ([self->_visitedPages containsObject: singleLink])
        {
            continue;
        }

        [self loadPageAsync: singleLink];
    }
}


#pragma mark - Delagate events
-(void)notifyTerminate
{
    for (auto d : self->_delegateList)
    {
        [d searchModelDidTerminate: self];
    }
}

// TODO : maybe notify about errors separately
-(void)notifyFinish
{
    for (auto d : self->_delegateList)
    {
        [d searchModelDidFinishLoading: self];
    }
}

@end
