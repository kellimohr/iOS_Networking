//
//  KMViewController.h
//  Networking
//
//  Created by Kelli Mohr on 11/13/13.
//  Copyright (c) 2013 Kelli Mohr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONKit/JSONKit.h>
#import "KMWeatherData.h"

@interface KMViewController : UIViewController

@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UILabel *tempLabel;
@property (nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic) IBOutlet UIButton *refreshButton;
- (IBAction)refreshWeather:(id)sender;

@property (nonatomic, strong) KMWeatherData *weatherData;


@end
