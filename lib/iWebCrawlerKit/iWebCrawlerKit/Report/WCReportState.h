//
//  WCReportState.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 22/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSIndexPath;

@protocol WCReportState <NSObject>

-(NSUInteger)numberOfEntriesInReport;

-(NSString*)urlOfEntryAtIndexPath:(NSIndexPath*)indexPath;
-(NSUInteger)numberOfOccurencesAtIndexPath:(NSIndexPath*)indexPath;

@end
