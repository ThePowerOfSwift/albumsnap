//
//  VideoDataOutput.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import AVFoundation
import UIKit

class VideoDataOutput: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    var output = AVCaptureVideoDataOutput()
    var imageFrameCompletion: ((CIImage) -> ())?

    override init() {
        super.init()
        let videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        output.videoSettings = videoSettings
        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: .main)
    }

    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!)
    {

        if !CMSampleBufferIsValid(sampleBuffer) { return }
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer!)
        imageFrameCompletion?(ciImage)
    }

    func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didDrop sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!)
    {

    }
}
