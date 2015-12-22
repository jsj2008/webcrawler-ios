//
//  AppDelegate.m
//  iWebCrawler
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "AppDelegate.h"



#import "WCSettingsLocalizerApple.h"
#import "WCSearchVC.h"
#import "WCReportVC.h"


@interface AppDelegate ()
@end


@implementation AppDelegate


-(BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    WCSearchModelImpl* model = [WCSearchModelImpl new];
    
    UIStoryboard* defaultBoard = [UIStoryboard storyboardWithName: @"Main"
                                                           bundle: nil];
    
    UITabBarController* tabBar = objc_member_of_cast<UITabBarController>([defaultBoard instantiateInitialViewController]);
    
    WCSearchVC* searchVC = objc_member_of_cast<WCSearchVC>(tabBar.viewControllers[0]);
    {
        WCSettingsLocalizerApple* localizer = [WCSettingsLocalizerApple new];
        WCSettingsStatePOD* defaultSettings = [WCSettingsStatePOD new];
        {
            defaultSettings.maxThreadCount = 1;
            defaultSettings.maxWebPageCount = 1;
            defaultSettings.searchTerm = nil;
            defaultSettings.rootUrlForSearch = nil;
        }
        
        WCSettingsVMImpl* settingsVM =
        [[WCSettingsVMImpl alloc] initWithDefaultState: defaultSettings
                                                 model: model
                                             localizer: localizer];

        
        
        searchVC.viewModel = settingsVM;
    }
    
    
    
    WCReportVC* reportVC = objc_member_of_cast<WCReportVC>(tabBar.viewControllers[1]);
    {
        WCReportVMImpl* reportVM = [[WCReportVMImpl alloc] initWithModel: model];
        reportVC.viewModel = reportVM;
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBar;
    
    return YES;
}

@end
