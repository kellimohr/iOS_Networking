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
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration
                                                          delegate: self
                                                     delegateQueue: nil];
    NSURL *downloadURL = [NSURL URLWithString: @"http://api.openweathermap.org/data/2.5/weather?q=Seattle,us"];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL: downloadURL];
    
    [downloadTask resume];
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
        
        //KMWeatherData *weatherData = [[NSDictionary alloc] init];
        NSData *fileData = [NSData dataWithContentsOfURL: location];
        
        KMWeatherData *weatherWebData = [fileData objectFromJSONData];
        _weatherData = weatherWebData;
        
        NSDictionary *weatherEntry = [[ _weatherData valueForKeyPath: @"weather"] lastObject];
        NSDictionary *mainEntry = [ _weatherData valueForKeyPath: @"main"] ;
        
        _nameLabel.text = [ _weatherData valueForKeyPath:@"name"];
        _descriptionLabel.text = [ weatherEntry valueForKeyPath:@"description"];
        _tempLabel.text = [NSString stringWithFormat:@"%@",[mainEntry objectForKey:@"temp"]];
        
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
