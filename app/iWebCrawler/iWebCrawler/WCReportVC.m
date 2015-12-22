//
//  SecondViewController.m
//  iWebCrawler
//
//  Created by Oleksandr Dodatko on 21/12/2015.
//  Copyright © 2015 dodikk. All rights reserved.
//

#import "WCReportVC.h"

@interface WCReportVC ()<WCReportVMDelegate>

@end

@implementation WCReportVC

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
    

    NSParameterAssert(nil != self.viewModel);
    [self->_viewModel setVcDelegate: self];
}

-(void)reloadData
{
    
}

#pragma mark - @protocol WCReportVMDelegate

-(void)reportVMDidStartSearch:(id<WCReportVM>)sender
{
    // IDLE
}

-(void)reportVMDidFinishSearch:(id<WCReportVM>)sender
{
    // TODO : hide progress indicator
    [self reloadData];
}

-(void)reportVMDidTerminateSearch:(id<WCReportVM>)sender
{
    // TODO : hide progress indicator
    [self reloadData];
}


-(void)reportVMDidUpdateReportEntries:(id<WCReportVM>)sender
{
    // TODO : hide progress indicator
    [self reloadData];
}


@end
