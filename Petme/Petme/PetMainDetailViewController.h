//
//  PetMainDetailViewController.h
//  PetMe
//
//  Created by CLAY on 2017. 3. 9..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PetInfoData.h"

@interface PetMainDetailViewController : UIViewController

@property (nonatomic) NSString *userId;
@property (nonatomic) PetInfoData *petInfoData;

@end
