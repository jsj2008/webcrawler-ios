//
//  WCSettingsLocalizer.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 22/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCSettingsLocalizer <NSObject>

-(NSString*)titleForStartButton;
-(NSString*)titleForStopButton;

@end
