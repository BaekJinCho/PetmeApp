//
//  CustomPetCollectionReusableView.m
//  Petme
//
//  Created by CLAY on 2017. 3. 12..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "CustomPetCollectionReusableView.h"

@interface CustomPetCollectionReusableView()

@property (weak, nonatomic) IBOutlet UIButton *likePet;
@property (weak, nonatomic) IBOutlet UIButton *likeMe;


@end

@implementation CustomPetCollectionReusableView

- (IBAction)didClickLikeButton:(UIButton *)sender {
    
    if(sender.tag == 10) {
        [self.likePet setSelected:YES];
        [self.likeMe setSelected:NO];
        
        [self.delegate clickLikeButton:YES];
    } else if(sender.tag == 20) {
        [self.likePet setSelected:NO];
        [self.likeMe setSelected:YES];
        
        [self.delegate clickLikeButton:NO];
    } else {
        [self.likePet setSelected:NO];
        [self.likePet setSelected:NO];
    }
    
}


@end
