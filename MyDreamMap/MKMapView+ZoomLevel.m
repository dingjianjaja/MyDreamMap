//
//  MKMapView+ZoomLevel.m
//  MyDreamMap
//
//  Created by dingjianjaja on 2022/4/27.
//

#import "MKMapView+ZoomLevel.h"

@implementation MKMapView (ZoomLevel)

- (double) zoomLevel{
    NSLog(@"%f",self.frame.size.width);
    NSLog(@"%f",self.region.span.longitudeDelta);
    return log2(360 * (self.frame.size.width) / 256.0 / self.region.span.longitudeDelta);
}

@end
