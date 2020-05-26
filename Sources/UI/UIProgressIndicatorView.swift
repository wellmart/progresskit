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
import Adrenaline
import CodeLayout

public final class UIProgressIndicatorView: UILoadableView {
    public static var appearance: UIProgressIndicatorAppearance?
    
    public enum Value {
        case infinite
    }
    
    public var value: Value = .infinite {
        willSet {
            updateIndicator(newValue: newValue)
        }
    }
    
    private var duration: TimeInterval {
        return 0.85
    }
    
    private weak var indicatorView: UIView!
    
    private var initialFrame: CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: bounds.height)
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        DispatchQueue.main.async {
            self.infiniteLoop()
        }
    }
    
    public override func loadView() {
        let appearance = UIProgressIndicatorView.appearance
        backgroundColor = appearance?.progressIndicatorSecondaryColor
        
        indicatorView = addSubview(UIView(frame: initialFrame)) {
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.backgroundColor = appearance?.progressIndicatorPrimaryColor
        }
        
        resetIndicator()
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using: willEnterForeground)
    }
    
    private func resetIndicator() {
        indicatorView.layer.removeAllAnimations()
        indicatorView.frame = initialFrame
        indicatorView.layoutIfNeeded()
    }
    
    private func updateIndicator(newValue: Value) {
        switch newValue {
        case .infinite:
            if case .infinite = value {
                return
            }
            
            infiniteLoop()
        }
    }
    
    private func infiniteLoop() {
        guard window != nil, case .infinite = value else {
            return
        }
        
        let halfDuration = duration / 2
        
        let width = bounds.width
        let height = bounds.height
        
        resetIndicator()
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, animations: { [weak self] in
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: halfDuration, animations: {
                self?.indicatorView.frame = CGRect(x: 0, y: 0, width: width * 0.65, height: height)
            })
            
            UIView.addKeyframe(withRelativeStartTime: halfDuration, relativeDuration: halfDuration, animations: {
                self?.indicatorView.frame = CGRect(x: width, y: 0, width: width * 0.15, height: height)
            })
        }) { [weak self] completed in
            guard completed else {
                return
            }
            
            self?.infiniteLoop()
        }
    }
    
    private func willEnterForeground(notification: Notification) {
        DispatchQueue.main.async {
            self.infiniteLoop()
        }
    }
}
