//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 11.11.2025.
//



import UIKit

final class ToDoListViewController: UIViewController {
    
    var presenter: ToDoListPresenterProtocol?
    
    private var todos: [ToDoItem] = []
    private let tableView = UITableView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Поиск"
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ToDo List"
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupTableView()
        
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        [titleLabel, searchBar, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)
        
    }
    
    
    private func deleteTodo(at indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        let context = CoreDataManager.shared.mainContext
        context.delete(todo)
        CoreDataManager.shared.saveContext()
        todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as! ToDoTableViewCell
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        cell.circleTapAction = {
            todo.isCompleted.toggle()
            CoreDataManager.shared.saveContext()
            cell.updateCircleAndText(todo.isCompleted)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectTodo(todos[indexPath.row], at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = .identity
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let todo = todos[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                print("Редактировать: \(todo.title ?? "")")
                self.presenter?.router?.showDetail(for: todo)
            }
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                let text = todo.title ?? ""
                let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                self.present(activityVC, animated: true)
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteTodo(at: indexPath)
            }
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
    
    
}

extension ToDoListViewController: ToDoListViewProtocol {
    func showTodos(_ todos: [ToDoItem]) {
        self.todos = todos
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter?.viewDidLoad()
        } else {
            let filtered = todos.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
            showTodos(filtered)
        }
    }
}
