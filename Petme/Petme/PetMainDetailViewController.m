//
//  PetMainDetailViewController.m
//  PetMe
//
//  Created by CLAY on 2017. 3. 9..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "PetMainDetailViewController.h"
#import <MapKit/MapKit.h>
#import "DataCenter.h"
#import "NewAnnotation.h"

@interface PetMainDetailViewController ()
<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailContentView;
@property (weak, nonatomic) IBOutlet UIImageView *dogImage;
@property (weak, nonatomic) IBOutlet UILabel *dogName;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *dogInfo;

@property (nonatomic) CLLocationManager *location;

@property (nonatomic) CGFloat wido;
@property (nonatomic) CGFloat kyungdo;

@end

@implementation PetMainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.dogImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.dogImage setBackgroundColor:[UIColor whiteColor]];
    [self.dogImage setImage:[UIImage imageWithData:self.petInfoData.petImageData]];
    
    self.dogName.text = self.petInfoData.petName;
    
    CGFloat offsetX = 32;
    CGFloat offsetY = 349;
    
    CGFloat width = (self.view.frame.size.width - ((32 * 2) + (12 * 2))) / 3;
    
    UIView *feature1 = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, 32)];
    [feature1.layer setCornerRadius:16];
    [feature1.layer setBorderWidth:1];
    [feature1.layer setBorderColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1].CGColor];
    [self.detailContentView addSubview:feature1];
    
    UILabel *featureL1 = [[UILabel alloc] initWithFrame:feature1.bounds];
    [featureL1 setText:[self.petInfoData.petFeature objectAtIndex:0]];
    [featureL1 setFont:[UIFont systemFontOfSize:12]];
    [featureL1 setTextAlignment:NSTextAlignmentCenter];
    [featureL1 setTextColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1]];
    [feature1 addSubview:featureL1];
    
    offsetX += width + 12;
    UIView *feature2 = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, 32)];
    [feature2.layer setCornerRadius:16];
    [feature2.layer setBorderWidth:1];
    [feature2.layer setBorderColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1].CGColor];
    [self.detailContentView addSubview:feature2];
    
    UILabel *featureL2 = [[UILabel alloc] initWithFrame:feature2.bounds];
    [featureL2 setText:[self.petInfoData.petFeature objectAtIndex:1]];
    [featureL2 setFont:[UIFont systemFontOfSize:12]];
    [featureL2 setTextAlignment:NSTextAlignmentCenter];
    [featureL2 setTextColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1]];
    [feature2 addSubview:featureL2];
    
    offsetX += width + 12;
    UIView *feature3 = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, 32)];
    [feature3.layer setCornerRadius:16];
    [feature3.layer setBorderWidth:1];
    [feature3.layer setBorderColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1].CGColor];
    [self.detailContentView addSubview:feature3];
    
    UILabel *featureL3 = [[UILabel alloc] initWithFrame:feature3.bounds];
    [featureL3 setText:[self.petInfoData.petFeature objectAtIndex:2]];
    [featureL3 setFont:[UIFont systemFontOfSize:12]];
    [featureL3 setTextAlignment:NSTextAlignmentCenter];
    [featureL3 setTextColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1]];
    [feature3 addSubview:featureL3];
    
    self.location = [[CLLocationManager alloc] init];
    [self.location setDelegate:self];
    self.location.desiredAccuracy = kCLLocationAccuracyBest;
    [self.location requestWhenInUseAuthorization];
    [self.location startUpdatingLocation];
//    [self.mapView setShowsUserLocation:YES];
    
    self.dogInfo.text = self.petInfoData.petDecription;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [manager stopUpdatingLocation]; //위치 업데이트를 stop
    
    [UIView animateWithDuration:1 animations:^{
        
        
        CLLocationCoordinate2D location2d = CLLocationCoordinate2DMake([self.petInfoData.petLocation_1 floatValue], [self.petInfoData.petLocation_2 floatValue]);
        
        //좌표 설정(위도, 경도)
        //CLLocationCoordinate2D coordinate = ((CLLocation *)locations.lastObject).coordinate;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.015, 0.015);
        //지역 만들기
        MKCoordinateRegion region = MKCoordinateRegionMake(location2d, span);
        [self.mapView setRegion:region animated:YES];
        
        NewAnnotation *annotation = [[NewAnnotation alloc] init];
        [annotation setCoordinate:location2d];
        [self.mapView addAnnotation:annotation];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
