//
//  WCSettingsVMDelegate.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCSettingsVM;

@protocol WCSettingsVMDelegate <NSObject>

/**
 The user has tapped the "start" button
 */
-(void)settingsVMDidStartSearch:(id<WCSettingsVM>)sender;

/**
 All reachable web pages have been processed.
 Or the search limits have been exceeded.
 */
-(void)settingsVMDidFinishSearch:(id<WCSettingsVM>)sender;


/**
 The user has tapped the "stop" button
 */
-(void)settingsVMDidTerminateSearch:(id<WCSettingsVM>)sender;

@end
