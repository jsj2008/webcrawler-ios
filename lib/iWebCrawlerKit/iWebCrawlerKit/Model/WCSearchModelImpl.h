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

@property (nonatomic, readonly) WCSearchStatus status;

@end
