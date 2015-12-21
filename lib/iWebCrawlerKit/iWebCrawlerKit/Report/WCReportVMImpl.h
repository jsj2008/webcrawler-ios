//
//  WCReportVMImpl.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iWebCrawlerKit/Report/WCReportVM.h>

@protocol WCSearchModel;
@protocol WCReportVMDelegate;


@interface WCReportVMImpl : NSObject<WCReportVM>

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;


-(instancetype)initWithModel:(id<WCSearchModel>)model
NS_REQUIRES_SUPER
NS_DESIGNATED_INITIALIZER
__attribute__((nonnull));

@property (nonatomic, weak) id<WCReportVMDelegate> vcDelegate;

@end
