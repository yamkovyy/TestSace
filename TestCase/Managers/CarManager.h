//
//  CarManager.h
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Car;

@interface CarManager : NSObject

@property (nonatomic, strong) NSMutableArray *cars;

+ (CarManager*)sharedManager;
- (void)createCar:(NSString*)model price:(NSString*)price engine:(NSString*)engine transmittion:(NSString*)transmittion condition:(NSString*)condition additionalInfo:(NSString*)additionalInfo images:(NSMutableArray*)images;
- (void)deleteCar:(Car*)car;

@end
