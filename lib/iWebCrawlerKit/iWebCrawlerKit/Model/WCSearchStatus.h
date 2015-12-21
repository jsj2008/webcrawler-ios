//
//  WCSearhStatus.h
//  iWebCrawlerKit
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#ifndef WCSearchStatus_h
#define WCSearchStatus_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WCSearchStatus)
{
    WCSearchNotStarted = 0,
    WCSearchInProgress    ,
    WCSearchFinished      ,
    WCSearchTerminated
};

#endif /* WCSearhStatus_h */
