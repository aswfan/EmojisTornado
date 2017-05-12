//
//  ViewController.swift
//  EmojisTornado
//
//  Created by iGuest on 5/11/17.
//  Copyright © 2017 yyfan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let emojis = [
        "😀",
        "😃",
        "😄",
        "😁",
        "😆",
        "😅",
        "😂"
    ]
    
    let textLayer = CATextLayer()
    
    let fontSize: CGFloat = 24.0
    let fontColor = UIColor(white: 0.1, alpha: 1.0)
    
    let emitterrLayer = CAEmitterLayer()
    
    let fallRate: CGFloat = 72
    let spinRange: CGFloat = 5
    let birthRate: Float = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.masksToBounds = true
        
        configureTextLayer()
        configureEmitterLayer()
        
        beginRotatingIn3D()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emitterrLayer.frame = view.bounds
        
        emitterrLayer.emitterPosition = CGPoint(x: emitterrLayer.frame.midX, y: 50)
        emitterrLayer.emitterSize = CGSize(width: emitterrLayer.frame.width, height: 50)
        
        
    }
    
    // Mark:Raining Emojis
    func configureTextLayer() {
        textLayer.contentsScale = UIScreen.main.scale
        
        textLayer.fontSize = fontSize
        textLayer.alignmentMode = kCAAlignmentCenter
        
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = fontColor.cgColor
        
        textLayer.frame = CGRect(x: 0, y: 0, width: fontSize*2, height: fontSize*2)
        
    }
    
    func configureEmitterLayer() {
        emitterrLayer.contentsScale = UIScreen.main.scale
        
        emitterrLayer.preservesDepth = true
        
        emitterrLayer.emitterMode = kCAEmitterLayerVolume
        emitterrLayer.emitterShape = kCAEmitterLayerRectangle
        
//        emitterrLayer.backgroundColor = UIColor.red.cgColor
        emitterrLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        emitterrLayer.emitterCells = generateEmitterCells()
        
        view.layer.addSublayer(emitterrLayer)
    }
    
    func generateEmitterCells() -> [CAEmitterCell] {
        var emitterCells = Array<CAEmitterCell>()
        
        for emoji in self.emojis {
            let emitterCell = emitterCellWith(text: emoji)
            emitterCells.append(emitterCell)
        }
        
        return emitterCells
    }
    
    func emitterCellWith(text: String) ->CAEmitterCell {
        let emitterCell = CAEmitterCell()
        
        emitterCell.contents = cgImageFrom(text: text)
        emitterCell.contentsScale = UIScreen.main.scale
        
        emitterCell.birthRate = birthRate
        emitterCell.lifetime = Float(view.bounds.height * 2 / fallRate)
        
        emitterCell.emissionLongitude = CGFloat.pi * 0.5
        emitterCell.emissionRange = CGFloat.pi * 0.25
        emitterCell.velocity = fallRate
        
        emitterCell.spinRange = spinRange
        
        return emitterCell
    }
    
    
    func cgImageFrom(text: String) -> CGImage? {
        textLayer.string = text
        UIGraphicsBeginImageContextWithOptions(textLayer.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        textLayer.render(in: context)
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return renderedImage?.cgImage
    }
    
    // MARK: Rotating
    func beginRotatingIn3D() {
        view.layer.sublayerTransform.m34 = 1 / 500.0
        
        
        let roatationAnimation = infiniteRotatingAnimation()
        
        emitterrLayer.add(roatationAnimation, forKey: "fadaf")
    }
    
    func infiniteRotatingAnimation() -> CABasicAnimation{
        let rotation = CABasicAnimation(keyPath: "transform.rotation.y")
        
        rotation.toValue = 4 * Double.pi
        rotation.duration = 10
        
        rotation.isCumulative = true
        rotation.repeatCount = HUGE
        
        return rotation
    }

}

