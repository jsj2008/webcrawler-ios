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
    id<WCSettingsState> _initialState;
    WCSettingsStatePOD* _currentState;
    
    id<WCSearchModel> _model;
}

-(instancetype)initWithDefaultState:(id<WCSettingsState>)initialState
                              model:(id<WCSearchModel>)model
{
    NSParameterAssert(nil != initialState);
    NSParameterAssert(nil != model       );
    
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
    [self->_model setVmDelegate: self];
    
    return self;
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
    [self doesNotRecognizeSelector: _cmd];
}


-(void)searchModel:(id<WCSearchModel>)sender
didParseReachablePages:(NSArray*)reachablePages
            forUrl:(NSString*)pageUrl
{
    [self doesNotRecognizeSelector: _cmd];
}



-(void)searchModel:(id<WCSearchModel>)sender
didParseSearchTermEntries:(NSUInteger)foundResultsCount
            forUrl:(NSString*)pageUrl
{
    [self doesNotRecognizeSelector: _cmd];
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
