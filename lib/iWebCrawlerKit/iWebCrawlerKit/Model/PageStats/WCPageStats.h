//
//  WCPageStats.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCPageStats <NSObject>

-(NSString*)pageUrl;
-(NSUInteger)searchKeywordOccurenceCount;
-(NSArray*)links;

@end
