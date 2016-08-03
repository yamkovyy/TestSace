//
//  WeatherManager.m
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "WeatherManager.h"
#import "AFNetworking.h"
#import "LocationManager.h"
#import <MagicalRecord/MagicalRecord.h>

#define kBaseMethodURL @"http://api.openweathermap.org"
#define kAPI_KEY @"ae727d9e09566bc3833a2489df950315"
#define kSortKey @"Weather"

@interface WeatherManager()

@property (nonatomic, strong) AFHTTPRequestOperationManager *mHttpManager;
@property (nonatomic, strong) NSString *currentWeather;

@end

@implementation WeatherManager

#pragma mark - Memory management
+ (WeatherManager*)sharedManager
{
    static dispatch_once_t pred;
    static WeatherManager *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[WeatherManager alloc] init];
        [shared initHTTPManager];
        [shared loadStoredWeather];
    });
    
    return shared;
}

#pragma mark - View LifeCycle

#pragma mark - Action Handlers

#pragma mark - Public
- (void)getCurrentWeatherWithCompletetionBlock:(void (^)(BOOL success, NSDictionary *dict, NSError *error))completionBlock
{
    NSString *currentLat = [NSString stringWithFormat:@"%f", [[LocationManager sharedManager] getCurrentLatitude]];
    NSString *currentLon = [NSString stringWithFormat:@"%f", [[LocationManager sharedManager] getCurrentLongitude]];
    
    NSDictionary *params = @{@"APPID" : kAPI_KEY, @"lat" : currentLat, @"lon" : currentLon};
    
    [self.mHttpManager GET:@"/data/2.5/weather" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *responseTemp = operation.responseObject[@"main"];
         NSArray *tmpArray = operation.responseObject[@"weather"];
         NSDictionary *responseWeatherCond = tmpArray.firstObject;
         if (responseTemp && responseWeatherCond)
         {
             NSNumber *temp = responseTemp[@"temp"];
             int roundedTemt = roundf(temp.floatValue - 273.15);
             NSString *cond = responseWeatherCond[@"main"];
             NSString *indicator = roundedTemt >= 0 ? @"+" : @"";
             NSString *celcius = [NSString stringWithFormat: @"%@%d", indicator, roundedTemt];
             
             NSDictionary *weather = @{@"weather" : cond, @"temp" : celcius};
             [self saveWeather: weather];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     completionBlock(YES, weather, nil);
                 });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 completionBlock(NO, nil, nil);
             });
         }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             completionBlock(NO, nil, error);
         });
     }];

}

#pragma mark - Private
- (void)initHTTPManager
{
    self.mHttpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString: kBaseMethodURL]];
    [self.mHttpManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    self.mHttpManager.responseSerializer = [AFJSONResponseSerializer serializer];
}

- (void)saveWeather:(NSDictionary*)dict
{
    Weather *weather = [Weather MR_createEntity];
    weather.temperature = dict[@"temp"];
    weather.weatherCond = dict[@"weather"];
    weather.city = [[LocationManager sharedManager] getCurrentCity];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion: ^(BOOL success, NSError *error)
     {
    
     }];
}

- (void)loadStoredWeather
{
    NSString *sortKey = [[NSUserDefaults standardUserDefaults] objectForKey: kSortKey];
    NSArray *array = [[Weather MR_findAllSortedBy: sortKey ascending: NO] mutableCopy];
    if (array.count > 0)
    {
        self.weather = array.lastObject;
    }
}

#pragma mark - Delegates

@end
