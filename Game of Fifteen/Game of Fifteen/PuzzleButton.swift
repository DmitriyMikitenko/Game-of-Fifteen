//
//  PuzzleButton.swift
//  Game of Fifteen
//
//  Created by Dmitriy Mikitenko on 23.07.2021.
//

import UIKit

class PuzzleButton: UIButton {

    override var tag: Int {
        didSet {
            label.text = String(tag)
            if tag == 16{
                self.backgroundColor = .clear
                self.layer.borderColor = UIColor.clear.cgColor
                self.label.text = ""
            }
        }
    }
    
    private let label = UILabel()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.borderWidth = 0.5
        
        if self.backgroundColor == nil {
            self.layer.backgroundColor = UIColor.cyan.cgColor
            self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 100)
        }
        
        label.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        label.font = UIFont(name: "AvenirNextCondensed-Heavy", size: 35.0)
        label.textAlignment = .center
        
        self.addSubview(label)
    }
}
