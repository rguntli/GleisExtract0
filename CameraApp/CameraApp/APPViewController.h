//
//  APPViewController.h
//  CameraApp
//
//  Created by Rafael Garcia Leiva on 10/04/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import <TesseractOCR/G8Constants.h>
#import "opencv2/imgcodecs/ios.h"


@interface APPViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    cv::Mat cvImage;
    cv::Mat cvImage2;
    NSNumber *slideVal;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) IBOutlet UISlider *slider;

@property UIImage *selectedImage;
@property (retain, nonatomic) NSNumber *slideVal;



- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)slideEnd:(UISlider *)sender;


@end
