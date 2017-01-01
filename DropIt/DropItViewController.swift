//
//  DropItViewController.swift
//  DropIt
//
//  Created by Aleksei Neronov on 01.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController {
    
    @IBOutlet weak var gameView: DropItView! {
        didSet {
            gameView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addDrop(recognizer:))))
        }
    }
    
    func addDrop(recognizer:UITapGestureRecognizer) {
        if recognizer.state == .ended {
            gameView.addDrop()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.animating = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gameView.animating = false
    }
    
}
