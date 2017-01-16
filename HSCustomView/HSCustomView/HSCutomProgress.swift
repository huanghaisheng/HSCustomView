//
//  HSCutomProgress.swift
//  HSCustomView
//
//  Created by haisheng huang on 2017/1/4.
//  Copyright © 2017年 haisheng huang. All rights reserved.
//

import Foundation
import UIKit
import CoreFoundation

//MARK:渐变效果的方向
enum GradientChangeDirection {

    case right
    case left
    case bottom
    case top
    case topLeftToBottomRight
    case topRightToBottomLeft
    case bottomLeftToTopRight
    case bottomRightToTopLeft
    
}

public class HSCustomProgress: UIView {
    
    //MARK:进度条百分比，默认为0.0
    var value: CGFloat = 0.0
    
    //MARK:渐变的深色，默认为黑色
    var deepColor: UIColor = UIColor.black
    
    //MARK:渐变的浅色，默认为白色
    var lightColor: UIColor = UIColor.white
    
    //GradientChangeDirection default direction is right
    var direction: GradientChangeDirection = GradientChangeDirection.right
    
    //MARK:是否是圆角，默认是true
    var isCornerRadius: Bool = true
    
    //MARK:是否动态加载，默认是false
    var isAnimated: Bool = false
    
    //MARK:渐变的Layer
    var gradientLayer: CAGradientLayer?
    
    //MARK:渐变的view，由于caanimation的frame实现不了动画，所以采用了UIView的Animation
    var gradientView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(frame: CGRect, deepColor: UIColor?, lightColor: UIColor?, backgroundColor: UIColor?, value: CGFloat, isCornerRadius: Bool, direction: GradientChangeDirection?, isAnimated: Bool?, duration: TimeInterval?) {
        
        self.init(frame: frame)
        
        self.value = value
        
        if deepColor != nil {
            self.deepColor = deepColor!
        }
        
        if lightColor != nil {
            self.lightColor = lightColor!
        }
        
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor
        }
        
        if isCornerRadius == false {
            self.isCornerRadius = false
        } else {
            self.layer.cornerRadius = self.frame.height / 2.0
        }
        
        if direction != nil {
            self.direction = direction!
        }
        
        if isAnimated == true {
            self.isAnimated = true
            if duration != nil {
                self.addAnimation(duration: duration!)
            } else {
                self.addAnimation(duration: 2.5)
            }
        }
    }
    
    class func create(at superView: UIView, frame: CGRect, deepColor: UIColor?, lightColor: UIColor?, backgroundColor: UIColor?, value: CGFloat, isCornerRadius: Bool, direction: GradientChangeDirection?, isAnimated: Bool?, duration: TimeInterval) -> Void {
        
        let progress: HSCustomProgress = HSCustomProgress.init(frame: frame, deepColor: deepColor, lightColor: lightColor, backgroundColor: backgroundColor, value: value, isCornerRadius: isCornerRadius, direction: direction, isAnimated: isAnimated, duration: duration)
        superView.addSubview(progress)
        
    }
    
    private func createGradientLayer() -> Void {
        
        if self.value < 1.0 && self.value > 0.0 {
            self.getDeepColor(deepColor: self.deepColor, lightColor: self.lightColor, value: self.value)
        }
        
        let gradientColors: [CGColor] = [self.lightColor.cgColor, self.deepColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect.init(x: 0.0, y: 0.0, width: self.frame.width * self.value, height: self.frame.height)
        gradientLayer.colors = gradientColors
        self.setChangeDirection(gradientLayer: gradientLayer, direction: self.direction)
        if self.isCornerRadius == true {
            gradientLayer.cornerRadius = self.frame.height / 2.0
        }
        self.gradientLayer = gradientLayer

    }
    
    private func createGradientView() -> Void {
        
        self.createGradientLayer()
        
        let view: UIView = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = true        //TODO: 有可能需要优化，否则多个使用后有可能会出现离屏渲染影响性能效果
        view.layer.cornerRadius = self.frame.height / 2.0
        view.frame = CGRect.init(x: 0.0, y: 0.0, width: 0.0, height: self.frame.height)
        self.addSubview(view)
        view.layer.addSublayer(self.gradientLayer!)
        self.gradientView = view
        
    }
    
    private func getDeepColor(deepColor: UIColor, lightColor: UIColor, value: CGFloat) -> Void {
        
        let deepColorComponents: [CGFloat] = deepColor.cgColor.components!
        let lightColorComponents: [CGFloat] = lightColor.cgColor.components!
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        if deepColorComponents[0] == 1.0 && deepColorComponents[0] == lightColorComponents[0] {
            red = 1.0
        } else if deepColorComponents[0] > lightColorComponents[0] {
            red = lightColorComponents[0] + (deepColorComponents[0] - lightColorComponents[0]) * value
        } else if deepColorComponents[0] < lightColorComponents[0] {
            red = lightColorComponents[0] - (lightColorComponents[0] - deepColorComponents[0]) * value
        }
        
        if deepColorComponents[1] == 1.0 && deepColorComponents[1] == lightColorComponents[1] {
            green = 1.0
        } else if deepColorComponents[1] > lightColorComponents[1] {
            green = lightColorComponents[1] + (deepColorComponents[1] - lightColorComponents[1]) * value
        } else if deepColorComponents[1] < lightColorComponents[1] {
            green = lightColorComponents[1] - (lightColorComponents[1] - deepColorComponents[1]) * value
        }
        
        if deepColorComponents[2] == 1.0 && deepColorComponents[2] == lightColorComponents[2] {
            blue = 1.0
        } else if deepColorComponents[2] > lightColorComponents[2] {
            blue = lightColorComponents[2] + (deepColorComponents[2] - lightColorComponents[2]) * value
        } else if deepColorComponents[2] < lightColorComponents[2] {
            blue = lightColorComponents[2] - (lightColorComponents[2] - deepColorComponents[2]) * value
        }
        
        self.deepColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        
    }
    
    private func setChangeDirection(gradientLayer: CAGradientLayer, direction: GradientChangeDirection) -> Void {
        
        switch direction {
        case .right:
            gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        case .left:
            gradientLayer.startPoint = CGPoint.init(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint.init(x: 0.0, y: 0.5)
        case .bottom:
            gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1.0)
        case .top:
            gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 0.0)
        case .topLeftToBottomRight:
            gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 1.0)
        case .topRightToBottomLeft:
            gradientLayer.startPoint = CGPoint.init(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint.init(x: 0.0, y: 1.0)
        case .bottomLeftToTopRight:
            gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0.0)
        default:
            gradientLayer.startPoint = CGPoint.init(x: 1.0, y: 1.0)
            gradientLayer.endPoint = CGPoint.init(x: 0.0, y: 0.0)
        }
        
    }
    
    func addAnimation(duration: TimeInterval) -> Void {
        
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            self.gradientView?.frame.size.width = self.frame.width * self.value
            }, completion: { (finish) in
                
        })
    }
    
}




