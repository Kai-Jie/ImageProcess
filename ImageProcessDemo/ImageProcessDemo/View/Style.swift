//
//  Style.swift
//  ImageProcessDemo
//
//  Created by Neo Hsu on 2024/5/17.
//

import SwiftUI


struct RoundedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(width: 60, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(radius: 4)
            )
    }
}
