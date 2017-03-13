//
//  PetMainHomeViewController.m
//  PetMe
//
//  Created by CLAY on 2017. 3. 8..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "PetMainHomeViewController.h"
#import "PetMainDetailViewController.h"
#import "DraggableViewBackground.h"

#import "DataCenter.h"

@interface PetMainHomeViewController ()
<DraggableViewBackgroundDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingBar;

@property (nonatomic) DraggableViewBackground *draggableBackground;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@property (nonatomic) BOOL isMore;

@end

@implementation PetMainHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    
    if(!self.isMore) {
        [self.loadingLabel setText:@"Loading..."];
        [self.loadingBar setHidden:NO];
        [self.loadingBar startAnimating];
        
        [[DataCenter shreadInstance] fetchPetmeInfo];
    }
    
    self.isMore = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    if(!self.isMore) {
        NSLog(@"%d", self.isMore);
        [self.draggableBackground removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isMore = NO;
    
    [self.loadingBar setHidden:NO];
    [self.loadingBar startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDraggableViewBackground) name:@"initPetchInfo" object:nil];
    
    [self initPetchInfo:nil];
}

-(void)initPetchInfo:(NSNotification *)notification {
    
    [self initDraggableViewBackground];
}

-(IBAction)initDraggableViewBackground {
    
    [self.loadingBar setHidden:YES];
    [self.loadingBar stopAnimating];
    [self.loadingLabel setText:@"마지막 페이지입니다."];
    
    self.draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.bounds];
    self.draggableBackground.delegate = self;
    [self.view addSubview:self.draggableBackground];
    
    
//    [self.loadingBar setHidden:YES];
//    [self.loadingBar stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didButtonClick:(id)sender {
    [self initDraggableViewBackground];
}

-(void)clickMoreButton:(PetInfoData *)petInfo {
    
    PetMainDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PetMainDetailViewController"];
    vc.petInfoData = petInfo;
    
    self.isMore = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)dealloc {
    
    /* NSNotificationCenter removeObserver */
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
