//
//  WCReportVM.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iWebCrawlerKit/Report/WCReportState.h>

@protocol WCReportVMDelegate;


@protocol WCReportVM <NSObject, WCReportState>

/**
 Typically a weak property
 */
-(id<WCReportVMDelegate>)vcDelegate;

/**
 @param vcDelegate Typically a weak property
 */
-(void)setVcDelegate:(id<WCReportVMDelegate>)vcDelegate;


@end
