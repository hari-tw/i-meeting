//
//  ViewController.m
//  i-Meeting
//
//  Created by Sanchit Bahal on 12/10/12.
//  Copyright (c) 2012 ThoughtWorks Technologies (India) Pvt. Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "QRCodeController.h"

@interface RootViewController ()

@property (nonatomic, strong) QRCodeController *qrCodeController;

@end

@implementation RootViewController

@synthesize qrCodeController = _qrCodeController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QRCodeController *)qrCodeController {
    if (!_qrCodeController) {
        _qrCodeController = [QRCodeController new];
    }
    
    return _qrCodeController;
}

- (IBAction)btnScan:(UIButton *)sender {
    // URL to generate QR Code
    // https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=Hello%20World
    NSLog(@"Scan button tapped.");
    
    UIViewController *reader = [self.qrCodeController prepareQrCodeReader];
    [self presentModalViewController:reader animated:YES];
}
@end
