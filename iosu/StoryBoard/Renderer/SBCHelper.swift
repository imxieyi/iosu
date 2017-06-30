//
//  SBCHelper.swift
//  iosu
//
//  Created by xieyi on 2017/5/16.
//  Copyright © 2017年 xieyi. All rights reserved.
//

import Foundation

class SBCHelper {
    
    static func str2cmdtype(_ string:String) -> StoryBoardCommand {
        var str=string
        while str.hasPrefix(" ") || str.hasPrefix("_") {
            str=(str as NSString).substring(from: 1)
        }
        switch str {
        case "F":return StoryBoardCommand.fade
        case "M":return StoryBoardCommand.move
        case "MX":return StoryBoardCommand.moveX
        case "MY":return StoryBoardCommand.moveY
        case "S":return StoryBoardCommand.scale
        case "V":return StoryBoardCommand.vScale
        case "R":return StoryBoardCommand.rotate
        case "C":return StoryBoardCommand.color
        case "P":return StoryBoardCommand.parameter
        case "L":return StoryBoardCommand.loop
        case "T":return StoryBoardCommand.trigger
        default:return StoryBoardCommand.unknown
        }
    }
    
    static func num2easing(_ num:Int) -> Easing {
        switch num {
        case 0:return Easing(function: .curveTypeLinear, type: .easeTypeIn)
        case 1:return Easing(function: .curveTypeSine, type: .easeTypeOut)
        case 2:return Easing(function: .curveTypeSine, type: .easeTypeIn)
        case 3:return Easing(function: .curveTypeQuadratic, type: .easeTypeIn)
        case 4:return Easing(function: .curveTypeQuadratic, type: .easeTypeOut)
        case 5:return Easing(function: .curveTypeQuadratic, type: .easeTypeInOut)
        case 6:return Easing(function: .curveTypeCubic, type: .easeTypeIn)
        case 7:return Easing(function: .curveTypeCubic, type: .easeTypeOut)
        case 8:return Easing(function: .curveTypeCubic, type: .easeTypeInOut)
        case 9:return Easing(function: .curveTypeQuartic, type: .easeTypeIn)
        case 10:return Easing(function: .curveTypeQuartic, type: .easeTypeOut)
        case 11:return Easing(function: .curveTypeQuartic, type: .easeTypeInOut)
        case 12:return Easing(function: .curveTypeQuintic, type: .easeTypeIn)
        case 13:return Easing(function: .curveTypeQuintic, type: .easeTypeOut)
        case 14:return Easing(function: .curveTypeQuintic, type: .easeTypeInOut)
        case 15:return Easing(function: .curveTypeSine, type: .easeTypeIn)
        case 16:return Easing(function: .curveTypeSine, type: .easeTypeOut)
        case 17:return Easing(function: .curveTypeSine, type: .easeTypeInOut)
        case 18:return Easing(function: .curveTypeExpo, type: .easeTypeIn)
        case 19:return Easing(function: .curveTypeExpo, type: .easeTypeOut)
        case 20:return Easing(function: .curveTypeExpo, type: .easeTypeInOut)
        case 21:return Easing(function: .curveTypeCircular, type: .easeTypeIn)
        case 22:return Easing(function: .curveTypeCircular, type: .easeTypeOut)
        case 23:return Easing(function: .curveTypeCircular, type: .easeTypeInOut)
        case 24:return Easing(function: .curveTypeElastic, type: .easeTypeIn)
        case 25:return Easing(function: .curveTypeElastic, type: .easeTypeOut)
        //ElasticHalf Out, function modified from plain elastic
        case 26:return Easing(function: .curveTypeElasticHalf, type: .easeTypeOut)
        //ElasticQuarter Out, function modified from plain elastic
        case 27:return Easing(function: .curveTypeElasticQuarter, type: .easeTypeOut)
        case 28:return Easing(function: .curveTypeElastic, type: .easeTypeInOut)
        case 29:return Easing(function: .curveTypeBack, type: .easeTypeIn)
        case 30:return Easing(function: .curveTypeBack, type: .easeTypeOut)
        case 31:return Easing(function: .curveTypeBack, type: .easeTypeInOut)
        case 32:return Easing(function: .curveTypeBounce, type: .easeTypeIn)
        case 33:return Easing(function: .curveTypeBounce, type: .easeTypeOut)
        case 34:return Easing(function: .curveTypeBounce, type: .easeTypeInOut)
        default:return Easing(function: .curveTypeLinear, type: .easeTypeIn)
        }
    }
    
}
