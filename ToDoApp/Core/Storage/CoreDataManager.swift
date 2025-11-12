//
//  CoreData.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 09.11.2025.
//

import Foundation
import CoreData


final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
  
        let container = NSPersistentContainer(name: "ToDoApp")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    // Main context для UI
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Background context для тяжелых операций
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    

    // MARK: - Core Data Saving support

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
    
    func clearAllData() {
        let context = mainContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ToDoItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
            print("✅ Все данные успешно удалены из Core Data")
        } catch {
            print("❌ Ошибка при удалении данных: \(error)")
        }
    }
    
    // MARK: - Perform operations
      func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
          persistentContainer.performBackgroundTask(block)
      }
}

