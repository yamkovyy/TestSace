//
//  CarTableViewCell.h
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@class Car;

@interface CarTableViewCell : SWTableViewCell

- (void)configureWithCar:(Car*)car;

@end
