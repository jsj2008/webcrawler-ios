//
//  WCSettingsLocalizerApple.m
//  iWebCrawler
//
//  Created by Oleksandr Dodatko on 22/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSettingsLocalizerApple.h"

@implementation WCSettingsLocalizerApple

-(NSString*)titleForStartButton
{
    return NSLocalizedString(@"BUTTON_TITLE_START", @"Start");
}

-(NSString*)titleForStopButton
{
    return NSLocalizedString(@"BUTTON_TITLE_STOP", @"Terminate");
}

@end
