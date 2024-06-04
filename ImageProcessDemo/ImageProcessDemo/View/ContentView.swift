//
//  ContentView.swift
//  ImageProcessDemo
//
//  Created by Neo Hsu on 2024/5/17.
//

import UIKit
import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var selectedColor: Color = .white.opacity(0.5)
    @State private var showImagePicker = false
    @State private var showColorPicker = false
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var points: [[CGPoint]] = []
    @State private var currentPoints: [CGPoint] = []
    @State private var isDragging = false
    @State private var showSaveAlert = false
    @State private var showFailureAlert = false
    @State private var hasRequestedPhotoLibraryAccess = false

    var body: some View {
        ZStack {
            VStack {
                let canvasView = CanvasView(
                    selectedImage: $selectedImage,
                    selectedColor: $selectedColor,
                    scale: $scale,
                    lastScale: $lastScale,
                    points: $points,
                    currentPoints: $currentPoints,
                    isDragging: $isDragging
                )
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                
                canvasView
                
                Divider()
                                
                // 下方工具區域
                HStack {
                    ColorPicker("", selection: $selectedColor)
                        .labelsHidden()
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(uiColor: UIColor.systemBackground))
                                .shadow(radius: 4)
                        )
                    
                    Spacer()
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("", systemImage: "photo")
                    }
                    .buttonStyle(RoundedButtonStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        if let image = canvasView.asUIImage() {
                            saveImageToPhotosLibrary(image) { success, error in
                                if success {
                                    showSaveAlert = true
                                } else if error != nil {
                                    showFailureAlert = true
                                }
                            }
                        } else {
                            showFailureAlert = true
                        }
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title)
                    }
                    .buttonStyle(RoundedButtonStyle())
                }
                .padding()
            }
            
        }
        .onChange(of: selectedItem) {
            Task {
                if let item = selectedItem, let data = try? await item.loadTransferable(type: Data.self) {
                    selectedImage = Image(uiImage: UIImage(data: data)!)
                }
            }
        }
        .alert(isPresented: $showSaveAlert) {
            Alert(
                title: Text("儲存成功"),
                message: Text("照片已儲存到系統相簿"),
                dismissButton: .default(Text("確定"))
            )
        }
        .alert(isPresented: $showFailureAlert) {
            Alert(
                title: Text("儲存失敗"),
                message: Text("無法將照片儲存到相簿,請稍後再試。"),
                dismissButton: .default(Text("確定"))
            )
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
