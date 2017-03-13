//
//  Annotation.m
//  PetMe
//
//  Created by 조백진 on 2017. 3. 8..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    _coordinate = newCoordinate;
}

-(instancetype)initWithTitle:(NSString *)title AndCoordinate:(CLLocationCoordinate2D)Coordinate {
    self = [super init];
    
    if (self) {
        self.title = title;
        self.coordinate = Coordinate;
    }
    
    return self;
}

@end
