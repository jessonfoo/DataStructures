//
//  PriorityQueue.swift
//  DataStructures
//
//  Created by Alex Usbergo on 29/12/15.
//  Copyright © 2015 Alex Usbergo. All rights reserved.
//  Edited from https://github.com/mauriciosantos/Buckets-Swift
//

import Foundation

/// In a priority queue each element is associated with a "priority",
/// elements are dequeued in highest-priority-first order (the
/// elements with the highest priority are dequeued first).
/// The `enqueue` and `dequeue` operations run in O(log(n)) time.
public struct PriorityQueue<T> {
    
    // MARK: Creating a Priority Queue
    
    /// Constructs an empty priority queue using a closure to
    /// determine the order of a provided pair of elements. The closure that you supply for
    /// `isOrderedBefore` should return a boolean value to indicate whether one element
    /// should be before (`true`) or after (`false`) another element using strict weak ordering.
    /// See http://en.wikipedia.org/wiki/Weak_ordering#Strict_weak_orderings
    ///
    /// - parameter isOrderedBefore: Strict weak ordering function for checking if the first element has higher priority.
    public init(_ isOrderedBefore: (T,T) -> Bool) {
        self.init([], isOrderedBefore)
    }
    
    /// Constructs a priority queue from a sequence, such as an array, using a given closure to
    /// determine the order of a provided pair of elements. The closure that you supply for
    /// `isOrderedBefore` should return a boolean value to indicate whether one element
    /// should be before (`true`) or after (`false`) another element using strict weak ordering.
    /// See http://en.wikipedia.org/wiki/Weak_ordering#Strict_weak_orderings
    ///
    /// - parameter isOrderedBefore: Strict weak ordering function for checking if the first element has higher priority.
    public init<S: SequenceType where S.Generator.Element == T>(_ elements: S, _ isOrderedBefore: (T,T) -> Bool) {
        heap = BinaryHeap<T>(compareFunction: isOrderedBefore)
        for e in elements {
            enqueue(e)
        }
    }
    
    /// Number of elements stored in the priority queue.
    public var count: Int {
        return heap.count
    }
    
    /// Returns `true` if and only if `count == 0`.
    public var isEmpty: Bool {
        return count == 0
    }
    
    /// The highest priority element in the queue, or `nil` if the queue is empty.
    public var first: T? {
        return heap.max
    }
    
    /// Inserts an element into the priority queue.
    public mutating func enqueue(element: T) {
        heap.insert(element)
    }
    
    /// Retrieves and removes the highest priority element of the queue.
    /// - returns: The highest priority element, or `nil` if the queue is empty.
    public mutating func dequeue() -> T? {
        return heap.removeMax()
    }
    
    /// Removes all the elements from the priority queue, and by default
    /// clears the underlying storage buffer.
    public mutating func removeAll(keepCapacity keep: Bool = true)  {
        heap.removeAll(keepCapacity: keep)
    }
    
    /// Internal structure holding the elements.
    private var heap : BinaryHeap<T>
}

extension PriorityQueue: SequenceType {
    
    /// Provides for-in loop functionality. Generates elements in no particular order.
    public func generate() -> AnyGenerator<T> {
        return heap.generate()
    }
}

extension PriorityQueue: CustomStringConvertible {
    
    /// A string containing a suitable textual
    /// representation of the priority queue.
    public var description: String {
        return "[" + map{"\($0)"}.joinWithSeparator(", ") + "]"
    }
}

// MARK: - Operators

/// Returns `true` if and only if the priority queues contain the same elements
/// in the same order.
/// The underlying elements must conform to the `Equatable` protocol.
public func ==<U: Equatable>(lhs: PriorityQueue<U>, rhs: PriorityQueue<U>) -> Bool {
    return lhs.heap == rhs.heap
}

public func !=<U: Equatable>(lhs: PriorityQueue<U>, rhs: PriorityQueue<U>) -> Bool {
    return !(lhs==rhs)
}

