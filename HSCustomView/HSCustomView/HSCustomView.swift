//
//  HSCustomView.swift
//  HSCustomView
//
//  Created by haisheng huang on 2017/1/6.
//  Copyright © 2017年 haisheng huang. All rights reserved.
//

import Foundation
import UIKit

public class HSCustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public class func createProgress(at superView: UIView, frame: CGRect, deepColor: UIColor?, lightColor: UIColor?, backgroundColor: UIColor?, value: CGFloat, isCornerRadius: Bool, direction: GradientChangeDirection?, isAnimated: Bool?, duration: TimeInterval) -> Void {
        
        let progress: HSCustomProgress = HSCustomProgress.init(frame: frame, deepColor: deepColor, lightColor: lightColor, backgroundColor: backgroundColor, value: value, isCornerRadius: isCornerRadius, direction: direction, isAnimated: isAnimated, duration: duration)
        
        superView.addSubview(progress)

    }

}

