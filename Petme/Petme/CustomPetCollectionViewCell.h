//
//  CustomPetCollectionViewCell.h
//  Petme
//
//  Created by CLAY on 2017. 3. 12..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPetCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *petImageCell;
@property (weak, nonatomic) IBOutlet UILabel *petNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *petGender;


@end
