//
//  RectangleDetector.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import CoreImage

class RectangleDetector {

    var detector: CIDetector = {
        let context = CIContext(options:[kCIContextUseSoftwareRenderer : true])
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: options)
        return detector!
    }()
    var lastRectangle: CIRectangleFeature?
    var confidentRectangle: CIRectangleFeature?
    var range: CGFloat = 20.0
    var confidenceLevel = 0
    let confidenceThreshold = 10
    var confidenceReached: ((CIRectangleFeature) -> ())?

    func rectangle(in image: CIImage) -> CIRectangleFeature? {
        if let filteredImage = applyFilters(image),
            let rectangles = detector.features(in: filteredImage) as? [CIRectangleFeature],
            let rectangle = biggestRect(in: rectangles)
        {
            if lastRectangle != nil, pointsWithin(range, lastRectangle!, rectangle) {
                confidenceLevel += 1
                if confidenceLevel == confidenceThreshold {
                    confidentRectangle = rectangle
                } else if confidenceLevel == confidenceThreshold * 2 {
                    confidenceReached?(confidentRectangle!)
                }
            } else {
                confidenceLevel = 0
            }
            lastRectangle = rectangle
        } else {
            confidenceLevel = 0
            confidentRectangle = nil
        }
        return confidentRectangle
    }

    func pointsWithin(_ radius: CGFloat,
                      _ lastRectangle: CIRectangleFeature,
                      _ newRectangle: CIRectangleFeature) -> Bool
    {
        return newRectangle.topLeft.pointWithin(radius, of: lastRectangle.topLeft) &&
            newRectangle.topRight.pointWithin(radius, of: lastRectangle.topRight) &&
            newRectangle.bottomLeft.pointWithin(radius, of: lastRectangle.bottomLeft) &&
            newRectangle.bottomRight.pointWithin(radius, of: lastRectangle.bottomRight)
    }

    func biggestRect(in rectangles: [CIRectangleFeature]) -> CIRectangleFeature? {
        if rectangles.count == 0 { return nil }
        print(rectangles.count)
        var halfPerimiter: CGFloat = 0
        var biggestRect = rectangles.first
        rectangles.forEach { rect in
            let p1 = rect.topLeft
            let p2 = rect.topRight
            let width = hypot(p1.x - p2.x, p1.y - p2.y)
            let p3 = rect.topLeft
            let p4 = rect.bottomLeft
            let height = hypot(p3.x - p4.x, p3.y - p4.y)
            let currentHalfPerimiter = height + width
            if halfPerimiter < currentHalfPerimiter {
                halfPerimiter = currentHalfPerimiter
                biggestRect = rect
            }
        }
        return biggestRect
    }

    func applyGrayscaleFilter(_ image: CIImage) -> CIImage? {
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(0.0, forKey: kCIInputSaturationKey)
        return filter.outputImage
    }

    func applyNoiseReductionFilter(_ image: CIImage) -> CIImage? {
        let filter = CIFilter(name: "CINoiseReduction")!
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter.outputImage
    }

    func applyFilters(_ image: CIImage) -> CIImage? {
        if let noiseOutput = applyNoiseReductionFilter(image),
            let image = applyGrayscaleFilter(noiseOutput) {
            return image
        }
        return nil
    }
}

extension CGPoint {

    func pointWithin(_ radius: CGFloat, of point: CGPoint) -> Bool {
        return self.distance(toPoint: point) <= radius
    }

    func distance(toPoint p: CGPoint) -> CGFloat {
        return sqrt(pow(x - p.x, 2) + pow(y - p.y, 2))
    }
}
