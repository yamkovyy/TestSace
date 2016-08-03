//
//  Car+CoreDataProperties.h
//  
//
//  Created by viera on 8/3/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Car.h"

NS_ASSUME_NONNULL_BEGIN

@interface Car (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *model;
@property (nullable, nonatomic, retain) NSString *price;
@property (nullable, nonatomic, retain) NSString *engine;
@property (nullable, nonatomic, retain) NSString *condition;
@property (nullable, nonatomic, retain) NSString *additionalInfo;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *transmission;

@end

NS_ASSUME_NONNULL_END
