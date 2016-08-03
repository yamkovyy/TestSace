//
//  AddCarViewController.m
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "AddCarViewController.h"
#import "CarCollectionViewCell.h"
#import "PhotoManager.h"
#import "SCLAlertView.h"
#import "Utils.h"
#import "CarManager.h"

#define kMaxNumberOfImages 10
#define kUnwindSegue @"unwindSegue"

@interface AddCarViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *carLabel;
@property (strong, nonatomic) IBOutlet UITextField *carInfo;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UITextField *price;
@property (strong, nonatomic) IBOutlet UIButton *engine;
@property (strong, nonatomic) IBOutlet UIButton *transmission;
@property (strong, nonatomic) IBOutlet UIButton *condition;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionField;

@property (nonatomic, strong) NSArray *engines;
@property (nonatomic, strong) NSArray *transmissions;
@property (nonatomic, strong) NSArray *conditions;

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) NSMutableArray *carImages;

@property (nonatomic, strong) UITextField *activeField;

@property (nonatomic, strong) UIView *pickerToolBarView;

@end

@implementation AddCarViewController

#pragma mark - Memory management

#pragma mark - View LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureInterface];
    [self initVariables];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardAppear:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDisAppear:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [self.navigationController setNavigationBarHidden: false];
}

#pragma mark - Action Handlers
- (IBAction)onEngineSelectionAction:(id)sender
{
    [self showPickerWithTag: 0];
}
- (IBAction)onTransmittionSelectionAction:(id)sender
{
    [self showPickerWithTag: 1];
}
- (IBAction)onConditionSelectionAction:(id)sender
{
    [self showPickerWithTag: 2];
}

- (IBAction)onAddCarAction:(id)sender
{
    if (self.carInfo.text.length == 0)
    {
        [Utils showAlertIn: self withTitle: NSLocalizedString(@"Fill field", nil) message: NSLocalizedString(@"Car", nil) withDuration: 0.0];
        return;
    }
    else if (self.price.text.length == 0)
    {
        [Utils showAlertIn: self withTitle: NSLocalizedString(@"Fill field", nil) message: NSLocalizedString(@"Price", nil) withDuration: 0.0];
        return;
    }
    else if ([self.engine.titleLabel.text isEqualToString: [NSString stringWithFormat:@"%@:",NSLocalizedString(@"engine", nil)]])
    {
        [Utils showAlertIn: self withTitle: NSLocalizedString(@"Fill field", nil) message: NSLocalizedString(@"engine", nil) withDuration: 0.0];
        return;
    }
    else if ([self.engine.titleLabel.text isEqualToString: [NSString stringWithFormat:@"%@:",NSLocalizedString(@"transmission", nil)]])
    {
        [Utils showAlertIn: self withTitle: NSLocalizedString(@"Fill field", nil) message: NSLocalizedString(@"transmission", nil) withDuration: 0.0];
        return;
    }
    else if ([self.engine.titleLabel.text isEqualToString: [NSString stringWithFormat:@"%@:",NSLocalizedString(@"condition", nil)]])
    {
        [Utils showAlertIn: self withTitle: NSLocalizedString(@"Fill field", nil) message: NSLocalizedString(@"condition", nil) withDuration: 0.0];
        return;
    }
    
    [[CarManager sharedManager] createCar: self.carInfo.text price: self.price.text engine: self.engine.titleLabel.text transmittion: self.transmission.titleLabel.text condition: self.condition.titleLabel.text additionalInfo: self.descriptionField.text images: self.carImages];
    [Utils showAlertIn: self withTitle: NSLocalizedString(@"saved", nil) message: nil withDuration: 1.0];
}

#pragma mark - Public

#pragma mark - Private
- (void)keyboardAppear:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrameBeginRect.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardFrameBeginRect.size.height;
    if (!CGRectContainsPoint(aRect, self.descriptionField.frame.origin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.descriptionField.frame.origin.y - keyboardFrameBeginRect.size.height);
        [self.scrollView setContentOffset: scrollPoint animated:YES];
    }
    
    [self hidePicker];
}

- (void)keyboardDisAppear:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentOffset: CGPointMake(0, -70) animated:YES];
}

