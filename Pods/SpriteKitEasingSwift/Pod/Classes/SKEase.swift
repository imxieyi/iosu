//
//  SKEase.swift
//
//  Created by CraigGrummitt on 6/08/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//
//  Based on SpriteKit_Easing.m
//  SpriteKit-Easing
//
//  Created by Andrew Eiche on 10/20/13.
//  Copyright (c) 2013 Birdcage Games LLC. All rights reserved.
//
import Foundation
import UIKit
import SpriteKit

open class SKEase {
    /**
     Get an easing function with a curve and ease type.
     - parameter curve: Curve type
     - parameter easeType: Ease type
     */
    open class func getEaseFunction(_ curve:CurveType, easeType:EaseType)->AHEasingFunction {
        var currentFunction:AHEasingFunction
        switch(curve) {
        case .curveTypeLinear:
            currentFunction=LinearInterpolation
        case .curveTypeQuadratic:
            if (easeType == EaseType.easeTypeIn) {print("YES")}
            currentFunction = (easeType == .easeTypeIn) ? QuadraticEaseIn : (easeType == .easeTypeOut) ? QuadraticEaseOut : QuadraticEaseInOut;
        case .curveTypeCubic:
            currentFunction = (easeType == .easeTypeIn) ? CubicEaseIn : (easeType == .easeTypeOut) ? CubicEaseOut : CubicEaseInOut;
        case .curveTypeQuartic:
            currentFunction = (easeType == .easeTypeIn) ? QuarticEaseIn : (easeType == .easeTypeOut) ? QuarticEaseOut : QuarticEaseInOut;
        case .curveTypeQuintic:
            currentFunction = (easeType == .easeTypeIn) ? QuinticEaseIn : (easeType == .easeTypeOut) ? QuinticEaseOut : QuinticEaseInOut;
        case .curveTypeSine:
            currentFunction = (easeType == .easeTypeIn) ? SineEaseIn : (easeType == .easeTypeOut) ? SineEaseOut : SineEaseInOut;
        case .curveTypeCircular:
            currentFunction = (easeType == .easeTypeIn) ? CircularEaseIn : (easeType == .easeTypeOut) ? CircularEaseOut : CircularEaseInOut;
        case .curveTypeExpo:
            currentFunction = (easeType == .easeTypeIn) ? ExponentialEaseIn : (easeType == .easeTypeOut) ? ExponentialEaseOut : ExponentialEaseInOut;
        case .curveTypeElastic:
            currentFunction = (easeType == .easeTypeIn) ? ElasticEaseIn : (easeType == .easeTypeOut) ? ElasticEaseOut : ElasticEaseInOut;
        //Only parse thouse osu storyboard needs
        case .curveTypeElasticHalf:
            currentFunction = (easeType == .easeTypeIn) ? ElasticEaseIn : (easeType == .easeTypeOut) ? ElasticHalfEaseOut : ElasticEaseInOut;
        case .curveTypeElasticQuarter:
            currentFunction = (easeType == .easeTypeIn) ? ElasticEaseIn : (easeType == .easeTypeOut) ? ElasticQuarterEaseOut : ElasticEaseInOut;
        case .curveTypeBack:
            currentFunction = (easeType == .easeTypeIn) ? BackEaseIn : (easeType == .easeTypeOut) ? BackEaseOut : BackEaseInOut;
        case .curveTypeBounce:
            currentFunction = (easeType == .easeTypeIn) ? BounceEaseIn : (easeType == .easeTypeOut) ? BounceEaseOut : BounceEaseInOut;
        }
        return currentFunction
    }
    /**
     Create a tween between two points.
     - parameter start: Start point
     - parameter end: End point
     - parameter time: duration of tween
     - parameter easingFunction: ease function - create an ease function with the getEaseFunction method.
     - parameter setterBlock: Any additional properties to tween.
     */
    open class func createPointTween(_ start:CGPoint, end:CGPoint, time:TimeInterval,easingFunction:@escaping AHEasingFunction, setterBlock setter:@escaping ((SKNode,CGPoint)->Void))->SKAction {
        let action:SKAction = SKAction.customAction(withDuration: time, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            let timeEq = easingFunction(Float(elapsedTime)/Float(time))
            let xValue:CGFloat = start.x + CGFloat(timeEq) * (end.x - start.x)
            let yValue:CGFloat = start.y + CGFloat(timeEq) * (end.y - start.y)
            setter(node,CGPoint(x: xValue, y: yValue))
        })
        return action
    }
    /**
     Create a tween between two values.
     - parameter start: Start value
     - parameter end: End value
     - parameter time: duration of tween
     - parameter easingFunction: ease function - create an ease function with the getEaseFunction method.
     - parameter setterBlock: Any additional properties to tween.
     */
    open class func createFloatTween(_ start:CGFloat, end:CGFloat, time:TimeInterval,easingFunction:@escaping AHEasingFunction, setterBlock setter:@escaping ((SKNode,CGFloat)->Void))->SKAction {
        let action:SKAction = SKAction.customAction(withDuration: time, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            let timeEq = easingFunction(Float(elapsedTime)/Float(time))
            let value:CGFloat = start+CGFloat(timeEq) * (end-start)
            setter(node,value)
        })
        return action
    }
    /**
     Create a tween for flip horizontally.
     - parameter time: duration of tween
     - parameter easingFunction: ease function - create an ease function with the getEaseFunction method.
     - parameter setterBlock: Any additional properties to tween.
     */
    open class func createHFlipTween(_ time:TimeInterval,easingFunction:@escaping AHEasingFunction, setterBlock setter:@escaping ((SKNode,CGFloat)->Void))->SKAction {
        var firstcall=true
        var oriscale:CGFloat=0
        let action:SKAction = SKAction.customAction(withDuration: time, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            if firstcall {
                oriscale=node.xScale
                firstcall=false
            }
            let timeEq = easingFunction(Float(elapsedTime)/Float(time))
            let value:CGFloat = oriscale+CGFloat(timeEq) * (-2*oriscale)
            setter(node,value)
        })
        return action
    }
    /**
     Create a tween for flip vertically.
     - parameter time: duration of tween
     - parameter easingFunction: ease function - create an ease function with the getEaseFunction method.
     - parameter setterBlock: Any additional properties to tween.
     */
    open class func createVFlipTween(_ time:TimeInterval,easingFunction:@escaping AHEasingFunction, setterBlock setter:@escaping ((SKNode,CGFloat)->Void))->SKAction {
        var firstcall=true
        var oriscale:CGFloat=0
        let action:SKAction = SKAction.customAction(withDuration: time, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            if firstcall {
                oriscale=node.yScale
                firstcall=false
            }
            let timeEq = easingFunction(Float(elapsedTime)/Float(time))
            let value:CGFloat = oriscale+CGFloat(timeEq) * (-2*oriscale)
            setter(node,value)
        })
        return action
    }
    /**
     Create a tween between two colors.
     - parameter rstart: Start r
     - parameter gstart: Start g
     - parameter bstart: Start b
     - parameter rend: End r
     - parameter gend: End g
     - parameter bend: End b
     - parameter time: duration of tween
     - parameter easingFunction: ease function - create an ease function with the getEaseFunction method.
     - parameter setterBlock: Any additional properties to tween.
     */
    open class func createColorTween(_ rstart:CGFloat,gstart:CGFloat,bstart:CGFloat, rend:CGFloat, gend:CGFloat, bend:CGFloat, time:TimeInterval,easingFunction:@escaping AHEasingFunction, setterBlock setter:@escaping ((SKNode,CGFloat,CGFloat,CGFloat)->Void))->SKAction {
        let action:SKAction = SKAction.customAction(withDuration: time, actionBlock: { (node:SKNode, elapsedTime:CGFloat) -> Void in
            let timeEq = easingFunction(Float(elapsedTime)/Float(time))
            let rvalue:CGFloat = rstart+CGFloat(timeEq) * (rend-rstart)
            let gvalue:CGFloat = gstart+CGFloat(timeEq) * (gend-gstart)
            let bvalue:CGFloat = bstart+CGFloat(timeEq) * (bend-bstart)
            setter(node,rvalue,gvalue,bvalue)
        })
        return action
    }
    
    //MARK: Move
    /**
    Animate x/y movement
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial point
     - parameter to: destination point
    */
    open class func move(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGPoint, to:CGPoint)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createPointTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, point:CGPoint) -> Void in
            node.position = point
        }
        return action
    }
    ///legacy
    open class func moveToWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, to:CGPoint)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let startPosition = target.position
        let action = self.createPointTween(CGPoint(x: startPosition.x,y: startPosition.y), end: to, time: time, easingFunction: easingFunction) { (node:SKNode, point:CGPoint) -> Void in
            node.position = point
        }
        return action
    }
    ///legacy
    open class func moveFromWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGPoint)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let startPosition = target.position
        let action = self.createPointTween(from, end: CGPoint(x: startPosition.x,y: startPosition.y), time: time, easingFunction: easingFunction) { (node:SKNode, point:CGPoint) -> Void in
            node.position = point
        }
        return action
    }
    
    //MARK: MoveX
    /**
     Animate x movement
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial point
     - parameter to: destination point
     */
    open class func moveX(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGFloat, to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: to, time: time, easingFunction: easingFunction, setterBlock: { (node:SKNode, value:CGFloat)->Void in
            node.position.x=value
        })
        return action
    }
    
    //MARK: MoveY
    /**
     Animate y movement
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial point
     - parameter to: destination point
     */
    open class func moveY(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGFloat, to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: to, time: time, easingFunction: easingFunction, setterBlock: { (node:SKNode, value:CGFloat)->Void in
            node.position.y=value
        })
        return action
    }
    
    //MARK: Scale
    /**
     Animate scale
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial scale
     - parameter to: destination scale
     */
    open class func scale(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGFloat, to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.setScale(scale)
        }
        return action
    }
    ///legacy
    open class func scaleToWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, toValue to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(target.xScale, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.setScale(scale)
        }
        return action
    }
    open class func scaleFromWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, fromValue from:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: target.xScale, time: time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.setScale(scale)
        }
        return action
    }
    
    //MARK: VScale
    /**
     Animate scale
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter xfrom: initial x scale
     - parameter yfrom: initial y scale
     - parameter xto: destination x scale
     - parameter yto: destination y scale
     */
    open class func vscale(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, xfrom:CGFloat, yfrom:CGFloat, xto:CGFloat, yto:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let xaction = self.createFloatTween(xfrom, end: xto, time: time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.xScale = scale
        }
        let yaction = self.createFloatTween(yfrom, end: yto, time: time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.yScale = scale
        }
        let action=SKAction.group([xaction,yaction])
        return action
    }
    
    //MARK: Flip horizontally
    /**
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     */
    open class func hflip(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createHFlipTween(time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.xScale = scale
        }
        return action
    }
    
    //MARK: Flip vertically
    /**
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     */
    open class func vflip(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createVFlipTween(time, easingFunction: easingFunction) { (node:SKNode, scale:CGFloat) -> Void in
            node.yScale = scale
        }
        return action
    }
    
    //MARK: Rotate
    /**
     Animate z rotation
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial z rotation
     - parameter to: destination z rotation
     */
    open class func rotate(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, from:CGFloat, to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, rotation:CGFloat) -> Void in
            node.zRotation=rotation
        }
        return action
    }
    ///legacy
    open class func rotateToWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, toValue to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(target.zRotation, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, rotation:CGFloat) -> Void in
            node.zRotation=rotation
        }
        return action
    }
    open class func rotateFromWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, fromValue from:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: target.zRotation, time: time, easingFunction: easingFunction) { (node:SKNode, rotation:CGFloat) -> Void in
            node.zRotation=rotation
        }
        return action
    }
    
    
    //MARK: Fade
    /**
     Animate alpha
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter from: initial alpha
     - parameter to: destination alpha
     */
    open class func fade(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, fromValue from:CGFloat, toValue to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, alpha:CGFloat) -> Void in
            node.alpha=alpha
        }
        return action
    }
    ///legacy
    open class func fadeToWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, toValue to:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(target.alpha, end: to, time: time, easingFunction: easingFunction) { (node:SKNode, alpha:CGFloat) -> Void in
            node.alpha=alpha
        }
        return action
    }
    ///legacy
    open class func fadeFromWithNode(_ target:SKNode, easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, fromValue from:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createFloatTween(from, end: target.alpha, time: time, easingFunction: easingFunction) { (node:SKNode, alpha:CGFloat) -> Void in
            node.alpha=alpha
        }
        return action
    }
    
    
    //MARK: color
    /**
     Animate color
     - parameter easeFunction: Curve type
     - parameter easeType: Ease type
     - parameter time: duration of tween
     - parameter rfrom: initial r
     - parameter gfrom: initial g
     - parameter bfrom: initial b
     - parameter rto: destination r
     - parameter gto: destination g
     - parameter bto: destination b
     */
    open class func color(easeFunction curve:CurveType, easeType:EaseType, time:TimeInterval, rfrom:CGFloat, gfrom:CGFloat, bfrom:CGFloat, rto:CGFloat, gto:CGFloat, bto:CGFloat)->SKAction {
        let easingFunction = SKEase.getEaseFunction(curve, easeType: easeType)
        let action = self.createColorTween(rfrom, gstart: gfrom, bstart: bfrom, rend: rto, gend: gto, bend: bto, time: time, easingFunction: easingFunction) { (node:SKNode, rvalue:CGFloat, gvalue:CGFloat, bvalue:CGFloat) -> Void in
            //let fromcolor=(node as! SKSpriteNode).color
            let tocolor=UIColor(red: rvalue, green: gvalue, blue: bvalue, alpha: 1)
            node.run(SKAction.colorize(with: tocolor, colorBlendFactor: 1, duration: 0))
        }
        return action
    }
}
