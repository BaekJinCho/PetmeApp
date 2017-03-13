//
//  DataCenter.h
//  Petme
//
//  Created by CLAY on 2017. 3. 10..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PetInfoData.h"

@import Firebase;

@interface DataCenter : NSObject

@property (nonatomic) NSMutableArray *petArrayInfo;

@property (nonatomic) NSMutableArray *petLikeInfo;
@property (nonatomic) NSMutableArray *petLikeMeInfo;

@property (nonatomic) FIRDatabaseReference *ref;

@property (nonatomic) FIRAuth *auth;
@property (nonatomic) FIRStorage *storage;
@property (nonatomic) FIRUser *userInfo;

@property (nonatomic) PetInfoData *petInfo;

+(instancetype)shreadInstance;
-(void)fetchPetmeInfo;
-(void)fetchLoginUserPetInfo:(NSString *)userUID;
-(void)fetchLoginUserLikePetInfo:(NSString *)userUID;

@end
