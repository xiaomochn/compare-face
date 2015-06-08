//
//  SingChoseViewController.m
//  compareface
//
//  Created by qiao on 15/6/5.
//  Copyright (c) 2015年 qiao. All rights reserved.
//

#import "SingChoseViewController.h"
#import "btRippleButtton.h"
#import "LTBounceSheet.h"

#import "APIKeyAndAPISecret.h"

#define color [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]
@interface SingChoseViewController ()
@property(nonatomic,strong) LTBounceSheet *sheet;

@end
@implementation SingChoseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    imagePicker = [[UIImagePickerController alloc] init];
    
    // initialize
    NSString *API_KEY = @"d277502ffe983493f92754c4431726db";
    NSString *API_SECRET = @"pxyJuPZXukNG4JGPllXqooYaOOna4rIv";
    [FaceppAPI initWithApiKey:API_KEY andApiSecret:API_SECRET andRegion:APIServerRegionCN];
    
    BTRippleButtton *rippleButton = [[BTRippleButtton alloc]initWithImage:[UIImage imageNamed:@"maincolor.png"]
                                                                 andFrame:CGRectMake((kSCREEN_WIDTH)/2-50, (kSCREEN_HEIGHT)/2, 100, 100)
                                                                andTarget:@selector(toggle)
                                                                    andID:self];
    
    [rippleButton setRippeEffectEnabled:YES];
    [rippleButton setRippleEffectWithColor:kMAIN_COLOOR];
   
    [self.view addSubview:rippleButton];
    // turn on the debug mode
    [FaceppAPI setDebugMode:TRUE];
  
    self.sheet = [[LTBounceSheet alloc]initWithHeight:250 bgColor:color];
    
    UIButton * option1 = [self produceButtonWithTitle:@"拍 照"];
    option1.frame=CGRectMake(15, 30, kSCREEN_WIDTH-30, 46);
    [option1 addTarget:self action:@selector(toggleClickCM) forControlEvents:UIControlEventTouchUpInside];
    [self.sheet addView:option1];
    
    UIButton * option2 = [self produceButtonWithTitle:@"从相册选择"];
    option2.frame=CGRectMake(15, 90, kSCREEN_WIDTH-30, 46);
    [option2 addTarget:self action:@selector(toggleClickPT) forControlEvents:UIControlEventTouchUpInside];
    [self.sheet addView:option2];
    
    UIButton * cancel = [self produceButtonWithTitle:@"取消"];
    cancel.frame=CGRectMake(15, 170, kSCREEN_WIDTH-30, 46);
    [cancel addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];

    [self.sheet addView:cancel];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.sheet];
    [self initall];
}



-(UIButton *) produceButtonWithTitle:(NSString*) title
{
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor= [UIColor whiteColor];
    button.layer.cornerRadius=23;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}



- (IBAction)toggleClickCM {
     [self.sheet toggle];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"failed to camera"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    }
}
- (IBAction)toggleClickPT {
     [self.sheet toggle];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:imagePicker animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"failed to access photo library"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        
    }
}
- (IBAction)toggle {
    [self.sheet toggle];
 
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pickFromCameraButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"failed to camera"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
       
    }
}

