//
//  ViewController.m
//  MyDreamMap
//
//  Created by dingjianjaja on 2022/4/23.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<MKMapViewDelegate>

@end

//NSString * const openstreetmap = @"http://tile.openstreetmap.org/{z}/{x}/{y}.png";
NSString * const openstreetmap = @"https://raw.githubusercontent.com/dingjianjaja/MyDreamMap/main/res/{z}/{x}/{y}.png";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) MKTileOverlay *customOverlay;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView addOverlay:self.customOverlay];
}


- (MKTileOverlay *)customOverlay{
    if (!_customOverlay) {
        _customOverlay = [[MKTileOverlay alloc] initWithURLTemplate:openstreetmap];
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


@end
