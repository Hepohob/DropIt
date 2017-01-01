//
//  NamedBezierPathsView.swift
//  DropIt
//
//  Created by Aleksei Neronov on 01.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import UIKit

class NamedBezierPathsView: UIView
{
    var bezierPaths = [String:UIBezierPath]() { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }
}
