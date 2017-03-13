//
//  PetMainProfileViewController.m
//  Petme
//
//  Created by CLAY on 2017. 3. 11..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "PetMainProfileViewController.h"
#import "CustomPetCollectionViewCell.h"
#import "CustomPetCollectionReusableView.h"

#import "DataCenter.h"

@interface PetMainProfileViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, CustomPetCollectionReusableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *petCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;

@property (nonatomic) BOOL isLikeInfo;
@end

@implementation PetMainProfileViewController

-(void)viewWillAppear:(BOOL)animated {
    
    //[self.petCollectionView removeFromSuperview];
    
    [self.petCollectionView reloadData];
    
    [self.loadingBar setHidden:NO];
    [self.loadingBar startAnimating];
    
    NSString *userUID = [DataCenter shreadInstance].userInfo.uid;
    [[DataCenter shreadInstance] fetchLoginUserLikePetInfo:userUID];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [self.loadingBar setHidden:YES];
    [self.loadingBar stopAnimating];
    
    [DataCenter shreadInstance].petLikeInfo = nil;
    [DataCenter shreadInstance].petLikeMeInfo = nil;
    [self.petCollectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isLikeInfo = YES;
    
//  NSString *userUID = [DataCenter shreadInstance].userInfo.uid;
//  [[DataCenter shreadInstance] fetchLoginUserLikePetInfo:userUID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectionViewReloadData) name:@"initPetchLikeInfo" object:nil];
}

-(void)collectionViewReloadData {
    
    [self.loadingBar setHidden:YES];
    [self.loadingBar stopAnimating];
    
    [self.petCollectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomPetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    [cell.layer setCornerRadius:10];
    
    PetInfoData *info;
    
    if(self.isLikeInfo) {
        info = [[DataCenter shreadInstance].petLikeInfo objectAtIndex:indexPath.item];
    } else {
        info = [[DataCenter shreadInstance].petLikeMeInfo objectAtIndex:indexPath.item];
    }
    
    cell.petNameLabel.text = info.petName;
    cell.petImageCell.image = [UIImage imageWithData:info.petImageData];
    
    if([info.petGender isEqualToString:@"M"]) {
        cell.petGender.image = [UIImage imageNamed:@"shape_m"];
    } else {
        cell.petGender.image = [UIImage imageNamed:@"shape_w"];
    }
    
    return cell;
    
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    // 재사용 큐에서 뷰를 가져온다
    CustomPetCollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    view.delegate = self;
    
    
    if([[DataCenter shreadInstance].petInfo.petName isEqualToString:@"M"]) {
        view.petGenderImage.image = [UIImage imageNamed:@"shape_m"];
    } else {
        view.petGenderImage.image = [UIImage imageNamed:@"shape_w"];
    }
    
    view.petNameLabel.text = [DataCenter shreadInstance].petInfo.petName;
    view.petProfileImage.image = [UIImage imageWithData:[DataCenter shreadInstance].petInfo.petImageData];
    
    return view;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if(self.isLikeInfo) {
     
        return [[DataCenter shreadInstance].petLikeInfo count];
    }else {
        
        return [[DataCenter shreadInstance].petLikeMeInfo count];
    }
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}

-(void)clickLikeButton:(BOOL)isLikeInfo {
    if(isLikeInfo) {
        
        self.isLikeInfo = YES;
        
    } else {
        
        self.isLikeInfo = NO;
    }
    
    [self collectionViewReloadData];
    
}

@end
