//
//  View+Extensions.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/22.
//

import SwiftUI

// MARK: View extension for UI building
extension View{
    func hAlign(_ alignment: Alignment) -> some View{
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    func vAlign(_ alignment: Alignment) -> some View{
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    // MARK: Custom border view with padding
    func border(_ width: CGFloat = 1, _ color: Color = .gray.opacity(0.5)) -> some View{
        self.padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
                
            )
    }
    // MARK: Custom fill view with padding
    func fillView(_ color: Color) -> some View{
        self.padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
                
            )
    }
    func disableWidthOpacity(_ condition:Bool)-> some View{
        self.disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}
