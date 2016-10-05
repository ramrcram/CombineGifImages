//
//  ViewController.m
//  CombineGif
//
//  Created by Ramesh on 02/10/16.
//  Copyright © 2016 Trellisys. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "LinkedListStack.h"
#import "CombineGifImages.h"

@interface ViewController ()
{
    NSTimeInterval total_d;
    NSMutableArray* ns_Images;
    
    NSMutableArray* dirty_Images;
    NSMutableArray* combined_Images;
    NSTimeInterval combined_duration;
}
@property (weak, nonatomic) IBOutlet UIImageView *animatedImage;
@property (weak, nonatomic) IBOutlet UILabel *myTimerLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerTick:(NSTimer *)timer {
    NSDate *now = [NSDate date];
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"h:mm:ss a";  // very simple format  "8:47:22 AM"
    }
    self.myTimerLabel.text = [dateFormatter stringFromDate:now];
}

- (IBAction)btnStartClick:(id)sender {
    
    NSMutableArray* tempArray = [[NSMutableArray alloc] init];
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
    
    /*Gif image - 1  */
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Thermo" ofType:@"gif"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    [tempDict setObject:data forKey:@"GifData"];
    [tempDict setObject:[NSString stringWithFormat:@"%f",0.0] forKey:@"StartTime"];
    
    [tempArray addObject:tempDict];
    tempDict = nil;
    tempDict = [[NSMutableDictionary alloc] init];
    
    /*Gif image - 2  */
    path=[[NSBundle mainBundle] pathForResource:@"drillAnimation" ofType:@"gif"];
    data = [[NSFileManager defaultManager] contentsAtPath:path];
    [tempDict setObject:data forKey:@"GifData"];
    [tempDict setObject:[NSString stringWithFormat:@"%f",5.0] forKey:@"StartTime"];
    [tempArray addObject:tempDict];
    tempDict = nil;
    tempDict = [[NSMutableDictionary alloc] init];
    
    /*Gif image - 3  */
    path=[[NSBundle mainBundle] pathForResource:@"Spiral" ofType:@"gif"];
    data = [[NSFileManager defaultManager] contentsAtPath:path];
    [tempDict setObject:data forKey:@"GifData"];
    [tempDict setObject:[NSString stringWithFormat:@"%f",10.0] forKey:@"StartTime"];
    [tempArray addObject:tempDict];
    tempDict = nil;
    
    
    CombineGifImages* cg = [[CombineGifImages alloc] init];
    self.animatedImage.image = [cg doImageCombine:tempArray];
}

@end
