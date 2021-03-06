//
//  DJTileOverlay.m
//  MyDreamMap
//
//  Created by dingjianjaja on 2022/6/8.
//

#import "DJTileOverlay.h"

@implementation DJTileOverlay

//- (NSURL *)URLForTilePath:(MKTileOverlayPath)path{
//
//    NSLog(@"x:%d\ny:%d\nz:%d",path.x,path.y,path.z);
//    return [NSURL URLWithString:@"http://lc-zkRVyTsa.cn-n1.lcfile.com/HLkT1PJ0RvzBQ6PBgqrwLH1PnNCfX8Mh/11532.png"];
//}

- (void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData * _Nullable, NSError * _Nullable))result{
    if (path.z < 10) {
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tile.openstreetmap.org/%d/%d/%d.png",path.z,path.x,path.y]] options:NSDataReadingMapped error:NULL];
        result(imgData,NULL);
    }else{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://lc-zkRVyTsa.cn-n1.lcfile.com/HLkT1PJ0RvzBQ6PBgqrwLH1PnNCfX8Mh/11532.png"] options:NSDataReadingMapped error:NULL];
        result(imgData,NULL);
    }
}

@end
