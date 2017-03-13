//
//  MapViewController.m
//  PetMe
//
//  Created by 조백진 on 2017. 3. 8..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"

@interface MapViewController ()
<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *location;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.location = [[CLLocationManager alloc] init];
    [self.location setDelegate:self];
    self.location.desiredAccuracy = kCLLocationAccuracyBest;
    [self.location requestWhenInUseAuthorization];
    [self.location startUpdatingLocation];
    [self.mapView setShowsUserLocation:YES];
    
    // longPress Gesture
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPress:)];
    longPressGesture.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:longPressGesture];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [UIView animateWithDuration:2 animations:^{
    
    //좌표 설정(위도, 경도)
    CLLocationCoordinate2D coordinate = ((CLLocation *)locations.lastObject).coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.3, 0.3);
    //지역 만들기
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
    
    //pin추가
    Annotation *annotation = [[Annotation alloc]init];
        annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
    [self.mapView setShowsUserLocation:YES];
    
    [manager stopUpdatingLocation]; //위치 업데이트를 stop
    }];
}

- (void)mapLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        CGPoint touchLocation = [gestureRecognizer locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinate;
        coordinate = [self.mapView convertPoint:touchLocation toCoordinateFromView:self.mapView];// how to convert this to a String or something else?
        
        self.wido = coordinate.latitude;
        self.kyungdo = coordinate.longitude;
        CLLocationCoordinate2D customCoordinate = CLLocationCoordinate2DMake(self.wido, self.kyungdo);
        
        Annotation *anno = [[Annotation alloc] initWithTitle:@"산책하기 좋은 곳" AndCoordinate:customCoordinate];
        [self.mapView addAnnotation:anno];
        NSLog(@"Longpress");
        NSLog(@"touch 좌표 : 위도 = %f, 경도  = %f", self.wido, self.kyungdo);
    }
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
