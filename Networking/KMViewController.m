//
//  KMViewController.m
//  Networking
//
//  Created by Kelli Mohr on 11/13/13.
//  Copyright (c) 2013 Kelli Mohr. All rights reserved.
//

#import "KMViewController.h"
#import "KMWeatherData.h"

@interface KMViewController () <NSURLSessionDownloadDelegate>

@end

@implementation KMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self resetView];
    
}

- (void)resetView
{
    [self.view setNeedsDisplay];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration
                                                          delegate: self
                                                     delegateQueue: nil];
    NSURL *downloadURL = [NSURL URLWithString: @"http://api.openweathermap.org/data/2.5/weather?q=Seattle,us"];
    
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL: downloadURL];
    
    [downloadTask resume];
}

- (IBAction)refreshWeather:(id)sender
{
    //NSURLRequest* request = session.currentRequest;
    //[self.session invalidateAndCancel];
    
    [self resetView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"URL Session did finish downloading URL: %@", location);
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSData *fileData = [NSData dataWithContentsOfURL: location];

        NSDictionary *weatherDictionary = [fileData objectFromJSONData];
        KMWeatherData *weatherWebData = [[KMWeatherData alloc] initWithDictionary: weatherDictionary];
        
        _nameLabel.text = weatherWebData.name;
        _descriptionLabel.text = weatherWebData.description;
        _tempLabel.text = [weatherWebData.temp stringValue];
        
    }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    CGFloat percentComplete = (CGFloat)totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"URL Session did write %lli of %lli (%f)", bytesWritten, totalBytesWritten, percentComplete * 100.f);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"Did resume...");
}


@end
