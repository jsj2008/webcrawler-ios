//
//  WCSearchThread.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSearchThread.h"

#import "WCPageStatsPOD.h"

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
    
    
    if ([self isCancelled])
    {
        return;
    }
    [self notifySuccess];
}


// TODO : implement tags trimming.
// Assuming neither tag names nor therir parts will be a part of the query.
//
//
// Using NSScanner since third-parties are forbidden for this task.
-(void)searchForOccurrences
{
    NSString* tmp = nil;
    
    
    // TODO : use NSRange if "browser like" search is considered as a bug
    //
    NSScanner* scanner = [[NSScanner alloc] initWithString: self->_pageContents];
    scanner.caseSensitive = NO;
    
    while (!scanner.isAtEnd)
    {
        if ([self isCancelled])
        {
            return;
        }
        
        [scanner scanUpToString: self->_searchTerm
                     intoString: NULL];
        
        
        // If string is present at the current scan location, then the current scan location is advanced to after the string; otherwise the scan location does not change.
        BOOL isSearchTermFound = [scanner scanString: self->_searchTerm
                                          intoString: &tmp];
        if (isSearchTermFound)
        {
            ++self->_foundWordsCounter;
        }
    }
}


// TODO : Use an appropriate library for HTML parsing
// https://github.com/nolanw/HTMLReader
//
// Otherwise some invalid pages may cause bugs
//
-(void)searchForLinks
{
    NSCharacterSet* quotesCharacterSet =
    [NSCharacterSet characterSetWithCharactersInString: @"'\""];
    
    NSScanner* scanner = [[NSScanner alloc] initWithString: self->_pageContents];
    scanner.caseSensitive = NO;
    
    while (!scanner.isAtEnd)
    {
        if ([self isCancelled])
        {
            return;
        }
        
        [scanner scanUpToString: @"<"
                     intoString: NULL];
        [scanner scanString: @"<"
                 intoString: NULL];
        
        
        [scanner scanUpToString: @"a"
                     intoString: NULL];
        [scanner scanString: @"a"
                 intoString: NULL];
        
        [scanner scanUpToString: @"href"
                     intoString: NULL];
        [scanner scanString: @"href"
                 intoString: NULL];
        
        [scanner scanUpToString: @"="
                     intoString: NULL];
        [scanner scanString: @"="
                 intoString: NULL];
        
        [scanner scanUpToCharactersFromSet: quotesCharacterSet
                                intoString: NULL];
        [scanner scanCharactersFromSet: quotesCharacterSet
                            intoString: NULL];
        
        
        NSString* linkValue = nil;
        [scanner scanUpToCharactersFromSet: quotesCharacterSet
                                intoString: &linkValue];
        [scanner scanCharactersFromSet: quotesCharacterSet
                            intoString: NULL];

        if (nil != linkValue)
        {
            // TODO : fix combo bookmarks if needed
            // http://xyz.html#abcde
            //
            BOOL isBookmarkLink = [linkValue hasPrefix: @"#"];
            if (isBookmarkLink)
            {
                continue;
            }
            
            BOOL isAbsoluteLink =
                [linkValue hasPrefix: @"http://" ] ||
                [linkValue hasPrefix: @"https://"];
            if (!isAbsoluteLink)
            {
                NSString* currentDir = [self->_pageUrl stringByDeletingLastPathComponent];
                linkValue = [currentDir stringByAppendingPathComponent: linkValue];
            }
            
            [self->_foundLinks addObject: linkValue];
        }
    }
}

-(void)notifySuccess
{
    WCPageStatsPOD* result = [WCPageStatsPOD new];
    {
        result.pageUrl = self->_pageUrl;
        result.searchKeywordOccurenceCount = self->_foundWordsCounter;
        result.links = [NSArray arrayWithArray: self->_foundLinks];
    }
    
    self->_callback(self->_pageUrl, result, nil);
}

@end
