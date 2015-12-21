//
//  WCSearchModel.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iWebCrawlerKit/Model/WCSearchStatus.h>

@protocol WCSettingsState;
@protocol WCSearchModelDelegate;


@protocol WCSearchModel <NSObject>

-(id<WCSearchModelDelegate>)vmDelegate;
-(void)setVmDelegate:(id<WCSearchModelDelegate>)delegate;

-(void)startWithSettings:(id<WCSettingsState>)settings;
-(void)terminate;

-(WCSearchStatus)status;

@end
