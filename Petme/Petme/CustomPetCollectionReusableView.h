//
//  CustomPetCollectionReusableView.h
//  Petme
//
//  Created by CLAY on 2017. 3. 12..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPetCollectionReusableViewDelegate <NSObject>

-(void)clickLikeButton:(BOOL)isLikeInfo;

@end

@interface CustomPetCollectionReusableView : UICollectionReusableView

@property (weak) id <CustomPetCollectionReusableViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *petProfileImage;

@property (weak, nonatomic) IBOutlet UILabel *petNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *petGenderImage;

@end
