//
//  PhotoManager.h
//  TestCase
//
//  Created by viera on 8/3/16.
//  Copyright © 2016 vydeveloping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoManager : NSObject

+ (id)sharedManager;

- (void)takePhotoFromVC:(UIViewController*)controller withCompletetionBlock:(void (^)(BOOL success, UIImage *image))completionBlock;

@end
