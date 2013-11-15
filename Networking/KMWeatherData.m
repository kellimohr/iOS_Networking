//
//  KMWeatherData.m
//  Networking
//
//  Created by Kelli Mohr on 11/13/13.
//  Copyright (c) 2013 Kelli Mohr. All rights reserved.
//

#import "KMWeatherData.h"

@implementation KMWeatherData

- (KMWeatherData *)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        NSDictionary *weatherEntry = [[dictionary objectForKey: @"weather"] lastObject];

        self.name = [weatherEntry objectForKey: @"name"];
        self.temp = [weatherEntry valueForKeyPath: @"main.temp"];
        self.description = [weatherEntry valueForKeyPath: @"weather.description"];
    }
    return self;
}

@end
