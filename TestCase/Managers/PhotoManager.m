//
//  PhotoManager.m
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import "PhotoManager.h"
#import "TGCameraViewController.h"

typedef void(^PhotoCompletionBlock)(BOOL success, UIImage *photo);

@interface PhotoManager () <TGCameraDelegate>

@property (strong, nonatomic) UIImageView *photoView;
@property (nonatomic, copy) PhotoCompletionBlock block;
@property (strong, nonatomic) UIViewController *currentVC;

@end

@implementation PhotoManager

+ (id)sharedManager
{
    static PhotoManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.photoView = [UIImageView new];
    });
    return sharedMyManager;
}

- (void)takePhotoFromVC:(UIViewController*)controller withCompletetionBlock:(void (^)(BOOL success, UIImage *image))completionBlock {
    TGCameraNavigationController *navigationController = [TGCameraNavigationController newWithCameraDelegate:self];
    self.currentVC = controller;
    [controller presentViewController:navigationController animated:YES completion:nil];
    self.block = completionBlock;
}

#pragma mark - TGCameraDelegate optional

- (void)cameraWillTakePhoto
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)cameraDidSavePhotoAtPath:(NSURL *)assetURL
{
    // When this method is implemented, an image will be saved on the user's device
    NSLog(@"%s album path: %@", __PRETTY_FUNCTION__, assetURL);
}

- (void)cameraDidSavePhotoWithError:(NSError *)error
{
    NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    self.block(NO, nil);
    [self.currentVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    self.block(YES, image);
    [self.currentVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    self.block(YES, image);
    [self.currentVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
