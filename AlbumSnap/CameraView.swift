//
//  CameraView.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import AVFoundation
import UIKit

class CameraView: UIView {

    let session = AVCaptureSession()
    var videoQuality: VideoQuality = .high
    var captureCamera: CaptureDevice = .backCamera
    let microphone: CaptureDevice = .microphone
    // Outputs
    let videoDataOutput = VideoDataOutput()
    let photoOutput = PhotoOutput()
    // UI
    let previewLayer = AVCaptureVideoPreviewLayer()
    let qrCodeView = UIView()
    let detectedView = DetectedView()
    let rectangleDetector = RectangleDetector()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        addInputs()
        addOutputs()
        setupSession()
        detectRectangles()
    }

    func addInputs() {
        session.addInput(captureCamera.input)
        session.addInput(microphone.input)
    }

    func addOutputs() {
        session.addOutput(videoDataOutput.output)
        //session.addOutput(photoOutput.output)
    }

    func setupSession() {
        previewLayer.session = session
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = self.layer.bounds
        self.layer.addSublayer(previewLayer)

        session.sessionPreset = videoQuality.preset
        session.startRunning()
    }

    func convertImagePoint(point: CGPoint, videoSize: CGSize) -> CGPoint {
        return previewLayer.pointForCaptureDevicePoint(ofInterest: CGPoint(x: point.x*1/videoSize.width, y: 1-point.y*1/videoSize.height))
    }

    func detectRectangles() {
        detectedView.frame = bounds
        addSubview(detectedView)
        videoDataOutput.imageFrameCompletion = { [unowned self] ciImage in
            let videoSize = ciImage.extent.size
            if let rectangle = self.rectangleDetector.rectangle(in: ciImage) {
                let topLeft = self.convertImagePoint(point: rectangle.topLeft, videoSize: videoSize)
                let topRight = self.convertImagePoint(point: rectangle.topRight, videoSize: videoSize)
                let bottomLeft = self.convertImagePoint(point: rectangle.bottomLeft, videoSize: videoSize)
                let bottomRight = self.convertImagePoint(point: rectangle.bottomRight, videoSize: videoSize)
                self.detectedView.updatePoints(topLeft, topRight, bottomLeft, bottomRight)
                self.detectedView.show = true
            } else {
                self.detectedView.show = false
            }
        }
        rectangleDetector.confidenceReached = { rectangle in

        }
    }

}

enum VideoQuality {
    case high, medium, low

    var preset: String {
        switch self {
        case .high: return AVCaptureSessionPresetHigh
        case .medium: return AVCaptureSessionPresetMedium
        case .low: return AVCaptureSessionPresetLow
        }
    }
}

enum CaptureDevice {
    case backCamera, frontCamera, microphone

    var avDevice: AVCaptureDevice {
        switch self {
        case .backCamera: return AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
        case .frontCamera: return AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        case .microphone: return AVCaptureDevice.defaultDevice(withDeviceType: .builtInMicrophone, mediaType: AVMediaTypeAudio, position: .unspecified)
        }
    }

    var input: AVCaptureInput? {
        return try? AVCaptureDeviceInput(device: avDevice)
    }

    func toggle() -> CaptureDevice {
        switch self {
        case .backCamera: return .frontCamera
        case .frontCamera: return .backCamera
        case .microphone: return .microphone
        }
    }
}
