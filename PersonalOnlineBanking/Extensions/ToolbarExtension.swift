//
//  ToolbarExtension.swift
//  Project
//
//  Created by Abu Nabe on 11/3/2023.
//

import UIKit

class ToolbarShadow: UIView{
    override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private func setup() {
            let line = UIView()
           
            if traitCollection.userInterfaceStyle == .dark {
                line.backgroundColor = .systemGray6
                line.layer.shadowColor = UIColor.systemGray.cgColor
            } else {
                line.backgroundColor = .lightGray
                line.layer.shadowColor = UIColor.lightGray.cgColor
            }
            line.layer.masksToBounds = false
            line.layer.shadowOpacity = 0.8
            line.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            line.layer.shadowRadius = 0.5
            addSubview(line)
            
            line.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    line.leadingAnchor.constraint(equalTo: leadingAnchor),
                    line.trailingAnchor.constraint(equalTo: trailingAnchor),
                    line.bottomAnchor.constraint(equalTo: bottomAnchor),
                    line.heightAnchor.constraint(equalToConstant: 1.0)
                ])
    }
}
