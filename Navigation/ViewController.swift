//
//  ViewController.swift
//  Navigation
//
//  Created by Евгений Суханов on 10.04.2020.
//  Copyright © 2020 Евгений Суханов. All rights reserved.
//

import UIKit
import SnapKit
import Overture

class ViewController: UIViewController {
    let label = UILabel()
    let button = update(UIButton()) {
        $0.setTitle("Push", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        view.addSubview(button)
        label.snp.makeConstraints { make in
           make.center.equalTo(view)
        }
        button.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.centerX.equalTo(label)
        }
    }
}

extension ViewController {
    func render(text: String, color: UIColor) {
        label.text = text
        view.backgroundColor = color
    }
}
