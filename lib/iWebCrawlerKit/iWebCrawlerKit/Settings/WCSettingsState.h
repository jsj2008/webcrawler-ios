//
//  WCSettingsState.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCSettingsState <NSObject>

-(NSString*)searchTerm;
-(NSString*)rootUrlForSearch;
-(NSUInteger)maxThreadCount;
-(NSUInteger)maxWebPageCount;


@end
