//
//  ProgressKit
//
//  Copyright (c) 2020 Wellington Marthas
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import CodeLayout

public final class UIProgressCircular: UILoadableView {
    private weak var shadowLayer: CAShapeLayer!
    private weak var valueLayer: CAShapeLayer!
    private weak var valueLabel: UILabel!
    
    public var value: Double {
        get {
            return Double(valueLayer.strokeEnd)
        }
        set {
            valueLayer.strokeEnd = CGFloat(newValue)
            valueLabel.text = "\(Int(newValue * 100))%"
        }
    }
    
    private var lineWidth: CGFloat {
        return UIProgress.appearance?.progressCircularLineWidth ?? 0
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let startAngle = -CGFloat.pi / 2
        let endAngle = CGFloat.pi * 1.5
        
        shadowLayer.path = UIBezierPath(arcCenter: center,
                                        radius: (frame.width - lineWidth) / 2,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true).cgPath
        
        valueLayer.path = UIBezierPath(arcCenter: center,
                                       radius: (frame.width - (lineWidth * 2)) / 2,
                                       startAngle: startAngle,
                                       endAngle: endAngle,
                                       clockwise: true).cgPath
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let appearance = UIProgress.appearance
        
        shadowLayer.strokeColor = appearance?.progressSecondaryColor.cgColor
        valueLayer.strokeColor = appearance?.progressPrimaryColor.cgColor
    }
    
    public override func loadView() {
        let appearance = UIProgress.appearance
        
        shadowLayer = addSublayer(CAShapeLayer.self) {
            $0.fillColor = UIColor.clear.cgColor
            $0.lineCap = .square
            $0.lineWidth = lineWidth
            $0.strokeColor = appearance?.progressSecondaryColor.cgColor
        }
        
        valueLayer = addSublayer(CAShapeLayer.self) {
            $0.fillColor = UIColor.clear.cgColor
            $0.lineCap = .square
            $0.lineWidth = lineWidth
            $0.strokeEnd = 0
            $0.strokeColor = appearance?.progressPrimaryColor.cgColor
        }
        
        valueLabel = addSubview(UILabel.self) {
            $0.anchor(centerX: 0)
            $0.anchor(centerY: 0)
        }
    }
}
