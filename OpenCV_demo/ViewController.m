//
//  ViewController.m
//  OpenCV_demo
//
//  Created by Jonathan Williamson on 12/7/17.
//  Copyright © 2017 Credera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIImage *image;
@property Boolean isGray;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.image = [UIImage imageNamed:@"image.jpg"];
	[self.imageView setImage:self.image];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)grayButtonPressed:(id)sender {
	if (!_isGray) {
		[self.imageView setImage:[OpenCVWrapper grayscaleFromImage:self.image]];
		_isGray = true;
	} else {
		[self.imageView setImage:self.image];
		_isGray = false;
	}
}

@end
