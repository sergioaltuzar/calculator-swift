//
//  UIButtonExtension.swift
//  iOS-Calculator
//
//  Created by Sergio Altuzar on 17/08/22.
//

import UIKit

private let orange = UIColor (red:254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton {
    // Borde redondo
       func round() {
           layer.cornerRadius = bounds.height / 2
           clipsToBounds = true
       }
    
    // Brilla
    func shine() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0.5
        }) { (completion) in
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1
            })
        }
    }
    // Apariencia seleccion boton de operacion
    func selecOperation(_ selected: Bool){
        backgroundColor = selected ? .white : orange
        setTitleColor(selected ? orange : .white, for: .normal )
        
    }

}
