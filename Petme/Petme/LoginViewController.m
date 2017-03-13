//
//  LoginPageViewController.m
//  PetMe
//
//  Created by 조백진 on 2017. 3. 8..
//  Copyright © 2017년 Dev101. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "PetProFileViewController.h"
#import "DataCenter.h"

@import Firebase;

@interface LoginViewController ()
<UITextFieldDelegate>
//id 텍스트 필드
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *lodingBar;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
//password 텍스트 필드
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//회원가입 버튼
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
//로그인 버튼
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
//content view
@property (weak, nonatomic) IBOutlet UIView *contentView;
//스크롤 뷰
@property (weak, nonatomic) IBOutlet UIScrollView *sc;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 비밀번호 텍스트 필드 * 표시
    self.passwordTextField.secureTextEntry = YES;
    
    // 텍스트 필드 placeholder 컬러
    UIColor *color = [UIColor whiteColor];
    self.idTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User Name" attributes:@{NSForegroundColorAttributeName:color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName:color}];
    
    // 로그인 버튼 boder주기
    self.signInButton.layer.cornerRadius = 20;
    self.signInButton.layer.borderWidth = 1;
    self.signInButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.idTextField.text = @"petme_01@petme.com";
    self.passwordTextField.text = @"123456";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginPageMove) name:@"initLoginUserPetInfo" object:nil];
}


//텍스트 필드를 클릭했을 때, 키보드가 올라옴과 동시에 텍스트필드 전체가 올라가는 메소드
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.sc setContentOffset:CGPointMake(0, 120) animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.sc setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}
//텍스트 필드를 입력했을 때 로그인 버튼에 color이 채워지는 메소드
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
     if ((self.idTextField.text.length > 0 && textField.tag == 2) ||  (self.passwordTextField.text.length >0 && textField.tag == 1))
     {
        //로그인 버튼의 이미지
         self.signInButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
         [self.signInButton setTitleColor:[UIColor colorWithRed:80/255.0 green:164/255.0 blue:112/255.0 alpha:1] forState:UIControlStateNormal];
     }else if((self.idTextField.text.length == 1 && textField.tag == 1) || (self.passwordTextField.text.length == 1 &&  textField.tag == 2)){
         self.signInButton.layer.backgroundColor = [UIColor colorWithRed:80/255.0 green:164/255.0 blue:112/255.0 alpha:1].CGColor;
        [self.signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     }
    return YES;
}


//회원가입 버튼 메소드
- (IBAction)signUp:(UIButton *)sender {
//    //스토리 보드 객체 만들기
//    UIStoryboard *st = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
//    //뷰컨트롤러 객체만들기
//    SignUpViewController *signUpView = [st instantiateViewControllerWithIdentifier:@"SignUpViewController"];
//    signUpView.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//    [self presentViewController:signUpView animated:YES completion:nil];
    if (sender.tag == 10){
        
        //로그인 성공시 alert 띄어주기
        //alertcontroller 객체 생성
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"회원가입 하시겠습니까?" message:@"버튼을 누르시면 회원가입 페이지로 이동합니다." preferredStyle:UIAlertControllerStyleAlert];
        //alert action
        

        UIAlertAction *okAciton = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
//            UIStoryboard *st = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
//            SignUpViewController *signUpView = [st instantiateViewControllerWithIdentifier:@"SignUpViewController"];
//            [self presentViewController:signUpView animated:YES completion:nil];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAciton];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        NSLog(@"회원가입 button이 클릭되었습니다.");
    }
//    else{
//        UIAlertController *alertController2 = [UIAlertController alertControllerWithTitle:@"로그인 실패" message:@"회원 또는 비밀번호가 일치하지 않습니다." preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alertController2 addAction:okAction2];
//        [self presentViewController:alertController2 animated:YES completion:nil];
//        NSLog(@"로그인 실패!!!");
//    }

}

//로그인 버튼 메소드
- (IBAction)signIn:(UIButton *)sender {

    //self.idTextField.text
    //self.passwordTextField.text
    
    [self signInMember];
}

//로그인 멤버 정보
-(void)signInMember{
    //loadingBar start
    [self.passwordTextField resignFirstResponder];
    [self.lodingBar setHidden:NO];
    [self.lodingBar startAnimating];
    
    [[FIRAuth auth] signInWithEmail:self.idTextField.text
                           password:self.passwordTextField.text
                         completion:^(FIRUser *user, NSError *error)
     {
//         예외처리 방법1(가입한 이메일이 없을 경우 예외처리)
//         if(![user.email isEqualToString:self.idTextField.text]) {

//         예외처리 방법2(가입한 이메일이 없을 경우 예외처리)
         if(error) {
         
             [self.lodingBar setHidden:YES];
             [self.lodingBar stopAnimating];
             
             NSString *msg = @" ";
             NSString *errorName = [[error valueForKey:@"userInfo"] valueForKey:@"error_name"];
             
             if([errorName isEqualToString:@"ERROR_USER_NOT_FOUND"]) {
                 msg = @"회원정보가 없습니다.";
             }else if([errorName isEqualToString:@"ERROR_WRONG_PASSWORD"]) {
                 msg = @"비밀번호가 틀렸습니다.";
             }
         
             UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"잘못된 로그인" message:msg preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *errorAlertAlertAction = [UIAlertAction actionWithTitle:@"다시 시도" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 
             }];
             [errorAlert addAction:errorAlertAlertAction];
             [self presentViewController:errorAlert animated:YES completion:nil];
         
         } else {
             NSLog(@"Login Success");
             
             [DataCenter shreadInstance].userInfo = user;
             
             // 로그인 유저의 강아지 정보
             [[DataCenter shreadInstance] fetchLoginUserPetInfo:user.uid];
         }
         
     }];
}

-(void)loginPageMove {
    
    // 화면이동
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"PetProfile" bundle:nil];
    PetProFileViewController *vc = [story instantiateViewControllerWithIdentifier:@"PetProFileViewController"];
    
    [[[UIApplication sharedApplication] valueForKey:@"statusBar"] setValue:[UIColor colorWithRed:86/255.0 green:164/255.0 blue:112/255.0 alpha:1] forKey:@"foregroundColor"];
    
    //loadingBar stop
    [self.lodingBar setHidden:YES];
    [self.lodingBar stopAnimating];
    [self presentViewController:vc animated:YES completion:nil];
}

//텍스트 필드 return
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    /****************텍스트 필드에서 return을 누르면 반응하는 로직***********************/
    if (textField.tag == 1) {
        [self.passwordTextField becomeFirstResponder];
    }else if(textField.tag == 2){
        [self.passwordTextField resignFirstResponder];
        
        [self signInMember];
    }
    return YES;
    /**************************************************************************/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
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
