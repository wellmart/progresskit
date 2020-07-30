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
    private weak var titleLabel: UILabel!
    private weak var valueLabel: UILabel!
    
    public var title: String? {
        get {
            return titleLabel?.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    public var value: Double {
        get {
            return Double(valueLayer.strokeEnd)
        }
        set {
            valueLayer.strokeEnd = CGFloat(newValue)
            valueLabel.text = "\(Int(newValue * 100))%"
        }
    }
    
    public override func loadView() {
        guard let appearance = UIProgress.appearance else {
            preconditionFailure("The appearance was not specified")
        }
        
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        
        shadowLayer = addSublayer(CAShapeLayer.self) {
            $0.fillColor = UIColor.clear.cgColor
            $0.lineCap = .square
            $0.lineWidth = appearance.progressCircularWidth / 3
            $0.strokeColor = appearance.progressSecondaryColor.cgColor
        }
        
        valueLayer = addSublayer(CAShapeLayer.self) {
            $0.fillColor = UIColor.clear.cgColor
            $0.lineCap = .square
            $0.lineWidth = appearance.progressCircularWidth
            $0.strokeEnd = 0
            $0.strokeColor = appearance.progressPrimaryColor.cgColor
        }
        
        valueLabel = addSubview(UILabel.self) {
            $0.anchor(centerX: 0)
            $0.anchor(centerY: -appearance.progressCircularSpacing)
        }
        
        titleLabel = addSubview(UILabel.self) {
            $0.anchor(centerX: 0)
            $0.anchor(centerY: appearance.progressCircularSpacing)
            
            $0.font = appearance.progressCircularTitleFont
        }
        
        if !UIApplication.shared.leftToRightLayoutDirection {
            valueLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
            titleLabel.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let appearance = UIProgress.appearance else {
            preconditionFailure("The appearance was not specified")
        }
        
        let path = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
                                radius: (min(frame.width, frame.height) - appearance.progressCircularWidth) / 2,
                                startAngle: -CGFloat.pi / 2,
                                endAngle: CGFloat.pi * 1.5,
                                clockwise: true)
        
        path.lineJoinStyle = .round
        
        shadowLayer.path = path.cgPath
        valueLayer.path = path.cgPath
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        guard let appearance = UIProgress.appearance else {
            preconditionFailure("The appearance was not specified")
        }
        
        shadowLayer.strokeColor = appearance.progressSecondaryColor.cgColor
        valueLayer.strokeColor = appearance.progressPrimaryColor.cgColor
    }
}
