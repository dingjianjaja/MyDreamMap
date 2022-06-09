//
//  ViewController.m
//  MyDreamMap
//
//  Created by dingjianjaja on 2022/4/23.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MKMapView+ZoomLevel.h"
#import "DJTileOverlay.h"
#import "DJImagePicker.h"
#import "DJEditStoryViewController.h"

@interface ViewController ()<MKMapViewDelegate>

@end

NSString * const openstreetmap = @"http://tile.openstreetmap.org/{z}/{x}/{y}.png";
//NSString * const openstreetmap = @"https://raw.githubusercontent.com/dingjianjaja/MyDreamMap/main/res/{z}/{x}/{y}.png";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationM;
@property (strong,nonatomic) CLGeocoder *geocoder;
@property (weak, nonatomic) IBOutlet UILabel *zoomLevelTextView;
@property (strong,nonatomic) DJTileOverlay *customOverlay;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置用户跟踪模式
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self requestUserLocationAuthor];
    [self.mapView setShowsScale:true];
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.mapView addGestureRecognizer:mTap];
    self.geocoder = [[CLGeocoder alloc] init];
    
    [self.mapView addOverlay:self.customOverlay];
    
    
    
}



#pragma mark Aciton

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    if (self.mapView.zoomLevel  == 10) {
        
        
        return;
    }
    NSLog(@"%f",self.mapView.zoomLevel);
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    [self getAddressByLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
//    [self showDialog:[NSString stringWithFormat:@"经度：%f\n纬度：%f\n地址：%@",touchMapCoordinate.longitude,touchMapCoordinate.latitude,address]];
}
- (IBAction)backToImageLayer:(UIButton *)sender {
    
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.region.center, MKCoordinateSpanMake(0.74165710274547081, 0.49695225506195584)) animated:YES];
}

- (void) showDialog:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"点击经纬度" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)chooseImage:(UIButton *)sender {
    [DJImagePicker.sharedInstance getImage:self didDone:^(HXPhotoModel * _Nonnull photoModel) {
        
        DJEditStoryViewController *editVc = [[DJEditStoryViewController alloc] init];
                        editVc.photoModel = photoModel;
    [self.navigationController pushViewController:editVc animated:YES];
    }];
}

// 缩小
- (IBAction)zoomOutBtnClick:(UIButton *)sender {
    
    //设置地图范围
    //设置中心点为当前地图范围的中心点
    CLLocationCoordinate2D center = self.mapView.region.center;
    //设置跨度为当前地图范围的跨度 * 比例系数
    MKCoordinateSpan span = MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta * 2, self.mapView.region.span.longitudeDelta * 2);
    //设置范围
    [self.mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
    
}
// 放大
- (IBAction)zoomInBtnClick:(UIButton *)sender {
    // 设置范围
    // 设置中心点
    CLLocationCoordinate2D center = self.mapView.region.center;
    
    // 设置跨度 : 跨度变小,地图显示缩大  (地图的范围跨度 * 比例系数)
    MKCoordinateSpan span = MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta * 0.5, self.mapView.region.span.longitudeDelta * 0.5);
    //设置地图范围
    [self.mapView setRegion:MKCoordinateRegionMake(center, span) animated:YES];
    
    /**
     *
     typedef struct {
     CLLocationCoordinate2D center;  中心点  确定地图的位置
     MKCoordinateSpan span;  经纬度跨度       确定地图的大小
     } MKCoordinateRegion;
     */
    
    /**
     *
     typedef struct {
     CLLocationDegrees latitudeDelta;  纬度跨度 1°=111km
     CLLocationDegrees longitudeDelta; 经度跨度
     } MKCoordinateSpan;
     */
}

#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [self.geocoder geocodeAddressString:address
                      completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark = [placemarks firstObject];
        CLLocation *location = placemark.location;//位置
        CLRegion *region = placemark.region;//区域
        NSDictionary *addressDic = placemark.addressDictionary;//详细地址信息字典
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}
#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude
                  longitude:(CLLocationDegrees)longitude
{
    //反地理编码
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude
                                                      longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.country);
        [self showDialog:[NSString stringWithFormat:@"详细信息:%@%@%@%@",placemark.country,placemark.locality,placemark.subThoroughfare,placemark.name]];
    }];
}

- (DJTileOverlay *)customOverlay{
    if (!_customOverlay) {
        _customOverlay = [[DJTileOverlay alloc] initWithURLTemplate:openstreetmap];
        _customOverlay.canReplaceMapContent = YES;
    }
    return _customOverlay;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    return nil;
}

#pragma mark - MKMapViewDelegate
/* 更新用户位置会调用 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"经度：%f，纬度：%f",coordinate.latitude,coordinate.longitude);
}


- (void)requestUserLocationAuthor{
    //如果没有获得定位授权，获取定位授权请求
    self.locationM = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationM requestWhenInUseAuthorization];
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    NSLog(@"%f",self.mapView.zoomLevel);
    self.zoomLevelTextView.text = [NSString stringWithFormat:@"%.0f",self.mapView.zoomLevel];
}



@end
