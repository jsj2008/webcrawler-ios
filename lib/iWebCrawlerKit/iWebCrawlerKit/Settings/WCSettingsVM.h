//
//  WCSettingsVM.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCSettingsVMDelegate;

@protocol WCSettingsVM <NSObject>

-(id<WCSettingsVMDelegate>)vcDelegate;
-(void)setVcDelegate:(id<WCSettingsVMDelegate>)vcDelegate;

-(void)startButtonTapped;
-(void)stopButtonTapped;

-(void)searchTermDidChange:(NSString*)newValue;
-(void)rootUrlForSearchDidChange:(NSString*)newValue;
-(void)maxThreadCountDidChange:(NSUInteger)newValue;
-(void)maxWebPageCountDidChange:(NSUInteger)newValue;

-(NSString*)searchTerm;
-(NSString*)rootUrlForSearch;
-(NSUInteger)maxThreadCount;
-(NSUInteger)maxWebPageCount;

@end
