//
//  PetProFileViewController.m
//  PetMe
//
//  Created by 박찬웅 on 2017. 3. 8..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "PetProFileViewController.h"
#import "PetMainHomeViewController.h"

#import "DataCenter.h"
#import "PetInfoData.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Annotation.h"
#import "MapViewController.h"

@interface PetProFileViewController ()
<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *lodingBar;

@property (nonatomic) PetInfoData *petInfo;


@property (nonatomic) NSMutableArray *petFeatureInfo;
@property (nonatomic) CLLocationManager *location;
//강아지의 성별 체크버튼
@property (weak, nonatomic) IBOutlet UIButton *genderWoman;
@property (weak, nonatomic) IBOutlet UIButton *genderMan;

//강아지의 성격 버튼
@property (weak, nonatomic) IBOutlet UIButton *introspective;   //내성적
@property (weak, nonatomic) IBOutlet UIButton *barkWell;        //잘짖음
@property (weak, nonatomic) IBOutlet UIButton *slight;          //순함

@property (weak, nonatomic) IBOutlet UIButton *energetic;       //활발
@property (weak, nonatomic) IBOutlet UIButton *ferocity;        //사나움
@property (weak, nonatomic) IBOutlet UIButton *docility;        //온순
@property (weak, nonatomic) IBOutlet UIButton *shy;             //낯가림
@property (weak, nonatomic) IBOutlet UIButton *complete;        //완료
@property (weak, nonatomic) IBOutlet UIButton *later;           //나중에 하기

//강아지 이미지 버튼
@property (weak, nonatomic) IBOutlet UIButton *dogImageBtn;     //강아지 이미지

//텍스트 필드 모음
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;        //이름 텍스트필드
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;    //자주 산책하는 장소 텍스트필드
@property (weak, nonatomic) IBOutlet UITextField *introduceTextField;   //소개 텍스트필드

//이름 밑의 라인 = 이미지뷰
@property (weak, nonatomic) IBOutlet UIImageView *nameLine;
//성별 밑의 라인 = 이미지뷰
@property (weak, nonatomic) IBOutlet UIImageView *genderLine;
//소개 밑의 라인 = 이미지뷰
@property (weak, nonatomic) IBOutlet UIImageView *introduceLine;

//멍멍이 이미지 뷰
@property (weak, nonatomic) IBOutlet UIImageView *dogImage;

@property (nonatomic) UIImage *petImage;


@property UIAlertController *alertController;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation PetProFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.petInfo = [[PetInfoData alloc] init];
    
    self.petFeatureInfo = [[NSMutableArray alloc] init];
    //[self.genderMan setSelected:YES];
    
    self.location = [[CLLocationManager alloc] init];
    [self.location setDelegate:self];
    self.location.desiredAccuracy = kCLLocationAccuracyBest;
    [self.location requestWhenInUseAuthorization];
    [self.location startUpdatingLocation];
    [self.mapView setShowsUserLocation:YES];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initProfileInfo:) name:@"initProfileInfo" object:nil];
    [self initProfileInfo:nil];
}

