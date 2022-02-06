//
//  CFDBHelper.swift
//  CarFit
//
//  Created by Abhijithkrishnan on 22/02/21.
//  Copyright © 2021 Test Project. All rights reserved.
//

import Foundation

public protocol CFDBHelperInterface {
    associatedtype ObjectType
    associatedtype PredicateType
    
    func create(_ object: ObjectType)
    func fetchFirst(_ objectType: ObjectType.Type, predicate: PredicateType?) -> Result<ObjectType?, Error>
    func fetch(_ objectType: ObjectType.Type, predicate: PredicateType?, limit: Int?) -> Result<[ObjectType], Error>
    func update(_ object: ObjectType)
    func delete(_ object: ObjectType)
}

public extension CFDBHelperInterface {
    func fetch(_ objectType: ObjectType.Type, predicate: PredicateType? = nil, limit: Int? = nil) -> Result<[ObjectType], Error> {
        return fetch(objectType, predicate: predicate, limit: limit)
    }
}

