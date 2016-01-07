//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by test on 1/4/16.
//  Copyright © 2016 Mrtang. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@end

@implementation BNRImageViewController

//-(void)loadView
//{
//    [super loadView];
//     _imageView = [[UIImageView alloc] init];
//    _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    UIScrollView *scorllview = [[UIScrollView alloc] init];
//    CGSize size = [[UIScreen mainScreen] bounds].size;
//    scorllview.contentSize = CGSizeMake(size.width, size.height);
//    scorllview.minimumZoomScale = 1.0;
//    scorllview.maximumZoomScale = 2.0;
//    scorllview.delegate = self;
//    [scorllview addSubview:_imageView];
//    self.view = scorllview;
//}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView    // return a view that will be scaled. if delegate returns nil, nothing happens
{
    return self.imageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIScrollView *scorllview = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        scorllview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 470)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300,450)];
    }
    else
    {
         scorllview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scorllview.bounds.size.width,scorllview.bounds.size.height)];
    }

    _imageView.contentMode = UIViewContentModeScaleAspectFit;

    
    
   // scorllview.contentSize = CGSizeMake(800.0, 800.0);
    scorllview.minimumZoomScale = 1.0;
    scorllview.maximumZoomScale = 2.0;
    scorllview.delegate = self;
    [scorllview addSubview:_imageView];
    [self.view addSubview:scorllview];
}

-(void)viewWillAppear:(BOOL)animated
{
    //UIImageView *imageView = (UIImageView *)self.view;
    self.imageView.image = self.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
