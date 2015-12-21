//
//  WCSearchModelImpl.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 22/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSearchModelImpl.h"

@implementation WCSearchModelImpl

-(void)addVmDelegate:(id<WCSearchModelDelegate>)delegate
{
    
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
}

@end