- (void)initProfileInfo:(NSNotification *)notification {
    
    PetInfoData *info = [DataCenter shreadInstance].petInfo;

    self.nameTextField.text = info.petName;
    
    if([info.petGender isEqualToString:@"M"]) {
        [self.genderMan setSelected:YES];
    } else if([info.petGender isEqualToString:@"W"]) {
        [self.genderWoman setSelected:YES];
    }
    self.introduceTextField.text = info.petDecription;
    
    NSArray *arry = info.petFeature;
    self.petFeatureInfo = [arry mutableCopy];
    self.petInfo.petFeature = [arry mutableCopy];
    
    for (NSString *str in arry) {
        
        if([self.introspective.titleLabel.text isEqualToString:str])
            [self.introspective setSelected:YES];
        
        if([self.barkWell.titleLabel.text isEqualToString:str])
            [self.barkWell setSelected:YES];
        
        if([self.slight.titleLabel.text isEqualToString:str])
            [self.slight setSelected:YES];
        
        if([self.energetic.titleLabel.text isEqualToString:str])
            [self.energetic setSelected:YES];
        
        if([self.ferocity.titleLabel.text isEqualToString:str])
            [self.ferocity setSelected:YES];
        
        if([self.docility.titleLabel.text isEqualToString:str])
            [self.docility setSelected:YES];
        
        if([self.shy.titleLabel.text isEqualToString:str])
            [self.shy setSelected:YES];
        
    }
    
    if(info.petImageData != nil) {
        self.petImage = [UIImage imageWithData:info.petImageData];
        self.dogImage.image = [UIImage imageWithData:info.petImageData];
        [self.dogImageBtn setImage:nil forState:UIControlStateNormal];
    }
    
    //self.petInfo.petFeature    = self.petFeatureInfo;
    
    if(self.petInfo.petFeature == nil){
        self.petInfo.petFeature = [[NSMutableArray alloc] init];
        self.petFeatureInfo = [[NSMutableArray alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    
//    [self.lodingBar setHidden:YES];
//    [self.lodingBar stopAnimating];
}

- (IBAction)selectedWoman:(UIButton *)sender
{
    [self.genderWoman setSelected:YES];
    [self.genderMan setSelected:NO];
    [self.genderLine setHighlighted:YES];
}

- (IBAction)sender:(UIButton *)sender
{
    [self.genderMan setSelected:YES];
    [self.genderWoman setSelected:NO];
    [self.genderLine setHighlighted:YES];
}


//특징 버튼 클릭시 행동
- (IBAction)didClickBtnSelected:(UIButton *)sender
{
    if (sender.selected)
    {
        [sender setSelected:NO];
        [self.petFeatureInfo removeObjectAtIndex:[self.petFeatureInfo count]-1];
    }
    else
    {
        [sender setSelected:YES];
        [self.petFeatureInfo addObject:[sender.titleLabel text]];
    }
        if (self.petFeatureInfo.count >= 4)
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"특징은 3개까지 선택이 가능합니다." message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:nil];
            
            [sender setSelected:NO];
            [self.petFeatureInfo removeObjectAtIndex:[self.petFeatureInfo count]-1];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
}

- (IBAction)didClickLaterButton:(UIButton *)sender {
    
    [self.lodingBar setHidden:NO];
    [self.lodingBar startAnimating];
    
    // Main 화면으로 이동
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"PetMeTabBar"];
    
    [self presentViewController:vc animated:YES completion:nil];
}

//완료 버튼 클릭시 행동
- (IBAction)nextToMainPage:(UIButton *)sender
{
       [self.lodingBar setHidden:NO];
    [self.lodingBar startAnimating];

    NSString *gender = ([self.genderMan isSelected] ? @"M" : @"W");
    
    /* Data Save */
//    self.petInfo.petImageUrl   = @"";
    self.petInfo.petName       = self.nameTextField.text;
    self.petInfo.petGender     = gender;
    self.petInfo.petFeature    = self.petFeatureInfo;
    self.petInfo.petLocation_1 = @"37.132569";
    self.petInfo.petLocation_2 = @"127.132569";;
    self.petInfo.petDecription = self.introduceTextField.text;
    
    NSData *data = UIImageJPEGRepresentation(self.petImage, 0.2);
    
    NSString *userUID = [DataCenter shreadInstance].auth.currentUser.uid;
    NSString *imagePath = [NSString stringWithFormat:@"images/%@/petImage.jpg", userUID];
    
    FIRStorageReference *storageRef = [[DataCenter shreadInstance].storage reference];
    FIRStorageReference *riversRef = [storageRef child:imagePath];

//    // Upload the file to the path "images/rivers.jpg"
    FIRStorageUploadTask *uploadTask = [riversRef putData:data metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            // Uh-oh, an error occurred!
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
            NSURL *downloadURL = metadata.downloadURL;
            
            self.petInfo.petImageUrl = [downloadURL relativeString];
            
            FIRDatabaseReference *ref = [[DataCenter shreadInstance].ref child:@"user"];
            [[[ref child:userUID] child:@"petInfo"] setValue:[self.petInfo formatDictionary]];
            [[[ref child:userUID] child:@"email"] setValue:[DataCenter shreadInstance].auth.currentUser.email];
            
            self.petInfo.petImageData = [NSData dataWithContentsOfURL:downloadURL];
            [DataCenter shreadInstance].petInfo = self.petInfo;
            
            // Main 화면으로 이동 , 하지만 특징 카운트가 3개가 아니면 못감 ㅋㅋ
            if (self.petFeatureInfo.count <= 2) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"특징은 3개가 선택되어야 합니다." message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:cancel];
                
                [self presentViewController:alert animated:YES completion:nil];

            }
            else
            {
                //Main 화면으로 이동
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *vc = [story instantiateViewControllerWithIdentifier:@"PetMeTabBar"];
                [self presentViewController:vc animated:YES completion:nil];
            }
          
        }
    }];
}

