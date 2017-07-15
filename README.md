# SFSpeechRecognizerDemo  
## IOS10Speech.bak folder  
Files i forked from https://github.com/suifengqjn/IOS10Speech , 2017-6-5 no modify  
## XCSpeechRecognizer .h .m  
Files i forked from https://github.com/suifengqjn/IOS10Speech , 2017-6-5 i modify  
## ViewController.m
Demo code All here
## How to use  
1. import framework:  
```Speech.framework,  SystemConfiguration.framework```  
2. add info.plist Privacy:  
```NSMicrophoneUsageDescription(Privacy - Microphone Usage Description), NSSpeechRecognitionUsageDescription(Privacy - Speech Recognition Usage Description)```  
3. add i modified files and some..  
add  
XCSpeechRecognizer .h .m in your project  
XCSpeechRecognizerDelegate in your viewcontroller file  
add  
@property (nonatomic , strong) UIButton *           speechButton;  
@property (nonatomic , strong) XCSpeechRecognizer * speechXCSpeechRecognizer;  
add  
NSString *regnizedNString;  
6. Demo code:  
```  
see viewcontroller.m file
```  
