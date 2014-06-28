//
//  SplitStoryboardSegue.swift
//  SwiftSplitViewController
//
//  Created by Stevenson on 6/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

import UIKit

class SplitStoryboardSegue: UIStoryboardSegue {
   
    override func perform(){
        let src:UIViewController = self.sourceViewController as UIViewController;
        let dst:UIViewController = self.destinationViewController as UIViewController;
        
        UIView.transitionWithView(dst.navigationController.view, duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
                src.navigationController.popToRootViewControllerAnimated(false);
                src.navigationController.pushViewController(dst, animated: false);
            }, completion: nil)
    }
}