-(IBAction)pickFromLibraryButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:imagePicker animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"failed to access photo library"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
      
    }
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// Use facepp SDK to detect faces
-(void) detectWithImage: (UIImage*) image {
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   
    FaceppResult *result = [[FaceppAPI detection] detectWithURL:nil orImageData:UIImageJPEGRepresentation(image, 0.5) mode:FaceppDetectionModeNormal attribute:FaceppDetectionAttributeNone];
    if (result.success) {
        double image_width = [[result content][@"img_width"] doubleValue] *0.01f;
        double image_height = [[result content][@"img_height"] doubleValue] * 0.01f;
        
        UIGraphicsBeginImageContext(image.size);
        [image drawAtPoint:CGPointZero];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 0, 0, 1.0, 1.0);
        CGContextSetLineWidth(context, image_width * 0.7f);
        
        // draw rectangle in the image
        int face_count = [[result content][@"face"] count];
//        for (int i=0; i<face_count; i++) {
//            double width = [[result content][@"face"][i][@"position"][@"width"] doubleValue];
//            double height = [[result content][@"face"][i][@"position"][@"height"] doubleValue];
//            CGRect rect = CGRectMake(([[result content][@"face"][i][@"position"][@"center"][@"x"] doubleValue] - width/2) * image_width,
//                                     ([[result content][@"face"][i][@"position"][@"center"][@"y"] doubleValue] - height/2) * image_height,
//                                     width * image_width,
//                                     height * image_height);
//            CGContextStrokeRect(context, rect);
//        }
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
//        float scale = 1.0f;
//        scale = MIN(scale, 280.0f/image.size.width);
//        scale = MIN(scale, 257.0f/image.size.height);
//        [imageView setFrame:CGRectMake(kSCREEN_WIDTH/2-image.size.width * scale/2,
//                                       kSCREEN_HEIGHT/2-image.size.height * scale/2,
//                                       image.size.width * scale,
//                                       image.size.height * scale)];
//        [imageView setImage:image];
        FaceppResult *resultcoompare=[[[FaceppRecognition alloc ] init] compareWithFaceId1:[result content][@"face"][0][@"face_id"]  andId2:[result content][@"face"][1][@"face_id"]  async:NO];
//        FaceppResult *resulu= [[[FaceppRecognition alloc] init] searchWithKeyFaceId:[result content][@"face"][0][@"face_id"] andFacesetId:nil orFacesetName:@"starlib3" andCount:nil async:NO];
        
    } else {
        // some errors occurred
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"error message: %@", [result error].message]
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
           }
   
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
   
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIImage *sourceImage = info[UIImagePickerControllerOriginalImage];
    

    UIImage *imageToDisplay = [self fixOrientation:sourceImage];
    float scale = 1.0f;
    scale = MIN(scale, (kSCREEN_WIDTH-40)/imageToDisplay.size.width);
    scale = MIN(scale, (kSCREEN_HEIGHT/3*2)/imageToDisplay.size.height);
    
//    [imageView setImage:sourceImage];
    // perform detection in background thread
        [picker dismissModalViewControllerAnimated:YES];
    if (imageView==nil) {
        imageView=[[UIImageView alloc] initWithImage:imageToDisplay];
        [imageView setFrame:CGRectMake(kSCREEN_WIDTH/2-imageToDisplay.size.width * scale/2,
                                       kSCREEN_HEIGHT/2-imageToDisplay.size.height * scale/2,
                                       imageToDisplay.size.width * scale,
                                       imageToDisplay.size.height * scale)];
        imageView.userInteractionEnabled=true;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)]];
        [self.view addSubview:imageView];
    }else
    {
        float scale = 1.0f;
        scale = MIN(scale, (kSCREEN_WIDTH-40)/imageToDisplay.size.width);
        scale = MIN(scale, (kSCREEN_HEIGHT/3*2)/imageToDisplay.size.height);
        scale=scale/2;

        imageViewSecond=[[UIImageView alloc] initWithImage:imageToDisplay];
        [imageViewSecond setFrame:CGRectMake(kSCREEN_WIDTH,
                                       kSCREEN_HEIGHT/2-imageToDisplay.size.height * scale/2,
                                       imageToDisplay.size.width * scale,
                                       imageToDisplay.size.height * scale)];
        imageViewSecond.userInteractionEnabled=true;
        [imageViewSecond addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)]];
        [self.view addSubview:imageViewSecond];
       [self performSelector:@selector(addphoto) withObject:nil afterDelay:0.1f];
    }
//     [self performSelectorInBackground:@selector(detectWithImage:) withObject:imageToDisplay ];

}
-(void)initall
{
    
}
-(void)addphoto
{
    [UIView animateWithDuration:1 animations:^{
        CGRect rect=imageView.frame;
        rect.size.height=rect.size.height/2;
        rect.size.width=rect.size.width/2;
        rect.origin.y=kSCREEN_HEIGHT/2-rect.size.height/2;
        imageView.frame=rect;
        CGRect rectsecond=imageViewSecond.frame;
        rectsecond.origin.x=kSCREEN_WIDTH/2;
        imageViewSecond.frame=rectsecond;
        //            [self.view addSubview:imageViewSecond];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}


@end
