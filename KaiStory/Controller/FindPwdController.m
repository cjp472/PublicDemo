//
//  FindPwdController.m
//  KaiStory
//
//  Created by yanzehua on 15/4/18.
//  Copyright (c) 2015年 gaoxinfei. All rights reserved.
//

#import "FindPwdController.h"
#import "LoginDataService.h"
#import "Tools.h"
#import "UserInfo.h"
#import "UIColor+HexStringToColor.h"
#import "MyDataService.h"

@implementation FindPwdController

-(void) initLayout: (UIView*)contentView
{
    int const backImgMarginLeft = 56;
    int const backImgMarginTop = 85;
    int const backImgWidth = 547;
    int const backImgHeight = 267;
    
    UIImageView* backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(backImgMarginLeft*RESIZE_RATIO, backImgMarginTop*RESIZE_RATIO, backImgWidth*RESIZE_RATIO, backImgHeight*RESIZE_RATIO) ];
    [backImgView setImage:[UIImage imageNamed:@"信息框3排"]];
    [contentView addSubview:backImgView];
    
    int const lableFontSize = 26;
    NSString* labelFontColorStr = @"656f6d";
    
    int const phoneLabelMarginLeft = 100;
    int const phoneLabelMarginTop = backImgMarginTop + 36;
    int const phoneLabelWidth = 26*3;
    int const phoneLabelHeight = 26;
    UILabel* phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(phoneLabelMarginLeft*RESIZE_RATIO, phoneLabelMarginTop*RESIZE_RATIO, phoneLabelWidth*RESIZE_RATIO, phoneLabelHeight*RESIZE_RATIO)];
    phoneLabel.font = [UIFont systemFontOfSize:lableFontSize*RESIZE_RATIO];
    phoneLabel.textColor = [UIColor ColorWithHexString:labelFontColorStr];
    phoneLabel.text = @"手机号";
    [contentView addSubview:phoneLabel];
    
    int const captchaLabelMarginLeft = 100;
    int const captchaLabelMarginTop = backImgMarginTop + 120;
    int const captchaLabelWidth = 26*3;
    int const captchaLabelHeight = 26;
    UILabel* captchaLabel = [[UILabel alloc] initWithFrame:CGRectMake(captchaLabelMarginLeft*RESIZE_RATIO, captchaLabelMarginTop*RESIZE_RATIO, captchaLabelWidth*RESIZE_RATIO, captchaLabelHeight*RESIZE_RATIO)];
    captchaLabel.font = [UIFont systemFontOfSize:phoneLabelHeight*RESIZE_RATIO];
    captchaLabel.textColor = [UIColor ColorWithHexString:labelFontColorStr];
    captchaLabel.text = @"验证码";
    [contentView addSubview:captchaLabel];
    
    int const pwdLabelMarginLeft = 100;
    int const pwdLabelMarginTop = backImgMarginTop + 204;
    int const pwdLabelWidth = 26*3;
    int const pwdLabelHeight = 26;
    UILabel* pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(pwdLabelMarginLeft*RESIZE_RATIO, pwdLabelMarginTop*RESIZE_RATIO, pwdLabelWidth*RESIZE_RATIO, pwdLabelHeight*RESIZE_RATIO)];
    pwdLabel.font = [UIFont systemFontOfSize:phoneLabelHeight*RESIZE_RATIO];
    pwdLabel.textColor = [UIColor ColorWithHexString:labelFontColorStr];
    pwdLabel.text = @"密码";
    [contentView addSubview:pwdLabel];
    
    
    int const phoneTxtMarginLeft = 200;
    int const phoneTxtMarginTop = phoneLabelMarginTop;
    int const phoneTxtWidth = 300;
    int const phoneTxtHeight = 26;
    self.phoneTxt = [[UITextField alloc] initWithFrame:CGRectMake(phoneTxtMarginLeft*RESIZE_RATIO, phoneTxtMarginTop*RESIZE_RATIO, phoneTxtWidth*RESIZE_RATIO, phoneTxtHeight*RESIZE_RATIO)];
    self.phoneTxt.textColor = [UIColor ColorWithHexString:labelFontColorStr];
    self.phoneTxt.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTxt.placeholder = @"请输入手机号";
    self.phoneTxt.delegate = self;
    [contentView addSubview:self.phoneTxt];
    
    int const captchaTxtMarginLeft = 200;
    int const captchaTxtMarginTop = captchaLabelMarginTop;
    int const captchaTxtWidth = 300;
    int const captchaTxtHeight = 26;
    self.captchaTxt = [[UITextField alloc] initWithFrame:CGRectMake(captchaTxtMarginLeft*RESIZE_RATIO, captchaTxtMarginTop*RESIZE_RATIO, captchaTxtWidth*RESIZE_RATIO, captchaTxtHeight*RESIZE_RATIO)];
    self.captchaTxt.textColor = [UIColor ColorWithHexString:labelFontColorStr];
    self.captchaTxt.placeholder = @"请输入验证码";
    self.captchaTxt.keyboardType = UIKeyboardTypePhonePad;
    self.captchaTxt.delegate = self;
    [contentView addSubview:self.captchaTxt];
    
    int const captchaBtnMarginLeft = 430;
    int const captchaBtnMarginTop = captchaLabelMarginTop;
    int const captchaBtnWidth = 150;
    int const captchaBtnHeight = 34;
    self.captchaBtn = [[UIButton alloc] initWithFrame:CGRectMake(captchaBtnMarginLeft*RESIZE_RATIO, captchaBtnMarginTop*RESIZE_RATIO, captchaBtnWidth*RESIZE_RATIO, captchaBtnHeight*RESIZE_RATIO)];
    [self.captchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.captchaBtn setTitleColor:[UIColor ColorWithHexString:@"ffffff"]forState:UIControlStateNormal];
    self.captchaBtn.titleLabel.font = [UIFont systemFontOfSize:20*RESIZE_RATIO];
    [self.captchaBtn setBackgroundImage:[UIImage imageNamed:@"验证码背景.png"] forState:UIControlStateNormal];
    [contentView addSubview:self.captchaBtn];
    [self.captchaBtn addTarget:self action:@selector(captchaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSUserDefaults *userDeFaults = [NSUserDefaults standardUserDefaults];
    NSString *lastCaptchaSecStr = [userDeFaults objectForKey:@"captchaTime"];
    NSInteger lastCaptchaSec = [lastCaptchaSecStr integerValue];
    NSDate* currentDate = [NSDate date];
    NSInteger currentSec =currentDate.timeIntervalSince1970;
    if(currentSec - lastCaptchaSec <= 60)
    {
        NSLog(@"CURRENT %@ %ld",currentDate,currentSec);
        self.captchaCount = 60- (currentSec - lastCaptchaSec);
        [self.captchaBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",self.captchaCount] forState:UIControlStateNormal];
        self.captchaTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        
    }

    
    int const pwdTxtMarginLeft = 200;
    int const pwdTxtMarginTop = pwdLabelMarginTop;
    int const pwdTxtWidth = 300;
    int const pwdTxtHeight = 26;
    self.pwdTxt = [[UITextField alloc] initWithFrame:CGRectMake(pwdTxtMarginLeft*RESIZE_RATIO, pwdTxtMarginTop*RESIZE_RATIO, pwdTxtWidth*RESIZE_RATIO, pwdTxtHeight*RESIZE_RATIO)];
    self.pwdTxt.textColor = [UIColor ColorWithHexString:labelFontColorStr];
    self.pwdTxt.placeholder = @"请输入6位以上密码";
    self.pwdTxt.secureTextEntry = YES;
    //self.pwdTxt.keyboardType = UIKeyboardTypePhonePad;
    self.pwdTxt.delegate = self;
    [contentView addSubview:self.pwdTxt];
    
    int const btnMarginLeft = 56;
    int const btnMarginTop =  backImgMarginTop + backImgHeight + 48;
    int const btnWidth = 547;
    int const btnHeight = 90;
    UIButton* resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnMarginLeft*RESIZE_RATIO,btnMarginTop*RESIZE_RATIO,btnWidth*RESIZE_RATIO,btnHeight*RESIZE_RATIO)];
    [resetBtn setTitle:@"确定" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor ColorWithHexString:@"ffffff"]forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:30*RESIZE_RATIO];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"登陆按钮.png"] forState:UIControlStateNormal];
    [contentView addSubview:resetBtn];
    [resetBtn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL) checkAvail
{
    if(self.phoneTxt.text.length==0)
        return NO;
    if(self.captchaTxt.text.length==0)
        return NO;
    if(self.pwdTxt.text.length==0)
        return NO;
    return YES;
}
-(void) requestUserInfo:(NSString*) userId accessToken:(NSString*) accessToken
{
    NSString *url = @"/api/user/index";
    NSString *appid=@"1.0";
    NSString *app_ver = @"1.0";
    NSString *json_ver = @"0.1";
    
    NSString *ln = @"33.332";
    NSString *lat = @"199.3232";
    
    NSMutableDictionary *dir = [NSMutableDictionary dictionaryWithObjectsAndKeys:appid,@"appid",app_ver,@"app_ver",json_ver,@"json_ver",ln,@"lng",lat,@"lat",userId,@"user_id",accessToken,@"token",nil];
    [MyDataService requestAFURL:url httpMethod:@"POST" params:dir data:nil complection:^(id result) {
        NSLog(@"___________result=======%@",result);
        NSString *codeStr = [result objectForKey:@"code"];
        NSInteger code = [codeStr integerValue];
        if(200 == code)
        {
            NSDictionary *res = [result objectForKey:@"result"];
            NSDictionary *userinfo = [res objectForKey:@"userinfo"];
            UserInfo* user = [[UserInfo alloc]initWithDict:userinfo];
            
            //  保存状态数据
            NSUserDefaults *userDeFaults = [NSUserDefaults standardUserDefaults];
            [userDeFaults setValue:user.user_name forKey:@"userName"];
            [userDeFaults setValue:user.baby_name forKey:@"babyName"];
            [userDeFaults setValue:user.mobile forKey:@"mobile"];
            [userDeFaults setValue:user.age forKey:@"babyAge"];
            [userDeFaults setValue:user.birthday forKey:@"birthday"];
            [userDeFaults setValue:user.listen_count forKey:@"listenCount"];
            [userDeFaults setValue:user.continue_listen_day forKey:@"continueListenDay"];
            [userDeFaults setValue:user.continue_listen_day forKey:@"listenTotalTime"];
            [userDeFaults setValue:user.favor_count forKey:@"favorCount"];
            [userDeFaults setValue:@"1" forKey:@"loginStatus"];
            [userDeFaults setValue:accessToken forKey:@"accessToken"];
            [userDeFaults setValue:userId forKey:@"userId"];
            NSLog(@"UserSex %@",user.sex);
            if([user.sex isEqualToString:@"m"])
            {
                [userDeFaults setValue:@"1" forKey:@"babySex"];
            }else
            {
                [userDeFaults setValue:@"0" forKey:@"babySex"];
            }
            [userDeFaults synchronize];
            
            [self dismissViewControllerAnimated:YES completion:^(){}];
        }
    }
     
     ];
    
}

