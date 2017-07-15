//
//  ViewController.m
//  nil
//
//  Created by nil on 7/6/17.
//  Copyright © 2017 https://github.com/foolsparadise All rights reserved.
//

#import "ViewController.h"
#import "XCSpeechRecognizer.h"

#define iOS10_OR_LATER (__IPHONE_OS_VERSION_MAX_ALLOWED >= 100000)
#define IOS_systemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define IMAGE_WIHT_NAME(p) [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:p]]

@interface ViewController () <XCSpeechRecognizerDelegate> {
    NSString *regnizedNString;
}

@property (nonatomic , strong) UIButton *           speechButton;
@property (nonatomic , strong) XCSpeechRecognizer * speechXCSpeechRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // init btn 这里需要初始化 speechButton ，及添加约束
    /* [self.view addSubview:self.speechButton];
    [self.speechButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(-30);
        make.right.equalTo(self.view.mas_centerX).offset(30);
        make.size.equalTo(CGSizeMake(60, 60));
    }]; */
    

    
}


- (UIButton *)speechButton{    

#if iOS10_OR_LATER
    if(IOS_systemVersion >= 10.0) {
        
        if (!_speechButton) {
            _speechButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *selectImage = IMAGE_WIHT_NAME(@"ico_select_IMG");
            UIImage *unSelectImage = IMAGE_WIHT_NAME(@"ico_unselect_IMG");
            NSString *titleString = NSLocalizedStringFromTable(@"语音控制",@"InfoPlist",nil);
            [_speechButton setImage:unSelectImage forState:UIControlStateNormal];
            [_speechButton setImage:selectImage forState:UIControlStateSelected];
            [_speechButton addTarget:self action:@selector(openSpeechRecognizer:) forControlEvents:UIControlEventTouchUpInside];
            [_speechButton setTitle:titleString forState:UIControlStateNormal];
            [_speechButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _speechButton.titleLabel.font = [UIFont systemFontOfSize:8];
            _speechButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            _speechButton.titleEdgeInsets =UIEdgeInsetsMake(0.5*selectImage.size.height, -0.5*selectImage.size.width, -0.5*selectImage.size.height, 0.5*selectImage.size.width);
            CGSize size1 = [titleString sizeWithFont:[UIFont systemFontOfSize:8] constrainedToSize:CGSizeMake(MAXFLOAT, _speechButton.titleLabel.frame.size.height)];
            _speechButton.imageEdgeInsets =UIEdgeInsetsMake(-0.5*size1.height, 0.5*size1.width, 0.5*size1.height, -0.5*size1.width);
        }
        
    }
#endif
    
    return _speechButton;
    
}
#pragma mark - XCSpeechRecognizerDelegate
- (void)recognizeDidStart:(NSError *)error
{
    NSLog(@"recognizeDidStart %@", error.description);
}
- (void)recognizeDidStop
{
    NSLog(@"recognizeDidStop");
}
- (void)recognizeFail:(NSError *)error
{
    NSLog(@"recognizeFail %@", error.description);
}
- (void)recognizeSuccess:(NSString *)result
{
    regnizedNString = [regnizedNString stringByAppendingString:result];
    NSLog(@"recognizeSuccess %@", regnizedNString);
    if([regnizedNString hasSuffix:@"茄子"] || [regnizedNString.lowercaseString hasSuffix:@"cheese"]
       ) {
        /* __weak typeof(self) weakSelf = self;
        [weakSelf xxxxxx]; */ // do something here 在这里做你想做的，比如 茄子拍照
    }
}
- (void)recognizeFinish
{
    NSLog(@"recognizeFinish");
}
- (void)openSpeechRecognizer:(UIButton *)sender{
    sender.selected = !sender.selected;
    regnizedNString = @"";
    //NSLog(@"%d", sender.selected);
    
    /* if ([self.speech isRunning]) { //测试验证发现，不如用一个 button 的 selected 来做判断处理
     [self.speech stopRecording];
     NSLog(@"停止");
     } else {
     [self.speech startRecording];
     NSLog(@"开始");
     } */
    
    if(sender.selected == YES)
    {
        
        NSString *systemLanguage = [self systemLanguage];
        if ([systemLanguage  hasPrefix:@"zh-Hans"]){
            //简体中文
            self.speechXCSpeechRecognizer = [[XCSpeechRecognizer alloc] initWithLocaleIdentifier:@"zh_CN"];
        }
        
        /* else if ([systemLanguage hasPrefix:@"zh-Hant"] || [systemLanguage hasPrefix:@"zh-HK"]){ //香港
         self.speech = [[XCSpeechRecognizer alloc] initWithLocaleIdentifier:@"zh_HK"];
         }
         else if ([systemLanguage hasPrefix:@"zh-TW"]){
         self.speech = [[XCSpeechRecognizer alloc] initWithLocaleIdentifier:@"zh_TW"];
         } */
        
        else{
            //默认英文
            self.speechXCSpeechRecognizer = [[XCSpeechRecognizer alloc] initWithLocaleIdentifier:@"en_US"];
        }
        
        /* for (NSLocale *lacal in [SFSpeechRecognizer supportedLocales].allObjects) { //列出国家及语言
         NSLog(@"countryCode:%@  languageCode:%@ ", lacal.countryCode, lacal.languageCode);
         } */
        
        /* self.speech = [[XCSpeechRecognizer alloc] initWithLocaleIdentifier:@"zh_CN"];
         self.speech = [[XCSpeechRecognizer alloc] initWithLocaleIdentifier:@"en_US"]; */
        
        self.speechXCSpeechRecognizer.delegate = self;
        
        [self.speechXCSpeechRecognizer startRecording];
        NSLog(@"开始");
        /* [self 提示:NSLocalizedStringFromTable(@"说<茄子>!\n请在有网的情况下使用",@"InfoPlist",nil) yOffset:150]; */
        
    } else {
        
        [self.speechXCSpeechRecognizer stopRecording];
        self.speechXCSpeechRecognizer = nil;
        NSLog(@"停止");
        
        
    }
}
- (void)exitThisViewController // 退出此 ViewController 的 button action
{
    __weak typeof(self) weajSekf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if ([weajSekf.speechXCSpeechRecognizer isRunning]) {
            [weajSekf.speechXCSpeechRecognizer stopRecording];
//            NSLog(@"关闭");
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated
{

#if iOS10_OR_LATER
    if(IOS_systemVersion >= 10.0) {
        if(self.speechButton.selected == YES) {
            // 每次进来，默认关闭
            self.speechButton.selected = !self.speechButton.selected;
        }
        
    }
#endif

    
}
- (NSString*)systemLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
