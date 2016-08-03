//
//  CarManager.m
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "CarManager.h"
#import "Car.h"
#import <MagicalRecord/MagicalRecord.h>

NSString *const SORT_KEY = @"model";

@interface CarManager()

@end

@implementation CarManager
#pragma mark - Memory management

+ (CarManager*)sharedManager
{
    static dispatch_once_t pred;
    static CarManager *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[CarManager alloc] init];
        [shared loadCars];
    });
    
    return shared;
}

#pragma mark - View LifeCycle

#pragma mark - Action Handlers

#pragma mark - Public
- (void)createCar:(NSString*)model price:(NSString*)price engine:(NSString*)engine transmittion:(NSString*)transmittion condition:(NSString*)condition additionalInfo:(NSString*)additionalInfo images:(NSMutableArray*)images
{
    Car *car = [Car MR_createEntity];
    car.model = model;
    car.price = price;
    car.engine = engine;
    car.transmission = transmittion;
    car.condition = condition;
    car.image = [NSKeyedArchiver archivedDataWithRootObject: images];
    car.additionalInfo = additionalInfo;
    
    [self.cars addObject: car];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion: ^(BOOL success, NSError *error)
     {
         [self loadCars];
     }];
}

- (void)deleteCar:(Car*)car
{
    [self.cars removeObject: car];
    [car MR_deleteEntity];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion: ^(BOOL success, NSError *error)
     {
         [self loadCars];
     }];
}

#pragma mark - Private
- (void)loadCars
{
    NSString *sortKey = [[NSUserDefaults standardUserDefaults] objectForKey: SORT_KEY];
    self.cars = [[Car MR_findAllSortedBy: sortKey ascending: NO] mutableCopy];
}

#pragma mark - Delegates
@end
