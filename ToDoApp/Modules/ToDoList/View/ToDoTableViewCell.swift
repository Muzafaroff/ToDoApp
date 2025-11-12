//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 11.11.2025.
//

import UIKit

final class ToDoTableViewCell: UITableViewCell {

    static let identifier = "ToDoTableViewCell"
    
    let circleButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var circleTapAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(circleButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        circleButton.addTarget(self, action: #selector(circleTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    @objc private func circleTapped() {
        circleTapAction?()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            circleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            circleButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            circleButton.widthAnchor.constraint(equalToConstant: 24),
            circleButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: circleButton.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with todo: ToDoItem) {
        titleLabel.text = todo.title
        descriptionLabel.text = todo.todoDescription
        if let date = todo.createdAt {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            dateLabel.text = formatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
        
        updateCircleAndText(todo.isCompleted)
    }
    
    func updateCircleAndText(_ completed: Bool) {
        if completed {
            circleButton.backgroundColor = .systemOrange
            titleLabel.textColor = .gray
            descriptionLabel.textColor = .gray
            titleLabel.attributedText = NSAttributedString(
                string: titleLabel.text ?? "",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
        } else {
            circleButton.backgroundColor = .clear
            titleLabel.textColor = .black
            descriptionLabel.textColor = .darkGray
            titleLabel.attributedText = NSAttributedString(
                string: titleLabel.text ?? "",
                attributes: [:]
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

