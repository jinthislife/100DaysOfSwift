//
//  ViewController.swift
//  Project27
//
//  Created by LeeKyungjin on 27/06/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
    }
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            writeText()
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
//            let rectangle = CGRect(x: 5, y: 5, width: 502, height: 502)
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckerBoard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect((CGRect(x: -128, y: -128, width: 256, height: 256)))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }

    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    

func drawEmoji() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    
        let img = renderer.image { ctx in
            let faceRectangle = CGRect(x: 128, y: 128, width: 256, height: 256)
            
            // draw face
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: faceRectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            //draw eyes white
            let leftWhiteRectangle = CGRect(x: 160, y: 200, width: 64, height: 64)
            let rightWhiteRectangle = CGRect(x: 288, y: 200, width: 64, height: 64)
            
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.gray.cgColor)
            ctx.cgContext.setLineWidth(6)
            
            ctx.cgContext.addEllipse(in: leftWhiteRectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.addEllipse(in: rightWhiteRectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            //draw eyes black
            let leftBlackRactangle = CGRect(x: 184, y: 200, width: 16, height: 16)
            let rightBlackRactangle = CGRect(x: 314, y: 200, width: 16, height: 16)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.fillEllipse(in: leftBlackRactangle)
            ctx.cgContext.fillEllipse(in: rightBlackRactangle)
            
            //draw mouse
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.stroke(CGRect(x: 224, y: 315, width: 64, height: 10))
        }

        imageView.image = img
    }
    
    func writeText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let img = renderer.image { ctx in
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(5)
            
            //T
            ctx.cgContext.move(to: CGPoint(x: 14, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 114, y: 192))
            ctx.cgContext.move(to: CGPoint(x: 64, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 64, y: 320))
            
            //W
            ctx.cgContext.move(to: CGPoint(x: 132, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 162, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 192, y: 195))
            ctx.cgContext.addLine(to: CGPoint(x: 222, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 252, y: 192))
            
            //I
            ctx.cgContext.move(to: CGPoint(x: 288, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 352, y: 192))
            ctx.cgContext.move(to: CGPoint(x: 320, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 320, y: 320))
            ctx.cgContext.move(to: CGPoint(x: 288, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 352, y: 320))
            
            //N
            ctx.cgContext.move(to: CGPoint(x: 396, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 396, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 498, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 498, y: 192))
            
            //draw
            ctx.cgContext.strokePath()
        }
        imageView.image = img
    }
}

