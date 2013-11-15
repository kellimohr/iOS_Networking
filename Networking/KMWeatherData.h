//
//  KMWeatherData.h
//  Networking
//
//  Created by Kelli Mohr on 11/13/13.
//  Copyright (c) 2013 Kelli Mohr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMWeatherData : NSObject

@property (nonatomic, copy, readonly) NSURL *URL;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDecimalNumber *temp;
@property (nonatomic, strong) NSString *description;

- (KMWeatherData *) initWithDictionary:(NSDictionary *)dictionary;

@end
