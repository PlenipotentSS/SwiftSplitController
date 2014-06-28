//
//  ViewController.swift
//  SwiftSplitViewController
//
//  Created by Stevenson on 6/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

import UIKit

enum MenuState:Int {
    case MenuCompletelyOpened, MenuOpened, MenuCompletelyHidden
    func simpleDescription() -> String {
        switch self {
        case .MenuCompletelyOpened:
            return "Menu Full Screen"
        case .MenuOpened:
            return "Menu Split Open"
        case .MenuCompletelyHidden:
            return "Menu Hidden"
        }
    }
}

class SplitViewController: UIViewController, UIGestureRecognizerDelegate {
    /// currrent state of splitviews
    var menuStateInView:MenuState?
    
    /// current front controller
    var frontViewcontroller: UINavigationController?
    
    /// current back controller
    var backViewController: UINavigationController?
    
    //constants
    let menuOffset:CGFloat = 60
    let maxOpenSpace:CGFloat =  256
    
    /*
        Boiler Plate
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0.1, alpha: 1)
        self.setupSplitViews()
        self.setupPanGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
        Private Methods
    */
    
    func setupSplitViews() {
        self.backViewController = self.storyboard.instantiateViewControllerWithIdentifier("back")
         as? UINavigationController
        
        self.frontViewcontroller = self.storyboard.instantiateViewControllerWithIdentifier("front") as? UINavigationController
        
        self.addChildViewController(self.backViewController)
        if let backController = self.backViewController {
            backController.navigationBar.hidden = true
        }
        if let backView = self.backViewController?.view {
            self.view.addSubview(backView)
        }
        
        self.addChildViewController(self.frontViewcontroller)
        if let frontController = self.frontViewcontroller {
            frontController.navigationBar.hidden = false
            frontController.didMoveToParentViewController(self)
        }
        if let frontView = self.frontViewcontroller?.view {
            self.view.addSubview(frontView)
            frontView.layer.shadowOpacity = 0.8
            frontView.layer.shadowOffset = CGSizeMake(-1, 0)
        }
    }
    
    func setupPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: "slidePanel:")
        
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        
        pan.delegate = self
        
        if let frontController = self.frontViewcontroller {
            frontController.view.addGestureRecognizer(pan)
        }
    }
    
    func slidePanel(pan:UIPanGestureRecognizer) {
        let velocity = pan.velocityInView(self.view)
        let translation = pan.translationInView(pan.view)
        
        
        let frontX = CGRectGetMinX(self.frontViewcontroller!.view.frame)
        switch pan.state {
        case .Changed:
            
            let backX = CGRectGetMinX(self.backViewController!.view.frame)
            
            //move front view to open (do not close beyond full)
            if frontX + translation.x >= 0 {
                let frontTranslationX = CGRectGetMidX(self.frontViewcontroller!.view.frame)+translation.x
                
                self.frontViewcontroller!.view.center = CGPointMake(frontTranslationX, CGRectGetMidY(self.frontViewcontroller!.view.frame))
                
                pan.setTranslation(CGPointMake(0, 0), inView: self.view)
            }
            
            //move back view with restrictions
            if  backX >= self.menuOffset && backX <= 0 {
                
            }
            
            return
        case .Ended:
            
            //close menu if before middle or moving fast
            //else open menu if going fast
            if frontX <= CGRectGetWidth(self.view.frame)/2 {
                UIView.animateWithDuration(0.4, animations: {
                    self.frontViewcontroller!.view.center = self.view.center
                })
            } else {
                UIView.animateWithDuration(0.4, animations: {
                    var frontFrame = self.backViewController!.view.frame
                    frontFrame.origin.x = self.maxOpenSpace
                    self.frontViewcontroller!.view.frame = frontFrame
                })
            }
            
            return
        default:
            return
        }
    }
    
    /*
        Public Methods
     */
    
    func showMenuFullScreen() {
        
    }
    
    func showMenuSplit() {
        
    }
    
    func hideMenu() {
        
    }
    
}

