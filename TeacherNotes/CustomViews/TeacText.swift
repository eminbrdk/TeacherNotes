//
//  TeacText.swift
//  TeacherNotes
//
//  Created by Muhammed Emin Bardakcı on 17.03.2023.
//

import UIKit

class TeacText: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        
        self.text = text
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        textColor = .label
        font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textAlignment = .left
        
        numberOfLines = 1
        lineBreakMode = .byTruncatingTail
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
    }
}
