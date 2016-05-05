//
//  GlobalVariables.swift
//  IAMStar
//
//  Created by xiaomo on 16/1/19.
//  Copyright © 2016年 xiaomo. All rights reserved.
//

import UIKit

class GlobalVariables: NSObject {
    class func getFaceApiPicByName(name :String)->(url: String,name: String){
        let temp = name as NSString
        
        let names = temp.componentsSeparatedByString("|")
        if names.count < 2
            
        {return ("http://www.faceplusplus.com.cn/assets/","")}
        return ("http://www.faceplusplus.com.cn/assets/demo-img2/\(names[1])/\(names[0])".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!,names[1])
    }
}