-(void)resetBtnClick:(id)sender
{
    NSMutableDictionary *passwordDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.phoneTxt.text,@"mobile",self.captchaTxt.text,@"code",self.pwdTxt.text,@"new_password", nil];
    [LoginDataService requestAFURL:@"/user/forget_password" httpMethod:@"POST" params:passwordDic data:nil complection:^(id result) {
        
        NSLog(@"result==%@",result);
        NSString *code = [result objectForKey:@"code"];
        NSInteger CODE = [code integerValue];
        if (CODE==200) {
            
            NSLog(@"发送成功");
            NSDictionary *tokenDic = [result objectForKey:@"result"];
            NSDictionary *token = [tokenDic objectForKey:@"token"];
            NSString *accestoken = [token objectForKey:@"access_token"];
            NSString *userId = [token objectForKey:@"user_id"];
            
            // 请求用户的基础信息
            [self requestUserInfo:userId accessToken:accestoken];
        }else if(CODE == 102){
            NSLog(@"参数错误，为空格式错误等");
            
        }
        else if (CODE == 500){
            
            NSLog(@"服务器错误");
            
        }else if (CODE ==103){
            
            NSLog(@"短信码错误");
            
            
        }
        
    }];

}
-(void)captchaBtnClick:(id)sender
{
    NSString* phoneNum = self.phoneTxt.text;
    if(phoneNum.length == 11)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneNum,@"mobile" ,nil];
        [LoginDataService requestAFURL:@"/sys/send_sms?appid=xx&app_ver=1.0&json_ver=&lng=&lat=" httpMethod:@"POST" params:dict data:nil complection:^(id result) {
            NSLog(@"result==%@",result);
            NSString *code = [result objectForKey:@"code"];
            NSInteger CODE = [code integerValue];
            if (CODE==200) {
                NSLog(@"发送成功");
            }else{
                NSLog(@"短信码错误");
            }
        }];
        
        self.captchaCount = 59;
        self.captchaTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        NSUserDefaults *userDeFaults = [NSUserDefaults standardUserDefaults];
        NSDate* currentDate = [NSDate date];
        NSInteger currentSec =currentDate.timeIntervalSince1970;
        [userDeFaults setObject:[NSString stringWithFormat:@"%ld",currentSec] forKey:@"captchaTime"];
        [self.captchaBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)self.captchaCount] forState:UIControlStateNormal];
        NSLog(@"CURRENT %@ %ld",currentDate,currentSec);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor ColorWithHexString:@"e2f2ee"];
    
    UIView* contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, FRAME_WIDTH, FRAME_HEIGHT)];
    
    [self initLayout:contentView ];
    [self.view addSubview:contentView];
    [self.phoneTxt becomeFirstResponder];
    
}

//定时器方法
- (void)timerFireMethod:(NSTimer*)theTimer{
    self.captchaCount--;
    if (self.captchaCount>0) {
        [self.captchaBtn setUserInteractionEnabled:NO];
        [self.captchaBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)self.captchaCount] forState:UIControlStateNormal];
    }else
    {
        [self.captchaTimer invalidate];
        [self.captchaBtn setUserInteractionEnabled:YES];
        [self.captchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

-(void)backBtnAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

@end
