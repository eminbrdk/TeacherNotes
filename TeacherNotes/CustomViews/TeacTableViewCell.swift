//
//  ClassCell.swift
//  TeacherNotes
//
//  Created by Muhammed Emin Bardakcı on 17.03.2023.
//

import UIKit

class TeacTableViewCell: UITableViewCell {
    
    static let reuseID = "tableViewCell"
    let cellView = UIView()
    let leftText = TeacText()
    let rightText = TeacText()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureTexts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(leftText: String, rightText: String = " ") {
        self.leftText.text = leftText
        self.rightText.text = rightText
        
        if rightText == " " { accessoryType = .disclosureIndicator }
    }
    
    func configureTexts() {
        cellView.addSubview(leftText)
        cellView.addSubview(rightText)
        addSubview(cellView)
        
        selectionStyle = .none
        
        rightText.textAlignment = .right
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.layer.cornerRadius = 10
        cellView.backgroundColor = .systemGray5
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            leftText.topAnchor.constraint(equalTo: cellView.topAnchor),
            leftText.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            leftText.trailingAnchor.constraint(equalTo: rightText.leadingAnchor, constant: -10),
            leftText.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
            
            rightText.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            rightText.heightAnchor.constraint(equalToConstant: 40),
            rightText.widthAnchor.constraint(equalTo: rightText.heightAnchor),
            rightText.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10)
        ])
    }
}
