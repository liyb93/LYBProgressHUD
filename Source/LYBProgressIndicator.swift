//
//  LYBProgressIndicator.swift
//  LYBProgressHUD
//
//  Created by liyb on 2020/11/13.
//

import Cocoa

fileprivate let kAlphaWhenStopped: CGFloat = 0.15
fileprivate let kFadeMultiplier: CGFloat = 0.85
fileprivate let kNumberOfFins: Int = 12
fileprivate let kFadeOutTime: TimeInterval = 0.7

public class LYBProgressIndicator: NSView {
    
    public var color: NSColor = .black {
        didSet {
            for idx in 0..<kNumberOfFins {
                let alpha = alphaValue(for: idx)
                finColors[idx] = color.withAlphaComponent(alpha)
            }
            needsDisplay = true
        }
    }
    public var backgroundColor: NSColor? = .clear {
        didSet {
            needsDisplay = true
        }
    }
    public var isDrawsBackground: Bool = false {
        didSet {
            needsDisplay = true
        }
    }
    public var isDisplayedWhenStopped: Bool = true {
        didSet {
            if !isAnimating {
                isHidden = !isDisplayedWhenStopped
            }
        }
    }
    public var isUsesThreadedAnimation: Bool = true {
        didSet {
            if isAnimating {
                stopAnimation(self)
                startAnimation(self)
            }
        }
    }
    public var isIndeterminate: Bool = true {
        didSet {
            if !isIndeterminate && isAnimating {
                stopAnimation(self)
            }
            needsDisplay = true
        }
    }
    public var currentValue: CGFloat = 0.0 {
        didSet {
            if isIndeterminate {
                isIndeterminate = false
            }
            needsDisplay = true
        }
    }
    public var maxValue: CGFloat = 100.0 {
        didSet {
            needsDisplay = true
        }
    }
    
    private var currentPosition: Int = 0
    private var finColors: [NSColor] = Array.init(repeating: .clear, count: kNumberOfFins)
    private var isAnimating: Bool = false
    private var animationTimer: Timer?
    private var animationThread: Thread?
    private var isFadingOut: Bool = false
    private var fadeOutStartTime: Date?
    
    public override func draw(_ dirtyRect: NSRect) {
        let size = bounds.size
        let length = min(size.height, size.width)
        
        if isDrawsBackground {
            backgroundColor?.set()
            NSBezierPath.fill(bounds)
        }
        
        let context = NSGraphicsContext.current?.cgContext
        context?.translateBy(x: size.width/2.0, y: size.height/2.0)
        
        if isIndeterminate {
            let path = NSBezierPath.init()
            let lineWidth = 0.0859375 * length
            let lineStart = 0.234375 * length
            let lineEnd = 0.421875 * length
            path.lineWidth = lineWidth
            path.lineCapStyle = .round
            path.move(to: .init(x: 0, y: lineStart))
            path.line(to: .init(x: 0, y: lineEnd))
            
            for idx in 0..<kNumberOfFins {
                let c = isAnimating ? finColors[idx] : color.withAlphaComponent(kAlphaWhenStopped)
                c.set()
                path.stroke()
                context?.rotate(by: 2.0 * CGFloat.pi / CGFloat(kNumberOfFins))
            }
        } else {
            let lineWidth = 1 + (0.01 * length)
            let circleRadius = (length - lineWidth) / 2.1
            let circleCenter = NSPoint.init(x: 0, y: 0)
            color.set()
            var path = NSBezierPath.init()
            path.lineWidth = lineWidth
            path.appendOval(in: .init(x: -circleRadius, y: -circleRadius, width: circleRadius*2.0, height: circleRadius*2.0))
            path.stroke()
            path = NSBezierPath.init()
            path.appendArc(withCenter: circleCenter, radius: circleRadius, startAngle: 90, endAngle: 90-(360*(currentValue/maxValue)), clockwise: true)
            path.line(to: circleCenter)
            path.fill()
        }
    }
    
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        if let _ = window {
            actuallyStopAnimation()
        } else if isAnimating {
            actuallyStartAnimation()
        }
    }
    
    private func actuallyStartAnimation() {
        actuallyStopAnimation()
        isAnimating = true
        isFadingOut = false
        
        currentPosition = 0
        
        if !isDisplayedWhenStopped {
            isHidden = false
        }
        
        if let _ = window {
            if isUsesThreadedAnimation {
                animationThread = Thread.init(target: self, selector: #selector(animateInBackgroundThread), object: nil)
                animationThread?.start()
            } else {
                animationTimer = Timer.init(timeInterval: 0.05, target: self, selector: #selector(updateFrame(from:)), userInfo: nil, repeats: true)
                RunLoop.current.add(animationTimer!, forMode: .common)
                RunLoop.current.add(animationTimer!, forMode: .default)
                RunLoop.current.add(animationTimer!, forMode: .eventTracking)
            }
        }
    }
    
    private func actuallyStopAnimation() {
        isAnimating = false
        isFadingOut = false
        if !isDisplayedWhenStopped {
            isHidden = true
        }
        if let thread = animationThread {
            thread.cancel()
            if !thread.isFinished {
                RunLoop.current.run(mode: .modalPanel, before: Date.init(timeIntervalSinceNow: 0.05))
            }
            animationThread = nil
        } else if let timer = animationTimer {
            timer.invalidate()
            animationTimer = nil
        }
        DispatchQueue.main.async {
            self.needsDisplay = true
        }
    }
    
    private func alphaValue(for position: Int) -> CGFloat {
        var value = pow(kFadeMultiplier, CGFloat((position + currentPosition) % kNumberOfFins))
        if isFadingOut, let time = fadeOutStartTime {
            let timeSinceStop = -time.timeIntervalSinceNow
            value *= CGFloat(kFadeOutTime - timeSinceStop)
        }
        return value
    }
    
    @objc private func animateInBackgroundThread() {
        let omega = 100
        let animationDelay = 60*1000000/omega/kNumberOfFins
        var poolFlushCounter = 0
        while !Thread.current.isCancelled {
            updateFrame(from: nil)
            usleep(useconds_t(animationDelay))
            poolFlushCounter += 1
            if poolFlushCounter > 256 {
                poolFlushCounter = 0
            }
        }
    }
    
    @objc private func updateFrame(from: Timer?) {
        let minAlpha = isDisplayedWhenStopped ? kAlphaWhenStopped : 0
        for idx in 0..<kNumberOfFins {
            let newAlpha = max(alphaValue(for: idx), minAlpha)
            finColors[idx] = color.withAlphaComponent(newAlpha)
        }
        if isFadingOut, fadeOutStartTime?.timeIntervalSinceNow ?? 0 < -kFadeOutTime {
            actuallyStopAnimation()
        }
        if isUsesThreadedAnimation {
            DispatchQueue.main.async {
                self.display()
            }
        } else {
            needsDisplay = true
        }
        if !isFadingOut {
            currentPosition = (currentPosition + 1) % kNumberOfFins
        }
    }

    public func startAnimation(_ sender: Any?) {
        if !isIndeterminate || (isAnimating && !isFadingOut) {
            return
        }
        actuallyStartAnimation()
    }
    
    public func stopAnimation(_ sender: Any?) {
        isFadingOut = true
        fadeOutStartTime = Date.init()
    }
    
}

