//
//  ImagePIcker.swift
//  CYFP
//
//  Created by xiaomo on 16/2/23.
//  Copyright © 2016年 umoney. All rights reserved.
//

import UIKit

import Photos
import ImagePickerSheetController
class XMImagePIcker: NSObject , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var completeHandler:(UIImage)->() = {_ in }
    func presentImagePickerSheet(viewController: UIViewController,completeHandler: (image:UIImage)->Void) {
        
       self.completeHandler = completeHandler
        let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
            let controller = UIImagePickerController()
            controller.delegate = self
            var sourceType = source
            if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                sourceType = .PhotoLibrary
                print("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
            }
            controller.sourceType = sourceType
            controller.allowsEditing=true
            viewController.presentViewController(controller, animated: true, completion: nil)
        }
        
        let controller = ImagePickerSheetController(mediaType: .Image)
        controller.maximumSelection=1
        controller.addAction(ImagePickerAction(title: NSLocalizedString("拍照", comment: "Action Title"), secondaryTitle: NSLocalizedString("使用", comment: "Action Title"), handler: { _ in
            presentImagePickerController(.Camera)
            }, secondaryHandler: { photo, numberOfPhotos in
                self.afterSelected(controller.selectedImageAssets)
        }))
        controller.addAction(ImagePickerAction(title: NSLocalizedString("相册", comment: "Action Title"), secondaryTitle:"", handler: { _ in
            presentImagePickerController(.PhotoLibrary)
            }, secondaryHandler: { _, numberOfPhotos in
                self.afterSelected(controller.selectedImageAssets)
                print("Send \(controller.selectedImageAssets)")
        }))
        controller.addAction(ImagePickerAction(title: NSLocalizedString("取消", comment: "Action Title"), style: .Cancel, handler: { _ in
            print("Cancelled")
        }))
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            controller.modalPresentationStyle = .Popover
            controller.popoverPresentationController?.sourceView = viewController.view
            controller.popoverPresentationController?.sourceRect = CGRect(origin: viewController.view.center, size: CGSize())
        }
        
        viewController.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func afterSelected( photos: [PHAsset]){
        if  photos.count < 1
        {return}
        
        PHCachingImageManager().requestImageForAsset(photos[0], targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (img, info) -> Void in
            if img ==  nil{
                return
            }
            let   info1 = info!
            let downloadFinined = !(info1[PHImageCancelledKey]?.boolValue == true ) && !(info1[PHImageErrorKey] != nil) && !(info1[PHImageResultIsDegradedKey]?.boolValue == true)
            if(downloadFinined){
                  self.loadt(img!)
            }
        }
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        viewController.dismissViewControllerAnimated(true, completion: nil)// 加
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker.dismissViewControllerAnimated(true, completion: nil)
        //        info[""]
        
        //        let data = UIImagePNGRepresentation(info["UIImagePickerControllerOriginalImage"] as! UIImage,0.2)
        if (info["UIImagePickerControllerEditedImage"] == nil)
        {
            return
        }
        loadt(info["UIImagePickerControllerEditedImage"] as! UIImage)
    }
    func loadt( image:UIImage){
            completeHandler(image)
    }
}
