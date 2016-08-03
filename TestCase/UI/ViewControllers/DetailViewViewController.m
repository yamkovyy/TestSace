//
//  DetailViewViewController.m
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "DetailViewViewController.h"
#import "CarCollectionViewCell.h"

@interface DetailViewViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *car;
@property (strong, nonatomic) IBOutlet UILabel *carInfo;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *priceInfo;
@property (strong, nonatomic) IBOutlet UILabel *engine;
@property (strong, nonatomic) IBOutlet UILabel *transmission;
@property (strong, nonatomic) IBOutlet UILabel *condition;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionField;

@property (strong, nonatomic) NSMutableArray *carImages;
@property (strong, nonatomic) UIView *dotsVeiw;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) int scrollFromLeftToRight;

@end

@implementation DetailViewViewController

#pragma mark - Memory management

#pragma mark - View LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initVariables];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self createDots];
}

#pragma mark - Action Handlers

#pragma mark - Public

#pragma mark - Private
- (void)initVariables
{
    self.car.text = NSLocalizedString(@"Car", nil);
    self.carInfo.text = self.currentCar.model;
    self.price.text = NSLocalizedString(@"Price", nil);
    self.priceInfo.text = self.currentCar.price;
    self.engine.text = self.currentCar.engine;
    self.transmission.text = self.currentCar.transmission;
    self.condition.text = self.currentCar.condition;
    self.descriptionLabel.text = NSLocalizedString(@"Description", nil);
    self.descriptionField.text = self.currentCar.additionalInfo;
    self.descriptionField.textColor = [UIColor whiteColor];
    
    self.carImages = [NSKeyedUnarchiver unarchiveObjectWithData: self.currentCar.image];
    
    self.currentIndex = 0;
}

- (void)createDots
{
    if (!self.dotsVeiw)
    {
        int dotSize = 15.0f;
        float offset = 10.0f;
        
        self.dotsVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dotSize * self.carImages.count, dotSize)];
        self.dotsVeiw.center = CGPointMake(self.view.bounds.size.width * 0.5, CGRectGetMaxY(self.collectionView.frame) + offset);
        self.dotsVeiw.backgroundColor = [UIColor clearColor];
        
        for (int i = 0; i < self.carImages.count; i++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(dotSize * i, 0, dotSize, dotSize)];
            imageView.image = [UIImage imageNamed: @"round"];
            imageView.alpha = 0.6;
            imageView.tag = i;
            [self.dotsVeiw addSubview: imageView];
        }
        
        [self.view addSubview: self.dotsVeiw];
        [self updateDots];
        
    }

}

- (void)updateDots
{
    for (UIImageView *imageView in self.dotsVeiw.subviews)
    {
        if (imageView.tag == self.currentIndex)
        {
            imageView.alpha = 1.0f;
        }
        else
        {
            imageView.alpha = 0.6f;
        }
    }
}

#pragma mark - Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.carImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellId" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.carImage.image = self.carImages[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
        NSIndexPath *indexPath = [self.collectionView indexPathForCell: [self.collectionView visibleCells].lastObject];
        
        if (self.scrollFromLeftToRight <= 0) {
            indexPath = [self.collectionView indexPathForCell: [self.collectionView visibleCells].firstObject];
        }
        self.currentIndex = indexPath.row;
        [self updateDots];
}

- (void)scrollViewWillEndDragging: (UIScrollView *)scrollView withVelocity: (CGPoint)velocity targetContentOffset: (inout CGPoint *)targetContentOffset
{
    self.scrollFromLeftToRight = [scrollView.panGestureRecognizer velocityInView: scrollView].x;
}

- (void)scrollViewDidEndDragging: (UIScrollView *)scrollView willDecelerate: (BOOL)decelerate
{
    self.scrollFromLeftToRight = [scrollView.panGestureRecognizer velocityInView: scrollView].x;

}

@end
