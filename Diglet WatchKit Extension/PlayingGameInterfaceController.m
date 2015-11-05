//
//  PlayingGameInterfaceController.m
//  WindUp
//
//  Created by Tyler J Schultz on 6/17/15.
//  Copyright © 2015 Progressive. All rights reserved.
//

#import "PlayingGameInterfaceController.h"

@import WatchConnectivity;

@interface PlayingGameInterfaceController () <WCSessionDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfacePicker *picker;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *scoreLBL;

//Playerplpl
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *player0;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *player1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *player2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *player3;
@property (strong, nonatomic) NSMutableArray *playerObjects;


//Road Objects
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *A1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *A2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *A3;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *A4;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *B1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *B2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *B3;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *B4;


@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *C1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *C2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *C3;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *C4;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *D1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *D2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *D3;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *D4;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *E1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *E2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *E3;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *E4;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *F1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *F2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *F3;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *F4;

@property (strong, nonatomic) NSMutableArray *level;
@property (strong, nonatomic) NSMutableArray *level2;


@property (strong, nonatomic) NSMutableArray *aColumn;
@property (strong, nonatomic) NSMutableArray *bColumn;
@property (strong, nonatomic) NSMutableArray *cColumn;
@property (strong, nonatomic) NSMutableArray *dColumn;
@property (strong, nonatomic) NSMutableArray *eColumn;
@property (strong, nonatomic) NSMutableArray *fColumn;
@property (strong, nonatomic) NSTimer *timer;


@property (strong, nonatomic) UIColor *currentColor;


@property  NSInteger counter;
@property  NSInteger currentPosition;
@property  NSInteger currentPlayerPosition;

@property  NSInteger score;
@property  BOOL shouldUpdate;

@end


#define GRAYCOLOR [UIColor colorWithRed:0.67 green:0.69 blue:0.75 alpha:1]
#define PURPLECOLOR [UIColor colorWithRed:0.69 green:0.22 blue:0.99 alpha:1]
#define GREENCOLOR [UIColor colorWithRed:0 green:0.69 blue:0.12 alpha:1]
#define REDCOLOR [UIColor colorWithRed:0.97 green:0.16 blue:0.35 alpha:1]
#define BLUECOLOR [UIColor colorWithRed:0.28 green:0.76 blue:0.95 alpha:1]

@implementation PlayingGameInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    NSInteger colorNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"colorNumber"];
    [self changeColor:colorNumber];
    [self.player0 setBackgroundColor: self.currentColor];

    
    self.playerObjects = [[NSMutableArray alloc] init];
    [self.playerObjects addObject:self.player0];
    [self.playerObjects addObject:self.player1];
    [self.playerObjects addObject:self.player2];
    [self.playerObjects addObject:self.player3];

    
    self.aColumn = [[NSMutableArray alloc] init];
    self.bColumn = [[NSMutableArray alloc] init];
    self.cColumn = [[NSMutableArray alloc] init];
    self.dColumn = [[NSMutableArray alloc] init];
    self.eColumn = [[NSMutableArray alloc] init];

//
    self.score = 0;
    [self.picker setSelectedItemIndex:1];
    self.currentPlayerPosition = 1;
    [self createArrays];
    self.counter = 0;
    self.currentPosition = 0;
    [self setupPickerView];
    [self createLevel];
    
    
    [self.picker focus];
    
    self.shouldUpdate = NO;
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:.5
//                                     target:self
//                                   selector:@selector(updateGame)
//                                   userInfo:nil
//                                    repeats:YES];
    // Configure interface objects here.
}

