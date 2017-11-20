//
//  extension.swift
//  TorontoBiker
//
//  Created by HSIAO JENHAO on 2017-08-21.
//  Copyright © 2017 HSIAO JENHAO. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


