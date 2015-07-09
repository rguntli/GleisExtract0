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
- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
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
- (IBAction)recGleis:(id)sender {
    
//    
//    // 1
//    let tesseract = G8Tesseract()
//    
//    // 2
//    tesseract.language = "eng+fra"
//    
//    // 3
//    tesseract.engineMode = .TesseractCubeCombined
//    
//    // 4
//    tesseract.pageSegmentationMode = .Auto
//    
//    // 5
//    tesseract.maximumRecognitionTime = 60.0
//    
//    // 6
//    tesseract.image = image.g8_blackAndWhite()
//    tesseract.recognize()
//    
//    // 7
//    textView.text = tesseract.recognizedText
//    textView.editable = true
//    
//    // 8
//    removeActivityIndicator()
    
    // do the tesseract magic
    G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;
    tesseract.maximumRecognitionTime = 30.0;
    //tesseract.image = self.selectedImage.g8_blackAndWhite; does not work yet!!
    tesseract.image = self.selectedImage;
    tesseract.recognize;
    sleep(2);
    
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
        cv::Mat gray;
        // Convert the image to grayscale
        cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
        
        // Convert cv::Mat to UIImage* and show the resulting image
        selectedImage = MatToUIImage(gray);
        self.imageView.image = selectedImage;
    }


}

@end
