//
//  WCSearchModelImpl.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 22/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSearchModelImpl.h"

typedef std::vector< __weak id<WCSearchModelDelegate> > WCSearchModelDelegate_vt;

@implementation WCSearchModelImpl
{
    WCSearchModelDelegate_vt _delegateList;
}


-(void)addVmDelegate:(id<WCSearchModelDelegate>)delegate
{
    self->_delegateList.push_back(delegate);
}

-(void)clearDelegateList
{
    self->_delegateList.clear();
}

-(void)startWithSettings:(id<WCSettingsState>)settings
{
    self->_status = WCSearchInProgress;
    
    // TODO : launch threads
    NSAssert(NO, @"not implemented");
    [self doesNotRecognizeSelector: _cmd];
}

-(void)terminate
{
    self->_status = WCSearchTerminated;
    
    // TODO : stop threads
    NSAssert(NO, @"not implemented");
    [self doesNotRecognizeSelector: _cmd];
    
    
    for (auto d : self->_delegateList)
    {
        [d searchModelDidTerminate: self];
    }
}

@end
