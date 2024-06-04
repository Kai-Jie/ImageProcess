//
//  ImageExtension.swift
//  ImageProcessDemo
//
//  Created by Neo Hsu on 2024/5/28.
//

import SwiftUI

extension UIImage {
    func asView() -> some View {
        Image(uiImage: self)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

extension Image {
    @MainActor 
    func asUIImage(newSize: CGSize) -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .frame(width: newSize.width, height: newSize.height)
            .clipped()
        return ImageRenderer(content: image).uiImage
    }
}
