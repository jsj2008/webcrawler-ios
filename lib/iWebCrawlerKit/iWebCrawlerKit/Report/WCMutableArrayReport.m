//
//  WCMutableArrayReport.m
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCMutableArrayReport.h"

@implementation WCMutableArrayReport
{
    NSMutableArray* _result;
}

-(instancetype)init
{
    self = [super init];
    if (nil == self)
    {
        return nil;
    }
    
    self->_result = [NSMutableArray new];
    
    return self;
}

-(void)addRecord:(id<WCPageStats>)newRecord
{
    [self->_result addObject: newRecord];
}

-(void)clear
{
    self->_result = [NSMutableArray new];
}

#pragma mark - @protocol WCReportState
-(NSUInteger)numberOfEntriesInReport
{
    return [self->_result count];
}

static const NSUInteger ROW_INDEX_POSITION = 1;
-(NSString*)urlOfEntryAtIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger recordIndex = [indexPath indexAtPosition: ROW_INDEX_POSITION];
    return [self->_result[recordIndex] pageUrl];
}

-(NSUInteger)numberOfOccurencesAtIndexPath:(NSIndexPath*)indexPath
{
    NSUInteger recordIndex = [indexPath indexAtPosition: ROW_INDEX_POSITION];
    return [self->_result[recordIndex] searchKeywordOccurenceCount];
}

@end
