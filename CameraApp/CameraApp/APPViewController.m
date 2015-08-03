//
//  APPViewController.m
//  CameraApp
//
//  Created by Rafael Garcia Leiva on 10/04/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "APPViewController.h"

@interface APPViewController ()

@end

@implementation APPViewController

@synthesize selectedImage;
@synthesize slideVal;
@synthesize slider;

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // set default photo
    selectedImage = [UIImage imageNamed:@"Gleisanzeiger.jpg"];
    self.imageView.image = selectedImage;
    self.slideVal = @(slider.value);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(IBAction)slideEnd:(UISlider *)sender {
    float f = sender.value;
    slideVal = @(f);
    [self openCV:nil];
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)tessText:(id)sender {
    
    // do the tesseract magic
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    tesseract.pageSegmentationMode = G8PageSegmentationModeSparseText;
    tesseract.maximumRecognitionTime = 30.0;
    //tesseract.image = self.selectedImage.g8_blackAndWhite; does not work yet!!
    tesseract.image = self.imageView.image;
    [tesseract recognize];
    NSString *gleis = @"not yet possible";
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Gleis" message:tesseract.recognizedText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [myAlert show];
}

- (IBAction)tessWord:(id)sender {
    
    // do the tesseract magic
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    tesseract.pageSegmentationMode = G8PageSegmentationModeSingleWord;
    tesseract.maximumRecognitionTime = 30.0;
    //tesseract.image = self.selectedImage.g8_blackAndWhite; does not work yet!!
    tesseract.image = self.imageView.image;
    [tesseract recognize];
    NSString *gleis = @"not yet possible";
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Gleis" message:tesseract.recognizedText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [myAlert show];
}

- (IBAction)tessChar:(id)sender {
    
    // do the tesseract magic
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    tesseract.pageSegmentationMode = G8PageSegmentationModeSingleChar;
    tesseract.maximumRecognitionTime = 30.0;
    //tesseract.image = self.selectedImage.g8_blackAndWhite; does not work yet!!
    tesseract.image = self.imageView.image;
    [tesseract recognize];
    NSString *gleis = @"not yet possible";
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Gleis" message:tesseract.recognizedText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [myAlert show];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.selectedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = self.selectedImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)openCV:(UIButton *)sender {
    // Convert UIImage* to cv::Mat
    UIImageToMat(selectedImage, cvImage);
    
    if (!cvImage.empty()) {
        cv::Mat imgHalfSize1;
        cv::Mat imgHalfSize2;
        cv::Mat imgHalfSize2Gray;
        cv::Mat imgBW;
        cv::Mat imgBWThresh;
        cv::Mat imgBWVectors;
        cv::Mat imgContours;

        
        cv::pyrDown(cvImage, imgHalfSize1);
        cv::pyrDown(imgHalfSize1, imgHalfSize2);
        
        // Convert the image to grayscale
        cv::cvtColor(imgHalfSize2, imgHalfSize2Gray, CV_RGBA2GRAY);

        
        //imgBW = cv::threshold(cvImage, 127, 255, cv::THRESH_BINARY)[1];
        //cv::threshold(cvImage, imgBW, 127, cv::THRESH_BINARY, c);
        
       // [[cvtColor(orig, cv2.COLOR_BGR2GRAY)]
        
        cv::cvtColor(cvImage, imgBW, cv::COLOR_BGR2GRAY);
        //cv::threshold(imgBW, imgBW2, cv::THRESH_BINARY, 127, 255);
        //cv::threshold(imgBW, imgBW2, 0.7, 1, cv::THRESH_BINARY);
        cv::threshold(imgBW, imgBWThresh, [slideVal doubleValue], 255.0, cv::THRESH_BINARY_INV);
        //cv::cvtColor(imgBW2, imgBW3, cv::COLOR_BGR2GRAY);

        imgBWVectors = imgBWThresh.clone();
        
        std::vector<std::vector<cv::Point>> contours;
        cv::findContours(imgBWVectors, contours, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE); //will find all
//        
//        for (int i = 0; i<contours.size(); i++) {
//            cv::draw
//        }
        
        //cv::drawContours(InputOutputArray image, contours, <#int contourIdx#>, <#const Scalar &color#>)
    
        cv::pyrDown(imgBWThresh, imgHalfSize1);
        cv::pyrDown(imgHalfSize1, imgHalfSize2);
        
        // Convert cv::Mat to UIImage* and show the resulting image
        //selectedImage = MatToUIImage(imgBW2);
        self.imageView.image = MatToUIImage(imgHalfSize2);
        self.imageView2.image = MatToUIImage(imgBWVectors);
    }


}

@end
