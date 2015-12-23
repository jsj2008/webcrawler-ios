//
//  WCPageStatsPOD.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 23/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCPageStats.h"

@interface WCPageStatsPOD : NSObject<WCPageStats>

@property (nonatomic) NSString*  pageUrl;
@property (nonatomic) NSUInteger searchKeywordOccurenceCount;
@property (nonatomic) NSArray*   links;

@end
