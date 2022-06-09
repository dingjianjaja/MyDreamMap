//
//  DJImagePicker.h
//  MyDreamMap
//
//  Created by dingjianjaja on 2022/6/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HXPhotoPicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJImagePicker : NSObject

+ (instancetype)sharedInstance;

- (void) getImage:(UIViewController *)viewController didDone:(void (^)(HXPhotoModel * photoModel))didDone;

- (NSData *)getTileImage:(UIImage *)source_image;
- (NSData *)resetSizeOfImageData:(UIImage *)source_image compressQuality:(CGFloat)compressQuality;

@end

NS_ASSUME_NONNULL_END
