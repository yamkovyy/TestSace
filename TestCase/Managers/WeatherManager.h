//
//  WeatherManager.h
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

@interface WeatherManager : NSObject

@property (nonatomic, strong) Weather *weather;

+ (WeatherManager*)sharedManager;
- (void)getCurrentWeatherWithCompletetionBlock:(void (^)(BOOL success, NSDictionary *dict, NSError *error))completionBlock;

@end
