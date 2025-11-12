//
//  ToDoListBuilder.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 11.11.2025.
//

import Foundation
import UIKit

final class ToDoListModuleBuilder {
    
    static func build() -> ToDoListViewController {
        let interactor = ToDoListInteractor()
        let presenter = ToDoListPresenter(interactor: interactor)
        let viewController = ToDoListViewController()
        
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        
        return viewController
    }
}
