//
//  WCSettingsVMImpl.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSettingsVMImpl.h"

@implementation WCSettingsVMImpl
{
    id<WCSettingsState> _initialState;
    WCSettingsStatePOD* _currentState;
}

-(instancetype)initWithDefaultState:(id<WCSettingsState>)initialState
{
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
    
    return self;
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

    // TODO : update model
    [self doesNotRecognizeSelector: _cmd];
    
    [strongDelegate settingsVMDidStartSearch: self];
}

-(void)stopButtonTapped
{
    [self doesNotRecognizeSelector: _cmd];
    // TODO : update model
}

-(WCSearchStatus)status
{
    [self doesNotRecognizeSelector: _cmd];
    // TODO : query model
    
    return WCSearchNotStarted;
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
