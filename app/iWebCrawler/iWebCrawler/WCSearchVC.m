//
//  FirstViewController.m
//  iWebCrawler
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCSearchVC.h"

@interface WCSearchVC ()<WCSettingsVMDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchKeywordPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *urlPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *threadsPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *sitesPlaceholder;


@property (weak, nonatomic) IBOutlet UILabel *searchKeywordLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *threadsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sitesLabel;


@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UITextField *searchKeywordInput;
@property (weak, nonatomic) IBOutlet UITextField *urlInput;

@property (weak, nonatomic) IBOutlet UISlider *threadsSlider;
@property (weak, nonatomic) IBOutlet UISlider *sitesSlider;

@property (weak, nonatomic) IBOutlet UILabel *threadsValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *sitesValueLabel;

@end


@implementation WCSearchVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.viewModel setVcDelegate: self];
    [self updateButtonText];
}

-(void)updateButtonText
{
    NSString* buttonTitle = [self.viewModel startButtonText];
    [self.startButton setTitle: buttonTitle
                      forState: UIControlStateNormal];
}

-(IBAction)onStartButtonTapped:(id)sender
{
    [self.searchKeywordInput resignFirstResponder];
    [self.urlInput resignFirstResponder];
    
    
    
    [self.viewModel startButtonTapped];
    [self updateButtonText];
}

-(IBAction)onSearchKeywordTextEntered:(id)sender
{
    [self.searchKeywordInput resignFirstResponder];
    [self.viewModel searchTermDidChange: self.searchKeywordInput.text];
}

-(IBAction)onRootWebPageTextEntered:(id)sender
{
    [self.urlInput resignFirstResponder];
    [self.viewModel rootUrlForSearchDidChange: self.urlInput.text];
}

-(IBAction)sitesSliderValueChanged:(id)sender
{
    NSUInteger castedValue = (NSUInteger)self.sitesSlider.value;
    [self.viewModel maxWebPageCountDidChange: castedValue];

    // TODO : maybe move to VM
    NSLocale* locale = [NSLocale currentLocale];
    self.sitesValueLabel.text = [@(castedValue) descriptionWithLocale: locale];
}

-(IBAction)threadsSliderValueChanged:(id)sender
{
    NSUInteger castedValue = (NSUInteger)self.threadsSlider.value;
    [self.viewModel maxThreadCountDidChange: castedValue];
    
    // TODO : maybe move to VM
    NSLocale* locale = [NSLocale currentLocale];
    self.threadsValueLabel.text = [@(castedValue) descriptionWithLocale: locale];
}


#pragma mark - @protocol WCSettingsVMDelegate

-(void)settingsVMDidStartSearch:(id<WCSettingsVM>)sender
{
    // TODO : navigate to other tab
}

-(void)settingsVMDidFinishSearch:(id<WCSettingsVM>)sender
{
    [self updateButtonText];
    // TODO : navigate to other tab
}

-(void)settingsVMDidTerminateSearch:(id<WCSettingsVM>)sender
{
    [self updateButtonText];
}

@end
