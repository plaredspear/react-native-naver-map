//
//  RCTConvert+RNNaverMapView.m
//
//  Created by flask on 14/04/2019.
//  Copyright © 2019 flask. All rights reserved.
//

#import <NMapsMap/NMFCameraUpdate.h>
#import <NMapsMap/NMGLatLng.h>
#import <NMapsMap/NMFCameraPosition.h>
#import <NMapsMap/NMGLatLngBounds.h>

#import "RCTConvert+NMFMapView.h"

@implementation RCTConvert(NMFMapView)

+ (NMFCameraUpdate*) NMFCameraUpdate: (id)json
{
  json = [self NSDictionary:json];
  return [NMFCameraUpdate cameraUpdateWithScrollTo:NMGLatLngMake([self double: json[@"latitude"]], [self double:json[@"longitude"]])
                                            zoomTo:[self double: json[@"zoom"]]];
}

+ (NMFCameraUpdate*) NMFCameraUpdateWith:(id)json
{
  NMGLatLng *position = NMGLatLngMake([self double: json[@"latitude"]], [self double:json[@"longitude"]]);
  double zoom = [self double: json[@"zoom"]];
  double tilt = [self double: json[@"tilt"]];
  double bearing = [self double: json[@"bearing"]];

  NMFCameraPosition* cameraPosition = [NMFCameraPosition cameraPosition:position zoom:zoom tilt:tilt heading:bearing];
  NMFCameraUpdate *cameraUpdate = [NMFCameraUpdate cameraUpdateWithPosition: cameraPosition];
  cameraUpdate.animation = NMFCameraUpdateAnimationEaseIn;
  return cameraUpdate;
}

+ (NMGLatLng*) NMGLatLng: (id)json
{
  json = [self NSDictionary:json];
  return NMGLatLngMake([self double: json[@"latitude"]], [self double:json[@"longitude"]]);
}

+ (NMGLatLngBounds*) NMGLatLngBounds: (id)json
{
    json = [self NSDictionary:json];
    double lat = [self double: json[@"latitude"]];
    double latDelta = [self double: json[@"latitudeDelta"]];
    double lng = [self double: json[@"longitude"]];
    double lngDelta = [self double: json[@"longitudeDelta"]];
    return NMGLatLngBoundsMake(lat - latDelta / 2, lng - lngDelta / 2,  // southwest
                               lat + latDelta / 2, lng + lngDelta / 2); // northeast
}

+ (UIColor *) colorWithRGBHex: (uint32_t)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *) colorWithHexString: (NSString *)stringToConvert
{
    NSString *string = stringToConvert;
    if ([string hasPrefix:@"#"])
        string = [string substringFromIndex:1];
    NSScanner *scanner = [NSScanner scannerWithString:string];
    unsigned hexNum;
    if (![scanner scanHexInt: &hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}

+ (RNNaverMapCaption *) RNNaverMapCaption: (id)json
{
    json = [self NSDictionary:json];
    RNNaverMapCaption *caption = [[RNNaverMapCaption alloc] init];
    caption.text = [self NSString: json[@"text"]];
    caption.textSize = [self CGFloat: json[@"textSize"]];
    NSString *colorString = [self NSString: json[@"color"]];
    caption.color = [self colorWithHexString: colorString];
    return caption;
}

@end
