//
//  WCMutableArrayReport.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCReportState.h"

@protocol WCPageStats;

@interface WCMutableArrayReport : NSObject<WCReportState>

-(void)addRecord:(id<WCPageStats>)newRecord;
-(void)clear;

@end
