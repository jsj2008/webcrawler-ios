//
//  WCSearchModelDelegate.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCSearchModel;

@protocol WCSearchModelDelegate <NSObject>

-(void)searchModelDidFinishLoading:(id<WCSearchModel>)sender;
-(void)searchModelDidTerminate:(id<WCSearchModel>)sender;

-(void)searchModel:(id<WCSearchModel>)sender
didDownloadPageContents:(id)pageContents
            forUrl:(NSString*)pageUrl;

-(void)searchModel:(id<WCSearchModel>)sender
didParseReachablePages:(NSArray*)reachablePages
            forUrl:(NSString*)pageUrl;


-(void)searchModel:(id<WCSearchModel>)sender
didParseSearchTermEntries:(NSUInteger)foundResultsCount
            forUrl:(NSString*)pageUrl;

@end
