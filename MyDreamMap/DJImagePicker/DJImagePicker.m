//
//  DJImagePicker.m
//  MyDreamMap
//
//  Created by dingjianjaja on 2022/6/9.
//

#import "DJImagePicker.h"
#import "DJEditStoryViewController.h"

@interface DJImagePicker ()
@property(nonatomic,strong) HXPhotoManager *manager;

@end

@implementation DJImagePicker

+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static DJImagePicker *singleClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleClass = [super allocWithZone:zone];//最先执行，只执行了一次
    });
    return singleClass;
}

// 懒加载 照片管理类
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
    }
    return _manager;
}



- (void) getImage:(UIViewController *)viewController didDone:(void (^)(HXPhotoModel * photoModel))didDone{
    HXWeakSelf
    [viewController hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
//        weakSelf.total.text = [NSString stringWithFormat:@"总数量：%ld   ( 照片：%ld   视频：%ld )",allList.count, photoList.count, videoList.count];
//        weakSelf.original.text = isOriginal ? @"YES" : @"NO";
        NSSLog(@"block - all - %@",allList);
        NSSLog(@"block - photo - %@",photoList);
        NSSLog(@"block - video - %@",videoList);
        for (HXPhotoModel *photoModel in photoList) {
            didDone(photoModel);
        }
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSSLog(@"block - 取消了");
    }];
}

- (NSData *)getTileImage:(UIImage *)source_image{
    return  [self resetSizeOfImageData:source_image givenSize:CGSizeMake(256, 256) referenceSize:30 compressQuality:0.5];
}


/**
 *  图片上传压缩
 *  @param source_image    原图片
 *  @param compressQuality 压缩系数 0-1
 *  默认参考大小30kb,一般用该方法可达到要求，压缩系数可根据压缩后的清晰度权衡，项目里我用的0.2😆
 */
- (NSData *)resetSizeOfImageData:(UIImage *)source_image compressQuality:(CGFloat)compressQuality
{
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    NSInteger tempHeight = newSize.height / 1024;
    NSInteger tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    
    return  [self resetSizeOfImageData:source_image givenSize:newSize referenceSize:30 compressQuality:compressQuality];
}

/**
 *  图片上传压缩
 *  @param source_image    原图片
 *  @param referenceSize   上传的参考大小**KB
 *  @param compressQuality 压缩系数 0-1
 *  @return                imageData
 */
- (NSData *)resetSizeOfImageData:(UIImage *)source_image givenSize:(CGSize)givenSize referenceSize:(NSInteger)maxSize compressQuality:(CGFloat)compressQuality
{

    
    UIGraphicsBeginImageContext(givenSize);
    [source_image drawInRect:CGRectMake(0,0,givenSize.width,givenSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,compressQuality);
        return finallImageData;
    }
    return imageData;
}


@end
