//
//  DraggableViewBackground.m
//  testing swiping
//
//  Created by Richard Kim on 8/23/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

#import "DraggableViewBackground.h"
#import "PetMainDetailViewController.h"
#import "DataCenter.h"

@implementation DraggableViewBackground{
    
    NSMutableArray *petInfoCards;
    
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    UIButton* menuButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
    BOOL isSwipe;
    
    PetInfoData *petInfoData;
}
//this makes it so only two cards are loaded at a time to
//avoid performance and memory costs
static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1
//static const float CARD_HEIGHT = 386; //%%% height of the draggable card
//static const float CARD_WIDTH = 290; //%%% width of the draggable card

//@synthesize exampleCardLabels; //%%% all the labels I'm using as example data at the moment
@synthesize allCards;//%%% all the cards

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        
        
        //[self setupView];
        isSwipe = YES;
        
        //exampleCardLabels = [[NSArray alloc]initWithObjects:@"first",@"second",@"third",@"fourth",@"last", nil]; //%%% placeholder for card-specific information
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        
        petInfoCards = [[DataCenter shreadInstance].petArrayInfo mutableCopy];
        
        cardsLoadedIndex = 0;
        [self loadCards];
    }
    return self;
}

//%%% sets up the extra buttons on the screen
-(void)setupView
{
#warning customize all of this.  These are just place holders to make it look pretty
//    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1]; //the gray background colors
//    menuButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 34, 22, 15)];
//    [menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
//    messageButton = [[UIButton alloc]initWithFrame:CGRectMake(284, 34, 18, 18)];
//    [messageButton setImage:[UIImage imageNamed:@"messageButton"] forState:UIControlStateNormal];
//    xButton = [[UIButton alloc]initWithFrame:CGRectMake(60, 485, 59, 59)];
//    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
//    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
//    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 485, 59, 59)];
//    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
//    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:menuButton];
//    [self addSubview:messageButton];
//    [self addSubview:xButton];
//    [self addSubview:checkButton];
}

#warning include own card customization here!
//%%% creates a card and returns it.  This should be customized to fit your needs.
// use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
// to get rid of it (eg: if you are building cards from data from the internet)
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    
    CGFloat offsetX = 16;
    CGFloat offsetY = 24;
    
    petInfoData = [[PetInfoData alloc] initWithPetInfo:[petInfoCards objectAtIndex:index]];
    
    DraggableView *draggableView = [[DraggableView alloc] initWithFrame:CGRectMake(offsetX, offsetY, self.frame.size.width - (offsetX * 2), (self.frame.size.width - (offsetX * 2)) * 1.24198250728863)];
    
    //draggableView.userId = [array objectAtIndex:index];
    
    draggableView.petInfoData = petInfoData;
    
    //UIImage *image = [UIImage imageNamed:[[dic objectForKey:@"petInfo"] objectForKey:@"petImage"]];
    //UIImage *image = [UIImage imageNamed:petInfoData.petImageUrl];
