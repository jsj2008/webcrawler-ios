//
//  WCSearchModelImpl.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 22/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSearchModelImpl.h"

#import "WCPageLoader.h"


typedef std::vector< __weak id<WCSearchModelDelegate> > WCSearchModelDelegate_vt;

@implementation WCSearchModelImpl
{
    WCSearchModelDelegate_vt _delegateList;
    NSString* _cacheDir;
    
    WCPageLoader* _loader;
    id _pendingUrlsList;
    id _loadedUrlsList;
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
    //    // TODO : stop threads
    //    NSAssert(NO, @"not implemented");
    //    [self doesNotRecognizeSelector: _cmd];
    
    [self notifyTerminate];
    
    [self clearDelegateList];
    self->_loader = nil;
    self->_pendingUrlsList = nil;
    self->_loadedUrlsList = nil;
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
    
    return self;
}

#pragma mark - delegate list
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
    
    __weak WCSearchModelImpl* weakSelf = self;
    
    self->_status = WCSearchInProgress;
    
    self->_loader =
    [[WCPageLoader alloc] initWithCacheDirectory: self->_cacheDir
                       maxParallelDownloadsCount: [settings maxThreadCount]];
    
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
            [strongSelf processLoadedPage: pageUrl
                                  content: localPathToPageContents];
        }
    };
    
    [self->_loader loadPageAsync: [settings rootUrlForSearch]
                      completion: onRootPageLoaded];
}

-(void)processLoadedPage:(NSString*)webPageUrl
                 content:(NSString*)pathToPageContentsFile
{
    NSAssert(NO, @"not implemented");
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
