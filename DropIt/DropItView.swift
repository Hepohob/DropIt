//
//  DropItView.swift
//  DropIt
//
//  Created by Aleksei Neronov on 01.01.17.
//  Copyright © 2017 Aleksei Neronov. All rights reserved.
//

import UIKit

class DropItView: NamedBezierPathsView, UIDynamicAnimatorDelegate {
    private var lastDrop: UIView?
    private let dropBehavior = FallingObjectBehavior()
    private lazy var animator:UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.delegate = self
        return animator
    }()
    private var dropsPerRow = 10
    var animating = false {
        didSet {
            if animating {
                animator.addBehavior(dropBehavior)
            } else {
                animator.removeBehavior(dropBehavior)
            }
        }
    }
    
    private var dropSize:CGSize {
        let size = bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    func addDrop() {
        var frame = CGRect(origin: CGPoint.zero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        let drop = UIView(frame: frame)
        drop.backgroundColor = UIColor.random
        addSubview(drop)
        dropBehavior.addItem(drop)
        lastDrop = drop
    }
    
    func grabDrop(_ recognizer:UIGestureRecognizer) {
        let gesturePoint = recognizer.location(in: self)
        switch recognizer.state {
        case .began:
            // create attachment
            if let dropToAttach = lastDrop, dropToAttach.superview != nil {
                attachment = UIAttachmentBehavior(item: dropToAttach, attachedToAnchor: gesturePoint)
            }
            lastDrop = nil
        case .changed:
            //create attachment's point
            attachment?.anchorPoint = gesturePoint
        default:
            attachment = nil
        }
    }
    
    //MARK: Attachment behavior
    
    private var attachment: UIAttachmentBehavior? {
        willSet {
            if attachment != nil {
                animator.removeBehavior(attachment!)
            }
        }
        didSet {
            if attachment != nil {
                animator.addBehavior(attachment!)
            }
        }
    }
    
    //MARK: Add border in center
    
    private struct PathNames {
        static let MiddlieBarrier = "Middle Barrier"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(ovalIn: CGRect(center: bounds.mid, size: dropSize))
        dropBehavior.addBarrier(path, named: PathNames.MiddlieBarrier)
        bezierPaths[PathNames.MiddlieBarrier] = path
    }
    
    // MARK: Remove Completed Row
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    private func removeCompletedRow()
    {
        var dropsToRemove = [UIView]()
        
        var hitTestRect = CGRect(origin: bounds.lowerLeft, size: dropSize)
        repeat {
            hitTestRect.origin.x = bounds.minX
            hitTestRect.origin.y -= dropSize.height
            var dropsTested = 0
            var dropsFound = [UIView]()
            while dropsTested < dropsPerRow {
                if let hitView = hitTest(hitTestRect.mid) , hitView.superview == self {
                    dropsFound.append(hitView)
                } else {
                    break
                }
                hitTestRect.origin.x += dropSize.width
                dropsTested += 1
            }
            if dropsTested == dropsPerRow {
                dropsToRemove += dropsFound
            }
        } while dropsToRemove.count == 0 && hitTestRect.origin.y > bounds.minY
        
        for drop in dropsToRemove {
            dropBehavior.removeItem(drop)
            drop.removeFromSuperview()
        }
    }
   
}
