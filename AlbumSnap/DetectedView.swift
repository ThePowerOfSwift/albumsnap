//
//  DetectedView.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import UIKit

class DetectedView: UIView {

    var line = Color.overlay.value
    var fill = Color.overlay.value.withAlpha(0.25)

    var shape = CAShapeLayer()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    var show: Bool = false {
        didSet {
            if show {
                spinner.startAnimating()
                Animator(duration: 0.3).animations {
                    self.alpha = 1
                    }.animate()
            } else  {
                spinner.stopAnimating()
                Animator(duration: 0.3).animations {
                    self.alpha = 0
                    }.animate()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        backgroundColor = .clear
        shape = CAShapeLayer()
        shape.path = UIBezierPath().cgPath
        shape.fillColor = fill.cgColor
        shape.strokeColor = line.cgColor
        shape.fillRule = kCAFillRuleEvenOdd
        layer.addSublayer(shape)
        addSubview(spinner)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updatePoints(_ topLeft: CGPoint, _ topRight: CGPoint,
                      _ bottomLeft: CGPoint, _ bottomRight: CGPoint) {

        Animator(duration: 0.3).animations {
            self.spinner.center = self.center(topLeft, topRight, bottomLeft, bottomRight)
            }.animate()

        let path = newPath(topLeft, topRight, bottomLeft, bottomRight)
        let myAnimation = CABasicAnimation(keyPath: "path")
        myAnimation.toValue = path
        myAnimation.duration = 0.3
        shape.add(myAnimation, forKey: nil)
        shape.path = path.cgPath
    }

    func newPath(_ topLeft: CGPoint, _ topRight: CGPoint,
                 _ bottomLeft: CGPoint, _ bottomRight: CGPoint) -> UIBezierPath
    {
        let newPath = UIBezierPath()
        newPath.move(to: topLeft)
        newPath.addLine(to: topRight)
        newPath.addLine(to: bottomRight)
        newPath.addLine(to: bottomLeft)
        newPath.addLine(to: topLeft)
        newPath.close()
        fill.setFill()
        newPath.fill()
        line.setStroke()
        newPath.lineWidth = 1
        newPath.stroke()
        return newPath
    }

    func center(_ topLeft: CGPoint, _ topRight: CGPoint,
                _ bottomLeft: CGPoint, _ bottomRight: CGPoint) -> CGPoint
    {
        let x = (topLeft.x + topRight.x + bottomLeft.x + bottomRight.x) / 4
        let y = (topLeft.y + topRight.y + bottomLeft.y + bottomRight.y) / 4
        return CGPoint(x: x, y: y)
    }
}
