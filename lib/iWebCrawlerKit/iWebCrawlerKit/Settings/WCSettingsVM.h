//
//  WCSettingsVM.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iWebCrawlerKit/Settings/WCSettingsState.h>
#import <iWebCrawlerKit/Model/WCSearchStatus.h>

@protocol WCSettingsVMDelegate;

@protocol WCSettingsVM <WCSettingsState>

/**
 Typically a weak property
 */
-(id<WCSettingsVMDelegate>)vcDelegate;

/**
 @param vcDelegate Typically a weak property
 */
-(void)setVcDelegate:(id<WCSettingsVMDelegate>)vcDelegate;

/**
 The user has tapped the "start" button
 */
-(void)startButtonTapped;

/**
 The user has tapped the "stop" button
 */
-(void)stopButtonTapped;

/**
 "Start" or "Terminage" depending on [self status];
 */
-(NSString*)startButtonText;

-(WCSearchStatus)status;

-(void)searchTermDidChange:(NSString*)newValue;
-(void)rootUrlForSearchDidChange:(NSString*)newValue;
-(void)maxThreadCountDidChange:(NSUInteger)newValue;
-(void)maxWebPageCountDidChange:(NSUInteger)newValue;

@end
