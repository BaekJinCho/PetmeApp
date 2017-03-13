//
//  NewAnnotation.h
//  MapKitExample
//
//  Created by CLAY on 2017. 3. 7..
//  Copyright © 2017년 CLAY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NewAnnotation : NSObject
<MKAnnotation>

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end
