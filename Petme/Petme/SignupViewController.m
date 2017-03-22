//
//  SignUpViewController.m
//  PetMe
//
//  Created by 조백진 on 2017. 3. 8..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "SignupViewController.h"
#import "LoginViewController.h"
//#import "PetProFileViewController.h"
@import Firebase;

@interface SignupViewController ()
<UITextFieldDelegate>

//id 텍스트 필드
@property (weak, nonatomic) IBOutlet UITextField *userID;

//닉네임 텍스트 필드

//비밀번호 텍스트 필드
@property (weak, nonatomic) IBOutlet UITextField *password;

//비밀번호 텍스트 필드 확인
@property (weak, nonatomic) IBOutlet UITextField *passwordCheck;

//회원가입 완료 버튼

@property (weak, nonatomic) IBOutlet UIScrollView *signUpSc;
@property (weak, nonatomic) IBOutlet UIView *signUpContent;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //회원가입 패스워드 *로 표시
    self.password.secureTextEntry = YES;
    self.passwordCheck.secureTextEntry = YES;
    
    //뷰 컬러
    self.view.backgroundColor = [UIColor colorWithRed:80/255.0 green:164/255.0 blue:112/255.0 alpha:1];
    //컨텐츠 뷰 컬러
    self.signUpContent.backgroundColor = [UIColor colorWithRed:80/255.0 green:164/255.0 blue:112/255.0 alpha:1];
    
    //텍스트 필드 placeholder 컬러
    UIColor *color = [UIColor whiteColor];
    self.userID.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User Name" attributes:@{NSForegroundColorAttributeName:color}];
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName:color}];
    self.passwordCheck.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password Check" attributes:@{NSForegroundColorAttributeName:color}];
    
    //회원가입 버튼 boder주기
    self.signInBtn.layer.cornerRadius = 20;
    self.signInBtn.layer.borderWidth = 1;
    self.signInBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//회원가입 페이지 텍스트 필드 return 클릭했을 때 메소드 
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 1) {
        [self.password becomeFirstResponder];
    }else if (textField.tag == 2){
        [self.passwordCheck becomeFirstResponder];
    }else if (textField.tag == 3){
        [self.passwordCheck resignFirstResponder];
    }
    return YES;
}

//로그인 버튼 
- (IBAction)signIn:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createUserWithEmail:(NSString *)email
                   password:(NSString *)password
                 completion:(nullable FIRAuthResultCallback)completion{
    
    
    
    
}


//회원가입 완료 버튼 메소드
- (IBAction)complete:(UIButton *)sender {
    //회원가입 완료 버튼 누르면 pet 프로필 등록화면으로 넘어가기
    
    [[FIRAuth auth]
     createUserWithEmail:self.userID.text
     password:self.password.text
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         //회원가입 예외처리(중복된 이메일, 비밀번호 안정성, 이메일 형식)
         if(error) {
             
             NSString *msg = @" ";
             NSString *errorName = [[error valueForKey:@"userInfo"] valueForKey:@"error_name"];
             
             if ([errorName isEqualToString:@"ERROR_INVALID_EMAIL"]) {
                 msg = @"잘못된 이메일 주소입니다.";
             } else if ([errorName isEqualToString:@"ERROR_WEAK_PASSWORD"]) {
                 msg = @"비밀번호를 6자 이상으로 설정하세요.";
             } else if ([errorName isEqualToString:@"ERROR_EMAIL_ALREADY_IN_USE"]) {
                 msg = @"입력하신 이메일 주소가 이미 존재합니다.";
             }
             
             UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"잘못된 로그인" message:msg preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *errorAlertAlertAction = [UIAlertAction actionWithTitle:@"다시 시도" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             }];
             NSLog(@"%@",error);
             [errorAlert addAction:errorAlertAlertAction];
             [self presentViewController:errorAlert animated:YES completion:nil];
             
         } else {
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.signUpSc setContentOffset:CGPointMake(0, 120) animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.signUpSc setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
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
