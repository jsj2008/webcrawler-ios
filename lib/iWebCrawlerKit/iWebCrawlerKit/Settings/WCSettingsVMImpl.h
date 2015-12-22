//
//  WCSettingsVMImpl.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iWebCrawlerKit/Settings/WCSettingsVM.h>


@protocol WCSearchModel;
@protocol WCSettingsState;
@protocol WCSettingsLocalizer;


@interface WCSettingsVMImpl : NSObject<WCSettingsVM>

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;

-(instancetype)initWithDefaultState:(id<WCSettingsState>)initialState
                              model:(id<WCSearchModel>)model
                          localizer:(id<WCSettingsLocalizer>)localizer
NS_REQUIRES_SUPER
NS_DESIGNATED_INITIALIZER
__attribute__((nonnull));

@property (nonatomic, weak) id<WCSettingsVMDelegate> vcDelegate;

@property (nonatomic, readonly) BOOL isProgressIndicatorVisible;

@end
