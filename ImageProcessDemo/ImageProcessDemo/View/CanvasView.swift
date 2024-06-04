//
//  ImageEditorView.swift
//  ImageProcessDemo
//
//  Created by Neo Hsu on 2024/5/24.
//

import SwiftUI

struct CanvasView: View {
    @Binding var selectedImage: Image?
    @Binding var selectedColor: Color
    @Binding var scale: CGFloat
    @Binding var lastScale: CGFloat
    @Binding var points: [[CGPoint]]
    @Binding var currentPoints: [CGPoint]
    @Binding var isDragging: Bool
    
    var body: some View {
        ZStack {
            if let selectedImage = selectedImage {
                selectedImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedColor == .white.opacity(0.5) ? .clear: selectedColor)
                    )
                    .scaleEffect(scale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                if !isDragging {
                                    scale = lastScale * value
                                }
                            }
                            .onEnded { value in
                                lastScale = scale
                            }
                    )
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                isDragging = true
                                let location = value.location
                                currentPoints.append(location)
                                points.append(currentPoints)
                            }
                            .onEnded { _ in
                                isDragging = false
                                currentPoints = []
                            }
                    )
                    .overlay(
                        GeometryReader { geometry in
                            let frame = geometry.frame(in: .global)
                            let center = CGPoint(x: frame.midX, y: frame.midY)
                            let newFrame = updatePositionWithCenterScale(frame: frame, scale: scale, center: center)
                            
                            Path { path in
                                for pointIndex in 0..<points.count {
                                    if !points[pointIndex].isEmpty {
                                        let scaledPoints = points[pointIndex].map { point in
                                            CGPoint(
                                                x: newFrame.minX - frame.minX + point.x * scale,
                                                y: newFrame.minY - frame.minY + point.y * scale
                                            )
                                        }
                                        path.move(to: scaledPoints[0])
                                        for index in 1..<scaledPoints.count {
                                            path.addLine(to: scaledPoints[index])
                                        }
                                    }
                                }
                            }
                            .stroke(Color.red, lineWidth: 5 * scale)
                        }
                    )
            }
        }
    }
}
