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

//-(id<WCSearchModelDelegate>)vmDelegate;

/**
 Multiple delegates are allowed.
 Since the model is shared across several ViewModel classes
 */
-(void)addVmDelegate:(id<WCSearchModelDelegate>)delegate;
-(void)clearDelegateList;

-(void)startWithSettings:(id<WCSettingsState>)settings;
-(void)terminate;

-(WCSearchStatus)status;

@end