//    NSURL *url = [NSURL URLWithString:petInfoData.petImageUrl];
//    NSData *data = [NSData dataWithContentsOfURL:url];
    
    ///UIImage *dogImage = [[dic objectForKey:@"petInfo"] objectForKey:@"petImage"];
    UIImage *dogImage = [UIImage imageWithData:petInfoData.petImageData];
    [draggableView setImage:dogImage];
    [draggableView.layer setCornerRadius:8];
    [draggableView setBackgroundColor:[UIColor lightGrayColor]];
    [draggableView setUserInteractionEnabled:YES];
    
    draggableView.delegate = self;
    [draggableView setClipsToBounds:NO];
    
    offsetX = 24;
    /* petInfo View */
    UIView *petInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - (offsetX * 2), 147)];
    petInfo.center = CGPointMake(draggableView.frame.size.width / 2, draggableView.frame.size.height);
    [petInfo setBackgroundColor:[UIColor whiteColor]];
    [petInfo.layer setCornerRadius:4];
    [petInfo setUserInteractionEnabled:YES];
    
    petInfo.layer.cornerRadius = 4;
    petInfo.layer.shadowRadius = 3;
    petInfo.layer.shadowOpacity = 0.2;
    petInfo.layer.shadowOffset = CGSizeMake(1, 1);
    draggableView.petInfoView = petInfo;
    
    [draggableView addSubview:petInfo];
    
    offsetX = 26;
    offsetY = 24;
    /* Dog Name Label */
    UILabel *dogName = [[UILabel alloc] init];
    [dogName setFont:[UIFont systemFontOfSize:22]];
    //[dogName setText:[[dic objectForKey:@"petInfo"] objectForKey:@"petName"]];
    [dogName setText:petInfoData.petName];
    /* Text Size -> label Rect */
    CGRect labelRect = [petInfoData.petName
                        boundingRectWithSize:dogName.frame.size
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{
                                     NSFontAttributeName : [UIFont systemFontOfSize:22]
                                     }
                        context:nil];
    
    [dogName setFrame:CGRectMake(offsetX, offsetY, labelRect.size.width, 24)];
    [petInfo addSubview:dogName];
    
    /* Dog Location Label */
    offsetX += dogName.frame.size.width + 12;
    offsetY = 29;
    UILabel *dogLocation = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, 100, 16)];
    [dogLocation setFont:[UIFont systemFontOfSize:16]];
    [dogLocation setText:@"200M"];
    [dogLocation setTextColor:[UIColor lightGrayColor]];
    [petInfo addSubview:dogLocation];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(petInfo.frame.size.width - 56, 18, 36, 36)];
    [button setImage:[UIImage imageNamed:@"btnMore"] forState:UIControlStateNormal];
    [petInfo addSubview:button];
    [button addTarget:self action:@selector(didClickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    
    /* Dog Gender ImageView */
    offsetX = 26;
    offsetY = 24;
    UIImageView *dogGender = [[UIImageView alloc] initWithFrame:CGRectMake(petInfo.frame.size.width - 96, offsetY, 17, 24)];
    
    
//    if([[[dic objectForKey:@"petInfo"] objectForKey:@"petName"] isEqualToString:@"M"]) {
//        [dogGender setImage:[UIImage imageNamed:@"dogGenderM"]];
//    } else {
//        [dogGender setImage:[UIImage imageNamed:@"dogGenderW"]];
//    }
    
    if([petInfoData.petName isEqualToString:@"W"]) {
        [dogGender setImage:[UIImage imageNamed:@"dogGenderW"]];
    } else if([petInfoData.petName isEqualToString:@"M"]) {
        [dogGender setImage:[UIImage imageNamed:@"dogGenderM"]];
    }
    
    [petInfo addSubview:dogGender];
    
    /* petInfo Under bar View */
    offsetX = 20;
    offsetY = 64;
    UIView *underBar = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, petInfo.frame.size.width - (offsetX * 2), 1)];
    
    [underBar setBackgroundColor:[UIColor colorWithDisplayP3Red:233/255.0 green:236/255.0 blue:239/255.0 alpha:1]];
    [petInfo addSubview:underBar];
    
    
    offsetX = 32;
    offsetY = 89;
    CGFloat width = (petInfo.frame.size.width - ((32 * 2) + (12 * 2))) / 3;
    
    UIView *feature1 = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, 32)];
    [feature1.layer setCornerRadius:16];
    [feature1.layer setBorderWidth:1];
    [feature1.layer setBorderColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1].CGColor];
    [petInfo addSubview:feature1];
    
    UILabel *featureL1 = [[UILabel alloc] initWithFrame:feature1.bounds];
    //[featureL1 setText:[[[dic objectForKey:@"petInfo"] objectForKey:@"petFeature"] objectAtIndex:0]];
    [featureL1 setText:[petInfoData.petFeature objectAtIndex:0]];
    [featureL1 setFont:[UIFont systemFontOfSize:12]];
    [featureL1 setTextAlignment:NSTextAlignmentCenter];
    [featureL1 setTextColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1]];
    [feature1 addSubview:featureL1];
    
    offsetX += width + 12;
    UIView *feature2 = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, 32)];
    [feature2.layer setCornerRadius:16];
    [feature2.layer setBorderWidth:1];
    [feature2.layer setBorderColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1].CGColor];
    [petInfo addSubview:feature2];
    
    UILabel *featureL2 = [[UILabel alloc] initWithFrame:feature2.bounds];
