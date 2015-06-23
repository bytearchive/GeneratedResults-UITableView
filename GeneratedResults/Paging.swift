//
//  Paging.swift
//  GeneratedResults
//
//  Created by Marcin Krzyzanowski on 22/06/15.
//  Copyright (c) 2015 Marcin Krzyżanowski. All rights reserved.
//

import Foundation

//MARK: Generator

protocol AsyncGeneratorType {
    typealias Element
    typealias FetchType
    typealias NextCompletion
    mutating func next(fetchNextBatch: FetchType, completion: NextCompletion?)
}

struct PagingGenerator<T>: AsyncGeneratorType {
    typealias Element = ArraySlice<T>
    typealias NextCompletion = (result: Element?) -> Void
    typealias FetchType = (offset: Int, limit: Int, completion: (result: Element) -> Void) -> Void
    
    var offset:Int
    let limit: Int
    
    init(offset: Int = 0, limit: Int = 25) {
        self.offset = offset
        self.limit = limit
    }
    
    mutating func next(fetchNextBatch: FetchType, completion: NextCompletion? = nil) {
        fetchNextBatch(offset: offset, limit: limit) { (elements) in
            self.offset += elements.count
            completion?(result: elements)
        }
    }
}

//MARK: Sequence

protocol AsyncSequenceType: _SequenceType {
    typealias Generator : AsyncGeneratorType
    func generate() -> Generator
}

struct Paging<T>: AsyncSequenceType {
    typealias Generator = PagingGenerator<T>
    
    let offset: Int
    let limit: Int
    
    func generate() -> Generator {
        return Generator(offset: offset, limit: limit)
    }
}
