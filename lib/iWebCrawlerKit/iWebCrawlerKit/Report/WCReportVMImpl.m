//
//  WCReportVMImpl.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCReportVMImpl.h"

@interface WCReportVMImpl() <WCSearchModelDelegate>
@end

@implementation WCReportVMImpl
{
    id<WCSearchModel> _model;
}

@dynamic isProgressIndicatorVisible;


-(instancetype)initWithModel:(id<WCSearchModel>)model
{
    self = [super init];
    if (nil == self)
    {
        return nil;
    }
    
    self->_model = model;
    [model addVmDelegate: self];
    
    return self;
}

-(BOOL)isProgressIndicatorVisible
{
    return (WCSearchInProgress == [self->_model status]);
}

#pragma mark - WCSearchModelDelegate

-(void)searchModelDidFinishLoading:(id<WCSearchModel>)sender
{
    id<WCReportVMDelegate> strongDelegate = self.vcDelegate;
    [strongDelegate reportVMDidFinishSearch: self];
}

-(void)searchModelDidTerminate:(id<WCSearchModel>)sender
{
    id<WCReportVMDelegate> strongDelegate = self.vcDelegate;
    [strongDelegate reportVMDidTerminateSearch: self];
}

-(void)searchModel:(id<WCSearchModel>)sender
didDownloadPageContents:(id)pageContents
            forUrl:(NSString*)pageUrl
{
    // IDLE
}


-(void)searchModel:(id<WCSearchModel>)sender
didParseReachablePages:(NSArray*)reachablePages
            forUrl:(NSString*)pageUrl
{
    // IDLE
}

-(void)searchModel:(id<WCSearchModel>)sender
didParseSearchTermEntries:(NSUInteger)foundResultsCount
            forUrl:(NSString*)pageUrl
{
    id<WCReportVMDelegate> strongDelegate = self.vcDelegate;
    [strongDelegate reportVMDidUpdateReportEntries: self];
}

#pragma  mark - WCReportState
-(NSUInteger)numberOfEntriesInReport
{
    id<WCReportState> report = [self->_model report];
    return [report numberOfEntriesInReport];
}

-(NSString*)urlOfEntryAtIndexPath:(NSIndexPath*)indexPath
{
    id<WCReportState> report = [self->_model report];
    return [report urlOfEntryAtIndexPath: indexPath];
}

-(NSUInteger)numberOfOccurencesAtIndexPath:(NSIndexPath*)indexPath
{
    id<WCReportState> report = [self->_model report];
    return [report numberOfOccurencesAtIndexPath: indexPath];
}

@end
