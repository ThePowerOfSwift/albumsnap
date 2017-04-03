//
//  PhotoOutput.swift
//  AlbumSnap
//
//  Created by Aaron Monick on 3/23/17.
//  Copyright © 2017 AlbumSnap. All rights reserved.
//

import AVFoundation
import UIKit

class PhotoOutput: NSObject, AVCapturePhotoCaptureDelegate {

    var output = AVCapturePhotoOutput()
    let photoSettings = AVCapturePhotoSettings()
    var photoCompletion: ((Data) -> ())?

    // get photo as Data
    func capturePhotoData(completion: @escaping (Data) -> ()) {
        output.capturePhoto(with: photoSettings, delegate: self)
        photoCompletion = { data in
            completion(data)
        }
    }

    // get photo as UIImage
    func capturePhoto(completion: @escaping (UIImage) -> ()) {
        capturePhotoData { data in
            if let image = UIImage(data: data) {
                completion(image)
            }
        }
    }

    func imageData(_ photoBuffer: CMSampleBuffer, _ previewBuffer: CMSampleBuffer?) -> Data? {
        return AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoBuffer, previewPhotoSampleBuffer: previewBuffer)
    }

    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?)
    {
        if let error = error {
            print(error.localizedDescription)
        }
        if let photoBuffer = photoSampleBuffer,
            let imageData = imageData(photoBuffer, previewPhotoSampleBuffer)
        {
            photoCompletion?(imageData)
        }
    }
}
