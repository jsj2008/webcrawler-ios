//
//  WCReportVMDelegate.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCReportVM;


@protocol WCReportVMDelegate <NSObject>

/**
 The user has tapped the "start" button
 */
-(void)reportVMDidStartSearch:(id<WCReportVM>)sender;

/**
 All reachable web pages have been processed.
 Or the search limits have been exceeded.
 */
-(void)reportVMDidFinishSearch:(id<WCReportVM>)sender;


/**
 The user has tapped the "stop" button
 */
-(void)reportVMDidTerminateSearch:(id<WCReportVM>)sender;


/**
 Invoked by when a new record is added to the report.
 */
-(void)reportVMDidUpdateReportEntries:(id<WCReportVM>)sender;

@end
