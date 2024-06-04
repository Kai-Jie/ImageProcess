//
//  ImageProcessFeature.swift
//  ImageProcessDemo
//
//  Created by Neo Hsu on 2024/5/17.
//

import UIKit
import SwiftUI
import Photos

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

func updatePositionWithCenterScale(frame: CGRect, scale: CGFloat, center: CGPoint) -> CGRect {
    let width = frame.width * scale
    let height = frame.height * scale
    let x = center.x - (width / 2)
    let y = center.y - (height / 2)
    return CGRect(x: x, y: y, width: width, height: height)
}

func checkAndRequestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized, .limited:
        completion(true)
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization { newStatus in
            DispatchQueue.main.async {
                completion(newStatus == .authorized || newStatus == .limited)
            }
        }
    default:
        completion(false)
    }
}

func saveImageToPhotosLibrary(_ image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
    checkAndRequestPhotoLibraryAccess { isAuthorized in
        if isAuthorized {
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: image)
            }) { success, error in
                completion(success, error)
            }
        } else {
            completion(false, nil)
        }
    }
}
