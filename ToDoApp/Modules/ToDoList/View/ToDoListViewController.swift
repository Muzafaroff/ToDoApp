//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 11.11.2025.
//

import UIKit

final class ToDoListViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: ToDoListPresenterProtocol?
    private var todos: [ToDoItem] = []
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.searchBarStyle = .minimal
        sb.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        sb.backgroundColor = .clear
        sb.isTranslucent = true
        
        sb.returnKeyType = .done
        
        
        let tf = sb.searchTextField
        tf.backgroundColor = UIColor(red: 55/255, green: 55/255, blue: 60/255, alpha: 1)
        tf.textColor = .white
        tf.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        if let leftIcon = tf.leftView as? UIImageView {
            leftIcon.tintColor = .lightGray
        }
        return sb
    }()
    
    private let bottomPanel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tasksCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 задач"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = UIColor(red: 254/255, green: 215/255, blue: 2/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupUI()
        setupTableView()
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        setupResetButton()
        
        presenter?.viewDidLoad()
        searchBar.delegate = self
        hideKeyboardOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
        tableView.reloadData()
    }
    
    // MARK: - Navigation Setup
    private func setupNavigation() {
        view.backgroundColor = .black
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        backItem.tintColor = UIColor(red: 254/255, green: 215/255, blue: 2/255, alpha: 1)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func setupResetButton() {
        let resetButton = UIBarButtonItem(title: "Сброс", style: .plain, target: self, action: #selector(resetData))
        resetButton.tintColor = .white
        navigationItem.rightBarButtonItem = resetButton
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        presenter?.router?.showDetail(for: nil)
    }
    
    @objc private func resetData() {
        CoreDataManager.shared.clearAllData()
        presenter?.viewDidLoad()
    }
    
    private func deleteTodo(at indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        let context = CoreDataManager.shared.mainContext
        context.delete(todo)
        CoreDataManager.shared.saveContext()
        todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        tasksCountLabel.text = "\(todos.count) задач"
        
    }
    
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        [titleLabel, searchBar, tableView, bottomPanel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        bottomPanel.addSubview(tasksCountLabel)
        bottomPanel.addSubview(addButton)
        
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
            tableView.bottomAnchor.constraint(equalTo: bottomPanel.topAnchor),
            
            bottomPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomPanel.heightAnchor.constraint(equalToConstant: 83),
            
            tasksCountLabel.topAnchor.constraint(equalTo: bottomPanel.topAnchor, constant: 21),
            tasksCountLabel.centerXAnchor.constraint(equalTo: bottomPanel.centerXAnchor),
            
            addButton.topAnchor.constraint(equalTo: bottomPanel.topAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: bottomPanel.trailingAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .black
        tableView.backgroundView = nil
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)
    }
    
    // MARK: - Keyboard
    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as! ToDoTableViewCell
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        
        // MARK: - Cell Actions
        cell.circleTapAction = { [weak self] in
            guard let self = self else { return }
            self.presenter?.didSelectTodo(todo, at: indexPath)
        }
        
        cell.editAction = { [weak self] in
            guard let self = self else { return }
            self.presenter?.didTapEdit(todo: todo)
        }
        
        cell.deleteAction = { [weak self] in
            guard let self = self else { return }
            self.deleteTodo(at: indexPath)
        }
        
        cell.shareAction = { [weak self] in
            guard let self = self else { return }
            let activityVC = UIActivityViewController(activityItems: [todo.title ?? ""], applicationActivities: nil)
            self.present(activityVC, animated: true)
        }
        
        if cell.interactions.isEmpty {
            let interaction = UIContextMenuInteraction(delegate: cell)
            cell.addInteraction(interaction)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectTodo(todos[indexPath.row], at: indexPath)
    }
}

// MARK: - ToDoListViewProtocol
extension ToDoListViewController: ToDoListViewProtocol {
    
    func showTodos(_ todos: [ToDoItem]) {
        self.todos = todos
        tableView.reloadData()
        tasksCountLabel.text = "\(todos.count) задач"
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter?.viewDidLoad()
        } else {
            let filtered = todos.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
            showTodos(filtered)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
