//
//  SecondViewController.h
//  iWebCrawler
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCReportVM;


@interface WCReportVC : UIViewController

@property (nonatomic) id<WCReportVM> viewModel;

@end

