//
//  Weather+CoreDataProperties.h
//  
//
//  Created by viera on 8/3/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Weather.h"

NS_ASSUME_NONNULL_BEGIN

@interface Weather (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *temperature;
@property (nullable, nonatomic, retain) NSString *weatherCond;

@end

NS_ASSUME_NONNULL_END
