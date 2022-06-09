//
//  DJEditStoryViewController.m
//  MyDreamMap
//
//  Created by dingjianjaja on 2022/6/9.
//

#import "DJEditStoryViewController.h"
#import "HXPhotoPicker.h"
#import "DJImagePicker.h"
#import <LeanCloudObjc/Foundation.h>


@interface DJEditStoryViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property(nonatomic,strong) HXPhotoManager *manager;
@property(nonatomic,strong) HXPhotoEdit *photoEdit;

@end

@implementation DJEditStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.photoModel getImageWithSuccess:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
        self.imageV.image = image;
    } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
        
    }];
}



#pragma mark -- actions

- (IBAction)editImageAction:(UIButton *)sender {
    HXWeakSelf
    // 单独使用仿微信编辑功能
    [self hx_presentWxPhotoEditViewControllerWithConfiguration:self.manager.configuration.photoEditConfigur photoModel:self.photoModel delegate:nil finish:^(HXPhotoEdit * _Nonnull photoEdit, HXPhotoModel * _Nonnull photoModel, HX_PhotoEditViewController * _Nonnull viewController) {
        if (photoEdit) {
            // 有编辑过
            weakSelf.imageV.image = photoEdit.editPreviewImage;
        }else {
            // 为空则未进行编辑
            weakSelf.imageV.image = photoModel.thumbPhoto;
        }
        // 记录下当前编辑的记录，再次编辑可在上一次基础上进行编辑
        weakSelf.photoModel.photoEdit = photoEdit;
    } cancel:^(HX_PhotoEditViewController * _Nonnull viewController) {
        // 取消
    }];
}

- (IBAction)uploadImageAction:(UIButton *)sender {
    [self saveImageWithLocation:11 x:1670 y:890];
    
}
- (IBAction)requestFile:(UIButton *)sender {
    [self requestObjectWith:11 x:1670 y:890];
}

- (void)saveImageWithLocation:(int)z x:(int)x y:(int)y{
    [self.photoModel getImageWithSuccess:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
        NSData *data = [[DJImagePicker sharedInstance] getTileImage:image];
        LCFile *file = [LCFile fileWithData:data];
        
        LCObject *fileModel = [LCObject objectWithClassName:@"FileInfo"];
        [fileModel setObject:file forKey:@"image"];
        [fileModel setObject:[NSString stringWithFormat:@"%d:%d:%d",z,x,y] forKey:@"fileLocation"];
        [fileModel saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"上传成功");
            }
        }];
    } failed:NULL];
}



- (void)testLeanCloudSave{
    LCObject *testObject = [LCObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"Hello world!" forKey:@"words"];
    [testObject save];
}

- (void)requestObjectWith:(int)z x:(int)x y:(int)y{
    // LeanCloud - 查询 - 获取商品列表
    LCQuery *query = [LCQuery queryWithClassName:@"FileInfo"];
    [query whereKey:@"fileLocation" equalTo:[NSString stringWithFormat:@"%d:%d:%d",z,x,y]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%@",objects);
            LCFile *imgFile = objects.firstObject[@"image"];
            NSLog(@"%@",imgFile.url);
        }
    }];
}

// 懒加载 照片管理类
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
    }
    return _manager;
}

@end
