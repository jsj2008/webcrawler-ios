//
//  WCSettingsVMImpl.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSettingsVMImpl.h"

@interface WCSettingsVMImpl() <WCSearchModelDelegate>
@end

@implementation WCSettingsVMImpl
{
    id<WCSettingsState>     _initialState;
    WCSettingsStatePOD*     _currentState;
    id<WCSearchModel>       _model       ;
    id<WCSettingsLocalizer> _localizer   ;
}

@dynamic isProgressIndicatorVisible;

-(instancetype)initWithDefaultState:(id<WCSettingsState>)initialState
                              model:(id<WCSearchModel>)model
                          localizer:(id<WCSettingsLocalizer>)localizer
{
    NSParameterAssert(nil != initialState);
    NSParameterAssert(nil != model       );
    NSParameterAssert(nil != localizer   );
    
    self = [super init];
    if (nil == self)
    {
        return nil;
    }
    
    self->_initialState = initialState;
    self->_currentState = [WCSettingsStatePOD new];
    {
        self->_currentState.searchTerm       = [initialState searchTerm      ];
        self->_currentState.rootUrlForSearch = [initialState rootUrlForSearch];
        self->_currentState.maxThreadCount   = [initialState maxThreadCount  ];
        self->_currentState.maxWebPageCount  = [initialState maxWebPageCount ];
    }
    
    self->_model = model;
    [self->_model addVmDelegate: self];
    
    self->_localizer = localizer;
    
    return self;
}

-(BOOL)isProgressIndicatorVisible
{
    return (WCSearchInProgress == [self->_model status]);
}


#pragma mark - WCSearchModelDelegate

-(void)searchModelDidFinishLoading:(id<WCSearchModel>)sender
{
    id<WCSettingsVMDelegate> strongDelegate = self.vcDelegate;
    [strongDelegate settingsVMDidFinishSearch: self];
}

-(void)searchModelDidTerminate:(id<WCSearchModel>)sender
{
    id<WCSettingsVMDelegate> strongDelegate = self.vcDelegate;
    [strongDelegate settingsVMDidTerminateSearch: self];
}

-(void)searchModel:(id<WCSearchModel>)sender
didDownloadPageContents:(id)pageContents
            forUrl:(NSString*)pageUrl
{
    // IDLE
    // ReportVC should handle this
}


-(void)searchModel:(id<WCSearchModel>)sender
didParseReachablePages:(NSArray*)reachablePages
            forUrl:(NSString*)pageUrl
{
    // IDLE
    // ReportVC should handle this
}



-(void)searchModel:(id<WCSearchModel>)sender
didParseSearchTermEntries:(NSUInteger)foundResultsCount
            forUrl:(NSString*)pageUrl
{
    // IDLE
    // ReportVC should handle this
}



#pragma mark - @protocol WCSettingsState
-(NSString*)searchTerm
{
    return [self->_currentState searchTerm];
}

-(NSString*)rootUrlForSearch
{
    return [self->_currentState rootUrlForSearch];
}

-(NSUInteger)maxThreadCount
{
    return [self->_currentState maxThreadCount];
}

-(NSUInteger)maxWebPageCount
{
    return [self->_currentState maxWebPageCount];
}

#pragma mark - Buttons
-(void)startButtonTapped
{
    id<WCSettingsVMDelegate> strongDelegate = self.vcDelegate;
    
    [self->_model startWithSettings: self->_currentState];
    [strongDelegate settingsVMDidStartSearch: self];
}

-(void)stopButtonTapped
{
    [self->_model terminate];
}

-(WCSearchStatus)status
{
    return [self->_model status];
}

-(NSString*)startButtonText
{
    if (WCSearchInProgress == self.status)
    {
        return [self->_localizer titleForStopButton];
    }
    else
    {
        return [self->_localizer titleForStartButton];
    }
}

#pragma mark - User Input
-(void)searchTermDidChange:(NSString*)newValue
{
    self->_currentState.searchTerm = newValue;
}

-(void)rootUrlForSearchDidChange:(NSString*)newValue
{
    self->_currentState.rootUrlForSearch = newValue;
}

-(void)maxThreadCountDidChange:(NSUInteger)newValue
{
    self->_currentState.maxThreadCount = newValue;
}

-(void)maxWebPageCountDidChange:(NSUInteger)newValue
{
    self->_currentState.maxWebPageCount = newValue;
}

@end
