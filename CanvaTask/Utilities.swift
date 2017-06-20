//
//  Utilities.swift
//  CanvaTask
//
//  Created by Darius Miliauskas on 19/06/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import Foundation
import UIKit

class AlertController: UIAlertController {
    
    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = "Canva Challenge"
        self.message = message
        //self.init(title: "Canva Challenge", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) -> Void in
        })
        self.addAction(OKAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
