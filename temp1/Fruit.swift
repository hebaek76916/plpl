//
//  File.swift
//  temp1
//
//  Created by 현은백 on 2023/08/31.
//

import Foundation

@objc public class Fruit: NSObject {
    
    public struct Product {
        let price: CGFloat
        let sweet: CGFloat
        let name: String
    }
    
    public func printProduct(product: Product) {
        print(product.price)
        print(product.sweet)
        print(product.name)
        
        
    }
}
