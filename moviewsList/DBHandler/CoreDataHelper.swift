//
//  CoreDataHelper.swift
//  CarFit
//
//  Created by Abhijithkrishnan on 22/02/21.
//  Copyright © 2021 Test Project. All rights reserved.
//

import Foundation
import CoreData

class CFCoreDataHelper: CFDBHelperInterface {
    
    static let shared = CFCoreDataHelper ()
    
    typealias ObjectType = NSManagedObject
    typealias PredicateType = NSPredicate
    
    lazy var context : NSManagedObjectContext = {persistentContainer.viewContext}()
    lazy var persistentContainer:NSPersistentContainer = {
        let container = NSPersistentCloudKitContainer(name: "SAPFLICKER")
        container.loadPersistentStores(completionHandler:{ (storeDescription, error) in
            if let error = error as NSError? {
            }
        })
        return container
    }()
}
//MARK:- Core Data Helpers
extension CFCoreDataHelper {
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }catch{
                _ = error as NSError
            }
        }
    }
}

//MARK:- DBHelper protocol
extension CFCoreDataHelper {
    func create(_ object: NSManagedObject) {
        do {
            try context.save()
        }catch{
        }
    }
    
    func fetch<T:ObjectType>(_ objectType: T.Type, predicate: PredicateType?, limit: Int? = nil) -> Result<[T], Error> {
        let request = objectType.fetchRequest()
        request.returnsObjectsAsFaults = false
//        request.sortDescriptors =  [NSSortDescriptor(key: #keyPath(SearchHistory.intelligence), ascending: true)]
        request.predicate = predicate
        if let limit = limit {
            request.fetchLimit = limit
        }
        do {
            let result = try context.fetch(request)
            return .success(result as?[T] ?? [])
        }catch {
            return .failure(error)
        }
    }
    
    func fetchFirst<T:ObjectType>(_ objectType: T.Type, predicate: PredicateType?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try context.fetch(request) as? [T]
            return .success(result?.first)
        }catch {
            return .failure(error)
        }
    }
    
    func update(_ object: ObjectType) {
        do {
            try context.save()
        }catch {
        }
    }
    
    func delete(_ object: ObjectType) {
        do {
            context.delete(object)
            try context.save()
            
        }catch {
            
        }
        
    }
    func flushDB<T:ObjectType>(_ objectType: T.Type) {
        let request = objectType.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            result.forEach{ mo in
                delete(mo as! NSManagedObject)
            }
            try context.save()
            
        }catch {
            
        }
    }
}
