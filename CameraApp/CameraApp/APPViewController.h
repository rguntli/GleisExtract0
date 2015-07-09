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
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property UIImage *selectedImage;

- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;

@end
