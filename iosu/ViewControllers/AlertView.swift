//
//  AlertView.swift
//  iosu
//
//  Created by xieyi on 2017/4/5.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation
import UIKit

class Alerts {
    
    static func show(_ sender:UIViewController,title:String,message:String,style:UIAlertControllerStyle,actiontitle:String,actionstyle:UIAlertActionStyle,handler:((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action=UIAlertAction(title: actiontitle, style: actionstyle, handler: handler)
        alertController.addAction(action)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    static func show(_ sender:UIViewController,title:String,message:String,style:UIAlertControllerStyle,action1title:String,action1style:UIAlertActionStyle,handler1:((UIAlertAction) -> Void)?,action2title:String,action2style:UIAlertActionStyle,handler2:((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action1=UIAlertAction(title: action1title, style: action1style, handler: handler1)
        let action2=UIAlertAction(title: action2title, style: action2style, handler: handler2)
        alertController.addAction(action1)
        alertController.addAction(action2)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    static func create(_ title:String,message:String,style:UIAlertControllerStyle,actiontitle:String,actionstyle:UIAlertActionStyle,handler:((UIAlertAction) -> Void)?) -> UIAlertController!{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action=UIAlertAction(title: actiontitle, style: actionstyle, handler: handler)
        alertController.addAction(action)
        //debugPrint("alert created,\(alertController)")
        return alertController
    }
    
    static func create(_ title:String,message:String,style:UIAlertControllerStyle,action1title:String,action1style:UIAlertActionStyle,handler1:((UIAlertAction) -> Void)?,action2title:String,action2style:UIAlertActionStyle,handler2:((UIAlertAction) -> Void)?) -> UIAlertController!{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action1=UIAlertAction(title: action1title, style: action1style, handler: handler1)
        let action2=UIAlertAction(title: action2title, style: action2style, handler: handler2)
        alertController.addAction(action1)
        alertController.addAction(action2)
        //debugPrint("alert created,\(alertController)")
        return alertController
    }
    
}
