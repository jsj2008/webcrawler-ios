//
//  WCSettingsStatePOD.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iWebCrawlerKit/Settings/WCSettingsState.h>

@interface WCSettingsStatePOD : NSObject<WCSettingsState>

@property (nonatomic) NSString*  searchTerm      ;
@property (nonatomic) NSString*  rootUrlForSearch;
@property (nonatomic) NSUInteger maxThreadCount  ;
@property (nonatomic) NSUInteger maxWebPageCount ;

@end
