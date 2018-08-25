//
//  List.swift
//  LinkedList
//
//  Created by Qingchuan Zhu on 8/24/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import Foundation

enum List<Element> {
    case end
    indirect case node(Element, next:List<Element>)
}

extension List{
    func cons(_ x:Element) -> List {
        return .node(x, next:self)
    }
}

extension List:ExpressibleByArrayLiteral{
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end) { (currList, e) -> List in
            // equavalently currList.cons(e)
            return .node(e, next:currList)
        }
    }
}

extension List{
    mutating func push(_ x:Element){
        self = .node(x, next:self)
    }
    
    mutating func pop() -> Element?{
        switch self {
        case .end:
            return nil
        case let .node(x, next:remaining):
            self = remaining
            return x
        }
    }
}

extension List:IteratorProtocol, Sequence{
    mutating func next() -> Element? {
        return pop()
    }
}
