//
//  ViewController.m
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "ViewController.h"
#import "DGActivityIndicatorView.h"
#import "CarManager.h"
#import "CarTableViewCell.h"
#import "WeatherManager.h"
#import "LocationManager.h"
#import "DetailViewViewController.h"
#import "Utils.h"

#define kAddCarSegue @"kAddCarSegue"
#define kPreviewSegueIdentefier @"kPreviewSegueIdentefier"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, LocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet DGActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) IBOutlet UILabel *condition;
@end

@implementation ViewController


#pragma mark - Memory management

#pragma mark - View LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage: nil
                                                  forBarMetrics: UIBarMetricsDefault];
    [self configureActivityView];
    [LocationManager sharedManager].delegate = self;
    
    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationItem.title = NSLocalizedString(@"Car List", nil);
    [self.navigationController.navigationBar setHidden: false];
    [self.tableView reloadData];
}

#pragma mark - Action Handlers
- (IBAction)onAddCarAction:(id)sender
{
    [self performSegueWithIdentifier: kAddCarSegue sender: self];
}

#pragma mark - Public

#pragma mark - Private
- (void)configureUI
{
    self.temperature.hidden = false;
    self.condition.hidden = false;
    self.temperature.text = [WeatherManager sharedManager].weather.temperature;
    self.condition.text = [WeatherManager sharedManager].weather.weatherCond;
    self.city.text = [WeatherManager sharedManager].weather.city;
}

- (void)configureActivityView
{
    self.activityIndicator.type = DGActivityIndicatorAnimationTypeBallClipRotate;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: kPreviewSegueIdentefier])
    {
        CarTableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];
        DetailViewViewController *vc = segue.destinationViewController;
        vc.currentCar = [CarManager sharedManager].cars[indexPath.row];
    }
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
    [self.navigationController.navigationBar setHidden: false];
}

#pragma mark - Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CarManager sharedManager].cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellId";
    
    CarTableViewCell *cell = (CarTableViewCell *)[tableView dequeueReusableCellWithIdentifier: cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell configureWithCar: [CarManager sharedManager].cars[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarTableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
    [self performSegueWithIdentifier: kPreviewSegueIdentefier sender: cell];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    [[CarManager sharedManager] deleteCar: [CarManager sharedManager].cars[index]];
    [self.tableView reloadData];
}

- (void)locationDidRecivedWithLocation:(NSString *)location
{
    if ([Utils isOnline])
    {
        self.city.text = location;
        [self.activityIndicator startAnimating];
        self.temperature.hidden = true;
        self.condition.hidden = true;
        [[WeatherManager sharedManager] getCurrentWeatherWithCompletetionBlock:^(BOOL success, NSDictionary *dict, NSError *error) {
            [self.activityIndicator stopAnimating];
            if (success)
            {
                self.temperature.hidden = false;
                self.condition.hidden = false;
                self.temperature.text = dict[@"temp"];
                self.condition.text = dict[@"weather"];
            }
        }];
    }
    else
    {
        [Utils showAlertIn: self withTitle: NSLocalizedString(@"No Internet", nil) message: NSLocalizedString(@"Offline mode", nil)  withDuration:1.0];
    }

}

@end
