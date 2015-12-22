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

@property (weak, nonatomic) IBOutlet UIView *progressPlaceholder;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressView;

@end


@implementation WCSearchVC

#pragma mark - write once
-(void)setViewModel:(id<WCSettingsVM>)value
{
    NSParameterAssert(nil == self->_viewModel);
    
    self->_viewModel = value;
}


#pragma mark - Initialization
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSParameterAssert(nil != self.viewModel);
    
    [self.viewModel setVcDelegate: self];
    
    [self removeStoryboardColourStubs];
    [self updateButtonText];
    
    [self localizeLabels];
    [self updateValues];
    
    [self updateProgressView];
    [self updateButtonText];
}

-(void)localizeLabels
{
    self.searchKeywordLabel.text = NSLocalizedString(@"LABEL_SEARCH_TERM", nil);
    self.urlLabel          .text = NSLocalizedString(@"LABEL_URL"        , nil);
    self.threadsLabel      .text = NSLocalizedString(@"LABEL_THREADS"    , nil);
    self.sitesLabel        .text = NSLocalizedString(@"LABEL_SITES"      , nil);
}

-(void)updateValues
{
    self.searchKeywordInput.text = [self.viewModel searchTerm];
    self.urlInput.text = [self.viewModel rootUrlForSearch];
    
    self.threadsSlider.value = [self.viewModel maxThreadCount];
    self.sitesSlider.value = [self.viewModel maxWebPageCount];
    
    NSLocale* locale = [NSLocale currentLocale];
    self.sitesValueLabel.text = [@([self.viewModel maxWebPageCount]) descriptionWithLocale: locale];
    self.threadsValueLabel.text = [@([self.viewModel maxThreadCount]) descriptionWithLocale: locale];
}

-(void)updateButtonText
{
    NSString* buttonTitle = [self.viewModel startButtonText];
    [self.startButton setTitle: buttonTitle
                      forState: UIControlStateNormal];
}

-(void)removeStoryboardColourStubs
{
    UIColor* clearColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.progressPlaceholder.backgroundColor = clearColor;
    self.searchKeywordPlaceholder.backgroundColor = clearColor;
    self.urlPlaceholder.backgroundColor = clearColor;
    self.threadsPlaceholder.backgroundColor = clearColor;
    self.sitesPlaceholder.backgroundColor = clearColor;

    self.threadsValueLabel.backgroundColor = clearColor;
    self.sitesValueLabel.backgroundColor = clearColor;
}

-(void)navigateToReportScreen
{
    [self.tabBarController setSelectedIndex: 1];
}

#pragma mark - User input
-(IBAction)onStartButtonTapped:(id)sender
{
    [self.searchKeywordInput resignFirstResponder];
    [self.urlInput resignFirstResponder];
    
    if ([self.viewModel status] != WCSearchInProgress)
    {
        [self.viewModel startButtonTapped];
    }
    else
    {
        [self.viewModel stopButtonTapped];
    }
    
    [self updateProgressView];
    [self updateButtonText];
}

-(void)updateProgressView
{
    if ([self.viewModel isProgressIndicatorVisible])
    {
        self.progressView.hidden = NO;
        [self.progressView startAnimating];
    }
    else
    {
        [self.progressView stopAnimating];
        self.progressView.hidden = YES;
    }
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
    NSUInteger castedValue = static_cast<NSUInteger>(self.sitesSlider.value);
    [self.viewModel maxWebPageCountDidChange: castedValue];

    // TODO : maybe move to VM
    NSLocale* locale = [NSLocale currentLocale];
    self.sitesValueLabel.text = [@(castedValue) descriptionWithLocale: locale];
}

-(IBAction)threadsSliderValueChanged:(id)sender
{
    NSUInteger castedValue = static_cast<NSUInteger>(self.threadsSlider.value);
    [self.viewModel maxThreadCountDidChange: castedValue];
    
    // TODO : maybe move to VM
    NSLocale* locale = [NSLocale currentLocale];
    self.threadsValueLabel.text = [@(castedValue) descriptionWithLocale: locale];
}


#pragma mark - @protocol WCSettingsVMDelegate

-(void)settingsVMDidStartSearch:(id<WCSettingsVM>)sender
{
    [self updateProgressView];
    [self updateButtonText];
    
    [self navigateToReportScreen];
}

-(void)settingsVMDidFinishSearch:(id<WCSettingsVM>)sender
{
    [self updateProgressView];
    [self updateButtonText];
    
    [self navigateToReportScreen];
}

-(void)settingsVMDidTerminateSearch:(id<WCSettingsVM>)sender
{
    [self updateProgressView];
    [self updateButtonText];
    
    [self navigateToReportScreen];
}

@end