-(void)updateGame{
    self.score ++;
    
    NSLog(@"CURRENT POS: %ld",(long)self.currentPosition);
    NSNumber *aGap = [self.level objectAtIndex:self.currentPosition];
    NSNumber *bGap = [self.level objectAtIndex:self.currentPosition+1];
    NSNumber *cGap = [self.level objectAtIndex:self.currentPosition+2];
    NSNumber *dGap = [self.level objectAtIndex:self.currentPosition+3];
    NSNumber *eGap = [self.level objectAtIndex:self.currentPosition+4];
    
    NSNumber *aGap2 = [self.level2 objectAtIndex:self.currentPosition];
    NSNumber *bGap2 = [self.level2 objectAtIndex:self.currentPosition+1];
    NSNumber *cGap2 = [self.level2 objectAtIndex:self.currentPosition+2];
    NSNumber *dGap2 = [self.level2 objectAtIndex:self.currentPosition+3];
    NSNumber *eGap2 = [self.level2 objectAtIndex:self.currentPosition+4];
    
    int playerPos = self.currentPlayerPosition;

    [self updateGroup:self.aColumn gap:aGap gap2:aGap2];
    [self updateGroup:self.bColumn gap:bGap gap2:bGap2];
    [self updateGroup:self.cColumn gap:cGap gap2:cGap2];
    [self updateGroup:self.dColumn gap:dGap gap2:dGap2];
    [self updateGroup:self.eColumn gap:eGap gap2:eGap2];

    if (self.currentPosition > 0) {
        
    
    if (playerPos+1 == ((NSNumber *)[self.level objectAtIndex:self.currentPosition-1]).integerValue||
        playerPos+1 == ((NSNumber *)[self.level2 objectAtIndex:self.currentPosition-1]).integerValue){
        
        [[NSUserDefaults standardUserDefaults] setInteger:self.score forKey:@"lastRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        NSNumber *savedValue = [[NSUserDefaults standardUserDefaults]
                                objectForKey:@"score"];
        
        if (savedValue.integerValue < self.score) {
            
            [[NSUserDefaults standardUserDefaults] setInteger:self.score forKey:@"score"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[WCSession defaultSession] sendMessage:@{@"score":[NSNumber numberWithInt:self.score]} replyHandler:nil errorHandler:nil];
        }
        [[WKInterfaceDevice currentDevice] playHaptic:WKHapticTypeFailure];
        
        [self.picker setEnabled:NO];
        [self popController];
        
    
    }
    }
    [self.scoreLBL setText:[NSString stringWithFormat:@"%ld",(long)self.score]];
    

    
    self.currentPosition ++;
    if (self.currentPosition > 90) {
        self.currentPosition = 0;
    }
}


-(void)updateGroup:(NSMutableArray *)column gap:(NSNumber *)gap1 gap2:(NSNumber *)gap2 {
    int tmpCounter = 1;
    for(WKInterfaceGroup *group in column){
        if (gap1.integerValue == tmpCounter || gap2.integerValue == tmpCounter) {
            [group setBackgroundColor:[UIColor whiteColor]];
        }else{
            [group setBackgroundColor:[UIColor clearColor]];
        }
        tmpCounter ++;
        
    }
}

-(void)createArrays{
    [self.aColumn insertObject:self.A1 atIndex:0];
    [self.aColumn insertObject:self.A2 atIndex:1];
    [self.aColumn insertObject:self.A3 atIndex:2];
    [self.aColumn insertObject:self.A4 atIndex:3];

    [self.bColumn insertObject:self.B1 atIndex:0];
    [self.bColumn insertObject:self.B2 atIndex:1];
    [self.bColumn insertObject:self.B3 atIndex:2];
    [self.bColumn insertObject:self.B4 atIndex:3];

    [self.cColumn insertObject:self.C1 atIndex:0];
    [self.cColumn insertObject:self.C2 atIndex:1];
    [self.cColumn insertObject:self.C3 atIndex:2];
    [self.cColumn insertObject:self.C4 atIndex:3];

    [self.dColumn insertObject:self.D1 atIndex:0];
    [self.dColumn insertObject:self.D2 atIndex:1];
    [self.dColumn insertObject:self.D3 atIndex:2];
    [self.dColumn insertObject:self.D4 atIndex:3];

    [self.eColumn insertObject:self.E1 atIndex:0];
    [self.eColumn insertObject:self.E2 atIndex:1];
    [self.eColumn insertObject:self.E3 atIndex:2];
    [self.eColumn insertObject:self.E4 atIndex:3];

}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


