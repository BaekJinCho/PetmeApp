//
//  Annotation.h
//  PetMe
//
//  Created by 조백진 on 2017. 3. 8..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject
<MKAnnotation>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

- (instancetype)initWithTitle:(NSString *)title AndCoordinate:(CLLocationCoordinate2D)Coordinate;

@end
