//
//  EditToDoViewController.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 12.11.2025.
//

import UIKit



final class EditTodoViewController: UIViewController {
    
    var presenter: EditTodoPresenterProtocol?
    
    // MARK: - UI
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Заголовок задачи"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Сохраняем изменения перед закрытием экрана
        presenter?.saveChanges(
            title: titleTextField.text ?? "",
            description: descriptionTextView.text ?? ""
        )
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Редактирование"
        
        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}

// MARK: - View Protocol
extension EditTodoViewController: EditTodoViewProtocol {
    func displayTodo(_ todo: ToDoItem) {
        titleTextField.text = todo.title
        descriptionTextView.text = todo.todoDescription
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = "Дата: \(dateFormatter.string(from: todo.createdAt ?? Date()))"
    }
}