-(void)setupPickerView{
    
    NSMutableArray *rowTypesList = [NSMutableArray array];
//    int responsiveness = 1;
//    for (int i=0; i<responsiveness*4; i++)
//    {
//        WKPickerItem *pickerItem = [[WKPickerItem alloc] init];
//        [pickerItem setTitle:[NSString stringWithFormat:@"%d%%",i+1]];
//        if (i >= 0 && i < responsiveness) {
//            [pickerItem setContentImage:[WKImage imageWithImageName:@"player_1"]];
//        }else if (i >= responsiveness && i < responsiveness*2) {
//            [pickerItem setContentImage:[WKImage imageWithImageName:@"player_2"]];
//        }else if (i >= responsiveness*2 && i < responsiveness*3) {
//            [pickerItem setContentImage:[WKImage imageWithImageName:@"player_3"]];
//        }else if (i >= responsiveness*3 && i < responsiveness*4) {
//            [pickerItem setContentImage:[WKImage imageWithImageName:@"player_4"]];
//        }
//        
//        [rowTypesList addObject:pickerItem];
//    }
//    
    WKPickerItem *pickerItem1 = [[WKPickerItem alloc] init];
    [pickerItem1 setTitle:@" "];
    [pickerItem1 setContentImage:[WKImage imageWithImageName:@"play_1"]];

    WKPickerItem *pickerItem2 = [[WKPickerItem alloc] init];
    [pickerItem2 setTitle:@" "];

    [pickerItem2 setContentImage:[WKImage imageWithImageName:@"play_2"]];

    WKPickerItem *pickerItem3 = [[WKPickerItem alloc] init];
    [pickerItem3 setTitle:@" "];

    [pickerItem3 setContentImage:[WKImage imageWithImageName:@"play_3"]];

    WKPickerItem *pickerItem4 = [[WKPickerItem alloc] init];
    [pickerItem4 setTitle:@" "];
    [pickerItem4 setContentImage:[WKImage imageWithImageName:@"play_4"]];
    
    [rowTypesList addObject:pickerItem1];
    [rowTypesList addObject:pickerItem2];
    [rowTypesList addObject:pickerItem3];
    [rowTypesList addObject:pickerItem4];

    [self.picker setItems:rowTypesList];
}

-(void)createLevel{
    self.level = [[NSMutableArray alloc]init];
    self.level2 = [[NSMutableArray alloc]init];

    BOOL blank = YES;
    for (int i=0; i<100; i++)
    {
        if (blank) {
            [self.level addObject:[NSNumber numberWithInteger:0]];
            [self.level2 addObject:[NSNumber numberWithInteger:0]];
            blank = NO;
        }else{
            [self.level addObject:[NSNumber numberWithInteger:arc4random_uniform(4)+1]];
            [self.level2 addObject:[NSNumber numberWithInteger:arc4random_uniform(4)+1]];

            blank = YES;
        }
        
    }

}

- (IBAction)itemIndex:(NSInteger)value {
    self.currentPlayerPosition = value;
    
    [self updatePlayer];
    
    
    [self updateGame];

    
}

-(void)updatePlayer{
    
    for (int i=0; i < self.playerObjects.count; i++){
        if (i == self.currentPlayerPosition) {
            [[self.playerObjects objectAtIndex:i] setBackgroundColor:self.currentColor];
        }else{
            [[self.playerObjects objectAtIndex:i] setBackgroundColor:[UIColor clearColor]];

        }
    }
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
            self.currentColor = BLUECOLOR;
            break;
        case 2:
            self.currentColor = REDCOLOR;
            break;
        case 3:
            self.currentColor = GREENCOLOR;
            break;
        case 4:
            self.currentColor = PURPLECOLOR;
            break;
        case 5:
            self.currentColor = GRAYCOLOR;
            break;
            
        default:
            break;
    }
}




@end