//    [featureL2 setText:[[[dic objectForKey:@"petInfo"] objectForKey:@"petFeature"] objectAtIndex:1]];
    [featureL2 setText:[petInfoData.petFeature objectAtIndex:1]];
    [featureL2 setFont:[UIFont systemFontOfSize:12]];
    [featureL2 setTextAlignment:NSTextAlignmentCenter];
    [featureL2 setTextColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1]];
    [feature2 addSubview:featureL2];
    
    offsetX += width + 12;
    UIView *feature3 = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, 32)];
    [feature3.layer setCornerRadius:16];
    [feature3.layer setBorderWidth:1];
    [feature3.layer setBorderColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1].CGColor];
    [petInfo addSubview:feature3];
    
    UILabel *featureL3 = [[UILabel alloc] initWithFrame:feature3.bounds];
    //[featureL3 setText:[[[dic objectForKey:@"petInfo"] objectForKey:@"petFeature"] objectAtIndex:2]];
    [featureL3 setText:[petInfoData.petFeature objectAtIndex:2]];
    [featureL3 setFont:[UIFont systemFontOfSize:12]];
    [featureL3 setTextAlignment:NSTextAlignmentCenter];
    [featureL3 setTextColor:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1]];
    [feature3 addSubview:featureL3];
    
    /* line View
    offsetX = petInfo.frame.size.width / 2;
    offsetY = 77;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, 1, 58)];
    [lineView setBackgroundColor:[UIColor colorWithDisplayP3Red:233/255.0 green:236/255.0 blue:239/255.0 alpha:1]];
    [petInfo addSubview:lineView];
    */
    
    /* NO Button
    offsetY = 86;
    UIImageView *noImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [noImageView setCenter:CGPointMake((petInfo.frame.size.width/2)/2, offsetY + (noImageView.frame.size.height/2))];
    [noImageView setImage:[UIImage imageNamed:@"noButton"]];
    [petInfo addSubview:noImageView];
    
    UIButton *noButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[noButton setImage:[UIImage imageNamed:@"noButton"] forState:UIControlStateNormal];
    //[noButton setFrame:CGRectMake(0, 0, 40, 40)];
    //[noButton setCenter:CGPointMake((petInfo.frame.size.width/2)/2, offsetY + (noButton.frame.size.height/2))];
    [noButton setFrame:noImageView.frame];
    [noButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    [noButton setUserInteractionEnabled:YES];
    [petInfo addSubview:noButton];
    draggableView.noButton = noButton;
    
    UIImageView *yesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [yesImageView setCenter:CGPointMake((petInfo.frame.size.width/2)+(petInfo.frame.size.width/2)/2, offsetY + (yesImageView.frame.size.height/2))];
    [yesImageView setImage:[UIImage imageNamed:@"yesButton"]];
    [petInfo addSubview:yesImageView];
    */
    
    /* YES Button
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesButton setFrame:yesImageView.frame];
    //[yesButton setImage:[UIImage imageNamed:@"yesButton"] forState:UIControlStateNormal];
    //[yesButton setFrame:CGRectMake(0, 0, 40, 40)];
    //[yesButton setCenter:CGPointMake((petInfo.frame.size.width/2)+(petInfo.frame.size.width/2)/2, offsetY + (yesButton.frame.size.height/2))];
    [yesButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];
    [yesButton setUserInteractionEnabled:YES];
    //[yesButton.imageView setUserInteractionEnabled:NO];
    [petInfo addSubview:yesButton];
    draggableView.yesButton = yesButton;
    */
    
    return draggableView;
}

-(void)didClickMoreButton:(UIButton *)sender {
    
    DraggableView *dragView = [loadedCards firstObject];
    
    [self.delegate clickMoreButton:dragView.petInfoData];
    
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    //[exampleCardLabels count]
    
    
//    if([[DataCenter sharedInstance].petMeList count] > 0) {
    if([petInfoCards count] > 0) {
//        NSInteger numLoadedCardsCap =(([[DataCenter sharedInstance].petMeList count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[[DataCenter sharedInstance].petMeList count]);
        NSInteger numLoadedCardsCap =(([petInfoCards count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:30);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
//        for (int i = 0; i<[[DataCenter sharedInstance].petMeList count]; i++) {
        for (int i = 0; i<[petInfoCards count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
//            [self addSubview:[loadedCards objectAtIndex:i]];

            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }

        
        
//        for (int i = 0; i<[loadedCards count]; i++) {
//            if (i>0) {
//                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
//            } else {
//                [self addSubview:[loadedCards objectAtIndex:i]];
//            }
////            [self addSubview:[loadedCards objectAtIndex:i]];
//            
//            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
//        }
        /* */
    }
}

#warning include own action here!
//%%% action called when the card goes to the left.
// This should be customized with your own action
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was
    [self petMeLikeInfo:card likeType:@"NO"];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
}

#warning include own action here!
//%%% action called when the card goes to the right.
// This should be customized with your own action
-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was
    [self petMeLikeInfo:card likeType:@"YES"];
    
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }

}

-(void)petMeLikeInfo:(UIView *)viewInfo likeType:(NSString*)likeType {
    
    DraggableView *c = (DraggableView *)viewInfo;
    
    PetInfoData *petInfo = [DataCenter shreadInstance].petInfo;
    
    NSString *mainUID = [DataCenter shreadInstance].userInfo.uid;
    NSString *likeUID = c.petInfoData.userUID;
    
    NSMutableDictionary *petInfoDic = [[c.petInfoData formatDictionary] mutableCopy];
    [petInfoDic setObject:likeType forKey:@"likeType"];
    
    NSMutableDictionary *petMyInfo = [[petInfo formatDictionary] mutableCopy];
    [petMyInfo setObject:likeType forKey:@"likeType"];
    
    FIRDatabaseReference *ref = [[DataCenter shreadInstance].ref child:@"user"];
    if([likeType isEqualToString:@"YES"]) {
        
        [[[[ref child:mainUID] child:@"likeInfo"] child:likeUID] setValue:petInfoDic];
        [[[[ref child:likeUID] child:@"likeMe"] child:mainUID] setValue:petMyInfo];
        
    } else if([likeType isEqualToString:@"NO"]) {
        
        [[[[ref child:mainUID] child:@"likeInfo"] child:likeUID] removeValue];
        [[[[ref child:likeUID] child:@"likeMe"] child:mainUID] removeValue];
    }
}

//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
