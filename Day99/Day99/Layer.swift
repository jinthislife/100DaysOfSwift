//
//  Layer.swift
//  Day99
//
//  Created by LeeKyungjin on 20/07/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit

//enum Content {
//    enum Shape {
//        case circle
//        case triangle
//        case square
//        case custom(CGPath)
//    }
//    
//    case shape(Shape, UIColor?)
//    case image(UIImage, UIColor?)
//    case emoji(Character)
//}
//
//extension Content {
//    var color: UIColor? {
//        switch self {
//        case let .image(_, color?),
//             let .shape(_, color?):
//            return color
//        default:
//            return nil
//        }
//    }
//    
//    var image: UIImage {
//        switch self {
//        case let .image(image, _):
//            return image
//        case let .shape(shape, color):
//            return shape.image(with: color ?? .white)
//        case let .emoji(character):
//            return "\(character)".image()
//        }
//    }
//}
//
//extension Content.Shape {
//    func path(in rect: CGRect) -> CGPath {
//        switch self {
//        case .circle:
//            return CGPath(ellipseIn: rect, transform: nil)
//        case .triangle:
//            let path = CGMutablePath()
//            path.addLines(between: [
//                CGPoint(x: rect.midX, y: 0),
//                CGPoint(x: rect.maxX, y: rect.maxY),
//                CGPoint(x: rect.minX, y: rect.maxY),
//                CGPoint(x: rect.midX, y: 0)
//                ])
//            return path
//        case .square:
//            return CGPath(rect: rect, transform: nil)
//        case .custom(let path):
//            return path
//        }
//    }
//    
//    func image(with color: UIColor) -> UIImage {
//        let rect = CGRect(origin: .zero, size: CGSize(width: 12.0, height: 12.0))
//        return UIGraphicsImageRenderer(size: rect.size).image { context in
//            context.cgContext.setFillColor(color.cgColor)
//            context.cgContext.addPath(path(in: rect))
//            context.cgContext.fillPath()
//        }
//    }
//}
//
//fileprivate extension String {
//    func image(with font: UIFont = UIFont.systemFont(ofSize: 16.0)) -> UIImage {
//        let string = NSString(string: "\(self)")
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: font
//        ]
//        let size = string.size(withAttributes: attributes)
//        
//        return UIGraphicsImageRenderer(size: size).image { _ in
//            string.draw(at: .zero, withAttributes: attributes)
//        }
//    }
//}

final class Layer: CAEmitterLayer {
    override func layoutSublayers() {
        super.layoutSublayers()
        
        emitterShape = .line
        emitterSize = CGSize(width: frame.size.width, height: 1.0)
        emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
    }
    
    func configure(with contents: [Content]) {
        emitterCells = contents.map { content in
            let cell = CAEmitterCell()
            
            cell.birthRate = 50.0
            cell.lifetime = 10.0
            cell.velocity = CGFloat(cell.birthRate * cell.lifetime)
            cell.velocityRange = cell.velocity / 2
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 4
            cell.spinRange = .pi * 6
            cell.scaleRange = 0.25
            cell.scale = 1.0 - cell.scaleRange
            cell.contents = content.image.cgImage
            if let color = content.color {
                cell.color = color.cgColor
            }
            
            return cell
        }
    }

}
