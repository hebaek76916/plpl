//
//  File.swift
//  temp1
//
//  Created by 현은백 on 2023/08/31.
//

import Foundation

@objc public class Product: NSObject {
    @objc public let price: CGFloat
    @objc public let sweet: CGFloat
    @objc public let name: String
    
    public override init() {
        self.price = 0.0
        self.sweet = 0.0
        self.name = "FRUIT"
    }
    
    @objc public init(price: CGFloat, sweet: CGFloat, name: String) {
        self.price = price
        self.sweet = sweet
        self.name = name
        super.init()
    }
}

@objc public class Fruit: NSObject {
    
    public override init() {}
    
    @objc public func printProduct(product: Product) {
        print(product.price)
        print(product.sweet)
        print(product.name)
        NSLog("\(product.price)")
        NSLog("\(product.sweet)")
        NSLog("\(product.name)")
        dump(product)
    }
}
