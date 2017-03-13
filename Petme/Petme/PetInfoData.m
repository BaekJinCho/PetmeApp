//
//  petInfoData.m
//  Petme
//
//  Created by CLAY on 2017. 3. 11..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "PetInfoData.h"

@implementation PetInfoData

-(instancetype)initWithPetInfo:(FIRDataSnapshot *)petInfo {
    
    self = [super init];
    
    if(self) {
        
        self.userUID       = [petInfo key];
        
        if([[petInfo childSnapshotForPath:@"petInfo"].value isEqual:[NSNull null]]) {
            self.userUID       = [petInfo key];
            self.petImageUrl   = nil;
            self.petName       = nil;
            self.petGender     = nil;
            self.petFeature    = nil;
            self.petLocation_1 = nil;
            self.petLocation_2 = nil;
            self.petDecription = nil;
            self.petImageData  = nil;
        } else {
            self.petImageUrl   = [[petInfo childSnapshotForPath:@"petInfo"] childSnapshotForPath:@"petImageUrl"].value;
            self.petName       = [[petInfo childSnapshotForPath:@"petInfo"] childSnapshotForPath:@"petName"].value;
            self.petGender     = [[petInfo childSnapshotForPath:@"petInfo"] childSnapshotForPath:@"petGender"].value;
            self.petFeature    = [[petInfo childSnapshotForPath:@"petInfo"] childSnapshotForPath:@"petFeature"].value;
            self.petLocation_1 = [[petInfo childSnapshotForPath:@"petInfo"] childSnapshotForPath:@"petLocation_1"].value;
            self.petLocation_2 = [[petInfo childSnapshotForPath:@"petInfo"] childSnapshotForPath:@"petLocation_2"].value;
            self.petDecription = [[petInfo childSnapshotForPath:@"petInfo"] childSnapshotForPath:@"petDecription"].value;
            
            NSURL *url = [NSURL URLWithString:self.petImageUrl];
            self.petImageData = [NSData dataWithContentsOfURL:url];
        }
    }
    
    return self;
}

-(instancetype)initWithPetLikeInfo:(FIRDataSnapshot *)petInfo {
    
    self = [super init];
    
    if(self) {
        self.userUID       = [petInfo key];
        self.petImageUrl   = [petInfo childSnapshotForPath:@"petImageUrl"].value;
        self.petName       = [petInfo childSnapshotForPath:@"petName"].value;
        self.petGender     = [petInfo childSnapshotForPath:@"petGender"].value;
        self.petFeature    = [petInfo childSnapshotForPath:@"petFeature"].value;
        self.petLocation_1 = [petInfo childSnapshotForPath:@"petLocation_1"].value;
        self.petLocation_2 = [petInfo childSnapshotForPath:@"petLocation_2"].value;
        self.petDecription = [petInfo childSnapshotForPath:@"petDecription"].value;
        
        NSURL *url = [NSURL URLWithString:self.petImageUrl];
        self.petImageData = [NSData dataWithContentsOfURL:url];
    }
    
    return self;
}

-(NSDictionary *)formatDictionary {
    
    NSDictionary *userInfo = @{@"petImageUrl":self.petImageUrl,
                               @"petName":self.petName,
                               @"petGender":self.petGender,
                               @"petFeature":self.petFeature,
                               @"petLocation_1":self.petLocation_1,
                               @"petLocation_2":self.petLocation_2,
                               @"petDecription":self.petDecription
                               };
    
    return userInfo;
}

@end
