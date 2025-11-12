//
//  ToDoItem+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 10.11.2025.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var todoDescription: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var userId: Int32

}

extension ToDoItem : Identifiable {

}
