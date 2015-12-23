//
//  WCPageLoader.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCPageLoader.h"

@interface WCPageLoader() <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@end

@implementation WCPageLoader
{
    NSURLSession* _urlSession;
    NSString*     _cacheDir;
    NSUInteger    _maxParallelDownloadsCount;

    
    NSMutableSet  * _loadingUrls;
    NSMutableArray* _pendingUrlsQueue;
    
    NSMutableDictionary* _callbackForUrlMap;
    NSMutableDictionary* _downloadTaskForUrlMap;
    
    BOOL _isTerminated;
}

-(void)dealloc
{
    [self terminateAllTasks];
}

-(instancetype)initWithCacheDirectory:(NSString*)cacheDir
            maxParallelDownloadsCount:(NSUInteger)maxParallelDownloadsCount
{
    self = [super init];
    if (nil == self)
    {
        return nil;
    }
    
    
    self->_cacheDir = cacheDir;
    self->_maxParallelDownloadsCount = maxParallelDownloadsCount;
    
    // TODO : maybe inject a pre-configured session object
    [self setupUrlSession];
    
    self->_loadingUrls = [NSMutableSet new];
    self->_pendingUrlsQueue = [NSMutableArray new];
    self->_callbackForUrlMap = [NSMutableDictionary new];
    self->_downloadTaskForUrlMap = [NSMutableDictionary new];
    
    self->_isTerminated = NO;
    
    return self;
}

-(void)setupUrlSession
{
    NSURLSessionConfiguration* sessionConfig =
        [NSURLSessionConfiguration defaultSessionConfiguration];
    
    
    self->_urlSession = [NSURLSession sessionWithConfiguration: sessionConfig
                                                      delegate: self
                                                 delegateQueue: nil];
    {
        self->_urlSession.sessionDescription = @"org.dodikk.iWebCrawler.UrlSession";
    }
}

-(void)loadPageAsync:(NSString*)pageUrl
          completion:(WCLoaderCompletionBlock)callback
{
    @synchronized(self)
    {
        if (self->_isTerminated)
        {
            return;
        }
        
        
        self->_callbackForUrlMap[pageUrl] = callback;
        
        if ([self->_loadingUrls count] < self->_maxParallelDownloadsCount)
        {
            [self launchDownloadTaskForPage: pageUrl];
        }
        else
        {
            [self->_pendingUrlsQueue addObject: pageUrl];
        }
    }
}

-(void)launchDownloadTaskForPage:(NSString*)pageUrl
{
    NSURL* nsPageUrl = [NSURL URLWithString: pageUrl];
    if (nil == nsPageUrl)
    {
        return;
    }
    
    NSURLSessionDownloadTask* task = [self->_urlSession downloadTaskWithURL: nsPageUrl];
    self->_downloadTaskForUrlMap[pageUrl] = task;
    [self->_loadingUrls addObject: pageUrl];
    [self->_pendingUrlsQueue removeObject: pageUrl];
    
    [task resume];
}

-(void)terminateAllTasks
{
    NSDictionary* callbacksCopy = nil;
    
    @synchronized (self)
    {
        self->_isTerminated = YES;
        callbacksCopy = [NSDictionary dictionaryWithDictionary: self->_callbackForUrlMap];
    }

    
    // TODO : create a proper error class
    NSError* terminationError = [[NSError alloc] initWithDomain: @"ololo"
                                                           code: 13
                                                       userInfo: nil];
    
    [callbacksCopy enumerateKeysAndObjectsUsingBlock:
     ^void(NSString* pageUrl, WCLoaderCompletionBlock callback, BOOL* stop)
    {
        callback(pageUrl, nil, terminationError);
    }];
    
    [self->_urlSession invalidateAndCancel];
    
    self->_urlSession            = nil;
    self->_loadingUrls           = nil;
    self->_pendingUrlsQueue      = nil;
    self->_callbackForUrlMap     = nil;
    self->_downloadTaskForUrlMap = nil;
}

-(void)checkPendingTasksAndLaunch
{
    @synchronized(self)
    {
        while
        (
            ([self->_loadingUrls count] < self->_maxParallelDownloadsCount) &&
            [self->_pendingUrlsQueue count] > 0
        )
        {
            NSString* poppedUrl = self->_pendingUrlsQueue[0];
            [self->_pendingUrlsQueue removeObjectAtIndex: 0];
            
            [self launchDownloadTaskForPage: poppedUrl];
        }
    }
}

-(void)removeUrlFromLoadingList:(NSString*)pageUrl
{
    @synchronized(self)
    {
        [self->_loadingUrls removeObject: pageUrl];
        [self->_callbackForUrlMap removeObjectForKey: pageUrl];
        [self->_downloadTaskForUrlMap removeObjectForKey: pageUrl];
    }
}
                         
#pragma mark - @protocol NSURLSessionDelegate
-(void)URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(nullable NSError *)error
{
    [self terminateAllTasks];
}

#pragma mark - @protocol NSURLSessionDownloadDelegate
-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSString* requestedUrl = [downloadTask.originalRequest.URL absoluteString];
    WCLoaderCompletionBlock callback = self->_callbackForUrlMap[requestedUrl];
    NSParameterAssert(nil != callback);
    
    NSError* moveFileError = nil;
    NSURL* newLocation = [self moveFileToCaches: location
                                          error: &moveFileError];
    if (nil != moveFileError)
    {
        callback(requestedUrl, nil, moveFileError);
    }
    else
    {
        NSString* strFileName = [[newLocation filePathURL] absoluteString];
        strFileName = [strFileName stringByReplacingOccurrencesOfString: @"file://"
                                                             withString: @""];
        
        callback(requestedUrl, strFileName, nil);
    }
    
    [self removeUrlFromLoadingList: requestedUrl];
    [self checkPendingTasksAndLaunch];
}


#pragma mark -
#pragma mark Utils
-(NSURL*)moveFileToCaches:(NSURL*)tmpFileUrl
                    error:(NSError**)error
{
    // copypasted from Apple's example
    
    NSFileManager* fileManager = [ NSFileManager defaultManager ];
    NSURL* cachesDirectory = [NSURL URLWithString: self->_cacheDir];
    
    
    NSURL* downloadURL = tmpFileUrl;
    
    NSString* hashForUrl = [[[[tmpFileUrl absoluteString] dataUsingEncoding: NSUTF8StringEncoding] MD5Hash] base16String];
    
    NSString* tempFileName = hashForUrl;
    NSURL* destinationURL = [cachesDirectory URLByAppendingPathComponent: tempFileName ];
    
    [fileManager removeItemAtURL: destinationURL
                           error: NULL ];
    
    
    BOOL success = [fileManager moveItemAtURL: downloadURL
                                        toURL: destinationURL
                                        error: error];
    
    // https://developer.apple.com/library/ios/qa/qa1719/_index.html
    [destinationURL setResourceValue: @YES
                              forKey: NSURLIsExcludedFromBackupKey
                               error: error];
    
    if (success)
    {
        return destinationURL;
    }
    else
    {
        return nil;
    }
}

@end
