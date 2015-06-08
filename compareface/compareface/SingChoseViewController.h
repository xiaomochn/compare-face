//
//  SingChoseViewController.h
//  compareface
//
//  Created by qiao on 15/6/5.
//  Copyright (c) 2015年 qiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceppAPI.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
@interface SingChoseViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    IBOutlet UIImageView *imageView;
    UIImageView *imageViewSecond;

    UIImagePickerController *imagePicker;
}

-(IBAction)pickFromCameraButtonPressed:(id)sender;
-(IBAction)pickFromLibraryButtonPressed:(id)sender;

-(void) detectWithImage: (UIImage*) image;
@end
