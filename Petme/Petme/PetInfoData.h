//
//  petInfoData.h
//  Petme
//
//  Created by CLAY on 2017. 3. 11..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface PetInfoData : NSObject

@property (nonatomic) NSString *userUID;
@property (nonatomic) NSString *petImageUrl;
@property (nonatomic) NSString *petName;
@property (nonatomic) NSString *petGender;
@property (nonatomic) NSArray  *petFeature;
@property (nonatomic) NSString *petLocation_1;
@property (nonatomic) NSString *petLocation_2;
@property (nonatomic) NSString *petDecription;

@property (nonatomic) NSData   *petImageData;

-(instancetype)initWithPetInfo:(FIRDataSnapshot *)petInfo;
-(instancetype)initWithPetLikeInfo:(FIRDataSnapshot *)petInfo;
-(NSDictionary *)formatDictionary;

@end
