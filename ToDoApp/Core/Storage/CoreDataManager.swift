//
//  CoreData.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 09.11.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Singleton
    static let shared = CoreDataManager()
    private init() {}
    
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoApp")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    
    // MARK: - Saving Support
    
    func saveContext(_ context: NSManagedObjectContext? = nil) {
        let contextToSave = context ?? mainContext
        
        guard contextToSave.hasChanges else { return }
        
        do {
            try contextToSave.save()
        } catch {
            print("Core Data save error: \(error)")
        }
    }
    
    func saveBackgroundContext() {
        backgroundContext.perform {
            self.saveContext(self.backgroundContext)
        }
    }
    
    
    // MARK: - Data Management
    
    func clearAllData() {
        let context = mainContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ToDoItem.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Данные CoreData удалены")
        } catch {
            print("Ошибка при очистке данных: \(error)")
        }
    }
}
