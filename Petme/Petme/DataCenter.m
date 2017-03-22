//
//  DataCenter.m
//  Petme
//
//  Created by CLAY on 2017. 3. 10..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "DataCenter.h"


@implementation DataCenter

+ (instancetype)shreadInstance {
    
    static DataCenter *dataCenter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataCenter = [[DataCenter alloc] init];
    });
    
    return dataCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    
    [FIRApp configure];
    
    self.auth    = [FIRAuth auth];
    self.ref     = [[FIRDatabase database] reference];
    self.storage = [FIRStorage storage];
}

/* 강아지 전체 정보 */
- (void)fetchPetmeInfo {
    
    [[self.ref child:@"user"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.petArrayInfo = [[NSMutableArray alloc] init];
        
        NSString *userUID = [DataCenter shreadInstance].userInfo.uid;
        
        NSArray *tempArry = [snapshot.children allObjects];
        for (FIRDataSnapshot *temp in tempArry) {
            
            if(![temp.key isEqualToString:userUID] && ([temp childSnapshotForPath:@"petInfo"].value != nil)) {
                [self.petArrayInfo addObject:temp];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initPetchInfo" object:nil];
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

/* 로그인 유저의 강아지 정보 */
- (void)fetchLoginUserPetInfo:(NSString *)userUID {

    FIRDatabaseQuery *query = [[[[FIRDatabase database] reference] child:@"user"] child:userUID];

    [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.petInfo = [[PetInfoData alloc] initWithPetInfo:snapshot];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"initProfileInfo" object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initLoginUserPetInfo" object:nil];
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

/* 좋아요 강아지 정보 */
- (void)fetchLoginUserLikePetInfo:(NSString *)userUID {
    
    FIRDatabaseQuery *query = [[[[FIRDatabase database] reference] child:@"user"] child:userUID];
    
    [query observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        self.petLikeInfo = [[NSMutableArray alloc] init];
        self.petLikeMeInfo = [[NSMutableArray alloc] init];
        
        NSArray *petLikeInfoArry = [[[snapshot childSnapshotForPath:@"likeInfo"] children] allObjects] ;
        NSArray *petLikeMeInfoArry = [[[snapshot childSnapshotForPath:@"likeMe"] children] allObjects] ;
        
        for (FIRDataSnapshot *info in petLikeInfoArry) {
            PetInfoData *petInfo = [[PetInfoData alloc] initWithPetLikeInfo:info];
            [self.petLikeInfo addObject:petInfo];
        }
        
        for (FIRDataSnapshot *info in petLikeMeInfoArry) {
            PetInfoData *petInfo = [[PetInfoData alloc] initWithPetLikeInfo:info];
            [self.petLikeMeInfo addObject:petInfo];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initPetchLikeInfo" object:nil];
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

@end
