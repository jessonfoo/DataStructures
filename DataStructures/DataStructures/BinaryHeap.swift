//
//  BinaryHeap.swift
//  DataStructures
//
//  Created by Alex Usbergo on 29/12/15.
//  Copyright © 2015 Alex Usbergo. All rights reserved.
//  Edited from https://github.com/mauriciosantos/Buckets-Swift
//

import Foundation

public struct BinaryHeap<T> : SequenceType {
    
    public var isEmpty: Bool {
        return items.isEmpty
    }
    public var count: Int {
        return items.count
    }
    public var max: T? {
        return items.first
    }
    
    // returns true if the first argument has the highest priority
    private let isOrderedBefore: (T,T) -> Bool
    private var items = [T]()
    
    public init(compareFunction: (T,T) -> Bool) {
        isOrderedBefore = compareFunction
    }
    
    public mutating func insert(element: T) {
        items.append(element)
        siftUp()
    }
    
    public mutating func removeMax() -> T? {
        if !isEmpty {
            let value = items[0]
            items[0] = items[count - 1]
            items.removeLast()
            if !isEmpty {
                siftDown()
            }
            return value
        }
        return nil
    }
    
    public mutating func removeAll(keepCapacity keep: Bool = true)  {
        items.removeAll(keepCapacity: keep)
    }
    
    public func generate() -> AnyGenerator<T> {
        return anyGenerator(items.generate())
    }
    
    private mutating func siftUp() {
        func parent(index: Int) -> Int {
            return (index - 1) / 2
        }
        
        var i = count - 1
        var parentIndex = parent(i)
        while i > 0 && !isOrderedBefore(items[parentIndex], items[i]) {
            swap(&items[i], &items[parentIndex])
            i = parentIndex
            parentIndex = parent(i)
        }
    }
    
    private mutating func siftDown() {
        // Returns the index of the maximum element if it exists, otherwise -1
        func maxIndex(i: Int, _ j: Int) -> Int {
            if j >= count && i >= count {
                return -1
            } else if j >= count && i < count {
                return i
            } else if isOrderedBefore(items[i], items[j]) {
                return i
            } else {
                return j
            }
        }
        
        func leftChild(index: Int) -> Int {
            return (2 * index) + 1
        }
        
        func rightChild(index: Int) -> Int {
            return (2 * index) + 2
        }
        
        var i = 0
        var max = maxIndex(leftChild(i), rightChild(i))
        while max >= 0 && !isOrderedBefore(items[i], items[max]) {
            swap(&items[max], &items[i])
            i = max
            max = maxIndex(leftChild(i), rightChild(i))
        }
    }
}

/// Returns `true` if and only if the heaps contain the same elements
/// in the same order.
/// The underlying elements must conform to the `Equatable` protocol.
public func ==<U: Equatable>(lhs: BinaryHeap<U>, rhs: BinaryHeap<U>) -> Bool {
    return lhs.items.sort(lhs.isOrderedBefore) == rhs.items.sort(rhs.isOrderedBefore)
}

public func !=<U: Equatable>(lhs: BinaryHeap<U>, rhs: BinaryHeap<U>) -> Bool {
    return !(lhs==rhs)
}