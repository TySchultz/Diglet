//
//  ViewController.m
//  WindUp
//
//  Created by Tyler J Schultz on 6/17/15.
//  Copyright © 2015 Progressive. All rights reserved.
//

#import "ViewController.h"
@import WatchConnectivity;

@interface ViewController  () <WCSessionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *blue;
@property (weak, nonatomic) IBOutlet UIButton *red;
@property (weak, nonatomic) IBOutlet UIButton *green;
@property (weak, nonatomic) IBOutlet UIButton *purple;
@property (weak, nonatomic) IBOutlet UIButton *gray;
@property (weak, nonatomic) IBOutlet UILabel *highScore;

@end



#define GRAYCOLOR [UIColor colorWithRed:0.67 green:0.69 blue:0.75 alpha:1]
#define PURPLECOLOR [UIColor colorWithRed:0.69 green:0.22 blue:0.99 alpha:1]
#define GREENCOLOR [UIColor colorWithRed:0 green:0.69 blue:0.12 alpha:1]
#define REDCOLOR [UIColor colorWithRed:0.97 green:0.16 blue:0.35 alpha:1]
#define BLUECOLOR [UIColor colorWithRed:0.28 green:0.76 blue:0.95 alpha:1]

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    NSInteger savedValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
    
    [self.highScore setText:[NSString stringWithFormat:@"%ld",(long)savedValue]];
    
    
    NSInteger colorNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"colorNumber"];

    if (colorNumber == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"colorNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    self.gray.backgroundColor = GRAYCOLOR;
    self.purple.backgroundColor = PURPLECOLOR;
    self.green.backgroundColor = GREENCOLOR;
    self.red.backgroundColor = REDCOLOR;
    self.blue.backgroundColor = BLUECOLOR;
    
    
    [self customizeButtons:self.gray];
    [self customizeButtons:self.purple];
    [self customizeButtons:self.green];
    [self customizeButtons:self.red];
    [self customizeButtons:self.blue];
    
    
    [self.green setTitle:@"✓" forState:UIControlStateNormal];
    
    
    self.view.backgroundColor = GREENCOLOR;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)customizeButtons:(UIButton *)button{
    
    button.layer.cornerRadius = button.frame.size.width/2;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1.0;
    
}
- (IBAction)changeColor:(UIButton *)sender {
    [self.gray setTitle:@"" forState:UIControlStateNormal];
    [self.purple setTitle:@"" forState:UIControlStateNormal];
    [self.green setTitle:@"" forState:UIControlStateNormal];
    [self.red setTitle:@"" forState:UIControlStateNormal];
    [self.blue setTitle:@"" forState:UIControlStateNormal];

    
    [sender setTitle:@"✓" forState:UIControlStateNormal];

    switch (sender.tag) {
        case 1:
            self.view.backgroundColor = BLUECOLOR;
            break;
        case 2:
            self.view.backgroundColor = REDCOLOR;
            break;
        case 3:
            self.view.backgroundColor = GREENCOLOR;
            break;
        case 4:
            self.view.backgroundColor = PURPLECOLOR;
            break;
        case 5:
            self.view.backgroundColor = GRAYCOLOR;
            break;
        default:
            break;
    }
    
    
    
    [[WCSession defaultSession] sendMessage:@{@"colorNumber":[NSNumber numberWithInteger:sender.tag]} replyHandler:nil errorHandler:nil];

}

-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message{
    
    
    NSNumber *score = message[@"score"];
    [[NSUserDefaults standardUserDefaults] setInteger:score.integerValue forKey:@"score"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.highScore setText:[NSString stringWithFormat:@"%ld",(long)score.integerValue]];

}

@end