- (void)showPickerWithTag:(NSUInteger)tag
{
    if (self.pickerToolBarView)
    {
        [self hidePicker];
    }
    
    [self.price resignFirstResponder];
    [self.carInfo resignFirstResponder];
    
    float pickerHeight = 200.0f;
    float toolBarHeight = 43.0f;
    self.pickerToolBarView = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - pickerHeight - toolBarHeight, self.view.frame.size.width, pickerHeight + toolBarHeight)];
    [self.pickerToolBarView setBackgroundColor:[UIColor clearColor]];
    
    self.picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, self.pickerToolBarView.bounds.size.height - pickerHeight, self.view.bounds.size.width, pickerHeight)];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    self.picker.tag = tag;
    self.picker.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.7f];
    
    [self.pickerToolBarView addSubview: self.picker];
    
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, toolBarHeight)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    toolBar.userInteractionEnabled = true;
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Done", nil)
                                                                      style: UIBarButtonItemStyleDone target: self
                                                                     action: @selector(hidePicker)];
    barButtonDone.action = @selector(hidePicker);
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:self
                                                                           action:nil];
    
    toolBar.items = @[flex, barButtonDone];
    barButtonDone.tintColor = [UIColor blackColor];
    [self.pickerToolBarView addSubview: toolBar];
    
    [self.view addSubview: self.pickerToolBarView];

    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - pickerHeight);
}

- (void)configureInterface
{
    self.carLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"Car", nil)];
    self.priceLabel.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"Price", nil)];
    [self.engine setTitle: [NSString stringWithFormat:@"%@:",NSLocalizedString(@"engine", nil)] forState: UIControlStateNormal];
    [self.transmission setTitle: [NSString stringWithFormat:@"%@:",NSLocalizedString(@"transmission", nil)] forState: UIControlStateNormal];
    [self.condition setTitle: [NSString stringWithFormat:@"%@:",NSLocalizedString(@"condition", nil)] forState: UIControlStateNormal];
    self.descriptionLabel.text = NSLocalizedString(@"Description", nil);
}

- (void)initVariables
{
    self.carImages = [NSMutableArray new];
    
    [self keyboardDisAppear: nil];
    
    self.engines = @[@"",@"1.2",@"1.4",@"1.8",@"2.0",@"2.5",@"3.0",@"3.5",@"3.7"];
    self.transmissions = @[@"", NSLocalizedString(@"Automatic", nil), NSLocalizedString(@"Manual", nil)];
    self.conditions = @[@"", NSLocalizedString(@"new", nil),NSLocalizedString(@"used", nil)];
}

- (void)hidePicker
{
    [self.pickerToolBarView removeFromSuperview];
    self.pickerToolBarView = nil;
    [self keyboardDisAppear: nil];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)editingFinish
{
    
}

#pragma mark - Delegates

#pragma mark - Delegates: UIPikerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger numberOfRows = 0;
    
    switch (pickerView.tag)
    {
        case 0:
            numberOfRows = self.engines.count;
            break;
        case 1:
            numberOfRows = self.transmissions.count;
            break;
        case 2:
            numberOfRows = self.conditions.count;
            break;
            
        default:
            break;
    }
    
    return numberOfRows;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    
    switch (pickerView.tag)
    {
        case 0:
            title = self.engines[row];
            break;
        case 1:
            title = self.transmissions[row];
            break;
        case 2:
            title = self.conditions[row];
            break;
            
        default:
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = @"";
    NSString *content = @"";
    UIButton *button;
    
    switch (pickerView.tag)
    {
        case 0:
            content = self.engines[row];
            button = self.engine;
            title = NSLocalizedString(@"engine", nil);
            break;
        case 1:
            content = self.transmissions[row];
            button = self.transmission;
            title = NSLocalizedString(@"transmission", nil);
            break;
        case 2:
            content = self.conditions[row];
            button = self.condition;
            title = NSLocalizedString(@"condition", nil);
            break;
            
        default:
            break;
    }
    
    [button setTitle: [NSString stringWithFormat: @"%@: %@", title, content] forState: UIControlStateNormal];
    
}

#pragma mark - Delegates: UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.scrollView.contentSize = self.view.bounds.size;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.scrollView.contentSize = self.view.bounds.size;
    return YES;
}

#pragma mark - Delegates: UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString: @"\n"])
    {
        [textView resignFirstResponder];
        self.scrollView.contentSize = self.view.bounds.size;
    }
    
    return YES;
}

#pragma mark - Delegates: UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.carImages.count == kMaxNumberOfImages ? self.carImages.count : self.carImages.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellId" forIndexPath:indexPath];
    
    if (indexPath.row == self.carImages.count && self.carImages.count < kMaxNumberOfImages)
    {
        cell.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
        cell.carImage.image = [UIImage imageNamed: @"plus"];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
        cell.carImage.image = self.carImages[indexPath.row];
    }
    
    return cell;
}

#pragma mark - Delegates: UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.carImages.count == indexPath.row && self.carImages.count < kMaxNumberOfImages)
    {
        [[PhotoManager sharedManager] takePhotoFromVC:self withCompletetionBlock:^(BOOL success, UIImage *image) {
            if (success)
            {
                [self.carImages addObject: image];
                [self.collectionView reloadData];
            }
        }];
    }
}

#pragma mark - Delegates: UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float offset = 20.0f;
    return CGSizeMake((self.collectionView.bounds.size.width - offset)/2, self.collectionView.bounds.size.height);
}

@end
