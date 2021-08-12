//
//  GameOverViewController.swift
//  Game of Fifteen
//
//  Created by Dmitriy Mikitenko on 25.07.2021.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBAction func newGameButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
