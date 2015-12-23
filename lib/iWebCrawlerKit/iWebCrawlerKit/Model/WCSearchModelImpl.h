//
//  WCSearchModelImpl.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 22/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iWebCrawlerKit/Model/WCSearchModel.h>
#import <iWebCrawlerKit/Model/WCSearchStatus.h>

@interface WCSearchModelImpl : NSObject<WCSearchModel>

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;

-(instancetype)initWithCacheDirectory:(NSString*)cacheDir
NS_REQUIRES_SUPER
NS_DESIGNATED_INITIALIZER
__attribute__((nonnull));


@property (nonatomic, readonly) WCSearchStatus status;

-(void)addVmDelegate:(id<WCSearchModelDelegate>)delegate
__attribute__((nonnull));

-(void)startWithSettings:(id<WCSettingsState>)settings
__attribute__((nonnull));


@end
