//
//  CarTableViewCell.m
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "CarTableViewCell.h"
#import "Car.h"

@interface CarTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *currentImage;
@property (strong, nonatomic) IBOutlet UILabel *car;
@property (strong, nonatomic) IBOutlet UILabel *carInfo;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *priceInfo;
@property (strong, nonatomic) Car *currentCar;
@end

@implementation CarTableViewCell

#pragma mark - Memory management

#pragma mark - View LifeCycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self createRightButton];
    // Initialization code
}

#pragma mark - Action Handlers

#pragma mark - Public
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)configureWithCar:(Car*)car
{
    self.currentCar = car;
    NSMutableArray *images = [NSKeyedUnarchiver unarchiveObjectWithData: self.currentCar.image];
    self.currentImage.image = images.count ? images[0] : nil;
    self.car.text = NSLocalizedString(@"model", nil);
    self.price.text = NSLocalizedString(@"price", nil);
    self.carInfo.text = self.currentCar.model;
    self.priceInfo.text = self.currentCar.price;
    
}

#pragma mark - Private
- (void)createRightButton
{
    NSMutableArray *rightUtilityButton = [NSMutableArray new];
    [rightUtilityButton sw_addUtilityButtonWithColor:
    [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                    title:@"Delete"];
    self.rightUtilityButtons = rightUtilityButton;
}

#pragma mark - Delegates





@end
