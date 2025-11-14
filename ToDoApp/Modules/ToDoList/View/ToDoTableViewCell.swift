//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Илья Музафаров on 11.11.2025.
//

import UIKit

final class ToDoTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "ToDoTableViewCell"
    
    var editAction: (() -> Void)?
    var shareAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    var circleTapAction: (() -> Void)?
    
    // MARK: - UI Elements
    let circleButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        let circleBorderColor = UIColor(red: 77/255, green: 85/255, blue: 94/255, alpha: 1)
        button.layer.borderColor = circleBorderColor.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(circleButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        circleButton.addTarget(self, action: #selector(circleTapped), for: .touchUpInside)
        
        setupConstraints()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        contentView.addInteraction(interaction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.textColor = .white
        descriptionLabel.textColor = .white
        titleLabel.attributedText = NSAttributedString(string: "")
        circleButton.backgroundColor = .clear
        circleButton.setImage(nil, for: .normal)
    }
    
    // MARK: - Actions
    @objc private func circleTapped() {
        circleTapAction?()
    }
    
    // MARK: - Configuration
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
            let orangeColor = UIColor(red: 254/255, green: 215/255, blue: 2/255, alpha: 1)
            circleButton.backgroundColor = .clear
            circleButton.layer.borderColor = orangeColor.cgColor
            circleButton.layer.borderWidth = 2
            
            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
            circleButton.setImage(UIImage(systemName: "checkmark", withConfiguration: config), for: .normal)
            circleButton.tintColor = orangeColor
            
            titleLabel.textColor = .gray
            descriptionLabel.textColor = .gray
            titleLabel.attributedText = NSAttributedString(
                string: titleLabel.text ?? "",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
        } else {
            circleButton.backgroundColor = .clear
            circleButton.layer.borderColor = UIColor.systemGray.cgColor
            circleButton.layer.borderWidth = 2
            circleButton.setImage(nil, for: .normal)
            
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
            titleLabel.attributedText = NSAttributedString(string: titleLabel.text ?? "", attributes: [:])
        }
    }
    
    // MARK: - Layout
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
}

// MARK: - UIContextMenuInteractionDelegate
extension ToDoTableViewCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        contentView.backgroundColor = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1)
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.editAction?()
            }
            let share = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.shareAction?()
            }
            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteAction?()
            }
            return UIMenu(title: "", children: [edit, share, delete])
        }
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        animator?.addCompletion {
            self.contentView.backgroundColor = .clear
        }
    }
}
