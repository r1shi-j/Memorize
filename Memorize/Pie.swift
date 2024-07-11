//
//  Pie.swift
//  Memorize
//
//  Created by Rishi Jansari on 08/07/2024.
//

import SwiftUI
import CoreGraphics

struct Pie: Shape {
    var startAngle: Angle = .zero
    let endAngle: Angle
    var clockwise = true
    
    func path(in rect: CGRect) -> Path {
        let startAngle = startAngle - .degrees(90)
        let endAngle = endAngle - .degrees(90)
        let centre = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x:centre.x + radius * cos(startAngle.radians),
            y:centre.y + radius * sin(startAngle.radians)
        )
        
        var p = Path()
        p.move(to: centre)
        p.addLine(to: start)
        p.addArc(center: centre, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        p.addLine(to: centre)
        
        return p
    }
}
