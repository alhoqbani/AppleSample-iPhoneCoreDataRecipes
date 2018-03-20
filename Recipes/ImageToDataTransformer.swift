//
//  ImageToDataTransformer.swift
//  Recipes
//
//  Created by Hamoud Alhoqbani on 3/20/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit
import CoreData

class ImageToDataTransformer: ValueTransformer {

    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> Swift.AnyClass {
        return NSData.self
    }
    
    open override func transformedValue(_ value: Any?) -> Any? {
        return UIImagePNGRepresentation(value as! UIImage)
    }
    
    open override func reverseTransformedValue(_ value: Any?) -> Any? {
        return UIImage(data: value as! Data)
    }

    
    
}
