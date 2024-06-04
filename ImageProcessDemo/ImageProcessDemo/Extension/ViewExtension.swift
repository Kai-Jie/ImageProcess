//
//  ViewExtension.swift
//  ImageProcessDemo
//
//  Created by Neo Hsu on 2024/5/24.
//

import UIKit
import SwiftUI

extension UIView {
    func asScreenshot(of size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            layer.render(in: UIGraphicsGetCurrentContext()!)
        }
    }
    
    func asView() -> some View {
        return MySwiftUIView(view: self)
    }
    
    private struct MySwiftUIView: View {
        let view: UIView
        
        var body: some View {
            ViewRepresentation(view: view)
        }
    }
    
    private struct ViewRepresentation: UIViewRepresentable {
        let view: UIView
        
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            // 這裡可以進行任何必要的更新操作
        }
    }
    
    func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image(actions: { (context) in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        })
        
        return image
    }
}

extension View {
    
    func asUIView() -> UIView {
        let controller = UIHostingController(rootView: self)
        return controller.view
    }

    @MainActor 
    func asUIImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        return renderer.uiImage
    }
}