//강아지 이미지 추가 버튼
- (IBAction)setImageToDogImage:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 카메라
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *cameraController = [[UIImagePickerController alloc]init];
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraController.allowsEditing = NO;
        cameraController.delegate = self;
        [self presentViewController:cameraController animated:YES completion:nil];
    }];
    
    // 사진
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"사진" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *photo = [[UIImagePickerController alloc]init];
        photo.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photo.allowsEditing = NO;
        photo.delegate = self;
        [self presentViewController:photo animated:YES completion:nil];
    }];
    
    // 취소
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil];
    
    //알럿창에 추가
    [alert addAction:camera];
    [alert addAction:photo];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

/*  */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    NSLog(@"info %@", info);
    
    self.petImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.dogImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.dogImageBtn setImage:nil forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];

}

//키보드 내려가기
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    return YES;
}

//소개텍스트필드 글자수 제한 (한글,영어일때 다름...)
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    
    if (self.introduceTextField.text.length >= 20)
    {
        self.introduceTextField.text = [self.introduceTextField.text substringToIndex:20];
    }
    return YES;
}

//텍스트필드 편집하려고 누르면 라인들의 하이라이트를 활성화
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1)
    {
        [self.nameLine setHighlighted:YES];
    }
    else if (textField.tag == 3)
    {
        [self.introduceLine setHighlighted:YES];
    }

}


//텍스트필드 편집을 끝냈을때, 필드의 길이가 0이면 라인들의 하이라이트를 비활성화  tag == 1 이름 텍스트필드 tag == 3 소개 텍스트필드
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1)
    {
        if (textField.text.length == 0)
        {
            [self.nameLine setHighlighted:NO];
        }

    }
    else if(textField.tag == 3)
    {
        if (textField.text.length == 0)
        {
            [self.introduceLine setHighlighted:NO];
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [UIView animateWithDuration:1 animations:^{
        
        
//        MapViewController *map = [[MapViewController alloc] init];
//        CLLocationCoordinate2D location2d = CLLocationCoordinate2DMake(map.wido, map.kyungdo);
//        CLLocationCoordinate2D location2d = CLLocationCoordinate2DMake(37.12121, 127.12121);
        //좌표 설정(위도, 경도)
        //        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchLocation toCoordinateFromView:self.mapView];
        
        CLLocationCoordinate2D coordinate = ((CLLocation *)locations.lastObject).coordinate;
        MKCoordinateSpan span = MKCoordinateSpanMake(0.0015, 0.0015);
        //지역 만들기
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
        [self.mapView setRegion:region animated:YES];
        
        self.petInfo.petLocation_1 = [NSString stringWithFormat:@"%lf", coordinate.latitude];
        self.petInfo.petLocation_2 = [NSString stringWithFormat:@"%lf", coordinate.longitude];
        
        [manager stopUpdatingLocation]; //위치 업데이트를 stop
    }];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
