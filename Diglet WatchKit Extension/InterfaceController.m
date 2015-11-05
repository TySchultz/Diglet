//
//  InterfaceController.m
//  WindUpWatch Extension
//
//  Created by Tyler J Schultz on 6/17/15.
//  Copyright © 2015 Progressive. All rights reserved.
//

#import "InterfaceController.h"

@import WatchConnectivity;
@interface InterfaceController() <WCSessionDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *progressView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfacePicker *picker;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *highScore;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lastRun;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *startButton;

@end

#define GRAYCOLOR [UIColor colorWithRed:0.67 green:0.69 blue:0.75 alpha:1]
#define PURPLECOLOR [UIColor colorWithRed:0.69 green:0.22 blue:0.99 alpha:1]
#define GREENCOLOR [UIColor colorWithRed:0 green:0.69 blue:0.12 alpha:1]
#define REDCOLOR [UIColor colorWithRed:0.97 green:0.16 blue:0.35 alpha:1]
#define BLUECOLOR [UIColor colorWithRed:0.28 green:0.76 blue:0.95 alpha:1]


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    [self setupPickerView];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    
    
    NSInteger colorNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"colorNumber"];
    
    if (colorNumber == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"colorNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [self changeColor:colorNumber];
    }
    
    [self.picker setSelectedItemIndex:100];
    NSInteger savedValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"score"];
    
    [self.highScore setText:[NSString stringWithFormat:@"%ld",(long)savedValue]];
    
    NSInteger lastRun = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastRun"];
    if(lastRun == 0){
        [self.lastRun setText:@""];
    }else{
        [self.lastRun setText:[NSString stringWithFormat:@"last run: %ld",(long)lastRun]];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}



-(void)setupPickerView{
    
//    var images: [UIImage]! = []
//    var pickerItems: [WKPickerItem]! = []
//    for (var i=0; i<=36; i++) {
//        let name = "progress-\(i)"
//        images.append(UIImage(named: name)!)
//        
//        let pickerItem = WKPickerItem()
//        pickerItem.title = "\(i)"
//        pickerItems.append(pickerItem)
//    }
//    let progressImages = UIImage.animatedImageWithImages(images, duration: 0.0)
//    self.progressView.setBackgroundImage(progressImages);
    
//    NSMutableArray *images = [[NSMutableArray alloc] init];
//    
//
//    for (int i=0; i<=36; i++){
//        NSString *name = [NSString stringWithFormat:@"progress-%d",i];
//        
//        [images addObject:[UIImage imageNamed:name]];
//        
//    }
//    
//    [self.progressView setBackgroundImage:[UIImage animatedImageWithImages:images duration:0.1]];
    
    
    NSMutableArray *rowTypesList = [NSMutableArray array];
    
    for (int i=0; i<20; i++)
    {
        WKPickerItem *pickerItem = [[WKPickerItem alloc] init];
        [pickerItem setTitle:[NSString stringWithFormat:@"%d%%",100-i*5]];
        
        [rowTypesList addObject:pickerItem];
    }
    
    [self.picker setItems:rowTypesList];
}
- (IBAction)startGame {
    [self pushControllerWithName:@"PlayGame" context:nil];

}



-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message{
    NSNumber *colorNumber = message[@"colorNumber"];
    [[NSUserDefaults standardUserDefaults] setInteger:colorNumber.integerValue forKey:@"colorNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self changeColor:colorNumber.integerValue];
    
}


-(void)changeColor:(NSInteger)colorNumber{
    switch (colorNumber) {
            
        case 1:
            [self.startButton setBackgroundColor: BLUECOLOR];
            break;
        case 2:
            [self.startButton setBackgroundColor: REDCOLOR];
            break;
        case 3:
            [self.startButton setBackgroundColor: GREENCOLOR];
            break;
        case 4:
            [self.startButton setBackgroundColor: PURPLECOLOR];
            break;
        case 5:
            [self.startButton setBackgroundColor: GRAYCOLOR];
            break;
            
        default:
            break;
    }
}



@end



