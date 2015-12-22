//
//  SecondViewController.m
//  iWebCrawler
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCReportVC.h"

@interface WCReportVC ()
<
    WCReportVMDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UIView *progressPlaceholder;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressView;
@property (weak, nonatomic) IBOutlet UITableView *reportTable;

@end

@implementation WCReportVC
{
    NSLocale* _currentLocale;
}


#pragma mark - write once
-(void)setViewModel:(id<WCReportVM>)value
{
    NSParameterAssert(nil == self->_viewModel);
    
    self->_viewModel = value;
}


#pragma mark - Initialization
-(void)viewDidLoad
{
    [super viewDidLoad];
    

    self->_currentLocale = [NSLocale autoupdatingCurrentLocale];
    
    NSParameterAssert(nil != self.viewModel);
    [self->_viewModel setVcDelegate: self];
    
    [self updateProgressView];
    [self removeStoryboardColourStubs];
}

-(void)reloadData
{
    // TODO : optimize
    [self.reportTable reloadData];
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

-(void)removeStoryboardColourStubs
{
    UIColor* clearColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.progressPlaceholder.backgroundColor = clearColor;
}

#pragma mark - @protocol WCReportVMDelegate

-(void)reportVMDidStartSearch:(id<WCReportVM>)sender
{
    [self updateProgressView];
}

-(void)reportVMDidFinishSearch:(id<WCReportVM>)sender
{
    [self updateProgressView];
    [self reloadData];
}

-(void)reportVMDidTerminateSearch:(id<WCReportVM>)sender
{
    [self updateProgressView];
    [self reloadData];
}


-(void)reportVMDidUpdateReportEntries:(id<WCReportVM>)sender
{
    [self reloadData];
}


#pragma mark - @protocol UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return static_cast<NSInteger>([self.viewModel numberOfEntriesInReport]);
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* url = [self.viewModel urlOfEntryAtIndexPath: indexPath];
    NSUInteger entriesCount = [self.viewModel numberOfOccurencesAtIndexPath: indexPath];
    
    static NSString* const CELL_ID = @"REPORT_CELL";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: CELL_ID];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                      reuseIdentifier: CELL_ID];
    }

    
    cell.textLabel.text = url;
    cell.detailTextLabel.text = [@(entriesCount) descriptionWithLocale: self->_currentLocale];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
